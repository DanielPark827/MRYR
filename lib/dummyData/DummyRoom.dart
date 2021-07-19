import 'package:flutter/material.dart';

class DummyRoom with ChangeNotifier {
  int RoomPrice = null;
  String RoomStartTime = null;
  String RoomEndTime = null;
  String Description = null;

  List<String> RoomTags = [];
  String RoomImage = null;
  //option
  bool ExistMicrowave = false;
  bool ExistWasher = false;
  bool ExistWifi = false;
  bool ExistElevator = false;
  bool ExistAirConditioner = false;
  bool Likes = false;
  //위치에 대한 좌표값

  DummyRoom({this.Likes,this.Description,this.RoomPrice,this.RoomStartTime,this.RoomEndTime,this.RoomTags,this.RoomImage,this.ExistAirConditioner,this.ExistElevator,this.ExistMicrowave,this.ExistWasher,this.ExistWifi});

  void ChangeRoomPrice(int value){
    RoomPrice = value;
    notifyListeners();
  }
  void ChangeRoomStartTime(String value){
    RoomStartTime = value;
    notifyListeners();
  }
  void ChangeRoomEndTime(String value){
    RoomEndTime = value;
    notifyListeners();
  }
  void ChangeDescription(String value) {
    Description = value;
    notifyListeners();
  }


  void ChangeRoomImages(String value) {
    RoomImage = value;
    notifyListeners();
  }

  void ChangeExistMicrowave(bool value) {
    ExistMicrowave = value;
    notifyListeners();
  }
  void ChangeExistWasher(bool value) {
    ExistWasher = value;
    notifyListeners();
  }
  void ChangeExistWifi(bool value) {
    ExistWifi = value;
    notifyListeners();
  }
  void ChangeExistElevator(bool value) {
    ExistElevator = value;
    notifyListeners();
  }
  void ChangeExistAirConditioner(bool value) {
    ExistAirConditioner = value;
    notifyListeners();
  }
  void ChangeLikes() {
    Likes = !Likes;
    notifyListeners();
  }
}

List<String> RoomTagList1 = ['단기임대','양도','일년'];
List<String> RoomTagList2 = ['여자만','양도','일년'];
List<String> RoomTagList3 = ['여자만','양도'];
List<DummyRoom> DummyRoomList = [
  new DummyRoom(
    RoomPrice: 20,
    RoomStartTime: '8/27',
    RoomEndTime: '10/31',
    RoomTags: RoomTagList1,
    RoomImage: 'assets/images/dummy/RoomSample1.png',
    ExistAirConditioner: false,
    ExistElevator: true,
    ExistMicrowave: false,
    ExistWasher: true,
    ExistWifi: false,
    Description: '흡연X / 남자만 구해요',
    Likes: false,
  ),
  new DummyRoom(
    RoomPrice: 30,
    RoomStartTime: '9/27',
    RoomEndTime: '10/31',
    RoomTags: RoomTagList2,
    RoomImage: 'assets/images/dummy/RoomSample1.png',
    ExistAirConditioner: true,
    ExistElevator: true,
    ExistMicrowave: false,
    ExistWasher: true,
    ExistWifi: false,
    Description: '흡연X / 여자만 구해요',
    Likes: false,
  ),
  new DummyRoom(
    RoomPrice: 40,
    RoomStartTime: '10/27',
    RoomEndTime: '10/31',
    RoomTags: RoomTagList3,
    RoomImage: 'assets/images/dummy/RoomSample1.png',
    ExistAirConditioner: false,
    ExistElevator: true,
    ExistMicrowave: false,
    ExistWasher: true,
    ExistWifi: true,
    Description: '흡연X / 게이만 구해요',
    Likes: false,
  ),
];