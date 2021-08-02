
import 'package:flutter/cupertino.dart';

import 'dart:convert';

import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';

import '../chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/userData/RoomSalesLikes.dart';
import 'package:mryr/userData/GlobalProfile.dart';

class RoomInfo {
  String lastMessage;
  String date;
  int messageCount;
  ROOM_STATE roomState;
  List<ChatRecvMessageModel> chatList;

  RoomInfo({this.lastMessage, this.date, this.messageCount,this.roomState, this.chatList});

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(

    );
  }
}

class ThisMonthNewRoomList{
  int id;
  String title;
  String  imageUrl1;
  String  imageUrl2;
  String  imageUrl3;
  ThisMonthNewRoomList({this.id,this.title,this.imageUrl1,this.imageUrl2,this.imageUrl3});
  factory ThisMonthNewRoomList.fromJson(Map<String,dynamic> json){
    return ThisMonthNewRoomList(
      id: json["id"] as int,
      title: json['title'] as String,
      imageUrl1: json["ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl1"], //json["ImageUrl1"] as String,
      imageUrl2:   json["ImageUrl2"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl2"], // //json["ImageUrl2"] as String,
      imageUrl3: json["ImageUrl3"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl3"], // //json["ImageUrl3"] as String,
    );
  }
}

List<ThisMonthNewRoomList> monthlyNewFst = new List<ThisMonthNewRoomList>();
List<ThisMonthNewRoomList> monthlyNewScd = new List<ThisMonthNewRoomList>();
List<ThisMonthNewRoomList> monthlyNewTrd = new List<ThisMonthNewRoomList>();

class NeedRoomProposal {
  int id;
  int roomSalesID;
  int userID;
  int targetID;
  String createdAt;
  String updatedAt;

  NeedRoomProposal({this.id, this.roomSalesID, this.userID, this.targetID, this.createdAt, this.updatedAt});

  factory NeedRoomProposal.fromJson(Map<String, dynamic> json){
    return NeedRoomProposal(
      id: json['id'] as int,
      roomSalesID: json['RoomSaleInfoID'] as int,
      userID: json['UserID'] as int,
      targetID: json['TargetID'] as int,
      createdAt: replaceUTCDate(json['createdAt'] as String),
      updatedAt: replaceUTCDate(json['updatedAt'] as String)
    );
  }
}

class ChatRoomUser{
  int id;
  int roomSaleID;
  int userID;
  int chatID;
  int roomState;
  String createdAt;
  String updatedAt;

  ChatRoomUser({this.id, this.roomSaleID, this.userID, this.chatID, this.roomState, this.createdAt, this.updatedAt});

  factory ChatRoomUser.fromJson(Map<String, dynamic> json){
    return ChatRoomUser(
      id : json['id'],
      roomSaleID: json['RoomSaleID'],
      userID: json['UserID'],
      chatID: json['ChatID'],
      roomState: json['RoomState'],
      createdAt: replaceLocalDate(json['createdAt'] as String),
      updatedAt: replaceLocalDate(json['updatedAt'] as String),
    );
  }
}

List<ChatRoomUser> chatRoomUserList = new List<ChatRoomUser>();

chatRoomUserListSort() {
  if(chatRoomUserList.length < 2) return;

  List<ChatRoomUser> list = chatRoomUserList;

  for(int i = 0 ; i < chatRoomUserList.length; ++i){

    if(chatRoomUserList[i].updatedAt.contains('.')){
      chatRoomUserList[i].updatedAt = replaceLocalDate(chatRoomUserList[i].updatedAt);
    }

    print(chatRoomUserList[i].updatedAt);
  }

  list.sort((a,b) => int.parse(b.updatedAt).compareTo(int.parse(a.updatedAt)));

  chatRoomUserList = list;
}

class RoomSalesInfo with ChangeNotifier {
  int     id;
  int     userID;
  int     type;
  String  location;
  String  locationDetail;
  int     monthlyRentFees;
  int     depositFees;
  int     managementFees;
  int     utilityFees;
  int     square;
  int     depositFeesOffer;
  int     monthlyRentFeesOffer;
  String  termOfLeaseMin;
  String  termOfLeaseMax;
  int     preferenceSex;
  int     preferenceSmoking;
  int     preferenceTerm;
  bool    bed;
  bool    desk;
  bool    chair;
  bool    closet;
  bool    aircon;
  bool    induction;
  bool    refrigerator;
  bool    doorLock;
  bool    tv;
  bool    microwave;
  bool    washingMachine;
  bool    hallwayCCTV;
  bool    wifi;
  bool    parking;
  String  information;
  String  imageUrl1;
  String  imageUrl2;
  String  imageUrl3;
  String  imageUrl4;
  String  imageUrl5;
  int     tradingState;
  String  openchat;
  String  createdAt;
  String  updatedAt;
  double lng;
  double lat;
  List<ChatRoomUser> chatRoomUserList;

  int Condition;
  int Floor;
  int DailyRentFeesOffer;
  int WeeklyRentFeesOffer;
  bool ShortTerm;
  bool jeonse;

  List<RoomSalesLikes> isLikes;

  RoomSalesInfo Likeditem;


  bool Likes = false;

  void ChangeLikes() {
    // if(isLikes.length > 0) {
    //   isLikes.clear();
    // } else {
    //   isLikes.clear();
    //   isLikes.add(new RoomSalesLikes(id: GlobalProfile.loggedInUser.userID));
    // }
    notifyListeners();
  }

  void ChangeLikesWithValue(bool value) {
    Likes = value;
    notifyListeners();
  }

  RoomSalesInfo({
    this.id,this.userID,this.type,this.location,this.locationDetail,this.square,this.monthlyRentFees,this.depositFees,this.managementFees,this.depositFeesOffer,this.utilityFees,this.monthlyRentFeesOffer,
    this.termOfLeaseMin,this.termOfLeaseMax,this.preferenceSex,this.preferenceSmoking,this.preferenceTerm,
    this.bed, this.desk, this.chair, this.closet, this.aircon, this.induction, this.refrigerator,
    this.doorLock, this.tv,this.microwave, this.washingMachine, this.hallwayCCTV, this.wifi,
    this.information,this.imageUrl1,this.imageUrl2,this.imageUrl3,this.imageUrl4,this.imageUrl5,this.tradingState,
    this.createdAt,this.updatedAt,this.chatRoomUserList, this.openchat,this.lng,this.lat,this.DailyRentFeesOffer,this.Floor,this.ShortTerm,this.WeeklyRentFeesOffer,this.jeonse,this.isLikes
    ,this.Likes,this.parking,this.Condition,this.Likeditem
  });

  factory RoomSalesInfo.fromJson(Map<String, dynamic> json) {
    return RoomSalesInfo(
      id: json["id"] as int,
      userID: json["UserID"] as int,
      type: json["Type"] as int,
      jeonse: json["Jeonse"] as bool,
      location: json["Location"] as String,
      locationDetail: json["LocationDetail"] as String,
      square: json["square"] as int,
      monthlyRentFees: json["MonthlyRentFees"] as int,
      depositFees: json["DepositFees"] as int,
      depositFeesOffer : json["DepositFeesOffer"] as int,
      managementFees: json["ManagementFees"] as int,
      utilityFees: json["UtilityFees"] as int,
      monthlyRentFeesOffer: json["MonthlyRentFeesOffer"] as int,
      termOfLeaseMin: json["RentStart"] as String,
      termOfLeaseMax: json["RentDone"] as String,
      preferenceSex: json["PreferenceSex"] as int,
      preferenceSmoking: json["PreferenceSmoking"] as int,
      preferenceTerm: json["PreferenceTerm"] as int,
      bed: json["Bed"] as bool,
      desk: json["Desk"] as bool,
      chair: json["Chair"] as bool,
      closet: json["Closet"] as bool,
      aircon: json["Aircon"] as bool,
      induction: json["Induction"] as bool,
      refrigerator: json["Refrigerator"] as bool,
      doorLock: json["DoorLock"] as bool,
      tv: json["TV"] as bool,
      microwave: json["Microwave"] as bool,
      washingMachine: json["WashingMachine"] as bool,
      hallwayCCTV: json["HallwayCCTV"] as bool,
      wifi: json["Wifi"] as bool,
      parking: json["Parking"] as bool,
      information: json["Information"] as String,
      imageUrl1: json["ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl1"], //json["ImageUrl1"] as String,
      imageUrl2:   json["ImageUrl2"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl2"], // //json["ImageUrl2"] as String,
      imageUrl3: json["ImageUrl3"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl3"], // //json["ImageUrl3"] as String,
      imageUrl4:  json["ImageUrl4"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl4"], //  //json["ImageUrl4"] as String,
      imageUrl5:   json["ImageUrl5"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl5"], ////json["ImageUrl5"] as String,
      tradingState: json["TradingState"] as int,
      createdAt:  replaceLocalDate(json["createdAt"] as String),
      updatedAt:  replaceLocalDate(json["updatedAt"] as String),
      openchat:  json["Openchat"] as String,
      lng: json["Longitude"] as double,
      lat: json["Latitude"] as double,
      Condition: json["Condition"] as int,
      Floor: json["Floor"] as int,
      DailyRentFeesOffer: json["DailyRentFeesOffer"] as int,
      WeeklyRentFeesOffer: json["WeeklyRentFeesOffer"] as int,
      ShortTerm: json["ShortTerm"] as bool,
      isLikes: json['RoomSalesLikes'] == null ? null : (json['RoomSalesLikes'] as List).map((e) => RoomSalesLikes.fromJson(e)).toList(),
      Likes: json['RoomSalesLikes'] == null ? null : (json['RoomSalesLikes'] as List).map((e) => RoomSalesLikes.fromJson(e)).toList().length == 0 ? false : true,
     );
  }
  factory RoomSalesInfo.fromJsonLittle(Map<String, dynamic> json) {
    return RoomSalesInfo(
      id: json["id"] as int,//
      jeonse: json["Jeonse"] as bool,
      depositFeesOffer : json["DepositFeesOffer"] as int,
      monthlyRentFeesOffer: json["MonthlyRentFeesOffer"] as int,//
      DailyRentFeesOffer: json["DailyRentFeesOffer"] as int,
      WeeklyRentFeesOffer: json["WeeklyRentFeesOffer"] as int,
      termOfLeaseMin: json["RentStart"] as String,
      termOfLeaseMax: json["RentDone"] as String,
      information: json["Information"] as String,//
      imageUrl1: json["ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl1"], //json["ImageUrl1"] as String,//
      Condition: json["Condition"] as int,
      Floor: json["Floor"] as int,
      updatedAt:  replaceLocalDate(json["updatedAt"] as String),//
      ShortTerm: json["ShortTerm"] as bool,
      isLikes: json['RoomSalesLikes'] == null ? null : (json['RoomSalesLikes'] as List).map((e) => RoomSalesLikes.fromJson(e)).toList(),
      Likes: json['RoomSalesLikes'] == null ? null : (json['RoomSalesLikes'] as List).map((e) => RoomSalesLikes.fromJson(e)).toList().length == 0 ? false : true,

      Likeditem: (json["RoomSalesInfo"] as RoomSalesInfo),
    );
  }
}

List<RoomSalesInfo> globalRoomSalesInfoList = new List<RoomSalesInfo>();

List<RoomSalesInfo> globalShortList = new List<RoomSalesInfo>();
List<RoomSalesInfo> globalTransferList = new List<RoomSalesInfo>();

List<RoomSalesInfo> nbnbRoom = new List<RoomSalesInfo>();
List<RoomSalesInfo> mainShortList = new List<RoomSalesInfo>();
List<int> nbnbRoomListId = new List<int>();
List<RoomSalesInfo> mainTransferList = new List<RoomSalesInfo>();
List<RoomSalesInfo> globalRoomSalesInfoListFiltered = new List<RoomSalesInfo>();

List<RoomSalesInfo> RoomLikesList = new List<RoomSalesInfo>();

RoomSalesInfo isHaveRoomSalesInfoByID(int id) {
  for (int i = 0; i < globalRoomSalesInfoList.length; ++i) {
    if (globalRoomSalesInfoList[i].id == id) {
      return globalRoomSalesInfoList[i];
    }
  }

  return null;
}

RoomSalesInfo getRoomSalesInfoByID(int id){
  RoomSalesInfo roomSalesInfo = null;
  for(int i = 0; i < globalRoomSalesInfoList.length; ++i){
    if(globalRoomSalesInfoList[i].id == id){
      roomSalesInfo = globalRoomSalesInfoList[i];
      break;
    }
  }

  if(null == roomSalesInfo){
    for(int i = 0; i < nbnbRoom.length; ++i){
      if(nbnbRoom[i].id == id){
        roomSalesInfo = nbnbRoom[i];
        break;
      }
    }
  }

  //받아온 데이터 중에서 없으면
  if(null == roomSalesInfo){
    Future.microtask(() async => {
      roomSalesInfo = await selectAndAddRoomSalesInfo(id)
    });
  }

  return roomSalesInfo;
}

RoomSalesInfo getRoomSalesInfoByIDFromMainTransfer(int id){
  RoomSalesInfo roomSalesInfo = null;
  for(int i = 0; i < mainTransferList.length; ++i){
    if(mainTransferList[i].id == id){
      roomSalesInfo = mainTransferList[i];
      break;
    }
  }

  if(null == roomSalesInfo){
    for(int i = 0; i < globalRoomSalesInfoList.length; ++i){
      if(globalRoomSalesInfoList[i].id == id){
        roomSalesInfo = globalRoomSalesInfoList[i];
        break;
      }
    }
  }

  //받아온 데이터 중에서 없으면
  if(null == roomSalesInfo){
    Future.microtask(() async => {
      roomSalesInfo = await selectAndAddRoomSalesInfo(id)
    });
  }

  return roomSalesInfo;
}

//데이터를 받아와 저장함
Future<RoomSalesInfo> selectAndAddRoomSalesInfo(int id) async {
  var res = await ApiProvider().post('/RoomSalesInfo/Select/ID', jsonEncode(
      {
        "id" : id
      }
  ));

  if(res == null){
    return null;
  }

  RoomSalesInfo room = RoomSalesInfo.fromJson(res);
 // globalRoomSalesInfoList.add(room);

  return room;
}


