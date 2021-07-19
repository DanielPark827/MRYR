import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/RegistrationModel.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/UserRepository.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:equatable/equatable.dart';

part 'RegistrationEvent.dart';
part 'RegistrationState.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserRepository _userRepository;
  String errMsg = '';

  RegistrationBloc(this._userRepository);

  @override
  RegistrationState get initialState => RegistrationInitial();

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event,) async* {
    if (event is UserNameChanged) {
      bool isValidModel = await isValidName(event.userName);
      yield RegistrationModelChanged(state.model
          .copyWith(
          userName: event.userName, isValid: isValidModel, isValidPage: false));
    }
    if (event is UserIDChanged) {
      bool isValidModel = await isValidID(event.userID);
      yield RegistrationModelChanged(state.model
          .copyWith(
          userID: event.userID, errMsg: errMsg, isValid: isValidModel, isValidPage: false));
    }
    if (event is PasswordChanged) {
      bool isValidModel = await isValidPassword(
          event.password, state.model.userConfirmPassword);
      yield RegistrationModelChanged(state.model
          .copyWith(userPassword: event.password, errMsg: errMsg,
          isValid: isValidModel,
          isValidPage: false));
    }
    if (event is ConfirmPasswordChanged) {
      bool isValidModel = await isValidPassword(
          state.model.userPassword, event.confirmPassword);
      yield RegistrationModelChanged(state.model.copyWith(
          userConfirmPassword: event.confirmPassword, errMsg: errMsg,
          isValid: isValidModel,
          isValidPage: false));
    }
    if (event is PageChanged) {
      yield RegistrationModelChanged(state.model.copyWith(
          pageState: event.pageState, isValid: true, isValidPage: true));
    }
  }

  Future<bool> isValidName(String userName) async {
    //if(false == kReleaseMode) return true;

    return (userName.length >= 3) && (userName.length <= 10);
  }

  Future<bool> isValidID(String userID) async {
    //if(false == kReleaseMode) return true;

    bool isValid = true;
    if(userID.length < 6){
      errMsg = "최소 6글자 이상의 아이디어야 해요.";
      isValid = false;
    }
    else{
      var res = await ApiProvider().post('/Profile/Personal/IDCheck',jsonEncode({
        "id" : userID
      }));

      if(res != null){
        errMsg = "이미 등록된 아이디인걸요ㅠㅠ";
        isValid = false;
      }else{
        errMsg = "";
      }
    }

    return isValid;
  }

  Future<bool> isValidPassword(String password, String confirmPassword) async {
    //if(false == kReleaseMode) return true;

    RegExp exp = new RegExp("[0-9a-zA-Z.;\-]");

    bool isValidPassword = false;
    bool isConfirmPasswordMatched = false;
    if(exp.hasMatch(password)){
      isValidPassword = true;
      errMsg = "";
      if(password == confirmPassword){
        isConfirmPasswordMatched = true;
        errMsg = "";
      }else{
        errMsg = "비밀번호가 일치하지 않습니다";
      }
    }else{
      errMsg = "비밀번호가 올바르지 않습니다";
    }

    bool res = (isValidPassword && isConfirmPasswordMatched);
    return res;
  }
}
