import 'dart:async';

import 'package:demo/sqlite/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:demo/model/cart_model.dart';

class CartDB{
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
  //   String directory = await getDatabasesPath();
  //   String path = join(directory, "shopping.db");
  //   var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  //   return db;
  // }
  //
  // _onCreate(Database db, int version) async{
  //   var userTable = 'CREATE TABLE user ('
  //                   'id INTEGER PRIMARY KEY '
  //                   ', uid VARCHAR UNIQUE'
  //                   ', email VARCHAR'
  //                   ', name VARCHAR'
  //                   ', image TEXT )';
  //   var cartTable = 'CREATE TABLE cart ('
  //       '  id INTEGER PRIMARY KEY '
  //       ', productId VARCHAR UNIQUE'
  //       ', productName TEXT'
  //       ', initialPrice INTEGER'
  //       ', productPrice INTEGER '
  //       ', quantity INTEGER'
  //       ', unitTag TEXT '
  //       ', image TEXT )';
  //
  //   await db.execute(userTable);
  //   await db.execute(cartTable);
  // }

  final DBHelper _dbHelper = DBHelper();

  Future<Cart> insert(Cart cart)async{
    print(cart.toMap());
    var dbClient = await _dbHelper.db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList()async{
    var dbClient = await _dbHelper.db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> deleteProduct(int id)async{
    var dbClient = await _dbHelper.db;
    return await dbClient!.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateQuantity(Cart cart)async{
    var dbClient = await _dbHelper.db;
    return await dbClient!.update(
      'cart',
      cart.toMap(),
      where: 'id = ?',
      whereArgs: [cart.id],
    );
  }
}