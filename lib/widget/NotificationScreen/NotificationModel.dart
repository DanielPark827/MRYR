import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/widget/NotificationScreen/NotiDatabase.dart';

const int NOTI_EVENT_REQUIRE_ROOM = 1;
const int NOTI_EVENT_FIND_ROOM = 2;

class NotificationModel {
  int id;
  int from;
  int to;
  int type;
  int index;
  String time;
  int isRead;
  String createdAt;
  String updatedAt;

  NotificationModel({this.id,this.from,this.to,this.type,this.index,this.time, this.isRead, this.createdAt, this.updatedAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id : json['id'] as int,
      from: json['UserID'] as int,
      to: json['TargetID'] as int,
      type: GetType(json['Type'] as String),
      index: json['TableIndex'] as int,
      time: json['Time'] as String,
      isRead: 0,
      createdAt: replaceUTCDate(json["createdAt"] as String),
      updatedAt: replaceUTCDate(json["updatedAt"] as String),
    );
  }

  Map<String, dynamic> toJson(int response) =>{
    'id' : id,
    'from' : from,
    'to' : to,
    'type' : type,
    'index' : index,
    'time' : time,
    'isRead' : isRead,
    'response' : response,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
  };
}

List<NotificationModel> notiList = new List<NotificationModel>();

Future<void> SetNotificationListByEvent() async {
  var notiListGet = await ApiProvider().post('/Notification/UnSendSelect', jsonEncode(
      {
        "userID" : GlobalProfile.loggedInUser.userID,
      }
  ));

  if(null != notiListGet){
    for(int i = 0; i < notiListGet.length; ++i){
      NotificationModel noti = NotificationModel.fromJson(notiListGet[i]);
      notiList.add(noti);
      await NotiDBHelper().createData(noti);
    }
  }
}

String getNotiInformation(NotificationModel notificationModel){
  String info = '잘못된 접근입니다.';
  User1 user = GlobalProfile.getUserByUserID(notificationModel.from);

  switch(notificationModel.type){
    case NOTI_EVENT_REQUIRE_ROOM:
      info = "'내가 내놓은 방'에 대한 문의가 왔어요!";
      break;
    case NOTI_EVENT_FIND_ROOM:
      info = "'살고싶은 내방찾기'에 대한 문의가 도착했어요!";
      break;
    default:
      info = '잘못된 접근입니다.';
      break;
  }

  return info;
}

NotiEvent(BuildContext context, NotificationModel notificationModel, index){
  switch(notificationModel.type){
    case NOTI_EVENT_REQUIRE_ROOM:
        notificationModel;
      break;
    case NOTI_EVENT_FIND_ROOM:
      Navigator.push(
          context, // 기본 파라미터, SecondRoute로 전달
          MaterialPageRoute(
              builder: (context) =>
                  DetailedRoomInformation(
                    roomSalesInfo: getRoomSalesInfoByID(notificationModel.index),
                  )) // SecondRoute를 생성하여 적재
      );
      break;
    default:
      break;
  }
}

bool isHaveButton(BuildContext context, int type){
  bool res = false;

  if(type == NOTI_EVENT_REQUIRE_ROOM || type == NOTI_EVENT_FIND_ROOM)
    res = true;

  return res;
}

int GetType(String typeStr) {
  int type = 0;
  switch (typeStr) {
    case "REQUIRE_ROOM":
      type = NOTI_EVENT_REQUIRE_ROOM;
      break;
    case "FIND_ROOM":
      type = NOTI_EVENT_FIND_ROOM;
      break;
  }
  return type;
}

bool isHaveReadNoti(){
  bool res = false;
  for(int i = 0 ; i < notiList.length; ++i){
    if(notiList[i].isRead == 0) {
      res = true;
      break;
    }
  }

  return res;
}

void setNotiListRead() {
  for(int i = 0 ; i < notiList.length; ++i){
    if(notiList[i].isRead == 0){
      notiList[i].isRead = 1;
      NotiDBHelper().updateDate(notiList[i].id, 1);
    }
  }
}



void addNotiByChatRecvMessageModel(ChatRecvMessageModel model){

  //INQURE일 때만
  if(model.messageType != 2) return;

  NotificationModel notificationModel = new NotificationModel();
  notificationModel.id = model.roomId;
  notificationModel.from = model.from;
  notificationModel.to = model.to;

  switch(model.messageType){
    case 2:
      notificationModel.type = NOTI_EVENT_REQUIRE_ROOM;
      break;
  }

  notificationModel.index = model.roomSalesID;
  notificationModel.time = getRoomTime(DateTime.now().toLocal());
  notificationModel.isRead = 0;
  notiList.add(notificationModel);
}
