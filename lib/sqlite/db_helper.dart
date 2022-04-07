import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
  }

  initDatabase() async {
    String directory = await getDatabasesPath();
    String path = join(directory, "shopping.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    var userTable = 'CREATE TABLE user ('
        'id INTEGER PRIMARY KEY '
        ', uid VARCHAR UNIQUE'
        ', email VARCHAR'
        ', name VARCHAR'
        ', image TEXT )';
    var cartTable = 'CREATE TABLE cart ('
        '  id INTEGER PRIMARY KEY '
        ', productId VARCHAR UNIQUE'
        ', productName TEXT'
        ', initialPrice INTEGER'
        ', productPrice INTEGER '
        ', quantity INTEGER'
        ', unitTag TEXT '
        ', image TEXT )';

    await db.execute(userTable);
    await db.execute(cartTable);
  }
}