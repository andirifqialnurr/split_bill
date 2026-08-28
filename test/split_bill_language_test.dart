import 'package:flutter_test/flutter_test.dart';
import 'package:split_bill/app/split_bill_controller.dart';
import 'package:split_bill/app/split_bill_state.dart';
import 'package:split_bill/app/split_bill_strings.dart';
import 'package:split_bill/domain/split_bill_models.dart';

void main() {
  test('defaults to Indonesian copy', () {
    const state = SplitBillState();
    final strings = SplitStrings(state.language);

    expect(state.language, AppLanguage.id);
    expect(strings.newBill, 'Bill Baru');
    expect(strings.modeLabel(SplitMode.items), 'Per Item');
  });

  test('returns English copy', () {
    const strings = SplitStrings(AppLanguage.en);

    expect(strings.newBill, 'New Bill');
    expect(strings.modeLabel(SplitMode.items), 'By Items');
  });

  test('controller changes language', () {
    final controller = SplitBillController();
    addTearDown(controller.dispose);

    controller.setLanguage(AppLanguage.en);

    expect(controller.state.language, AppLanguage.en);
    expect(controller.strings.settings, 'Settings');
  });
}
