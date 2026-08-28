import 'package:flutter_test/flutter_test.dart';
import 'package:split_bill/core/money.dart';
import 'package:split_bill/domain/split_bill_calculator.dart';
import 'package:split_bill/domain/split_bill_models.dart';

void main() {
  const calculator = SplitBillCalculator();
  final participants = [
    const BillParticipant(localId: 'p1', name: 'Ayu', colorSeed: 0),
    const BillParticipant(localId: 'p2', name: 'Bima', colorSeed: 1),
    const BillParticipant(localId: 'p3', name: 'Citra', colorSeed: 2),
  ];

  test('equal split keeps amount due invariant with rupiah remainder', () {
    final bill = DraftBill(
      occurredAt: DateTime(2026, 8, 28),
      mode: SplitMode.equal,
      equalTotalAmount: 100000,
      participants: participants,
    );

    final result = calculator.calculate(bill);

    expect(result.grandTotal, 100000);
    expect(result.results.map((row) => row.amountDue), [33334, 33333, 33333]);
    expect(_sumDue(result), result.grandTotal);
  });

  test('item split allocates tax service and discount proportionally', () {
    final bill = DraftBill(
      occurredAt: DateTime(2026, 8, 28),
      mode: SplitMode.items,
      participants: participants,
      items: const [
        BillItem(
          localId: 'i1',
          name: 'Pizza',
          quantity: 2,
          totalAmount: 180000,
          participantIds: ['p1', 'p2'],
        ),
        BillItem(
          localId: 'i2',
          name: 'Tea',
          quantity: 3,
          totalAmount: 45000,
          participantIds: ['p1', 'p2', 'p3'],
        ),
      ],
      tax: BillCharge(type: ChargeType.percentage, value: 1000),
      service: BillCharge(type: ChargeType.fixed, value: 5000),
      discount: BillCharge(type: ChargeType.fixed, value: 10000),
    );

    final result = calculator.calculate(bill);

    expect(result.subtotal, 225000);
    expect(result.taxAmount, 22500);
    expect(result.serviceAmount, 5000);
    expect(result.discountAmount, 10000);
    expect(_sumDue(result), result.grandTotal);
  });

  test('custom split requires zero remaining amount', () {
    final bill = DraftBill(
      occurredAt: DateTime(2026, 8, 28),
      mode: SplitMode.custom,
      equalTotalAmount: 90000,
      participants: participants,
      customShares: const {
        'p1': 30000,
        'p2': 30000,
      },
    );

    expect(
      () => calculator.calculate(bill),
      throwsA(isA<BillValidationException>()),
    );
  });
}

int _sumDue(BillCalculation result) {
  return result.results.fold<int>(0, (sum, row) => sum + row.amountDue);
}
