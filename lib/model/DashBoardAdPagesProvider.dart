import 'package:flutter/material.dart';

class DashBoardAdPagesProvider extends ChangeNotifier{
  int _num = 0;
  int getNum() => _num;

  void setNum(int num){
    _num = num;
    notifyListeners();
  }
}

