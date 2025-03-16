import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
//static final  DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  // DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), "lyrics.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    String sql = '''CREATE TABLE nate_rasul (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      db_id TEXT,
      title TEXT,
      name TEXT,
      lyrics TEXT
    );''';
    await db.execute(sql);

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT , 
        name TEXT,
        email TEXT ,
        phone TEXT ,
        token TEXT  
      );
    ''');
  }

  Future<void> dropDatabase() async {
    // Get the path to the database
    String path = join(await getDatabasesPath(), 'lyrics.db');

    // Delete the database file
    await deleteDatabase(path);
    print("Database dropped successfully");
  }

  Future<void> insertItem(Map<String, dynamic> obj) async {
    final db = await database;
    final existingItems = await db.query(
      'nate_rasul',
      where: 'db_id = ?',
      whereArgs: [obj['db_id']], // Use the id in the check
    );

    if (existingItems.isEmpty) {
      await db.insert('nate_rasul', obj);
    } else {
      print("Item with id ${obj['db_id']} already exists, skipping insert.");
    }
  }

  Future<bool> notDownload(int id) async {
    final db = await database;
    final existingItems = await db.query(
      'nate_rasul',
      where: 'db_id = ?',
      whereArgs: [id],
    );
    return existingItems.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return await db.query('nate_rasul');
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('nate_rasul', where: 'id = ?', whereArgs: [id]);
  }

  //Save User form api

  Future<void> savedUserFromApi(
      Map<String, dynamic> userData, String token) async {
    final db = await database;
    db.insert('users', {
      'user_id': userData['id'].toString(),
      'name': userData['name'],
      'email': userData['email'],
      'phone': userData['phone'],
      'token': token,
    });
    print("User saved successfully!");
  }

  Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db.query('users');

    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }

  Future<bool?> isLogged() async {
    final user = await getUser();
    return user != null;
  }

  Future<String> getToken() async {
    final user = await getUser();
    print("My Token: ${user!['token']}");
    if (user.isNotEmpty) {
      return user['token'];
    } else {
      return '';
    }
  }

  Future<void> logout() async {
    final db = await database;
    await db.delete('users'); // Delete all user records
    print("User logged out successfully!");
  }
}
