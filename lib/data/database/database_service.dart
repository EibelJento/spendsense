import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const int databaseVersion = 3;
  static const String databaseName = 'spendsense.db';

  static const String tableTransactions = 'transactions';

  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnAmount = 'amount';
  static const String columnType = 'type';
  static const String columnCategory = 'category';
  static const String columnSubcategory = 'subcategory';
  static const String columnMerchant = 'merchant';
  static const String columnPaymentMethod = 'paymentMethod';
  static const String columnUpiApp = 'upiApp';
  static const String columnDate = 'date';
  static const String columnNotes = 'notes';
  static const String columnLatitude = 'latitude';
  static const String columnLongitude = 'longitude';
  static const String columnAddress = 'address';
  static const String columnReceiptImage = 'receiptImage';
  static const String columnVoiceNote = 'voiceNote';
  static const String columnNotificationId = 'notificationId';
  static const String columnIsAutoDetected = 'isAutoDetected';
  static const String columnCurrency = 'currency';
  static const String columnTags = 'tags';
  static const String columnCreatedAt = 'createdAt';
  static const String columnUpdatedAt = 'updatedAt';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTransactions(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnType TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnSubcategory TEXT,
        $columnMerchant TEXT,
        $columnPaymentMethod TEXT,
        $columnUpiApp TEXT,
        $columnDate TEXT NOT NULL,
        $columnNotes TEXT,
        $columnLatitude REAL,
        $columnLongitude REAL,
        $columnAddress TEXT,
        $columnReceiptImage TEXT,
        $columnVoiceNote TEXT,
        $columnNotificationId TEXT,
        $columnIsAutoDetected INTEGER NOT NULL DEFAULT 0,
        $columnCurrency TEXT NOT NULL DEFAULT 'USD',
        $columnTags TEXT,
        $columnCreatedAt TEXT NOT NULL,
        $columnUpdatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnSubcategory TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnMerchant TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnPaymentMethod TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnUpiApp TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnLatitude REAL');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnLongitude REAL');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnAddress TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnReceiptImage TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnVoiceNote TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnNotificationId TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnIsAutoDetected INTEGER NOT NULL DEFAULT 0');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnCurrency TEXT NOT NULL DEFAULT "USD"');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnTags TEXT');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnCreatedAt TEXT NOT NULL DEFAULT ""');
      await db.execute('ALTER TABLE $tableTransactions ADD COLUMN $columnUpdatedAt TEXT NOT NULL DEFAULT ""');
    }
  }
}