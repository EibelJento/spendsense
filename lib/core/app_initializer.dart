import 'package:flutter/foundation.dart';

import 'package:spendsense/data/repositories/transaction_repository.dart';
import 'package:spendsense/services/notification/notification_service.dart';
import 'package:spendsense/services/notification/notification_sync_service.dart';

class AppInitializer {
  AppInitializer._();

  static final NotificationService _notificationService =
      NotificationService();

  static final NotificationSyncService _syncService =
      NotificationSyncService();

  static final TransactionRepository _repository =
      TransactionRepository();

  static Future<void> initialize() async {
    await _syncService.syncPendingTransactions(_repository);

    _notificationService.transactionStream.listen((transaction) async {
      await _repository.addTransaction(transaction);

      debugPrint("Auto-saved: ${transaction.merchant}");
    });
  }
}