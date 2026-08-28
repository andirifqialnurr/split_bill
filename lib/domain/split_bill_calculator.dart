import 'dart:math' as math;

import 'split_bill_models.dart';

class SplitBillCalculator {
  const SplitBillCalculator();

  BillCalculation calculate(DraftBill bill) {
    if (bill.participants.isEmpty) {
      throw const BillValidationException('Add at least one participant.');
    }

    final baseShares = <String, int>{
      for (final participant in bill.participants) participant.localId: 0,
    };
    final itemShares = <String, List<PersonItemShare>>{
      for (final participant in bill.participants) participant.localId: [],
    };

    final subtotal = switch (bill.mode) {
      SplitMode.equal => _calculateEqualBase(bill, baseShares),
      SplitMode.items => _calculateItemBase(bill, baseShares, itemShares),
      SplitMode.custom => _calculateCustomBase(bill, baseShares),
    };

    final taxAmount = bill.tax.resolve(subtotal);
    final serviceAmount = bill.service.resolve(subtotal);
    final rawDiscount = bill.discount.resolve(subtotal);
    final discountAmount = math.min(rawDiscount, subtotal + taxAmount + serviceAmount);
    final grandTotal = subtotal + taxAmount + serviceAmount - discountAmount;

    final participantIds = bill.participants.map((p) => p.localId).toList();
    final weights = participantIds.map((id) => baseShares[id] ?? 0).toList();
    final taxShares = _allocateProportionally(taxAmount, weights);
    final serviceShares = _allocateProportionally(serviceAmount, weights);
    final discountShares = _allocateProportionally(discountAmount, weights);

    final results = <SettlementResult>[];
    var resultTotal = 0;
    for (var index = 0; index < bill.participants.length; index++) {
      final participant = bill.participants[index];
      final base = baseShares[participant.localId] ?? 0;
      final charges = taxShares[index] + serviceShares[index];
      final discount = discountShares[index];
      final amountDue = base + charges - discount;
      resultTotal += amountDue;
      results.add(
        SettlementResult(
          participant: participant,
          baseAmount: base,
          chargesAmount: charges,
          discountAmount: discount,
          roundingAmount: 0,
          amountDue: amountDue,
          items: itemShares[participant.localId] ?? const [],
        ),
      );
    }

    final residual = grandTotal - resultTotal;
    final finalResults = _applyResidual(results, residual);
    final verifiedTotal = finalResults.fold<int>(0, (sum, row) => sum + row.amountDue);
    if (verifiedTotal != grandTotal) {
      throw const BillValidationException('Bill total invariant failed.');
    }

    return BillCalculation(
      subtotal: subtotal,
      taxAmount: taxAmount,
      serviceAmount: serviceAmount,
      discountAmount: discountAmount,
      grandTotal: grandTotal,
      results: finalResults,
    );
  }

  int _calculateEqualBase(DraftBill bill, Map<String, int> baseShares) {
    if (bill.equalTotalAmount <= 0) {
      throw const BillValidationException('Enter the bill total.');
    }
    final shares = _divideEvenly(bill.equalTotalAmount, bill.participants.length);
    for (var index = 0; index < bill.participants.length; index++) {
      baseShares[bill.participants[index].localId] = shares[index];
    }
    return bill.equalTotalAmount;
  }

  int _calculateItemBase(
    DraftBill bill,
    Map<String, int> baseShares,
    Map<String, List<PersonItemShare>> itemShares,
  ) {
    if (bill.items.isEmpty) {
      throw const BillValidationException('Add at least one item.');
    }

    var subtotal = 0;
    for (final item in bill.items) {
      if (item.totalAmount <= 0) {
        throw BillValidationException('Enter price for ${item.name}.');
      }
      final validParticipantIds = item.participantIds
          .where((id) => baseShares.containsKey(id))
          .toList(growable: false);
      if (validParticipantIds.isEmpty) {
        throw BillValidationException('Assign ${item.name} to at least one person.');
      }
      subtotal += item.totalAmount;
      final portions = _divideEvenly(item.totalAmount, validParticipantIds.length);
      for (var index = 0; index < validParticipantIds.length; index++) {
        final participantId = validParticipantIds[index];
        final share = portions[index];
        baseShares[participantId] = (baseShares[participantId] ?? 0) + share;
        itemShares[participantId]?.add(
          PersonItemShare(itemName: item.name, amount: share),
        );
      }
    }
    return subtotal;
  }

  int _calculateCustomBase(DraftBill bill, Map<String, int> baseShares) {
    if (bill.equalTotalAmount <= 0) {
      throw const BillValidationException('Enter the bill total.');
    }

    var assigned = 0;
    for (final participant in bill.participants) {
      final amount = bill.customShares[participant.localId] ?? 0;
      if (amount < 0) {
        throw const BillValidationException('Custom amount cannot be negative.');
      }
      assigned += amount;
      baseShares[participant.localId] = amount;
    }
    if (assigned != bill.equalTotalAmount) {
      throw const BillValidationException('Custom split remaining must be zero.');
    }
    return bill.equalTotalAmount;
  }

  List<int> _divideEvenly(int total, int count) {
    if (count <= 0) return const [];
    final base = total ~/ count;
    final remainder = total % count;
    return List<int>.generate(count, (index) => base + (index < remainder ? 1 : 0));
  }

  List<int> _allocateProportionally(int total, List<int> weights) {
    if (total == 0 || weights.isEmpty) {
      return List<int>.filled(weights.length, 0);
    }
    final weightTotal = weights.fold<int>(0, (sum, weight) => sum + weight);
    if (weightTotal <= 0) {
      return _divideEvenly(total, weights.length);
    }

    final rows = <_AllocationRow>[];
    var allocated = 0;
    for (var index = 0; index < weights.length; index++) {
      final numerator = total * weights[index];
      final amount = numerator ~/ weightTotal;
      allocated += amount;
      rows.add(
        _AllocationRow(
          index: index,
          amount: amount,
          remainder: numerator % weightTotal,
        ),
      );
    }

    rows.sort((a, b) {
      final remainderCompare = b.remainder.compareTo(a.remainder);
      if (remainderCompare != 0) return remainderCompare;
      return a.index.compareTo(b.index);
    });

    var residual = total - allocated;
    for (final row in rows) {
      if (residual <= 0) break;
      row.amount += 1;
      residual -= 1;
    }

    rows.sort((a, b) => a.index.compareTo(b.index));
    return rows.map((row) => row.amount).toList(growable: false);
  }

  List<SettlementResult> _applyResidual(
    List<SettlementResult> results,
    int residual,
  ) {
    if (residual == 0 || results.isEmpty) return results;
    var remaining = residual;
    return [
      for (var index = 0; index < results.length; index++)
        _adjustResult(results[index], index, () {
          if (remaining == 0) return 0;
          final delta = remaining > 0 ? 1 : -1;
          remaining -= delta;
          return delta;
        }),
    ];
  }

  SettlementResult _adjustResult(
    SettlementResult result,
    int index,
    int Function() nextDelta,
  ) {
    final delta = nextDelta();
    if (delta == 0) return result;
    return SettlementResult(
      participant: result.participant,
      baseAmount: result.baseAmount,
      chargesAmount: result.chargesAmount,
      discountAmount: result.discountAmount,
      roundingAmount: result.roundingAmount + delta,
      amountDue: result.amountDue + delta,
      items: result.items,
    );
  }
}

class _AllocationRow {
  _AllocationRow({
    required this.index,
    required this.amount,
    required this.remainder,
  });

  final int index;
  int amount;
  final int remainder;
}
