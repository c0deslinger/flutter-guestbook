import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:guestbook/model/guest.dart';

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
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "guestbook.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE guests (
        id TEXT PRIMARY KEY,
        name TEXT,
        address TEXT,
        activity TEXT,
        imagePath TEXT,
        photoUrl TEXT,
        date TEXT
      )
    ''');
  }

  Future<int> insertGuest(Guest guest) async {
    Database db = await database;
    return await db.insert('guests', guest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Guest>> getGuests() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('guests');
    return List.generate(maps.length, (i) {
      return Guest.fromMap(maps[i]);
    });
  }

  // Add this method to the DatabaseHelper class in database.dart
  Future<int> deleteGuest(String id) async {
    final db = await database;
    return await db.delete(
      'guests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
