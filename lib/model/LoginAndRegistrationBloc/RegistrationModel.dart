import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class RegistrationModel {
  String _userName;
  String _userNickName;
  String _userID;
  String _userPassword;
  String _userConfirmPassword;
  String _pageState;
  String _errMsg;
  bool isValidForRegistration;
  bool isValidForNextPage;

  factory RegistrationModel.empty() {
    if(kReleaseMode) {
      return RegistrationModel("","","","","", "NAME", "", false, false);
    }else {
      return RegistrationModel("TESTNAME","TESTNICKNAME","TESTID","12341234","12341234", "NAME", "",true, false);
    }
  }

  RegistrationModel(this._userName, this._userNickName, this._userID, this._userPassword, this._userConfirmPassword, this._pageState, this._errMsg, this.isValidForRegistration, this.isValidForNextPage);


  RegistrationModel copyWith({String userName,String userNickName ,String userID, String userPassword, String userConfirmPassword, String pageState, String errMsg, @required isValid, @required isValidPage}){
    return RegistrationModel(
        userName ?? this._userName,
        userNickName ?? this._userNickName,
        userID ?? this._userID,
        userPassword ?? this._userPassword,
        userConfirmPassword ?? this._userConfirmPassword,
        pageState ?? this._pageState,
        errMsg ?? this._errMsg,
        isValid, isValidPage);
  }

  RegistrationModel.fromJson(Map<String, dynamic> parsedJson){
    this._userName = parsedJson['userName'];
    this._userID = parsedJson['userID'];
  }

  String get userName => _userName;
  String get userNickName => _userNickName;
  String get userID => _userID;
  String get userPassword => _userPassword;
  String get userConfirmPassword => _userConfirmPassword;
  String get pageState => _pageState;
  String get errMsg => _errMsg;
}