import 'package:sqflite/sqflite.dart';

import '../../../data/database/database_service.dart';
import '../../../data/models/transaction.dart';

class TransactionRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> addTransaction(TransactionModel transaction) async {
    final Database db = await _databaseService.database;

    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionModel>> getTransactions() async {
    final Database db = await _databaseService.database;

    final List<Map<String, dynamic>> maps =
        await db.query('transactions', orderBy: 'date DESC');

    return maps
        .map((map) => TransactionModel.fromMap(map))
        .toList();
  }

  Future<void> deleteTransaction(int id) async {
    final Database db = await _databaseService.database;

    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final Database db = await _databaseService.database;

    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }
}