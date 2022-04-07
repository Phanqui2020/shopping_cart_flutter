import 'dart:async';
import 'dart:io';

import 'package:demo/sqlite/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:demo/model/user_model.dart';

class UserDb {
  // static Database? _db;
  //
  // Future<Database?> get db async{
  //   if(_db != null){
  //     return _db!;
  //   }
  //
  //   _db = await initDatabase();
  // }
  //
  // initDatabase() async {
  //   try{
  //     // Directory directory = await getApplicationDocumentsDirectory();
  //     String directory = await getDatabasesPath();
  //     String path = join(directory, "shopping.db");
  //     var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  //     return db;
  //   }catch (e){
  //     print(e.toString());
  //   }
  // }
  //
  // _onCreate(Database db, int version) async{
  //   await db.execute(
  //       'CREATE TABLE user ('
  //           '  id INTEGER PRIMARY KEY '
  //           ', uid VARCHAR UNIQUE'
  //           ', email VARCHAR'
  //           ', name VARCHAR'
  //           ', image TEXT )');
  // }

  final DBHelper _dbHelper = DBHelper();

  Future<UserModel> insert(UserModel userModel) async{
    var dbClient = await _dbHelper.db;
    await dbClient!.insert('user', userModel.toMap());
    return userModel;
  }

  Future<UserModel> getUser()async{
    UserModel userModel = UserModel();
    var dbClient = await _dbHelper.db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'user',);
    for (var element in queryResult) {
      userModel.uid = element["uid"] as String?;
      userModel.name = element["name"] as String?;
      userModel.email = element["email"] as String?;
      userModel.image = element["image"] as String?;
    }
    return userModel;
  }

  Future<void> deleteUserByUid(String uid)async{
    var dbClient = await _dbHelper.db;
    await dbClient!.delete(
      'user',
      where: 'uid = ?',
      whereArgs: [uid],);
  }


}