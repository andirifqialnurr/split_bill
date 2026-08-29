import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:split_bill/app/split_bill_controller.dart';
import 'package:split_bill/app/split_bill_state.dart';
import 'package:split_bill/app/split_bill_strings.dart';
import 'package:split_bill/domain/split_bill_calculator.dart';
import 'package:split_bill/domain/split_bill_models.dart';
import 'package:split_bill/features/bill/result_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID');
  });

  test('defaults to Indonesian copy', () {
    const state = SplitBillState();
    final strings = SplitStrings(state.language);

    expect(state.language, AppLanguage.id);
    expect(strings.newBill, 'Bill Baru');
    expect(strings.viewAll, 'Lihat semua');
    expect(strings.modeLabel(SplitMode.items), 'Per Item');
  });

  test('returns English copy', () {
    const strings = SplitStrings(AppLanguage.en);

    expect(strings.newBill, 'New Bill');
    expect(strings.viewAll, 'View all');
    expect(strings.modeLabel(SplitMode.items), 'By Items');
  });

  test('controller changes language', () {
    final controller = SplitBillController();
    addTearDown(controller.dispose);

    controller.setLanguage(AppLanguage.en);

    expect(controller.state.language, AppLanguage.en);
    expect(controller.strings.settings, 'Settings');
  });

  test('copy summary uses Indonesian copy', () async {
    final text = await _captureCopiedSummary(SplitStrings(AppLanguage.id));

    expect(text, contains('Ringkasan Split Bill'));
    expect(text, contains('Ayu: Rp50.000'));
  });

  test('copy summary uses English copy', () async {
    final text = await _captureCopiedSummary(SplitStrings(AppLanguage.en));

    expect(text, contains('Split Bill Summary'));
    expect(text, contains('Ayu: Rp50.000'));
  });
}

Future<String> _captureCopiedSummary(SplitStrings strings) async {
  String? clipboardText;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'Clipboard.setData') {
        final arguments = call.arguments as Map<dynamic, dynamic>;
        clipboardText = arguments['text'] as String?;
      }
      return null;
    },
  );
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  const participants = [
    BillParticipant(localId: 'p1', name: 'Ayu', colorSeed: 0),
    BillParticipant(localId: 'p2', name: 'Bima', colorSeed: 1),
  ];
  final calculation = const SplitBillCalculator().calculate(
    DraftBill(
      occurredAt: DateTime(2026, 8, 29),
      mode: SplitMode.equal,
      equalTotalAmount: 100000,
      participants: participants,
    ),
  );

  await copyBillSummary(calculation, strings: strings);

  return clipboardText ?? '';
}
