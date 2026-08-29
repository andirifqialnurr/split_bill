import 'package:flutter_test/flutter_test.dart';
import 'package:split_bill/app/split_bill_controller.dart';
import 'package:split_bill/data/split_bill_database.dart';
import 'package:split_bill/data/split_bill_repository.dart';
import 'package:split_bill/domain/split_bill_models.dart';

void main() {
  test('delete saved bill refreshes history', () async {
    final repository = _FakeSplitBillRepository([
      _summary(1, 'Dinner'),
      _summary(2, 'Coffee'),
    ]);
    final controller = SplitBillController(repository: repository);
    addTearDown(controller.dispose);

    await controller.loadHistory();

    expect(controller.state.history.map((bill) => bill.id), [1, 2]);

    final deleted = await controller.deleteSavedBill(1);

    expect(deleted, isTrue);
    expect(controller.state.history.map((bill) => bill.id), [2]);
  });
}

SavedBillSummary _summary(int id, String title) {
  return SavedBillSummary(
    id: id,
    title: title,
    occurredAt: DateTime(2026, 8, 29),
    mode: SplitMode.items,
    participantCount: 2,
    grandTotal: 100000,
  );
}

class _FakeSplitBillRepository extends SplitBillRepository {
  _FakeSplitBillRepository(this._bills) : super(SplitBillDatabase());

  List<SavedBillSummary> _bills;

  @override
  Future<List<SavedBillSummary>> listBills() async {
    return _bills;
  }

  @override
  Future<bool> deleteBill(int id) async {
    final previousLength = _bills.length;
    _bills = _bills.where((bill) => bill.id != id).toList(growable: false);
    return _bills.length != previousLength;
  }
}
