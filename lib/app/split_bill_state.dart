import 'package:flutter/material.dart';

enum SplitTab { home, settings }

class SplitBillState {
  const SplitBillState({
    this.themeMode = ThemeMode.system,
    this.activeTab = SplitTab.home,
  });

  final ThemeMode themeMode;
  final SplitTab activeTab;

  SplitBillState copyWith({
    ThemeMode? themeMode,
    SplitTab? activeTab,
  }) {
    return SplitBillState(
      themeMode: themeMode ?? this.themeMode,
      activeTab: activeTab ?? this.activeTab,
    );
  }
}
