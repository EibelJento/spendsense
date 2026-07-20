import 'package:sqflite/sqflite.dart';

import '../../core/errors/app_exception.dart';
import '../database/database_service.dart';
import '../models/transaction.dart';

class TransactionRepository {
  
  TransactionRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService.instance;

  final DatabaseService _databaseService;

  Future<void> addTransaction(TransactionModel transaction) async {
  try {
    final Database db = await _databaseService.database;

    if (transaction.notificationId != null) {
      final exists = await notificationExists(
        transaction.notificationId!,
      );

      if (exists) {
        return;
      }
    }

    await db.insert(
      DatabaseService.tableTransactions,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (error) {
    throw AppException('Failed to add transaction', cause: error);
  }
}

  Future<bool> notificationExists(String notificationId) async {
  final Database db = await _databaseService.database;

  final result = await db.query(
    DatabaseService.tableTransactions,
    columns: [DatabaseService.columnId],
    where: '${DatabaseService.columnNotificationId} = ?',
    whereArgs: [notificationId],
    limit: 1,
  );

  return result.isNotEmpty;
}

  Future<List<TransactionModel>> getTransactions() async {
    return _getTransactionsWithQuery(
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to load transactions',
    );
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final Database db = await _databaseService.database;

      if (transaction.id == null) {
        throw AppException('Cannot update a transaction without an id');
      }

      await db.update(
        DatabaseService.tableTransactions,
        transaction.toMap(),
        where: '${DatabaseService.columnId} = ?',
        whereArgs: [transaction.id],
      );
    } catch (error) {
      throw AppException('Failed to update transaction', cause: error);
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      final Database db = await _databaseService.database;

      await db.delete(
        DatabaseService.tableTransactions,
        where: '${DatabaseService.columnId} = ?',
        whereArgs: [id],
      );
    } catch (error) {
      throw AppException('Failed to delete transaction', cause: error);
    }
  }

  Future<List<TransactionModel>> searchTransactions(String query) async {
    if (query.trim().isEmpty) {
      return getTransactions();
    }

    final searchValue = '%${query.trim().toLowerCase()}%';

    return _getTransactionsWithQuery(
      where: '''
        lower(${DatabaseService.columnTitle}) LIKE ?
        OR lower(${DatabaseService.columnNotes}) LIKE ?
        OR lower(${DatabaseService.columnCategory}) LIKE ?
        OR lower(${DatabaseService.columnMerchant}) LIKE ?
      ''',
      whereArgs: [searchValue, searchValue, searchValue, searchValue],
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to search transactions',
    );
  }

  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    return _getTransactionsWithQuery(
      where: '${DatabaseService.columnCategory} = ?',
      whereArgs: [category],
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to load transactions by category',
    );
  }

  Future<List<TransactionModel>> getTransactionsByMonth(DateTime date) async {
    final startDate = DateTime(date.year, date.month, 1);
    final endDate = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);

    return _getTransactionsWithQuery(
      where: '${DatabaseService.columnDate} BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to load transactions by month',
    );
  }

  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final start = startDate.toIso8601String();
    final end = endDate.toIso8601String();

    return _getTransactionsWithQuery(
      where: '${DatabaseService.columnDate} BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to load transactions by date range',
    );
  }

  Future<List<TransactionModel>> getIncome() async {
    return _getTransactionsWithQuery(
      where: '${DatabaseService.columnType} = ?',
      whereArgs: [TransactionType.income.value],
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to load income transactions',
    );
  }

  Future<List<TransactionModel>> getExpenses() async {
    return _getTransactionsWithQuery(
      where: '${DatabaseService.columnType} = ?',
      whereArgs: [TransactionType.expense.value],
      orderBy: '${DatabaseService.columnDate} DESC',
      errorMessage: 'Failed to load expense transactions',
    );
  }

  Future<double> getTotalBalance() async {
    try {
      final transactions = await getTransactions();
      return transactions.fold<double>(0, (sum, transaction) {
        return transaction.type == TransactionType.income
            ? sum + transaction.amount
            : sum - transaction.amount;
      });
    } catch (error) {
      throw AppException('Failed to calculate total balance', cause: error);
    }
  }

  Future<Map<String, double>> getMonthlySummary() async {
    try {
      final transactions = await getTransactions();
      final summary = <String, double>{};

      for (final transaction in transactions) {
        final monthKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
        final currentValue = summary[monthKey] ?? 0.0;
        final delta = transaction.type == TransactionType.income
            ? transaction.amount
            : -transaction.amount;
        summary[monthKey] = currentValue + delta;
      }

      return summary;
    } catch (error) {
      throw AppException('Failed to calculate monthly summary', cause: error);
    }
  }

  Future<Map<String, double>> getCategorySummary() async {
    try {
      final transactions = await getTransactions();
      final summary = <String, double>{};

      for (final transaction in transactions) {
        final category = transaction.category;
        final currentValue = summary[category] ?? 0.0;
        summary[category] = currentValue + transaction.amount;
      }

      return summary;
    } catch (error) {
      throw AppException('Failed to calculate category summary', cause: error);
    }
  }

  Future<List<TransactionModel>> _getTransactionsWithQuery({
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    required String errorMessage,
  }) async {
    try {
      final Database db = await _databaseService.database;

      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseService.tableTransactions,
        where: where,
        whereArgs: whereArgs?.map((value) => value as Object?).toList(),
        orderBy: orderBy,
      );

      return maps.map((map) => TransactionModel.fromMap(map)).toList();
    } catch (error) {
      throw AppException(errorMessage, cause: error);
    }
  }
}
