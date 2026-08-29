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

  test('duplicate saved bill creates an editable draft with fresh local ids', () async {
    final repository = _FakeSplitBillRepository(
      [_summary(1, 'Dinner')],
      details: {1: _detail()},
    );
    final controller = SplitBillController(repository: repository);
    addTearDown(controller.dispose);

    final duplicated = await controller.duplicateSavedBill(1);

    expect(duplicated, isTrue);
    final draft = controller.state.draft;
    expect(draft, isNotNull);
    expect(draft!.title, 'Dinner');
    expect(draft.mode, SplitMode.items);
    expect(draft.participants.map((participant) => participant.localId), ['p1', 'p2']);
    expect(draft.items.single.localId, 'i3');
    expect(draft.items.single.participantIds, ['p1', 'p2']);
    expect(draft.customShares, {'p1': 60000, 'p2': 40000});
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

SavedBillDetail _detail() {
  const participants = [
    BillParticipant(localId: '10', name: 'Ayu', colorSeed: 0),
    BillParticipant(localId: '20', name: 'Bima', colorSeed: 1),
  ];
  final bill = DraftBill(
    title: 'Dinner',
    occurredAt: DateTime(2026, 8, 1),
    mode: SplitMode.items,
    participants: participants,
    items: const [
      BillItem(
        localId: '30',
        name: 'Nasi goreng',
        quantity: 1,
        totalAmount: 100000,
        participantIds: ['10', '20'],
      ),
    ],
    customShares: const {'10': 60000, '20': 40000},
  );
  return SavedBillDetail(
    id: 1,
    bill: bill,
    calculation: const BillCalculation(
      subtotal: 100000,
      taxAmount: 0,
      serviceAmount: 0,
      discountAmount: 0,
      grandTotal: 100000,
      results: [],
    ),
  );
}

class _FakeSplitBillRepository extends SplitBillRepository {
  _FakeSplitBillRepository(this._bills, {Map<int, SavedBillDetail>? details})
      : _details = details ?? const {},
        super(SplitBillDatabase());

  List<SavedBillSummary> _bills;
  final Map<int, SavedBillDetail> _details;

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

  @override
  Future<SavedBillDetail?> getBillDetail(int id) async {
    return _details[id];
  }
}
