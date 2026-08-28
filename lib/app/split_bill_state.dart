import 'package:flutter/material.dart';

import '../data/split_bill_repository.dart';
import '../domain/split_bill_models.dart';

enum SplitTab { home, settings }

enum BillStep { detail, people, items, charges, result }

class SplitBillState {
  const SplitBillState({
    this.themeMode = ThemeMode.system,
    this.activeTab = SplitTab.home,
    this.history = const [],
    this.isLoading = false,
    this.errorMessage,
    this.draft,
    this.currentStep = BillStep.detail,
  });

  final ThemeMode themeMode;
  final SplitTab activeTab;
  final List<SavedBillSummary> history;
  final bool isLoading;
  final String? errorMessage;
  final DraftBill? draft;
  final BillStep currentStep;

  SplitBillState copyWith({
    ThemeMode? themeMode,
    SplitTab? activeTab,
    List<SavedBillSummary>? history,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    DraftBill? draft,
    bool clearDraft = false,
    BillStep? currentStep,
  }) {
    return SplitBillState(
      themeMode: themeMode ?? this.themeMode,
      activeTab: activeTab ?? this.activeTab,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      draft: clearDraft ? null : draft ?? this.draft,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}
