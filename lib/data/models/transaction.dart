enum TransactionType { income, expense }

extension TransactionTypeValue on TransactionType {
  String get value {
    switch (this) {
      case TransactionType.income:
        return 'income';
      case TransactionType.expense:
        return 'expense';
    }
  }

  static TransactionType fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case 'income':
        return TransactionType.income;
      case 'expense':
      default:
        return TransactionType.expense;
    }
  }
}

enum PaymentMethod { cash, card, upi, bankTransfer, other }

extension PaymentMethodValue on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.card:
        return 'card';
      case PaymentMethod.upi:
        return 'upi';
      case PaymentMethod.bankTransfer:
        return 'bankTransfer';
      case PaymentMethod.other:
        return 'other';
    }
  }

  static PaymentMethod fromValue(String? value) {
    switch (value?.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'card':
        return PaymentMethod.card;
      case 'upi':
        return PaymentMethod.upi;
      case 'banktransfer':
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      case 'other':
      default:
        return PaymentMethod.other;
    }
  }
}

class TransactionModel {
  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes = '',
    this.subcategory,
    this.merchant,
    this.paymentMethod = PaymentMethod.other,
    this.upiApp,
    this.latitude,
    this.longitude,
    this.address,
    this.receiptImage,
    this.voiceNote,
    this.notificationId,
    this.isAutoDetected = false,
    this.currency = 'USD',
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String notes;
  final String? subcategory;
  final String? merchant;
  final PaymentMethod paymentMethod;
  final String? upiApp;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? receiptImage;
  final String? voiceNote;
  final int? notificationId;
  final bool isAutoDetected;
  final String currency;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayAmount {
    final sign = type == TransactionType.income ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  String get formattedDate {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String get formattedCategory {
    return subcategory == null || subcategory!.isEmpty
        ? category
        : '$category • $subcategory';
  }

  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    TransactionType? type,
    String? category,
    DateTime? date,
    String? notes,
    String? subcategory,
    String? merchant,
    PaymentMethod? paymentMethod,
    String? upiApp,
    double? latitude,
    double? longitude,
    String? address,
    String? receiptImage,
    String? voiceNote,
    int? notificationId,
    bool? isAutoDetected,
    String? currency,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      subcategory: subcategory ?? this.subcategory,
      merchant: merchant ?? this.merchant,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      upiApp: upiApp ?? this.upiApp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      receiptImage: receiptImage ?? this.receiptImage,
      voiceNote: voiceNote ?? this.voiceNote,
      notificationId: notificationId ?? this.notificationId,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
      currency: currency ?? this.currency,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.value,
      'category': category,
      'subcategory': subcategory,
      'merchant': merchant,
      'paymentMethod': paymentMethod.value,
      'upiApp': upiApp,
      'date': date.toIso8601String(),
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'receiptImage': receiptImage,
      'voiceNote': voiceNote,
      'notificationId': notificationId,
      'isAutoDetected': isAutoDetected ? 1 : 0,
      'currency': currency,
      'tags': tags.join(','),
      'createdAt': (createdAt ?? DateTime.now()).toIso8601String(),
      'updatedAt': (updatedAt ?? DateTime.now()).toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  static DateTime _parseRequiredDate(String? value) {
    return _parseDateTime(value) ?? DateTime.now();
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionTypeValue.fromValue(map['type'] as String?),
      category: map['category'] as String,
      date: _parseRequiredDate(map['date'] as String?),
      notes: (map['notes'] as String?) ?? '',
      subcategory: map['subcategory'] as String?,
      merchant: map['merchant'] as String?,
      paymentMethod: PaymentMethodValue.fromValue(map['paymentMethod'] as String?),
      upiApp: map['upiApp'] as String?,
      latitude: map['latitude'] == null ? null : (map['latitude'] as num).toDouble(),
      longitude: map['longitude'] == null ? null : (map['longitude'] as num).toDouble(),
      address: map['address'] as String?,
      receiptImage: map['receiptImage'] as String?,
      voiceNote: map['voiceNote'] as String?,
      notificationId: map['notificationId'] as int?,
      isAutoDetected: map['isAutoDetected'] == 1 || map['isAutoDetected'] == true,
      currency: map['currency'] as String? ?? 'USD',
      tags: (map['tags'] as String? ?? '')
          .split(',')
          .where((tag) => tag.isNotEmpty)
          .toList(),
      createdAt: _parseDateTime(map['createdAt'] as String?),
      updatedAt: _parseDateTime(map['updatedAt'] as String?),
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel.fromMap(json);
}