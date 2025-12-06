import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Receipt {
  final int? id;
  final String title;
  final int amount;
  final String date;
  final String? imagePath; // 사진 위치 저장용 (추가됨)

  Receipt({
    this.id, 
    required this.title, 
    required this.amount, 
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'imagePath': imagePath,
    };
  }
}

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();
  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'receipt_manager_v2.db'); // v2로 이름 변경 (새로 생성)
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // imagePath 컬럼 추가됨
        await db.execute('''
          CREATE TABLE receipts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount INTEGER,
            date TEXT,
            imagePath TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertReceipt(Receipt receipt) async {
    final db = await database;
    await db.insert('receipts', receipt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Receipt>> getAllReceipts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('receipts');
    return List.generate(maps.length, (i) {
      return Receipt(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        imagePath: maps[i]['imagePath'],
      );
    });
  }
}