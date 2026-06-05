import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'app_ironlog.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT,
        senha TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        valor REAL,
        data TEXT,
        tipo TEXT
      )
    ''');
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String email, String senha) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return db.insert(
      'transactions',
      transaction,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return db.query('transactions');
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
