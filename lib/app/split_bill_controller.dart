import 'package:flutter/material.dart';

import 'split_bill_state.dart';

class SplitBillController extends ChangeNotifier {
  SplitBillState _state = const SplitBillState();

  SplitBillState get state => _state;

  void setTab(SplitTab tab) {
    if (_state.activeTab == tab) return;
    _state = _state.copyWith(activeTab: tab);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_state.themeMode == mode) return;
    _state = _state.copyWith(themeMode: mode);
    notifyListeners();
  }
}
