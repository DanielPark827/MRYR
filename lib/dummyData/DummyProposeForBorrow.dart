import 'package:flutter/material.dart';

class DummyProposeForBorrow with ChangeNotifier {
  String Price = null;
  String Start = null;
  String End = null;

  void ChangePrice(String value) {
    Price = value;
    notifyListeners();
  }
  void ChangeStart(String value) {
    Start = value;
    notifyListeners();
  }
  void ChangeEnd(String value) {
    End = value;
    notifyListeners();
  }
}