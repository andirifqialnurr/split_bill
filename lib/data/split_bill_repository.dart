import '../core/money.dart';
import '../domain/split_bill_models.dart';
import 'split_bill_database.dart';
import 'split_bill_mappers.dart';

class SavedBillSummary {
  const SavedBillSummary({
    required this.id,
    required this.title,
    required this.occurredAt,
    required this.mode,
    required this.participantCount,
    required this.grandTotal,
  });

  final int id;
  final String title;
  final DateTime occurredAt;
  final SplitMode mode;
  final int participantCount;
  final int grandTotal;
}

class SavedBillDetail {
  const SavedBillDetail({
    required this.id,
    required this.bill,
    required this.calculation,
  });

  final int id;
  final DraftBill bill;
  final BillCalculation calculation;
}

class SplitBillRepository {
  const SplitBillRepository(this.database);

  final SplitBillDatabase database;

  Future<List<SavedBillSummary>> listBills() async {
    final db = await database.instance;
    final rows = await db.rawQuery('''
SELECT
  b.id,
  b.title,
  b.occurred_at,
  b.split_mode,
  b.grand_total,
  COUNT(p.id) AS participant_count
FROM bills b
LEFT JOIN participants p ON p.bill_id = b.id
GROUP BY b.id
ORDER BY b.occurred_at DESC, b.created_at DESC
''');

    return rows.map((row) {
      final title = row['title'] as String?;
      return SavedBillSummary(
        id: row['id'] as int,
        title: title == null || title.trim().isEmpty ? 'Untitled Bill' : title,
        occurredAt: DateTime.parse(row['occurred_at'] as String),
        mode: splitModeFromDb(row['split_mode'] as String),
        participantCount: row['participant_count'] as int,
        grandTotal: row['grand_total'] as int,
      );
    }).toList(growable: false);
  }

  Future<int> saveBillSnapshot(DraftBill bill, BillCalculation calculation) async {
    final db = await database.instance;
    final now = DateTime.now().toIso8601String();
    return db.transaction((txn) async {
      final billId = await txn.insert('bills', {
        'title': bill.title.trim().isEmpty ? null : bill.title.trim(),
        'occurred_at': DateTime(
          bill.occurredAt.year,
          bill.occurredAt.month,
          bill.occurredAt.day,
        ).toIso8601String(),
        'split_mode': splitModeToDb(bill.mode),
        'equal_total_amount': bill.equalTotalAmount,
        'tax_type': chargeTypeToDb(bill.tax.type),
        'tax_value': bill.tax.value,
        'service_type': chargeTypeToDb(bill.service.type),
        'service_value': bill.service.value,
        'discount_type': chargeTypeToDb(bill.discount.type),
        'discount_value': bill.discount.value,
        'subtotal': calculation.subtotal,
        'tax_amount': calculation.taxAmount,
        'service_amount': calculation.serviceAmount,
        'discount_amount': calculation.discountAmount,
        'grand_total': calculation.grandTotal,
        'created_at': now,
        'updated_at': now,
      });

      final participantIds = <String, int>{};
      for (var index = 0; index < bill.participants.length; index++) {
        final participant = bill.participants[index];
        final id = await txn.insert('participants', {
          'bill_id': billId,
          'name': participant.name,
          'color_seed': participant.colorSeed,
          'sort_order': index,
        });
        participantIds[participant.localId] = id;
      }

      for (var index = 0; index < bill.items.length; index++) {
        final item = bill.items[index];
        final itemId = await txn.insert('bill_items', {
          'bill_id': billId,
          'name': item.name,
          'quantity': item.quantity,
          'total_amount': item.totalAmount,
          'sort_order': index,
        });
        for (final localParticipantId in item.participantIds) {
          final participantId = participantIds[localParticipantId];
          if (participantId == null) continue;
          await txn.insert('item_participants', {
            'item_id': itemId,
            'participant_id': participantId,
            'share_weight': 1,
          });
        }
      }

      for (final entry in bill.customShares.entries) {
        final participantId = participantIds[entry.key];
        if (participantId == null) continue;
        await txn.insert('custom_shares', {
          'bill_id': billId,
          'participant_id': participantId,
          'amount': entry.value,
        });
      }

      for (final result in calculation.results) {
        final participantId = participantIds[result.participant.localId];
        if (participantId == null) continue;
        await txn.insert('settlement_results', {
          'bill_id': billId,
          'participant_id': participantId,
          'base_amount': result.baseAmount,
          'charges_amount': result.chargesAmount,
          'discount_amount': result.discountAmount,
          'rounding_amount': result.roundingAmount,
          'amount_due': result.amountDue,
        });
      }

      return billId;
    });
  }

  Future<SavedBillDetail?> getBillDetail(int id) async {
    final db = await database.instance;
    final bills = await db.query('bills', where: 'id = ?', whereArgs: [id], limit: 1);
    if (bills.isEmpty) return null;

    final billRow = bills.single;
    final participantRows = await db.query(
      'participants',
      where: 'bill_id = ?',
      whereArgs: [id],
      orderBy: 'sort_order ASC, id ASC',
    );
    final itemRows = await db.query(
      'bill_items',
      where: 'bill_id = ?',
      whereArgs: [id],
      orderBy: 'sort_order ASC, id ASC',
    );
    final assignmentRows = await db.rawQuery('''
SELECT ip.item_id, ip.participant_id
FROM item_participants ip
JOIN bill_items bi ON bi.id = ip.item_id
WHERE bi.bill_id = ?
''', [id]);
    final customRows = await db.query(
      'custom_shares',
      where: 'bill_id = ?',
      whereArgs: [id],
    );
    final resultRows = await db.query(
      'settlement_results',
      where: 'bill_id = ?',
      whereArgs: [id],
      orderBy: 'id ASC',
    );

    final participants = participantRows.map((row) {
      return BillParticipant(
        localId: (row['id'] as int).toString(),
        name: row['name'] as String,
        colorSeed: row['color_seed'] as int,
      );
    }).toList(growable: false);
    final participantById = {for (final row in participants) row.localId: row};

    final assignmentsByItem = <String, List<String>>{};
    for (final row in assignmentRows) {
      final itemId = (row['item_id'] as int).toString();
      final participantId = (row['participant_id'] as int).toString();
      assignmentsByItem.putIfAbsent(itemId, () => []).add(participantId);
    }

    final items = itemRows.map((row) {
      final itemId = (row['id'] as int).toString();
      return BillItem(
        localId: itemId,
        name: row['name'] as String,
        quantity: row['quantity'] as int,
        totalAmount: row['total_amount'] as int,
        participantIds: assignmentsByItem[itemId] ?? const [],
      );
    }).toList(growable: false);
    final itemShares = _itemSharesByParticipant(items, participantById.keys.toSet());

    final customShares = <String, int>{};
    for (final row in customRows) {
      customShares[(row['participant_id'] as int).toString()] = row['amount'] as int;
    }

    final results = resultRows.map((row) {
      final participantId = (row['participant_id'] as int).toString();
      final participant = participantById[participantId];
      if (participant == null) return null;
      return SettlementResult(
        participant: participant,
        baseAmount: row['base_amount'] as int,
        chargesAmount: row['charges_amount'] as int,
        discountAmount: row['discount_amount'] as int,
        roundingAmount: row['rounding_amount'] as int,
        amountDue: row['amount_due'] as int,
        items: itemShares[participantId] ?? const [],
      );
    }).whereType<SettlementResult>().toList(growable: false);

    final bill = DraftBill(
      title: billRow['title'] as String? ?? '',
      occurredAt: DateTime.parse(billRow['occurred_at'] as String),
      mode: splitModeFromDb(billRow['split_mode'] as String),
      equalTotalAmount: billRow['equal_total_amount'] as int,
      participants: participants,
      items: items,
      customShares: customShares,
      tax: BillCharge(
        type: chargeTypeFromDb(billRow['tax_type'] as String),
        value: billRow['tax_value'] as int,
      ),
      service: BillCharge(
        type: chargeTypeFromDb(billRow['service_type'] as String),
        value: billRow['service_value'] as int,
      ),
      discount: BillCharge(
        type: chargeTypeFromDb(billRow['discount_type'] as String),
        value: billRow['discount_value'] as int,
      ),
    );

    final calculation = BillCalculation(
      subtotal: billRow['subtotal'] as int,
      taxAmount: billRow['tax_amount'] as int,
      serviceAmount: billRow['service_amount'] as int,
      discountAmount: billRow['discount_amount'] as int,
      grandTotal: billRow['grand_total'] as int,
      results: results,
    );

    return SavedBillDetail(id: id, bill: bill, calculation: calculation);
  }

  Map<String, List<PersonItemShare>> _itemSharesByParticipant(
    List<BillItem> items,
    Set<String> participantIds,
  ) {
    final shares = <String, List<PersonItemShare>>{
      for (final id in participantIds) id: [],
    };
    for (final item in items) {
      final assigned = item.participantIds
          .where(participantIds.contains)
          .toList(growable: false);
      if (assigned.isEmpty) continue;
      final portions = _divideEvenly(item.totalAmount, assigned.length);
      for (var index = 0; index < assigned.length; index++) {
        shares[assigned[index]]?.add(
          PersonItemShare(itemName: item.name, amount: portions[index]),
        );
      }
    }
    return shares;
  }

  List<int> _divideEvenly(int total, int count) {
    if (count <= 0) return const [];
    final base = total ~/ count;
    final remainder = total % count;
    return List<int>.generate(count, (index) => base + (index < remainder ? 1 : 0));
  }
}
