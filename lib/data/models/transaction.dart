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

class TransactionModel {
  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes = '',
  });

  final int? id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final DateTime date;
  final String notes;

  String get displayAmount {
    final sign = type == TransactionType.income ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.value,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: TransactionTypeValue.fromValue(map['type'] as String?),
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      notes: (map['notes'] as String?) ?? '',
    );
  }
}