import 'dart:convert';

import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';

ChatRecvMessageModel chatRecvMessageModelFromJson(String str) =>
    ChatRecvMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatRecvMessageModel data) =>
    json.encode(data.toJson());

enum MESSAGE_TYPE{
  MESSAGE,
  IMAGE,
  INQUIRE,
  INQUIRE_REQUEST,
  INQUIRE_OK,
  INQUIRE_CANCEL,
}

class ChatRecvMessageModel {
  int chatId;
  int roomId;
  int to;
  int from;
  String fromName;
  String message;
  int messageType;
  String date;
  String fileMessage;
  bool isContinue;
  int isRead;
  int roomSalesID;
  int isActive;
  String updatedAt;
  String createdAt;

  ChatRecvMessageModel({
    this.chatId,
    this.roomId,
    this.to,
    this.from,
    this.fromName,
    this.message,
    this.messageType,
    this.date,
    this.fileMessage,
    this.isRead,
    this.roomSalesID,
    this.isContinue,
    this.isActive,
    this.updatedAt,
    this.createdAt,
  });

factory ChatRecvMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatRecvMessageModel(
        chatId: json["id"] as int,
        roomId: json["RoomID"] as int,
        to: json["to"] as int,
        from: json["from"] as int,
        message: json["message"] as String,
        messageType: json['messageType'] as int,
        roomSalesID: json['roomSalesID'] as int,
        date: json["send_date"] as String,
        updatedAt: replaceLocalDate(json["updatedAt"] as String),
        createdAt: replaceLocalDate(json["createdAt"] as String),
      );

  Map<String, dynamic> toJson() => {
    "id": chatId,
    "roomId": roomId,
    "to" : to,
    "from": from,
    "message": message,
    "messageType": messageType,
    "fromName" : fromName,
    "date" : date,
    "roomSalesID" : roomSalesID
  };
}

String GetLocalNotiMessageByChat(ChatRecvMessageModel model){
  String message = model.message;

  User1 user = GlobalProfile.getUserByUserID(model.from);

  switch(model.messageType){
    case 1:
      message = user.name + "님이 사진을 보냈습니다.";
      break;
    case 2:
      message = user.name + "님이 내가 내놓은 방에 문의를 보냈어요";
      break;
    case 3:
      message = user.name + "님이 거래를 요청했습니다.";
      break;
    case 4:
      message = user.name + "님이 거래를 확인하였습니다.";
      break;
    case 5:
      message = user.name + "님이 거래를 취소하였습니다.";
      break;
    default:
      message = model.message;
      break;
  }

  return message;
}