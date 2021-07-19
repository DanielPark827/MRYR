import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void StatusBar(Color _color) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

    statusBarColor: _color,

  ));
}