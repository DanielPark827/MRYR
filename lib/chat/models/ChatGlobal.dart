import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:path_provider/path_provider.dart';

import '../models/ChatRecvMessageModel.dart';
import './ChatDatabase.dart';
import '../../userData/Room.dart';

enum RoomStatus{
  ROOM,
  CHAT,
  ETC
}

const int CENTER_MESSAGE = -1;
class ChatGlobal with ChangeNotifier{

  // Logged In User
  //static RoomStatus roomStatus;

  static Map<int, RoomInfo> roomInfoList = new Map<int, RoomInfo>();

  Map<int, RoomInfo> get getRoomInfoList => roomInfoList;

  addRoomInfoChat(int roomID, ChatRecvMessageModel model, {String date = ''}) async {
    RoomInfo roomInfo = ChatGlobal.getChatRoomUserInfo(roomID);

    if(null == roomInfo) {
      ChatRoomUser roomUser = ChatRoomUser(
          id:  model.roomId,
          userID: model.to,
          chatID: model.from,
          roomSaleID: model.roomSalesID,
          roomState: getValueByRoomState(ROOM_STATE.INQUIRE),
          updatedAt: getRoomTime(DateTime.now().toLocal()),
          createdAt: getRoomTime(DateTime.now().toLocal())
      );

      chatRoomUserList.add(roomUser);

      roomInfo = RoomInfo();
      roomInfo.messageCount = 0;
    }

    MESSAGE_TYPE type =  getMessageTypeByInt(model.messageType);
    switch(type){
      case MESSAGE_TYPE.MESSAGE : {
        roomInfo.lastMessage = model.message;
        break;
      }
      case MESSAGE_TYPE.IMAGE : {
        roomInfo.lastMessage = "사진을 보냈습니다.";
        model.fileMessage = await ChatGlobal.base64ToFileURL(model.message);
        break;
      }
      case MESSAGE_TYPE.INQUIRE :{
        roomInfo.lastMessage = "문의를 보냈습니다.";
        roomInfo.roomState = ROOM_STATE.INQUIRE;
        break;
      }
      case MESSAGE_TYPE.INQUIRE_REQUEST :{
        roomInfo.lastMessage = "거래를 요청했습니다.";
        roomInfo.roomState = ROOM_STATE.REQUEST;
        break;
      }
      case MESSAGE_TYPE.INQUIRE_CANCEL :{
        roomInfo.lastMessage = "거래를 취소했습니다.";
        roomInfo.roomState = ROOM_STATE.INQUIRE;
        break;
      }
      case MESSAGE_TYPE.INQUIRE_OK :{
        roomInfo.lastMessage = "거래를 확인했습니다.";
        roomInfo.roomState = ROOM_STATE.DONE;
        break;
      }
      default:{
        roomInfo.lastMessage = model.message;
        break;
      }
    }

    roomInfo.date = date == '' ? getRoomTime(DateTime.now().toLocal()) : date;

    int cnt = model.isRead == 0 ? 1 : 0;

    roomInfo.messageCount += cnt;

    if(null == roomInfo.chatList) roomInfo.chatList = List<ChatRecvMessageModel>();
    if(roomInfo.chatList.length != 0){
      if((MESSAGE_TYPE.MESSAGE != getMessageTypeByInt(model.messageType)) &&
          (MESSAGE_TYPE.IMAGE != getMessageTypeByInt(model.messageType))){

        for(int i = 0 ; i < roomInfo.chatList.length; ++i){
          if(getMessageTypeByInt(roomInfo.chatList[i].messageType) != MESSAGE_TYPE.MESSAGE &&
              getMessageTypeByInt(roomInfo.chatList[i].messageType) != MESSAGE_TYPE.IMAGE){
            roomInfo.chatList[i].isActive = 0;
          }
        }
      }
    }

    model.isActive = 1;
    //local db 저장
    model.chatId = await ChatDBHelper().createData(model);

    roomInfo.chatList.add(model);
    roomInfoList[roomID] = roomInfo;

    notifyListeners();
  }

  setRoomState(int roomID, ROOM_STATE state) {
    if(roomInfoList[roomID] == null) return;

    roomInfoList[roomID].roomState = state;
    notifyListeners();
  }

  setChatActive(int roomID, int chatIndex, int isActive){
    if(roomInfoList[roomID] == null) return;

    if(roomInfoList[roomID].chatList.length != 0){
      roomInfoList[roomID].chatList[chatIndex].isActive = isActive;
    }
    notifyListeners();
  }

  static addChatRecvMessage(int roomID, ChatRecvMessageModel model, {String date = ''}) async {

    RoomInfo roomInfo = ChatGlobal.getChatRoomUserInfo(roomID);

    if(null == roomInfo) {
      ChatRoomUser roomUser = ChatRoomUser(
        id:  model.roomId,
        userID: model.to,
        chatID: model.from,
        roomSaleID: model.roomSalesID,
        roomState: getValueByRoomState(ROOM_STATE.INQUIRE),
        updatedAt: getRoomTime(DateTime.now().toLocal()),
        createdAt: getRoomTime(DateTime.now().toLocal())
      );

      chatRoomUserList.add(roomUser);

      roomInfo = RoomInfo();
      roomInfo.messageCount = 0;
    }

    MESSAGE_TYPE type =  getMessageTypeByInt(model.messageType);
    switch(type){
      case MESSAGE_TYPE.MESSAGE : {
        roomInfo.lastMessage = model.message;
        break;
      }
      case MESSAGE_TYPE.IMAGE : {
        roomInfo.lastMessage = "사진을 보냈습니다.";
        model.fileMessage = await ChatGlobal.base64ToFileURL(model.message);
        break;
      }
      case MESSAGE_TYPE.INQUIRE :{
        roomInfo.lastMessage = "문의를 보냈습니다.";
        roomInfo.roomState = ROOM_STATE.INQUIRE;
        break;
      }
      case MESSAGE_TYPE.INQUIRE_REQUEST :{
        roomInfo.lastMessage = "거래를 요청했습니다.";
        roomInfo.roomState = ROOM_STATE.REQUEST;
        break;
      }
      case MESSAGE_TYPE.INQUIRE_CANCEL :{
        roomInfo.lastMessage = "거래를 취소했습니다.";
        roomInfo.roomState = ROOM_STATE.INQUIRE;
        break;
      }
      case MESSAGE_TYPE.INQUIRE_OK :{
        roomInfo.lastMessage = "거래를 확인했습니다.";
        roomInfo.roomState = ROOM_STATE.DONE;
        break;
      }
      default:{
        roomInfo.lastMessage = model.message;
        break;
      }
    }

    roomInfo.date = date == '' ? getRoomTime(DateTime.now().toLocal()) : date;
    roomInfo.messageCount += 1;

    if(null == roomInfo.chatList) roomInfo.chatList = List<ChatRecvMessageModel>();
    if(roomInfo.chatList.length != 0){
      if((MESSAGE_TYPE.MESSAGE != getMessageTypeByInt(model.messageType)) &&
          (MESSAGE_TYPE.IMAGE != getMessageTypeByInt(model.messageType))){

        for(int i = 0 ; i < roomInfo.chatList.length; ++i){
          if(getMessageTypeByInt(roomInfo.chatList[i].messageType) != MESSAGE_TYPE.MESSAGE &&
              getMessageTypeByInt(roomInfo.chatList[i].messageType) != MESSAGE_TYPE.IMAGE){
            roomInfo.chatList[i].isActive = 0;
          }
        }
      }
    }

    model.isActive = 1;
    //local db 저장
    model.chatId = await ChatDBHelper().createData(model);

    roomInfo.chatList.add(model);
    roomInfoList[roomID] = roomInfo;
  }

  static RoomInfo getChatRoomUserInfo(int chatUserID){
    if(roomInfoList[chatUserID] == null) return null;

    return roomInfoList[chatUserID];
  }

  static Future<String> base64ToFileURL(String base) async {
    final decodedBytes = base64Decode(base);

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String name = DateFormat('yyyyMMddHHmmss').format(DateTime.now().toLocal());

    var file = File(documentsDirectory.path + '/' +  name + ".png");
    await file.writeAsBytes(decodedBytes);
    var fileUrl = file.path;
    return fileUrl;
  }
}
