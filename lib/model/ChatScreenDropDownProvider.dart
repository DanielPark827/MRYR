import 'package:flutter/material.dart';

class ChatScreenDropDownProvider extends ChangeNotifier{

  String _text = "나한테 온 문의";

  String getString() => _text;

  void setString(String txt){

    _text = txt;
    notifyListeners();
  }
}

