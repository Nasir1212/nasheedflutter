import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

//static final  DatabaseHelper instance = DatabaseHelper._privateConstructor();
static Database? _database;


  // DatabaseHelper._privateConstructor();

   Future <Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
   }

   Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(),"lyrics.db");
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
   }

   Future _onCreate(Database db , int version) async{
    String sql = '''CREATE TABLE nate_rasul (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      db_id TEXT,
      title TEXT,
      name TEXT,
      lyrics TEXT
    );''';
      await db.execute(sql);
   }

Future<void> dropDatabase() async {
  // Get the path to the database
  String path = join(await getDatabasesPath(), 'lyrics.db');

  // Delete the database file
  await deleteDatabase(path);
  print("Database dropped successfully");
}

   Future<void> insertItem(Map<String,dynamic> obj)async{

   final db = await database;
     final existingItems = await db.query(
    'nate_rasul',
    where: 'db_id = ?',
    whereArgs: [obj['db_id']],  // Use the id in the check
  );

 if(existingItems.isEmpty){
    await db.insert('nate_rasul', obj);

 }else{
  print("Item with id ${obj['db_id']} already exists, skipping insert.");
 }
   }
Future<bool> notDownload(int id)async{
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


}