
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mryr/constants/AppConfig.dart';

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    String res = "$_prefix$_message";
    Fluttertoast.showToast(msg: res, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Color.fromRGBO(0, 0, 0, 0.51), textColor: hexToColor('#FFFFFF') );
    return res;
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "접속 상태가 원활하지 않습니다. 잠시 후 다시 시도해주십시오. ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}