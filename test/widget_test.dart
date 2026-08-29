import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:split_bill/app/split_bill_app.dart';

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
    expect(find.byTooltip('Bill Baru'), findsOneWidget);
    expect(find.text('Bagi tagihan offline.'), findsOneWidget);
  });

  testWidgets('switches to English from settings', (tester) async {
    await tester.pumpWidget(const SplitBillApp(loadPersistenceOnStart: false));

    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bills'));
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

    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bills'));
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
