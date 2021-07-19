import 'dart:io';

import 'package:flutter/material.dart';

class DummyUser with ChangeNotifier {
  String UserName = null;
  String UserId = null;
  String UserPassword = null;
  String UserSex = null;
  bool AcceptTotalNotification = false;
  bool AcceptMessageNotification  =false;
  bool AcceptSMSNotification = false;
  bool AccepMarketNotification = false;
  bool RegistrationCardCheck = false;
  bool StudentCardCheck = false;
  List<File> profileImage= [];
  List<File> studentAuthImage= [];
  List<File> reviewScreenInMapImage= [];


  //내가 찜한 리스트
  //최근 본방
  //최근 검색한 지역 -> 이거 1차때는 없어야 함
  //나한테 온 문의
  //내가 문의온 매물
  //채팅 리스트
  //알림 리스트

  void ResetDummyUser() {
     UserName = null;
     UserId = null;
     UserPassword = null;
     UserSex = null;
    AcceptTotalNotification = false;
    AcceptMessageNotification  =false;
    AcceptSMSNotification = false;
    AccepMarketNotification = false;
    RegistrationCardCheck = false;
    StudentCardCheck = false;
     profileImage= [];
     studentAuthImage= [];
     reviewScreenInMapImage= [];
     notifyListeners();
  }

  void ChangeUserName(String value) {
    UserName = value;
    notifyListeners();
  }
  void ChangeUserId(String value) {
    UserId = value;
    notifyListeners();
  }
  void ChangeUserPassword(String value) {
    UserPassword = value;
    notifyListeners();
  }
  void ChangeUserSex(String value) {
    UserSex = value;
    notifyListeners();
  }
  void ChangeAcceptTotalNotification(bool value) {
    AcceptTotalNotification = value;
    notifyListeners();
  }
  void ChangeAcceptMessageNotification(bool value) {
    AcceptMessageNotification = value;
    notifyListeners();
  }
  void ChangeAcceptSMSNotification(bool value) {
    AcceptSMSNotification = value;
    notifyListeners();
  }
  void ChangeAccepMarketNotification(bool value) {
    AccepMarketNotification = value;
    notifyListeners();
  }
  void ChangeRegistrationCardCheck(bool value) {
    RegistrationCardCheck = value;
    notifyListeners();
  }
  void ChangeStudentCardCheck(bool value) {
    StudentCardCheck = value;
    notifyListeners();
  }

  //360X360
  List<File> get profileImagesList =>  profileImage;
  void addProfileImage(File addFile){
    profileImage.add(addFile);
    notifyListeners();
  }
  void removeProfileImage({File targetFile}){
    int index =  profileImage.indexOf(targetFile);
    if(index < 0) return;
    profileImage.removeAt(index);
    notifyListeners();
  }


  List<File> get reviewScreenInMapImageList =>  reviewScreenInMapImage;
  void addReviewScreenInMapImage(File addFile){
    reviewScreenInMapImage.add(addFile);
    notifyListeners();
  }
  void removeReviewScreenInMapImage({File targetFile}){
    int index =  reviewScreenInMapImage.indexOf(targetFile);
    if(index < 0) return;
    reviewScreenInMapImage.removeAt(index);
    notifyListeners();
  }
  void changeReviewScreenInMapImage(int index,File targetFile){
    print(index);
    reviewScreenInMapImage[index] = targetFile;
    notifyListeners();
  }




  List<File> get studentAuthImagesList =>  studentAuthImage;
  void addstudentAuthImage(File addFile){
    studentAuthImage.add(addFile);
    notifyListeners();
  }
  void removestudentAuthImage({File targetFile}){
    int index =  studentAuthImage.indexOf(targetFile);
    if(index < 0) return;
    studentAuthImage.removeAt(index);
    notifyListeners();
  }
}