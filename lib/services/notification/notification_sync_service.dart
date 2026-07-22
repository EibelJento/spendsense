import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:spendsense/data/models/transaction.dart';
import 'package:spendsense/data/repositories/transaction_repository.dart';

class NotificationSyncService {
  static const MethodChannel _channel =
      MethodChannel('spendsense/notification_method');

  Future<List<Map<String, dynamic>>> getPendingTransactions() async {
    final result =
        await _channel.invokeMethod<List<dynamic>>('getPendingTransactions');

    if (result == null) return [];

    return result
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  Future<void> clearPendingTransactions() async {
    await _channel.invokeMethod('clearPendingTransactions');
  }

  Future<void> syncPendingTransactions(
    TransactionRepository repository,
  ) async {
    final pending = await getPendingTransactions();

    for (final data in pending) {
      debugPrint("Importing: $data");
      final transaction = TransactionModel(
        notificationId: data['notificationId'] as String?,
        amount: (data['amount'] as num).toDouble(),
        type: TransactionTypeValue.fromValue(data['type']),
        category: 'Other',
        date: DateTime.fromMillisecondsSinceEpoch(
          data['timestamp'] as int,
        ),
        originalMerchant: data['merchant'] as String?,
        merchant: data['merchant'] as String?,
        paymentMethod: PaymentMethod.upi,
        upiApp: _getUpiApp(data['sourceApp'] as String?),
        isAutoDetected: true,
        currency: 'INR',
      );

      await repository.addTransaction(transaction);
    }

    if (pending.isNotEmpty) {
      await clearPendingTransactions();
      debugPrint("Pending queue cleared.");

      debugPrint(
        'Imported ${pending.length} pending transaction(s).',
      );
    }
  }

  String? _getUpiApp(String? packageName) {
    switch (packageName) {
      case 'com.google.android.apps.nbu.paisa.user':
        return 'Google Pay';

      case 'com.phonepe.app':
        return 'PhonePe';

      case 'net.one97.paytm':
        return 'Paytm';

      default:
        return null;
    }
  }
}