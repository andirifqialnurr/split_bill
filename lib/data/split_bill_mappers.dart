import '../core/money.dart';
import '../domain/split_bill_models.dart';

String splitModeToDb(SplitMode mode) {
  return switch (mode) {
    SplitMode.equal => 'equal',
    SplitMode.items => 'items',
    SplitMode.custom => 'custom',
  };
}

SplitMode splitModeFromDb(String value) {
  return switch (value) {
    'equal' => SplitMode.equal,
    'custom' => SplitMode.custom,
    _ => SplitMode.items,
  };
}

String chargeTypeToDb(ChargeType type) {
  return switch (type) {
    ChargeType.none => 'none',
    ChargeType.fixed => 'fixed',
    ChargeType.percentage => 'percentage',
  };
}

ChargeType chargeTypeFromDb(String value) {
  return switch (value) {
    'fixed' => ChargeType.fixed,
    'percentage' => ChargeType.percentage,
    _ => ChargeType.none,
  };
}
