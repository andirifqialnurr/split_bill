import 'package:flutter/material.dart';

import '../core/money.dart';
import '../data/split_bill_database.dart';
import '../data/split_bill_repository.dart';
import '../domain/split_bill_calculator.dart';
import '../domain/split_bill_models.dart';
import 'split_bill_strings.dart';
import 'split_bill_state.dart';

class SplitBillController extends ChangeNotifier {
  SplitBillController({
    SplitBillRepository? repository,
    SplitBillCalculator calculator = const SplitBillCalculator(),
  })  : _repository = repository ?? SplitBillRepository(SplitBillDatabase()),
        _calculator = calculator;

  final SplitBillRepository _repository;
  final SplitBillCalculator _calculator;
  var _nextLocalId = 1;

  SplitBillState _state = const SplitBillState();

  SplitBillState get state => _state;

  SplitStrings get strings => SplitStrings(_state.language);

  BillCalculation? get currentCalculation {
    final draft = _state.draft;
    if (draft == null) return null;
    try {
      return _calculator.calculate(draft);
    } on BillValidationException {
      return null;
    }
  }

  bool get hasDraftChanges {
    final draft = _state.draft;
    if (draft == null) return false;
    return draft.title.trim().isNotEmpty ||
        draft.equalTotalAmount > 0 ||
        draft.participants.isNotEmpty ||
        draft.items.isNotEmpty ||
        draft.customShares.isNotEmpty ||
        draft.tax.value > 0 ||
        draft.service.value > 0 ||
        draft.discount.value > 0;
  }

  bool participantHasAssignment(String localId) {
    final draft = _state.draft;
    if (draft == null) return false;
    return draft.items.any((item) => item.participantIds.contains(localId)) ||
        draft.customShares.containsKey(localId);
  }

  Future<void> loadHistory() async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();
    try {
      final history = await _repository.listBills();
      _state = _state.copyWith(history: history, isLoading: false);
    } catch (error) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load saved bills.',
      );
    }
    notifyListeners();
  }

  Future<SavedBillDetail?> getBillDetail(int id) {
    return _repository.getBillDetail(id);
  }

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

  void setLanguage(AppLanguage language) {
    if (_state.language == language) return;
    _state = _state.copyWith(language: language);
    notifyListeners();
  }

  void startBill(SplitMode mode) {
    _state = _state.copyWith(
      draft: DraftBill(
        occurredAt: DateTime.now(),
        mode: mode,
      ),
      currentStep: BillStep.detail,
      clearError: true,
    );
    notifyListeners();
  }

  void closeDraft() {
    _state = _state.copyWith(clearDraft: true, currentStep: BillStep.detail);
    notifyListeners();
  }

  void setStep(BillStep step) {
    _state = _state.copyWith(currentStep: step, clearError: true);
    notifyListeners();
  }

  void nextStep() {
    final steps = _activeSteps();
    final index = steps.indexOf(_state.currentStep);
    if (index < 0) {
      setStep(steps.first);
      return;
    }
    if (index >= steps.length - 1) return;
    setStep(steps[index + 1]);
  }

  void previousStep() {
    final steps = _activeSteps();
    final index = steps.indexOf(_state.currentStep);
    if (index < 0) {
      setStep(steps.first);
      return;
    }
    if (index <= 0) return;
    setStep(steps[index - 1]);
  }

  List<BillStep> _activeSteps() {
    final mode = _state.draft?.mode ?? SplitMode.items;
    return switch (mode) {
      SplitMode.items => const [
          BillStep.detail,
          BillStep.people,
          BillStep.items,
          BillStep.charges,
          BillStep.result,
        ],
      SplitMode.equal || SplitMode.custom => const [
          BillStep.detail,
          BillStep.people,
          BillStep.charges,
          BillStep.result,
        ],
    };
  }

  void updateDraft(DraftBill Function(DraftBill draft) update) {
    final draft = _state.draft;
    if (draft == null) return;
    _state = _state.copyWith(draft: update(draft), clearError: true);
    notifyListeners();
  }

  void setMode(SplitMode mode) {
    updateDraft((draft) => draft.copyWith(mode: mode));
  }

  void setTitle(String title) {
    updateDraft((draft) => draft.copyWith(title: title));
  }

  void setBillTotal(String value) {
    updateDraft((draft) => draft.copyWith(equalTotalAmount: parseRupiah(value)));
  }

  void addParticipant(String name) {
    final cleaned = name.trim();
    if (cleaned.isEmpty) return;
    updateDraft((draft) {
      final participant = BillParticipant(
        localId: 'p${_nextLocalId++}',
        name: cleaned,
        colorSeed: draft.participants.length,
      );
      return draft.copyWith(participants: [...draft.participants, participant]);
    });
  }

  void removeParticipant(String localId) {
    updateDraft((draft) {
      final hasAssignment = draft.items.any((item) => item.participantIds.contains(localId));
      final items = hasAssignment
          ? [
              for (final item in draft.items)
                item.copyWith(
                  participantIds: item.participantIds.where((id) => id != localId).toList(),
                ),
            ]
          : draft.items;
      final customShares = Map<String, int>.from(draft.customShares)..remove(localId);
      return draft.copyWith(
        participants: draft.participants.where((p) => p.localId != localId).toList(),
        items: items,
        customShares: customShares,
      );
    });
  }

  void renameParticipant(String localId, String name) {
    final cleaned = name.trim();
    if (cleaned.isEmpty) return;
    updateDraft((draft) {
      return draft.copyWith(
        participants: [
          for (final participant in draft.participants)
            if (participant.localId == localId)
              participant.copyWith(name: cleaned)
            else
              participant,
        ],
      );
    });
  }

  void addItem({
    required String name,
    required String quantity,
    required String totalAmount,
  }) {
    final cleaned = name.trim();
    if (cleaned.isEmpty) return;
    updateDraft((draft) {
      final parsedQuantity = int.tryParse(quantity.trim()) ?? 1;
      final item = BillItem(
        localId: 'i${_nextLocalId++}',
        name: cleaned,
        quantity: parsedQuantity.clamp(1, 999),
        totalAmount: parseRupiah(totalAmount),
      );
      return draft.copyWith(items: [...draft.items, item]);
    });
  }

  void removeItem(String localId) {
    updateDraft((draft) {
      return draft.copyWith(
        items: draft.items.where((item) => item.localId != localId).toList(),
      );
    });
  }

  void setItemParticipants(String itemId, List<String> participantIds) {
    updateDraft((draft) {
      return draft.copyWith(
        items: [
          for (final item in draft.items)
            if (item.localId == itemId)
              item.copyWith(participantIds: participantIds)
            else
              item,
        ],
      );
    });
  }

  void setCustomShare(String participantId, String value) {
    updateDraft((draft) {
      final shares = Map<String, int>.from(draft.customShares);
      shares[participantId] = parseRupiah(value);
      return draft.copyWith(customShares: shares);
    });
  }

  void setTax(BillCharge charge) {
    updateDraft((draft) => draft.copyWith(tax: charge));
  }

  void setService(BillCharge charge) {
    updateDraft((draft) => draft.copyWith(service: charge));
  }

  void setDiscount(BillCharge charge) {
    updateDraft((draft) => draft.copyWith(discount: charge));
  }

  BillCalculation calculateOrThrow() {
    final draft = _state.draft;
    if (draft == null) {
      throw const BillValidationException('Create a bill first.');
    }
    return _calculator.calculate(draft);
  }

  Future<int?> saveCurrentBill() async {
    final draft = _state.draft;
    if (draft == null) return null;
    try {
      final calculation = _calculator.calculate(draft);
      final id = await _repository.saveBillSnapshot(draft, calculation);
      final history = await _repository.listBills();
      _state = _state.copyWith(
        history: history,
        clearDraft: true,
        currentStep: BillStep.detail,
        clearError: true,
      );
      notifyListeners();
      return id;
    } on BillValidationException catch (error) {
      _state = _state.copyWith(errorMessage: error.message);
    } catch (_) {
      _state = _state.copyWith(errorMessage: 'Could not save bill.');
    }
    notifyListeners();
    return null;
  }
}
