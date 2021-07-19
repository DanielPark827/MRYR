import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/models/ChatDatabase.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/main.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/userData/Chat.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/userData/Version.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/NotificationScreen/NotiDatabase.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/TutorialScreen.dart';
import 'package:url_launcher/url_launcher.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _launchUrl(String Url)async{
    if(await canLaunch(Url)){
      await launch(Url);
    }
    else{
      throw 'Could not open Url';
    }
  }
  @override
  void initState() {
    // TODO: implement initState

    bool versionCheck = false;
    Version _version;
    bool NFlag = false;
    (() async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      var tmp = await ApiProvider().get('/Version/Check');

      if(tmp != null){
          _version= Version.fromJson(tmp);
      }
      var android = _version.Android.split('.');
      var ios = _version.Ios.split('.');
      var platform = packageInfo.version.split('.');
      if (Platform.isAndroid) {
       if(int.parse(android[0])<int.parse(platform[0]))
         versionCheck = true;
       else if(int.parse(android[0])==int.parse(platform[0]))
         if(int.parse(android[1])<int.parse(platform[1]))
           versionCheck = true;
         else if(int.parse(android[1])==int.parse(platform[1]))
           if(int.parse(android[2])<=int.parse(platform[2]))
             versionCheck = true;
      } else if (Platform.isIOS) {
        if(int.parse(ios[0])<int.parse(platform[0]))
          versionCheck = true;
        else if(int.parse(ios[0])==int.parse(platform[0]))
          if(int.parse(ios[1])<int.parse(platform[1]))
            versionCheck = true;
          else if(int.parse(ios[1])==int.parse(platform[1]))
            if(int.parse(ios[2])<=int.parse(platform[2]))
              versionCheck = true;
      }
      else{

      }

      if(versionCheck == true) {
        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          String res = prefs.getString('autoLoginKey');
          if (
              null == res) { //처음 유저도 아니고, 자동 로그인도 아직 설정 안되어있을 때,
            Timer(Duration(milliseconds: 1500), () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => LoginMainScreen()
              )
              );
            });
          } else {
            NFlag = true;
            String id = await prefs.getString('autoLoginId');
            String pw = await prefs.getString('autoLoginPw');

            //  SocketProvider provider = Provider.of<SocketProvider>(context, listen: false);
            if (null != res) //일반 로그인
                {
              print(id);
              print(pw);
              var result;
              if (res == "normal") {
                result = await ApiProvider().post("/User/DebugLogin", jsonEncode(
                    {
                      "id" : id,
                      "password" : pw,
                    }
                ));
              }
              else if (res == "kakao") {
                result =
                await ApiProvider().post('/User/KakaoLogin', jsonEncode(
                    {
                      "id": id,
                    }
                ));
              }
              else if (res == "apple") {
                result = await ApiProvider().post('/User/AppleLogin',
                    jsonEncode({
                      "emailID": id,
                      "apple": pw,
                    }));
              }
//            if(id != null && pw != null) {
//              result = await ApiProvider().post('/User/Login', jsonEncode(
//                  {
//                    "id": id,
//                    "password": pw,
//                  }
//              ));
//            }

              if (false != result && null != result) {
                if(result['res'] == 1){
                  Function okFunc = () {
                    ApiProvider().post('/User/logout', jsonEncode(
                        {
                          "userID" : result['userID']
                        }
                    ));

                    Navigator.pop(context);
                  };

                  Function cancelFunc = () {
                    Navigator.pop(context);
                  };

                  OKCancelDialog(context, "로그아웃", "해당 아이디는 이미 로그인 중입니다.\n로그아웃을 요청하시겠어요?", "예", "아니오", okFunc, cancelFunc);
                  return;
                }
                User1 user = User1.fromJson(result["result"]);
                GlobalProfile.loggedInUser = user;
                //자기 매물 정보
                var list5 = await ApiProvider().post('/RoomSalesInfo/myroomInfo', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID
                    }
                ));

                GlobalProfile.roomSalesInfoList.clear();
                if (list5 != null && list5  != false) {
                  for (int i = 0; i < list5.length; ++i) {
                    RoomSalesInfo tmp = RoomSalesInfo.fromJson(list5[i]);
                    if (null ==
                        tmp.lng ||
                        null == tmp
                            .lat) {
                      var addresses = await Geocoder.google(
                          'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                          .findAddressesFromQuery(
                          tmp
                              .location);
                      var first = addresses.first;
                      tmp.lat = first.coordinates.latitude;
                      tmp.lng = first.coordinates.longitude;
                    }
                    GlobalProfile.roomSalesInfoList.add(tmp);
                  }
                }

                GlobalProfile.banner = await ApiProvider().get("/RoomSalesInfo/MonthlyNewBanner");
                chatSum =0;
                //쪽지함 리스트
                chatInfoList.clear();
                var ye = await ApiProvider().post('/Note/MessageRoomListTest', jsonEncode({
                  "userID" : GlobalProfile.loggedInUser.userID

                }));

                var tt = ye['result'];
                if (ye != null && ye  != false) {
                  for (int i = 0; i < ye['result'].length; ++i) {
                    chatInfoList.add(Chat.fromJson(ye['result'][i],ye['Contents'][i]));
                  }
                }


                //자기 매물 정보
                var myRoom = await ApiProvider().post('/RoomSalesInfo/Select/User', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID
                    }
                ));
                GlobalProfile.roomSalesInfo = null;
                if(myRoom != null){
                  RoomSalesInfo tmp = RoomSalesInfo.fromJson(myRoom);
                  if (null ==
                      tmp.lng ||
                      null == tmp
                          .lat) {
                    var addresses = await Geocoder.google(
                        'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                        .findAddressesFromQuery(
                        tmp
                            .location);
                    var first = addresses.first;
                    tmp.lat = first.coordinates.latitude;
                    tmp.lng = first.coordinates.longitude;
                  }
                  GlobalProfile.roomSalesInfo = tmp;
                }

                //역제안 정보
                GlobalProfile.NeedRoomInfoOfloggedInUser = null;
                var t = await ApiProvider().post('/NeedRoomSalesInfo/Select/User', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));


                GlobalProfile.NeedRoomInfoOfloggedInUser = null;
                if(t != null){
                  NeedRoomInfo tmp = NeedRoomInfo.fromJson(t);
                  GlobalProfile.NeedRoomInfoOfloggedInUser = tmp;
                }
                //매물 리스트
                var list = await ApiProvider().post('/RoomSalesInfo/TransferListWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));

                globalRoomSalesInfoList.clear();
                if(list != null){
                  for(int i = 0 ; i < list.length; ++i){
                    RoomSalesInfo tmp = RoomSalesInfo.fromJsonLittle(list[i]);
                    globalRoomSalesInfoList.add(tmp);
                  }
                }

                //내방니방직영
                nbnbRoom.clear();
                var tmp = await ApiProvider().post('/RoomSalesInfo/ShortListWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));
                if(null != tmp){
                  for(int i = 0;i<tmp.length;i++){
                    nbnbRoom.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                  }
                }
                // for(int i = 0;i<nbnbRoom.length;i++){
                //   if (null == nbnbRoom[i].lng ||
                //       null == nbnbRoom[i].lat) {
                //     var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(nbnbRoom[i].location);
                //     var first = addresses.first;
                //
                //     nbnbRoom[i].lng =
                //         first.coordinates.latitude;
                //     nbnbRoom[i].lat =
                //         first.coordinates.longitude;
                //   }
                // }


                //메인 단기매물 리스트
                mainShortList.clear();
                tmp = await ApiProvider().post('/RoomSalesInfo/MainShortWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));
                if(null != tmp){
                  for(int i = 0;i<tmp.length;i++){
                    mainShortList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                  }
                }


                //메인 양도매물 리스트
                mainTransferList.clear();
                tmp = await ApiProvider().post('/RoomSalesInfo/MainTransferWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID
                    }
                ));
                if(null != tmp){
                  for(int i = 0;i<tmp.length;i++){
                    mainTransferList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                  }
                }

                //메인 리뷰 리스트
                GlobalProfile.reviewForMain.clear();
                tmp = await ApiProvider().get('/Review/MainReviews');
                if(null != tmp){
                  for(int i =0;i<tmp.length;i++){
                    GlobalProfile.reviewForMain.add(Review.fromJson(tmp[i]));
                  }
                }

                //나에게 맞는 매물 추천
                GlobalProfile.listForMe.clear();
                var list2 = await ApiProvider().post('/RoomSalesInfo/Recommend', jsonEncode({
                  "userID" :  GlobalProfile.loggedInUser.userID,
                }));
                if(list2 != null){
                  for(int i = 0;i<list2.length;i++){
                    GlobalProfile.listForMe.add(RoomSalesInfo.fromJson(list2[i]));
                  }
                }


                //내방이 필요한 사람들
                GlobalProfile.listForMe2.clear();
                var list3 = await  ApiProvider().post('/NeedRoomSalesInfo/RecommendUserList', jsonEncode(
                    {


                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));
                if(list3 != null){
                  for(int i = 0;i<list3.length;i++){
                    GlobalProfile.listForMe2.add(NeedRoomInfo.fromJson(list3[i]));
                  }
                }

                GlobalProfile.needRoomProposal.clear();

                var needRoomProposal = await ApiProvider().post('/NeedRoomSalesInfo/Proposal/SelectUser', jsonEncode({
                  "userID" : user.userID
                }));

                if(needRoomProposal != null){
                  for(int i = 0 ; i < needRoomProposal.length; ++i){
                    GlobalProfile.needRoomProposal.add(NeedRoomProposal.fromJson(needRoomProposal[i]));
                  }
                }

                //Personal Profile 데이터 get
                GlobalProfile.personalProfile = await ApiProvider().post('/User/List', jsonEncode(
                    {
                      "userID" : user.userID
                    }
                ));

                //자기 매물에 채팅한 정보
                var roomByUserIDList = await ApiProvider().post('/ChatRoomUser/SelectUserID', jsonEncode(
                    {
                      "userID" : user.userID
                    }
                ));

                ChatGlobal.roomInfoList.clear();
                chatRoomUserList.clear();
                if(null != roomByUserIDList){
                  for(int i = 0 ; i < roomByUserIDList.length; ++i){

                    List<ChatRecvMessageModel> chatList = (await ChatDBHelper().getRoomDataByRoomID(roomByUserIDList[i]['id'])).cast<ChatRecvMessageModel>();

                    for(int i = 0 ; i < chatList.length; ++i){
                      if( getMessageTypeByInt(chatList[i].messageType) == MESSAGE_TYPE.IMAGE){

                        var getImageData = await ApiProvider().post('/ChatLog/SelectImageData', jsonEncode({
                          "id" : int.parse(chatList[i].message)
                        }));

                        if(getImageData != null) chatList[i].fileMessage = await ChatGlobal.base64ToFileURL(getImageData['message']);
                        else{
                          chatList[i].message = '사진을 불러올 수 없습니다';
                          chatList[i].messageType = getMessageType(MESSAGE_TYPE.MESSAGE);
                        }
                      }
                    }

                    ChatRoomUser chatRoomUser = ChatRoomUser.fromJson(roomByUserIDList[i]);

                    await GlobalProfile.getFutureUserByUserID(chatRoomUser.chatID);

                    if(chatList == null || chatList.length == 0){
                      chatRoomUserList.add(chatRoomUser);

                      RoomInfo roomInfo = new RoomInfo(
                          lastMessage: "",
                          date: "",
                          roomState: getRoomStateByValue(roomByUserIDList[i]['RoomState']),
                          messageCount: 0,
                          chatList: new List<ChatRecvMessageModel>()
                      );

                      int id = roomByUserIDList[i]['id'];
                      ChatGlobal.roomInfoList[id] = roomInfo;
                    }else{

                      String updatedAt = '';
                      if(chatList.last.updatedAt == null){
                        DateTime d = DateTime.now();
                        d = d.subtract(Duration(days: 30));
                        updatedAt = replaceLocalDate(d.toString(),isSend: true);
                      }else{
                        if(chatList.last.from == GlobalProfile.loggedInUser.userID){
                          DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse( chatList.last.updatedAt, true);
                          updatedAt = getRoomTime(date);
                        }else{
                          updatedAt = chatList.last.updatedAt;
                        }
                      }

                      int cnt = 0;
                      for(int i = 0; i < chatList.length; ++i){
                        if(chatList[i].isRead == 0) cnt++;
                      }

                      chatRoomUser.updatedAt = updatedAt;
                      chatRoomUser.createdAt = updatedAt;

                      chatRoomUserList.add(chatRoomUser);

                      RoomInfo roomInfo = new RoomInfo(
                        lastMessage: getRoomMessage(getMessageTypeByInt(chatList.last.messageType),chatList.last.message),
                        date: updatedAt,
                        roomState: getRoomStateByValue(roomByUserIDList[i]['RoomState']),
                        messageCount: cnt,
                        chatList: chatList,
                      );

                      int id = roomByUserIDList[i]['id'];
                      ChatGlobal.roomInfoList[id] = roomInfo;
                    }
                  }
                }
                //자기가 문의한 매물에 대한 정보
                var roomByChatIDList = await ApiProvider().post('/ChatRoomUser/SelectChatID', jsonEncode(
                    {
                      "userID" : user.userID
                    }
                ));

                if(null != roomByChatIDList){
                  for(int i = 0 ; i < roomByChatIDList.length; ++i){

                    List<ChatRecvMessageModel> chatList = (await ChatDBHelper()
                        .getRoomDataByRoomID(roomByChatIDList[i]['id'])).cast<ChatRecvMessageModel>();

                    for(int i = 0 ; i < chatList.length; ++i){
                      if( getMessageTypeByInt(chatList[i].messageType) == MESSAGE_TYPE.IMAGE){

                        var getImageData = await ApiProvider().post('/ChatLog/SelectImageData', jsonEncode({
                          "id" : int.parse(chatList[i].message)
                        }));

                        if(getImageData != null) chatList[i].fileMessage = await ChatGlobal.base64ToFileURL(getImageData['message']);
                        else{
                          chatList[i].message = '사진을 불러올 수 없습니다';
                          chatList[i].messageType = getMessageType(MESSAGE_TYPE.MESSAGE);
                        }
                      }
                    }

                    ChatRoomUser chatRoomUser = ChatRoomUser.fromJson(roomByChatIDList[i]);

                    await GlobalProfile.getFutureUserByUserID(chatRoomUser.userID);

                    if(chatList == null || chatList.length == 0){
                      chatRoomUserList.add(chatRoomUser);

                      RoomInfo roomInfo = new RoomInfo(
                          lastMessage: "",
                          date: "",
                          roomState: getRoomStateByValue(roomByChatIDList[i]['RoomState']),
                          messageCount: 0,
                          chatList: new List<ChatRecvMessageModel>()
                      );

                      int id = roomByChatIDList[i]['id'];
                      ChatGlobal.roomInfoList[id] = roomInfo;
                    }else{
                      String updatedAt = '';
                      if(chatList.last.from == GlobalProfile.loggedInUser.userID){
                        DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse( chatList.last.updatedAt, true);
                        updatedAt = getRoomTime(date);
                      }else{
                        updatedAt = chatList.last.updatedAt;
                      }

                      int cnt = 0;
                      for(int i = 0; i < chatList.length; ++i){
                        if(chatList[i].isRead == 0) cnt++;
                      }

                      chatRoomUser.updatedAt = updatedAt;
                      chatRoomUser.createdAt = updatedAt;

                      chatRoomUserList.add(chatRoomUser);

                      RoomInfo roomInfo = new RoomInfo(
                        lastMessage: getRoomMessage(getMessageTypeByInt(chatList.last.messageType),chatList.last.message) ,
                        date: updatedAt,
                        roomState: getRoomStateByValue(roomByChatIDList[i]['RoomState']),
                        messageCount: cnt,
                        chatList: chatList,
                      );

                      int id = roomByChatIDList[i]['id'];
                      ChatGlobal.roomInfoList[id] = roomInfo;
                    }
                  }
                }



                Map<int,int> selfMap = Map<int,int>();
                for(int i = 0 ; i < chatRoomUserList.length; ++i){
                  var lastInquireLog = await ApiProvider().post('/ChatLog/Select/LastInquire', jsonEncode(
                      {
                        "chatRoomUserID" : chatRoomUserList[i].id
                      }
                  ));

                  if(lastInquireLog == null) continue;

                  for(int j = lastInquireLog.length - 1  ; j >= 0; --j){
                    RoomInfo roomInfo = ChatGlobal.roomInfoList[lastInquireLog[j]['ChatRoomUserID']];

                    int getID = GlobalProfile.loggedInUser.userID == lastInquireLog[j]['from'] ? lastInquireLog[j]['to'] : lastInquireLog[j]['from'];

                    User1 user = await GlobalProfile.getFutureUserByUserID(getID);

                    ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
                      chatId: lastInquireLog[j]['id'],
                      roomId: lastInquireLog[j]['ChatRoomUserID'],
                      to: lastInquireLog[j]['to'],
                      from:lastInquireLog[j]['from'],
                      fromName : user.nickName,
                      message: lastInquireLog[j]['message'],
                      messageType: lastInquireLog[j]['messageType'],
                      date: setRoomDate(replaceLocalDate(lastInquireLog[j]['date'])),
                      isRead: 1,
                    );
                    chatRecvMessageModel.isContinue = true;
                    DateTime d = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse( lastInquireLog[j]['date'], true);
                    d = d.add(Duration(hours: 9));
                    chatRecvMessageModel.updatedAt = d.toString().replaceAll('T', ' ');
                    chatRecvMessageModel.createdAt = d.toString().replaceAll('T', ' ');
                    chatRecvMessageModel.chatId = await ChatDBHelper().createData(chatRecvMessageModel);

                    MESSAGE_TYPE type =  getMessageTypeByInt(lastInquireLog[j]['messageType']);

                    //오류나면 채팅방 정보가 없는것 데이터 확인 필요
                    String date = lastInquireLog[j]['date'] == null ? '' : replaceLocalDate(lastInquireLog[j]['date']);

                    roomInfo.date = date;
                    roomInfo.lastMessage = getRoomMessage(type, lastInquireLog[j]['message']);
                    switch(type){
                      case MESSAGE_TYPE.MESSAGE :
                        {
                          roomInfo.chatList.add(chatRecvMessageModel);
                          break;
                        }
                      case MESSAGE_TYPE.IMAGE :
                        {
                          chatRecvMessageModel.fileMessage = await ChatGlobal.base64ToFileURL(chatRecvMessageModel.message);
                          roomInfo.chatList.add(chatRecvMessageModel);
                        }

                        break;
                      default:{
                        chatRecvMessageModel.isActive = 1;
                        roomInfo.chatList.add(chatRecvMessageModel);
                        if(selfMap[lastInquireLog[j]['ChatRoomUserID']] == null){
                          selfMap[lastInquireLog[j]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
                        }else{
                          ChatGlobal.roomInfoList[lastInquireLog[j]['ChatRoomUserID']].chatList[selfMap[lastInquireLog[j]['ChatRoomUserID']]].isActive = 0;
                          selfMap[lastInquireLog[j]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
                        }

                        break;
                      }
                    }

                    ChatGlobal.roomInfoList[lastInquireLog[j]['ChatRoomUserID']] = roomInfo;
                  }
                }

                var chatLogList = await ApiProvider().post('/ChatLog/SelectUserID', jsonEncode(
                    {
                      "userID" : user.userID
                    }
                ));

                var needRoomList = await ApiProvider().get('/NeedRoomSalesInfo/Select/List');

                if(needRoomSalesInfoList != null)
                  needRoomSalesInfoList.clear();
                if(null != needRoomList){
                  for(int i = 0 ; i < needRoomList.length; ++i){
                    needRoomSalesInfoList.add(NeedRoomInfo.fromJson(needRoomList[i]));
                  }
                }

                //알림 초기화
                notiList.clear();
                notiList = await NotiDBHelper().getAllData();

                if(null != chatLogList && null != roomByChatIDList && null != roomByUserIDList){
                  Map<int,int> activeMap = Map<int,int>();
                  for(int i = 0 ; i < chatLogList.length; ++i){
                    RoomInfo roomInfo = ChatGlobal.roomInfoList[chatLogList[i]['ChatRoomUserID']];

                    User1 user = await GlobalProfile.getFutureUserByUserID(chatLogList[i]['from']);

                    ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
                      chatId: chatLogList[i]['id'],
                      roomId: chatLogList[i]['ChatRoomUserID'],
                      to: chatLogList[i]['to'],
                      from: chatLogList[i]['from'],
                      fromName : user.nickName,
                      message: chatLogList[i]['message'],
                      messageType: chatLogList[i]['messageType'],
                      date: setRoomDate(replaceLocalDate(chatLogList[i]['date'])),
                      isRead: 0,
                    );
                    chatRecvMessageModel.isContinue = true;
                    DateTime d = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse( chatLogList[i]['date'], true);
                    d = d.add(Duration(hours: 9));
                    chatRecvMessageModel.updatedAt = d.toString().replaceAll('T', ' ');
                    chatRecvMessageModel.createdAt = d.toString().replaceAll('T', ' ');
                    chatRecvMessageModel.chatId = await ChatDBHelper().createData(chatRecvMessageModel);

                    MESSAGE_TYPE type =  getMessageTypeByInt(chatLogList[i]['messageType']);

                    //오류나면 채팅방 정보가 없는것 데이터 확인 필요
                    String date = chatLogList[i]['date'] == null ? '' : replaceLocalDate(chatLogList[i]['date']);

                    roomInfo.date = date;
                    roomInfo.lastMessage = getRoomMessage(type, chatLogList[i]['message']);
                    roomInfo.messageCount += 1;
                    switch(type){
                      case MESSAGE_TYPE.MESSAGE :
                        {
                          roomInfo.chatList.add(chatRecvMessageModel);
                          break;
                        }
                      case MESSAGE_TYPE.IMAGE :
                        {
                          chatRecvMessageModel.fileMessage = await ChatGlobal.base64ToFileURL(chatRecvMessageModel.message);
                          roomInfo.chatList.add(chatRecvMessageModel);
                        }

                        break;
                      default:{
                        chatRecvMessageModel.isActive = 1;
                        roomInfo.chatList.add(chatRecvMessageModel);
                        if(activeMap[chatLogList[i]['ChatRoomUserID']] == null){
                          activeMap[chatLogList[i]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
                        }else{
                          ChatGlobal.roomInfoList[chatLogList[i]['ChatRoomUserID']].chatList[activeMap[chatLogList[i]['ChatRoomUserID']]].isActive = 0;
                          activeMap[chatLogList[i]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
                        }

                        break;
                      }
                    }



                    addNotiByChatRecvMessageModel(chatRecvMessageModel);

                    ChatGlobal.roomInfoList[chatLogList[i]['ChatRoomUserID']] = roomInfo;
                  }
                }

                chatRoomUserListSort();

                /* if(provider.socket != null)
        provider.socket.disconnect();
      await provider.initSocket(user);*/
                await SetNotificationListByEvent();
                GlobalProfile.acceceTokenCheck();

                bool flag = prefs.getBool(IfNewUser2);
                if(flag == null){
                  Navigator.pushReplacement(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) =>
                              TutorialScreen()) // SecondRoute를 생성하여 적재
                  );
                }
                else {
                  Navigator.pushReplacement(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) =>
                              MainPage()) // SecondRoute를 생성하여 적재
                  );
                }
              }
              else {
                Timer(Duration(milliseconds: 1500), () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LoginMainScreen()
                  )
                  );
                });
              }
            }
            else {
              Timer(Duration(milliseconds: 1500), () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => LoginMainScreen()
                )
                );
              });
            }
          }
        } catch (e) {
          Timer(Duration(seconds: 1), () {
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => LoginMainScreen()
            )
            );
          });
        }
      }
      else{

        Function okFunc = () {
          //_launchUrl('https://myroomyourroom.page.link/mryr2');
          _launchUrl(Platform.isAndroid ?'https://play.google.com/store/apps/details?id=com.myroomyourroom.mryr':Platform.isIOS? 'https://apps.apple.com/kr/app/%EB%82%B4%EB%B0%A9%EB%8B%88%EB%B0%A9/id1546545475?l=en':'https://myroomyourroom.page.link/mryr2');
        };
        OKDialog(context,"업데이트가 필요","중요한 변경으로 인해 업데이트를 해야만 앱을 이용할 수 있어요.","확인", okFunc);



      }
    })();
    if(NFlag) {
      Timer(Duration(seconds: 1), () {
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => LoginMainScreen()
        )
        );
      });
    }


    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final String imageLogoName = 'assets/images/public/PurpleLogo.svg';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: new Scaffold(
          backgroundColor: hexToColor('#6F22D2'),
          body: new Container(
            //height : MediaQuery.of(context).size.height,
            //color: kPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.384375),
                Container(
                  child: SvgPicture.asset(
                    imageLogoName,
                    width: screenWidth * 0.616666,
                    height: screenHeight * 0.0859375,
                  ),
                ),
                Expanded(child: SizedBox()),
                Align(
                  child: Text("© Copyright 2020, 내방니방(MRYR)",
                      style: TextStyle(
                        fontSize: screenWidth*( 14/360), color: Color.fromRGBO(255, 255, 255, 0.6),)
                  ),
                ),
                SizedBox( height: MediaQuery.of(context).size.height*0.0625,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}
