import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:csv/csv.dart';
import 'dart:io';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'inventory.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // таблица товаров
        await db.execute('''
          CREATE TABLE products(
            id TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            price REAL,
            quantity INTEGER
          )
        ''');

        // таблица продаж
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productId TEXT,
            date TEXT,
            quantity INTEGER,
            total REAL
          )
        ''');

        // таблица расходов
        await db.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT,
            date TEXT,
            amount REAL
          )
        ''');
      },
    );
  }

  // ---------- Товары ----------
  Future<void> addProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert(
      'products',
      product,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  // ---------- Продажи ----------
  Future<void> addSale(Map<String, dynamic> sale) async {
    final db = await database;
    await db.insert(
      'sales',
      sale,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await database;
    return await db.query('sales');
  }

  // ---------- Расходы ----------
  Future<void> addExpense(Map<String, dynamic> expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('expenses');
  }

  // ---------- Отчёт в CSV ----------
  Future<File> exportReportToCSV() async {
    final db = await database;

    final products = await db.query('products');
    final sales = await db.query('sales');
    final expenses = await db.query('expenses');

    List<List<dynamic>> rows = [];

    rows.add(['Товары']);
    rows.add(['ID', 'Название', 'Описание', 'Цена', 'Количество']);
    for (var p in products) {
      rows.add([
        p['id'],
        p['name'],
        p['description'],
        p['price'],
        p['quantity'],
      ]);
    }

    rows.add([]);
    rows.add(['Продажи']);
    rows.add(['ID', 'ID товара', 'Дата', 'Кол-во', 'Сумма']);
    for (var s in sales) {
      rows.add([s['id'], s['productId'], s['date'], s['quantity'], s['total']]);
    }

    rows.add([]);
    rows.add(['Расходы']);
    rows.add(['ID', 'Описание', 'Дата', 'Сумма']);
    for (var e in expenses) {
      rows.add([e['id'], e['description'], e['date'], e['amount']]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getDatabasesPath();
    final file = File(join(directory, 'report.csv'));
    return await file.writeAsString(csv);
  }
}
