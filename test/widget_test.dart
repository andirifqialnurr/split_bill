import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:split_bill/app/split_bill_controller.dart';
import 'package:split_bill/app/split_bill_app.dart';
import 'package:split_bill/data/split_bill_database.dart';
import 'package:split_bill/data/split_bill_repository.dart';
import 'package:split_bill/domain/split_bill_models.dart';
import 'package:split_bill/features/home/history_page.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  testWidgets('shows Indonesian home by default', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    expect(find.text('Split Bill'), findsOneWidget);
    expect(find.text('Bill Baru'), findsNothing);
    expect(find.text('Split Rata'), findsNothing);
    expect(find.text('Lihat semua'), findsOneWidget);
    expect(find.byTooltip('Riwayat'), findsOneWidget);
    expect(find.byTooltip('Bill Baru'), findsOneWidget);
    expect(find.text('Bagi tagihan offline.'), findsOneWidget);
  });

  testWidgets('opens history from bottom nav and home view all action', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    await tester.tap(find.text('Lihat semua'));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada bill'), findsOneWidget);
    expect(find.byTooltip('Bill Baru'), findsNothing);

    await tester.tap(find.byTooltip('Bill'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada bill'), findsOneWidget);
    expect(find.byTooltip('Bill Baru'), findsNothing);
  });

  testWidgets('filters history by search keyword', (tester) async {
    final controller = SplitBillController(
      repository: _FakeSplitBillRepository([
        _summary(id: 1, title: 'Dinner', mode: SplitMode.items, participantCount: 3),
        _summary(id: 2, title: 'Coffee', mode: SplitMode.equal, participantCount: 2),
      ]),
    );
    addTearDown(controller.dispose);
    await controller.loadHistory();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HistoryPage(controller: controller)),
      ),
    );

    expect(find.text('Dinner'), findsOneWidget);
    expect(find.text('Coffee'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('history-search-field')), 'coffee');
    await tester.pumpAndSettle();

    expect(find.text('Dinner'), findsNothing);
    expect(find.text('Coffee'), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('history-search-field')), '3');
    await tester.pumpAndSettle();

    expect(find.text('Dinner'), findsOneWidget);
    expect(find.text('Coffee'), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('history-search-field')), 'missing');
    await tester.pumpAndSettle();

    expect(find.text('Tidak ada hasil'), findsOneWidget);
  });

  testWidgets('switches to English from settings', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Bills'));
    await tester.pumpAndSettle();

    expect(find.text('Dark'), findsNothing);
    expect(find.text('New Bill'), findsNothing);
    expect(find.text('Equal Split'), findsNothing);
    expect(find.byTooltip('New Bill'), findsOneWidget);
    expect(find.text('Split bills offline.'), findsOneWidget);
  });

  testWidgets('completes Indonesian equal split flow', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    await _completeEqualSplitFlow(
      tester,
      equalLabel: 'Split Rata',
      nextLabel: 'Lanjut',
      nameFieldLabel: 'Nama',
      addPersonTooltip: 'Tambah peserta',
      expectedResultLabel: 'Hasil',
      expectedPerPersonLabel: 'Per peserta',
    );
  });

  testWidgets('completes English equal split flow', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Bills'));
    await tester.pumpAndSettle();

    await _completeEqualSplitFlow(
      tester,
      equalLabel: 'Equal Split',
      nextLabel: 'Next',
      nameFieldLabel: 'Nickname',
      addPersonTooltip: 'Add person',
      expectedResultLabel: 'Result',
      expectedPerPersonLabel: 'Per person',
    );
  });
}

SavedBillSummary _summary({
  required int id,
  required String title,
  required SplitMode mode,
  required int participantCount,
}) {
  return SavedBillSummary(
    id: id,
    title: title,
    occurredAt: DateTime(2026, 8, 29),
    mode: mode,
    participantCount: participantCount,
    grandTotal: 100000,
  );
}

class _FakeSplitBillRepository extends SplitBillRepository {
  _FakeSplitBillRepository(this._bills) : super(SplitBillDatabase());

  final List<SavedBillSummary> _bills;

  @override
  Future<List<SavedBillSummary>> listBills() async {
    return _bills;
  }
}

Future<void> _completeEqualSplitFlow(
  WidgetTester tester, {
  required String equalLabel,
  required String nextLabel,
  required String nameFieldLabel,
  required String addPersonTooltip,
  required String expectedResultLabel,
  required String expectedPerPersonLabel,
}) async {
  final newBillAction = find.byType(FloatingActionButton);
  await tester.ensureVisible(newBillAction);
  await tester.tap(newBillAction);
  await tester.pumpAndSettle();

  await tester.tap(find.text(equalLabel));
  await tester.pumpAndSettle();
  await _tapPrimaryButton(tester, nextLabel);

  await tester.enterText(find.widgetWithText(TextField, nameFieldLabel), 'Ayu');
  await tester.tap(find.byTooltip(addPersonTooltip));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextField, nameFieldLabel), 'Bima');
  await tester.tap(find.byTooltip(addPersonTooltip));
  await tester.pumpAndSettle();

  await _tapPrimaryButton(tester, nextLabel);

  final totalField = find.byKey(const ValueKey('bill-total-field'));
  await tester.ensureVisible(totalField);
  await tester.enterText(totalField, '100000');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pumpAndSettle();
  await _tapPrimaryButton(tester, nextLabel);
  await tester.drag(find.byType(ListView).last, const Offset(0, 700));
  await tester.pumpAndSettle();

  expect(find.text(expectedResultLabel), findsWidgets);
  await _scrollUntilText(tester, expectedPerPersonLabel);
  expect(find.text(expectedPerPersonLabel), findsWidgets);
}

Future<void> _tapPrimaryButton(WidgetTester tester, String text) async {
  final baseFinder = find.ancestor(
    of: find.text(text),
    matching: find.bySubtype<ButtonStyleButton>(),
  );
  for (var attempt = 0; attempt < 5 && baseFinder.evaluate().isEmpty; attempt++) {
    await tester.drag(find.byType(ListView).last, const Offset(0, -280));
    await tester.pumpAndSettle();
  }
  final finder = baseFinder.last;
  await tester.scrollUntilVisible(
    finder,
    120,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.drag(find.byType(ListView).last, const Offset(0, -180));
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _scrollUntilText(WidgetTester tester, String text) async {
  final finder = find.text(text);
  for (var attempt = 0; attempt < 5 && finder.evaluate().isEmpty; attempt++) {
    await tester.drag(find.byType(ListView).last, const Offset(0, -240));
    await tester.pumpAndSettle();
  }
}
