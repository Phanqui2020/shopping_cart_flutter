
import 'package:flutter/foundation.dart';

/// create provider (extends change Notifier)
/// notifyListerner()

class CounterProvider extends ChangeNotifier {
  int counter = 10;
  int get c => counter;

  void add(){
    counter++;
    notifyListeners();
  }
  void minus(){
    counter--;
    notifyListeners();
  }
}