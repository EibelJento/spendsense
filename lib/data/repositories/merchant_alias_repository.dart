import '../database/database_service.dart';
import '../models/merchant_alias_model.dart';
import 'package:sqflite/sqflite.dart';

class MerchantAliasRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> saveAlias({
    required String merchantName,
    required String displayName,
  }) async {
    final db = await _databaseService.database;

    await db.insert(
      DatabaseService.tableMerchantAliases,
      {
        DatabaseService.columnMerchantName: merchantName,
        DatabaseService.columnDisplayName: displayName,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getAlias(String merchantName) async {
    final db = await _databaseService.database;

    final result = await db.query(
      DatabaseService.tableMerchantAliases,
      columns: [DatabaseService.columnDisplayName],
      where: '${DatabaseService.columnMerchantName} = ?',
      whereArgs: [merchantName],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first[DatabaseService.columnDisplayName] as String;
  }

  Future<List<MerchantAliasModel>> getAllAliases() async {
    final db = await _databaseService.database;

    final result = await db.query(
      DatabaseService.tableMerchantAliases,
      orderBy: DatabaseService.columnDisplayName,
    );

    return result
        .map((e) => MerchantAliasModel.fromMap(e))
        .toList();
  }

  Future<void> deleteAlias(String merchantName) async {
    final db = await _databaseService.database;

    await db.delete(
      DatabaseService.tableMerchantAliases,
      where: '${DatabaseService.columnMerchantName} = ?',
      whereArgs: [merchantName],
    );
  }
}