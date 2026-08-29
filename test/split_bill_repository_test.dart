import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:split_bill/data/split_bill_database.dart';
import 'package:split_bill/data/split_bill_repository.dart';
import 'package:split_bill/domain/split_bill_calculator.dart';
import 'package:split_bill/domain/split_bill_models.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('saves reads updates and deletes a bill snapshot', () async {
    final tempDir = await Directory.systemTemp.createTemp('split_bill_repo_test_');
    databaseFactoryFfi.setDatabasesPath(tempDir.path);
    final database = SplitBillDatabase();
    final repository = SplitBillRepository(database);
    addTearDown(() async {
      await database.close();
      await tempDir.delete(recursive: true);
    });

    final bill = DraftBill(
      title: 'Dinner',
      occurredAt: DateTime(2026, 8, 29),
      mode: SplitMode.items,
      participants: const [
        BillParticipant(localId: 'p1', name: 'Ayu', colorSeed: 0),
        BillParticipant(localId: 'p2', name: 'Bima', colorSeed: 1),
      ],
      items: const [
        BillItem(
          localId: 'i1',
          name: 'Nasi goreng',
          quantity: 1,
          totalAmount: 100000,
          participantIds: ['p1', 'p2'],
        ),
      ],
    );
    final calculation = const SplitBillCalculator().calculate(bill);

    final id = await repository.saveBillSnapshot(bill, calculation);
    final list = await repository.listBills();
    final detail = await repository.getBillDetail(id);

    expect(list, hasLength(1));
    expect(list.single.title, 'Dinner');
    expect(detail, isNotNull);
    expect(detail!.bill.items.single.participantIds, hasLength(2));
    expect(detail.calculation.results.first.isPaid, isFalse);

    final participantId = int.parse(detail.calculation.results.first.participant.localId);
    final paidUpdated = await repository.updateParticipantPaidStatus(
      billId: id,
      participantId: participantId,
      isPaid: true,
    );
    final paidDetail = await repository.getBillDetail(id);

    expect(paidUpdated, isTrue);
    expect(paidDetail!.calculation.results.first.isPaid, isTrue);

    final deleted = await repository.deleteBill(id);

    expect(deleted, isTrue);
    expect(await repository.listBills(), isEmpty);
    expect(await repository.getBillDetail(id), isNull);
  });
}
