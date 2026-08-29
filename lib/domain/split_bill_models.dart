import '../core/money.dart';

enum SplitMode { equal, items, custom }

class BillParticipant {
  const BillParticipant({
    required this.localId,
    required this.name,
    required this.colorSeed,
  });

  final String localId;
  final String name;
  final int colorSeed;

  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  BillParticipant copyWith({
    String? localId,
    String? name,
    int? colorSeed,
  }) {
    return BillParticipant(
      localId: localId ?? this.localId,
      name: name ?? this.name,
      colorSeed: colorSeed ?? this.colorSeed,
    );
  }
}

class BillItem {
  const BillItem({
    required this.localId,
    required this.name,
    required this.quantity,
    required this.totalAmount,
    this.participantIds = const [],
  });

  final String localId;
  final String name;
  final int quantity;
  final int totalAmount;
  final List<String> participantIds;

  BillItem copyWith({
    String? localId,
    String? name,
    int? quantity,
    int? totalAmount,
    List<String>? participantIds,
  }) {
    return BillItem(
      localId: localId ?? this.localId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      participantIds: participantIds ?? this.participantIds,
    );
  }
}

class DraftBill {
  const DraftBill({
    this.title = '',
    required this.occurredAt,
    this.mode = SplitMode.items,
    this.equalTotalAmount = 0,
    this.participants = const [],
    this.items = const [],
    this.customShares = const {},
    this.tax = const BillCharge(),
    this.service = const BillCharge(),
    this.discount = const BillCharge(),
  });

  final String title;
  final DateTime occurredAt;
  final SplitMode mode;
  final int equalTotalAmount;
  final List<BillParticipant> participants;
  final List<BillItem> items;
  final Map<String, int> customShares;
  final BillCharge tax;
  final BillCharge service;
  final BillCharge discount;

  DraftBill copyWith({
    String? title,
    DateTime? occurredAt,
    SplitMode? mode,
    int? equalTotalAmount,
    List<BillParticipant>? participants,
    List<BillItem>? items,
    Map<String, int>? customShares,
    BillCharge? tax,
    BillCharge? service,
    BillCharge? discount,
  }) {
    return DraftBill(
      title: title ?? this.title,
      occurredAt: occurredAt ?? this.occurredAt,
      mode: mode ?? this.mode,
      equalTotalAmount: equalTotalAmount ?? this.equalTotalAmount,
      participants: participants ?? this.participants,
      items: items ?? this.items,
      customShares: customShares ?? this.customShares,
      tax: tax ?? this.tax,
      service: service ?? this.service,
      discount: discount ?? this.discount,
    );
  }
}

class PersonItemShare {
  const PersonItemShare({
    required this.itemName,
    required this.amount,
  });

  final String itemName;
  final int amount;
}

class SettlementResult {
  const SettlementResult({
    required this.participant,
    required this.baseAmount,
    required this.chargesAmount,
    required this.discountAmount,
    required this.roundingAmount,
    required this.amountDue,
    this.items = const [],
  });

  final BillParticipant participant;
  final int baseAmount;
  final int chargesAmount;
  final int discountAmount;
  final int roundingAmount;
  final int amountDue;
  final List<PersonItemShare> items;
}

class BillCalculation {
  const BillCalculation({
    required this.subtotal,
    required this.taxAmount,
    required this.serviceAmount,
    required this.discountAmount,
    required this.grandTotal,
    required this.results,
  });

  final int subtotal;
  final int taxAmount;
  final int serviceAmount;
  final int discountAmount;
  final int grandTotal;
  final List<SettlementResult> results;
}

class BillValidationException implements Exception {
  const BillValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
