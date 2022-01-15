
import 'package:flutter/foundation.dart';

enum Gender{men, women}

class CounterProvider extends ChangeNotifier {
  Gender _gender = Gender.men;

  Gender get gender => _gender;

  set gender(Gender value) {
    _gender = value;
    notifyListeners();
  }
}