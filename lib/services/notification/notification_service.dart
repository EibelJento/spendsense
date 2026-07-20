import 'dart:async';

import 'package:flutter/services.dart';

import '../../data/models/transaction.dart';

class NotificationService {
  static const EventChannel _channel =
      EventChannel('spendsense/notifications');

  Stream<TransactionModel> get transactionStream {
    return _channel.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);

      return TransactionModel(
        title: map['merchant'] ?? 'UPI Transaction',
        amount: (map['amount'] as num).toDouble(),
        type: TransactionTypeValue.fromValue(map['type']),
        category: 'Other',
        date: DateTime.fromMillisecondsSinceEpoch(
          map['timestamp'] as int,
        ),
        merchant: map['merchant'] as String?,
        paymentMethod: PaymentMethod.upi,
        upiApp: _getUpiApp(map['sourceApp'] as String?),
        isAutoDetected: true,
        currency: 'INR',
      );
    });
  }

  String _getUpiApp(String? packageName) {
    switch (packageName) {
      case 'com.google.android.apps.nbu.paisa.user':
        return 'Google Pay';

      case 'com.phonepe.app':
        return 'PhonePe';

      case 'net.one97.paytm':
        return 'Paytm';

      default:
        return 'Unknown';
    }
  }
}