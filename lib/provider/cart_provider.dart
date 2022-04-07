import 'package:demo/model/cart_model.dart';
import 'package:demo/sqlite/cart_db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier{
  CartDB db = CartDB();

  int _counter =0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart => _cart;

  void _setPreItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPreItems()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('cart_item') ?? 0;
    prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter(){
    _counter++;
    _setPreItems();
  }

  void removeCounter(){
    _counter--;
    _setPreItems();
  }

  int getCounter(){
    _getPreItems();
    return _counter;
  }

  void addTotalPrice(double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setPreItems();
  }

  void removeTotalPrice(double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPreItems();
  }

  double getTotalPrice(){
    _getPreItems();
    return _totalPrice;
  }

  Future<List<Cart>> getCartList () async{
    return db.getCartList();
  }

}