import 'package:intl/intl.dart';

final NumberFormat _rupiahFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

String formatRupiah(int amount) => _rupiahFormat.format(amount);

int parseRupiah(String input) {
  final normalized = input.replaceAll(RegExp(r'[^0-9-]'), '');
  if (normalized.isEmpty || normalized == '-') return 0;
  return int.tryParse(normalized) ?? 0;
}

int percentageToBasisPoints(String input) {
  final cleaned = input.replaceAll(',', '.').replaceAll('%', '').trim();
  final value = double.tryParse(cleaned);
  if (value == null || value <= 0) return 0;
  return (value * 100).round();
}

int chargeAmount({
  required int subtotal,
  required ChargeType type,
  required int value,
}) {
  return switch (type) {
    ChargeType.none => 0,
    ChargeType.fixed => value.clamp(0, 1 << 62),
    ChargeType.percentage => ((subtotal * value) + 5000) ~/ 10000,
  };
}

enum ChargeType { none, fixed, percentage }

class BillCharge {
  const BillCharge({
    this.type = ChargeType.none,
    this.value = 0,
  });

  final ChargeType type;
  final int value;

  int resolve(int subtotal) {
    return chargeAmount(subtotal: subtotal, type: type, value: value);
  }

  BillCharge copyWith({
    ChargeType? type,
    int? value,
  }) {
    return BillCharge(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}
