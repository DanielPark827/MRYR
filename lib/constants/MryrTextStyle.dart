import 'package:flutter/material.dart';

class MryrTextStyle {
  static TextStyle bottomNavigationTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width*(16/360),
      color: Colors.white,
      fontWeight: FontWeight.bold
    );
  }
}

var starColor = Color(0xffeeeeee);