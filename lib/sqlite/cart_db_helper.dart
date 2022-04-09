import 'dart:async';

import 'package:demo/sqlite/db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:demo/model/cart_model.dart';

class CartDB{

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

  Future<int> deleteAllProduct()async{
    var dbClient = await _dbHelper.db;
    return await dbClient!.delete(
      'cart'
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