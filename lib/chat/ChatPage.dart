import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatReportScreen.dart';
import 'package:mryr/chat/models/BottomSheetInRequestTrade.dart';
import 'package:mryr/chat/models/DateInRequestTradeBottomSheetProvider.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/CustomException.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotiProvider.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotification.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:mryr/widget/RoomWannaLive/StringForRommWannaLive.dart';
import 'package:provider/provider.dart';
import './models/ChatItem.dart';
import './models/ChatRecvMessageModel.dart';
import './models/ChatGlobal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './models/ChatDatabase.dart';

enum ROOM_STATE { INQUIRE, REQUEST, DONE }

class ChatPage extends StatefulWidget {
  User1 chatUser;
  ChatRoomUser chatRoomUser;
  RoomSalesInfo roomSalesInfo;
  bool isProposal;

  ChatPage(
      {Key key,
        this.chatUser,
        this.chatRoomUser,
        this.roomSalesInfo,
        this.isProposal})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  String navigatorBackArrowName = 'assets/images/Chat/navigatorBackArrow.svg';
  String photoUploadImageName = 'assets/images/Chat/ImageUpload.svg';
  String settingIconName = 'assets/images/Chat/ImageUpload.svg';

  LocalNotification _localNotification;
  //SocketProvider _socket;
  ChatGlobal _global;

  int roomIndex;
  int chatStartIndex;
  ScrollController _chatLVController;
  TextEditingController _chatTfController;

  bool isMe = false;
  bool isToggleButton = false;

  DateInRequestTradeBottomSheetProvider dateProvider;

  Widget bannerFlatButton() {
    switch (_global.getRoomInfoList[roomIndex].roomState) {
      case ROOM_STATE.INQUIRE:
        return Padding(
          padding: EdgeInsets.only(
              right: screenWidth * (12 / 360), top: screenHeight * (6 / 640)),
          child: GestureDetector(
            onTap: () {
              if (isMe) return;

              BottomSheetInRequestTrade(
                  context,
                  screenWidth,
                  screenHeight,
                  "확정된 거래 정보",
                  "마지막으로 확인 후 거래 확정을 요청해주세요",
                  widget.roomSalesInfo,
                  dateProvider)
                  .then((value) {
                if (value != null) {
                  String date = DateFormat('HH').format(DateTime.now());
                  int dateHour = int.parse(date);

                  date = dateHour.toString() +
                      ":" +
                      DateFormat('mm').format(DateTime.now());

                  ChatRecvMessageModel chatRecvMessageModel =
                  ChatRecvMessageModel(
                    roomId: widget.chatRoomUser.id,
                    to: widget.roomSalesInfo.userID,
                    from: GlobalProfile.loggedInUser.userID,
                    fromName: GlobalProfile.loggedInUser.name,
                    message: value,
                    messageType: getMessageType(MESSAGE_TYPE.INQUIRE_REQUEST),
                    date: date,
                    isRead: 1,
                    updatedAt: DateTime.now().toLocal().toString(),
                    createdAt: DateTime.now().toLocal().toString(),
                    isActive: 1,
                  );
                  chatRecvMessageModel.isContinue = true;

                  setState(() {
                    _global.setRoomState(roomIndex, ROOM_STATE.REQUEST);
                    _global.addRoomInfoChat(
                        widget.chatRoomUser.id, chatRecvMessageModel);
                  });

                /*  _socket
                    ..socket.emit(
                        "roomChatMessage", [chatRecvMessageModel.toJson()]);*/
                }
              });
            },
            child: Container(
              width: screenWidth * ((80 - 12) / 360),
              height: screenHeight * (52 / 640),
              decoration: (false == isMe)
                  ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor("#FFFFFF"),
                  border: Border.all(
                    color: hexToColor('#6F22D2'),
                    width: 1,
                  ))
                  : BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor("#CCCCCC"),
                  border: Border.all(
                    color: hexToColor('#CCCCCC'),
                    width: 1,
                  )),
              child: Center(
                child: Text(
                  (false == isMe) ? "거래 확정" : "거래 대기",
                  style: TextStyle(
                      fontSize: screenWidth * (12 / 360),
                      color: (false == isMe)
                          ? hexToColor('#6F22D2')
                          : hexToColor('#FFFFFF')),
                ),
              ),
            ),
          ),
        );
        break;
      case ROOM_STATE.REQUEST:
        return Padding(
          padding: EdgeInsets.only(
              right: screenWidth * (12 / 360), top: screenHeight * (6 / 640)),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: screenWidth * ((80 - 12) / 360),
              height: screenHeight * (52 / 640),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor("#CCCCCC"),
                  border: Border.all(
                    color: hexToColor('#CCCCCC'),
                    width: 1,
                  )),
              child: Center(
                child: Text(
                  "확정 진행 중",
                  style: TextStyle(
                      fontSize: screenWidth * (12 / 360),
                      color: hexToColor('#FFFFFF'),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
        break;
      case ROOM_STATE.DONE:
        return Padding(
          padding: EdgeInsets.only(
              right: screenWidth * (12 / 360), top: screenHeight * (6 / 640)),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: screenWidth * ((80 - 12) / 360),
              height: screenHeight * (52 / 640),

              /*decoration : BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: kPrimaryColor,
                  border: Border.all(
                    color:  hexToColor('#6F22D2'),
                    width: 1,
                  )
              ),*/
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: hexToColor("#CCCCCC"),
                  border: Border.all(
                    color: hexToColor('#CCCCCC'),
                    width: 1,
                  )),
              child: Center(
                //child: Text("이용 후기 작성", style: TextStyle(fontSize: screenWidth * (10/360), color: hexToColor('#FFFFFF'), fontWeight: FontWeight.bold),
                child: Text(
                  "거래 완료",
                  style: TextStyle(
                      fontSize: screenWidth * (10 / 360),
                      color: hexToColor('#FFFFFF'),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }

    return Container();
  }

  AnimationController extendedController;

  @override
  void initState() {
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    roomIndex = widget.chatRoomUser.id;
    _chatLVController = ScrollController(initialScrollOffset: 0.0); //flutter 제공
    _chatTfController = TextEditingController();

    chatStartIndex = 0;

    if (widget.chatRoomUser == null)
      throw FetchDataException('Chat User Data is Null');

    if (widget.roomSalesInfo.userID == GlobalProfile.loggedInUser.userID)
      isMe = true;

    (() async {
      await _initMessageData();
      _chatLVController.addListener(scrollListener);

      if (_chatLVController.hasClients) {
        _chatLVController.jumpTo(
          _chatLVController.position.maxScrollExtent,
        );
      }
    })();
  }

  @override
  void dispose() {
    _chatLVController.removeListener(scrollListener);
    _chatLVController.dispose();
    _chatTfController.dispose();
    extendedController.dispose();
    super.dispose();
  }

  Future<void> _initMessageData() async {
    RoomInfo roomInfo = ChatGlobal.roomInfoList[widget.chatRoomUser.id];
    if (null != roomInfo) {
      if (roomInfo.chatList.length > 1) {
        int readIndex = 0;
        bool isReadPoint = false;

        await ChatDBHelper().updateRoomRead(roomIndex, 1);

        for (int index = 1; index < roomInfo.chatList.length; ++index) {
          ChatRecvMessageModel chatRecvMessageModel = roomInfo.chatList[index];

          ChatGlobal.roomInfoList[roomIndex].chatList[index].isRead = 1;

          if (false == isReadPoint) {
            readIndex = index;
            isReadPoint = true;
          }

          if (ChatGlobal.roomInfoList[roomIndex].chatList[index - 1].from !=
              CENTER_MESSAGE) {
            bool isContinue = (chatRecvMessageModel.from ==
                ChatGlobal
                    .roomInfoList[roomIndex].chatList[index - 1].from) &&
                (chatRecvMessageModel.date ==
                    ChatGlobal
                        .roomInfoList[roomIndex].chatList[index - 1].date);
            if (true == isContinue) {
              ChatGlobal.roomInfoList[roomIndex].chatList[index - 1]
                  .isContinue = false;
              ChatGlobal.roomInfoList[roomIndex].chatList[index].isContinue =
              true;
            } else {
              ChatGlobal.roomInfoList[roomIndex].chatList[index - 1]
                  .isContinue = true;
            }
          }
        }

        if (isReadPoint && readIndex != 1) {
          ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
              to: CENTER_MESSAGE,
              from: CENTER_MESSAGE,
              message: "여기까지 읽으셨습니다.",
              messageType: getMessageType(MESSAGE_TYPE.MESSAGE),
              date: "00:00");
          chatRecvMessageModel.isContinue = false;

          ChatGlobal.roomInfoList[roomIndex].chatList
              .insert(readIndex - 1, chatRecvMessageModel);
          setState(() {});
        }
      }
    }
  }

  void scrollListener() {
    if (_chatLVController.offset <=
        _chatLVController.position.minScrollExtent &&
        !_chatLVController.position.outOfRange) {
      if (chatStartIndex == 0) return;

      Future.delayed(Duration(seconds: 1), () async {
        int tempIndex = chatStartIndex - MAX_PREV_CHAT_MESSAGE;
        if (tempIndex < 0) tempIndex = 0;

        int cnt = 0;
        for (int i = tempIndex; i < chatStartIndex; ++i) {
          ChatRecvMessageModel chatRecvMessageModel =
          _global.getRoomInfoList[roomIndex].chatList[i];
          chatRecvMessageModel.isContinue = true;

          if (cnt != 0) {
            bool isContinue = (chatRecvMessageModel.from ==
                _global
                    .getRoomInfoList[roomIndex].chatList[cnt - 1].from) &&
                (chatRecvMessageModel.date ==
                    _global.getRoomInfoList[roomIndex].chatList[cnt - 1].date);
            if (true == isContinue) {
              _global.getRoomInfoList[roomIndex].chatList[cnt - 1].isContinue =
              false;
            } else {
              _global.getRoomInfoList[roomIndex].chatList[cnt - 1].isContinue =
              true;
            }
          }
        }
        chatStartIndex = tempIndex;
        setState(() {});
      });
    }
  }

  _chatList() {
    if (_global.getRoomInfoList.length == 0) return;

    RoomInfo roomInfo = _global.getRoomInfoList[widget.chatRoomUser.id];

    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          cacheExtent: 30,
          controller: _chatLVController,
          reverse: false,
          shrinkWrap: true,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          itemCount: null == roomInfo.chatList ? 0 : roomInfo.chatList.length,
          itemBuilder: (context, index) {
            ChatRecvMessageModel chatMessage = roomInfo.chatList[index];
            bool isContinue = index == 0
                ? false
                : (roomInfo.chatList[index - 1].from ==
                roomInfo.chatList[index].from) &&
                (roomInfo.chatList[index - 1].date ==
                    roomInfo.chatList[index].date);
            return Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.00625),
              child: ChatItem(
                message: chatMessage,
                isContinue: isContinue,
                chatIconName: widget.chatUser.profileUrlList,
              ),
            );
          },
        ),
      ),
    );
  }

  _bottomChatArea() {
    return Container(
      color: hexToColor('#F8F8F8'),
      height: screenHeight * (60 / 640),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: screenWidth * (12 / 360),
          ),
          GestureDetector(
            onTap: () async {
              PickedFile imagePicked = await ImagePicker()
                  .getImage(source: ImageSource.gallery); //camera -> gallery
              if (imagePicked == null) return;

              File file = File(imagePicked.path);
              List<int> imageBytes = await file.readAsBytes();

              var chatID = await ApiProvider().get('/ChatLog/Count');

              String base64Image = base64Encode(imageBytes);
              String date = DateFormat('HH').format(DateTime.now());
              int dateHour = int.parse(date);

              date = dateHour.toString() +
                  ":" +
                  DateFormat('mm').format(DateTime.now());
              ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
                chatId: chatID['id'] + 1,
                to: widget.chatUser.userID,
                from: GlobalProfile.loggedInUser.userID,
                fromName: GlobalProfile.loggedInUser.name,
                roomId: widget.chatRoomUser.id,
                message: base64Image,
                messageType: getMessageType(MESSAGE_TYPE.IMAGE),
                date: date,
                updatedAt: DateTime.now().toLocal().toString(),
                createdAt: DateTime.now().toLocal().toString(),
              );
              chatRecvMessageModel.isRead = 1;
              chatRecvMessageModel.isContinue = true;
              chatRecvMessageModel.roomSalesID = widget.roomSalesInfo.id;

              _global.getRoomInfoList[roomIndex].lastMessage = "사진을 보냈습니다.";
              _global.getRoomInfoList[roomIndex].date =
                  getRoomTime(DateTime.now().toLocal());

              //채팅방 sorting용
              for (int i = 0; i < chatRoomUserList.length; ++i) {
                if (widget.chatRoomUser.id == chatRoomUserList[i].id) {
                  chatRoomUserList[i].updatedAt =
                      getRoomTime(DateTime.now().toLocal());
                }
              }

           /*   _socket
                ..socket
                    .emit("roomChatMessage", [chatRecvMessageModel.toJson()]);
*/
              _addRecvMessage(0, chatRecvMessageModel,
                  _global.getRoomInfoList[roomIndex].chatList.length - 1, true);
              return;
            },
            child: SvgPicture.asset(
              photoUploadImageName,
              width: MediaQuery.of(context).size.width * (16 / 360),
              height: MediaQuery.of(context).size.height * (16 / 640),
            ),
          ),
          SizedBox(
            width: screenWidth * (8 / 360),
          ),
          Container(
              width: screenWidth * (278 / 360),
              height: screenHeight * (32 / 640),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: hexToColor("#FFFFFF"),
                  border: Border.all(
                    color: hexToColor('#CCCCCC'),
                    width: 1,
                  )),
              child: TextField(
                controller: _chatTfController,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,

                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "메시지를 입력하세요.",
                  hintStyle: TextStyle(
                      fontSize: screenWidth * (12 / 360),
                      color: hexToColor("#D2D2D2")),
                  contentPadding: EdgeInsets.fromLTRB(screenWidth * (14 / 360),
                      0, 0, screenHeight * (13 / 640)),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              )),
//          SizedBox(width: screenWidth * (12/360),),
          //Spacer(flex: 1,),
          InkWell(
            onTap: () {
              _sendButtonTap();
            },
            child: Container(
              width: screenWidth * (46 / 360),
              height: screenHeight * (60 / 640),
              child: Center(
                child: Text(
                  "전송",
                  style: TextStyle(
                      fontSize: screenWidth * (12 / 360), color: kPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setScreenWidth(context);
    setScreenHeight(context);

    dateProvider = Provider.of<DateInRequestTradeBottomSheetProvider>(context);
    _global = Provider.of<ChatGlobal>(context);

    if (null == _localNotification)
      _localNotification =
          Provider.of<LocalNotiProvider>(context).localNotification;

   /* if (null == _socket)
      _socket = Provider.of<SocketProvider>(context)
        ..socket.on(SocketProvider.CHAT_RECEIVED_EVENT, (data) {
          ChatRecvMessageModel chatRecvMessageModel =
          ChatRecvMessageModel.fromJson(data);
          chatRecvMessageModel.isActive = 1;

          RoomInfo roomInfo =
          _global.getRoomInfoList[chatRecvMessageModel.roomId];

          if (roomInfo != null) {
            bool isRebuild = false;
            if (widget.chatRoomUser.id == chatRecvMessageModel.roomId) {
              if (getMessageTypeByInt(chatRecvMessageModel.messageType) !=
                  MESSAGE_TYPE.MESSAGE &&
                  getMessageTypeByInt(chatRecvMessageModel.messageType) !=
                      MESSAGE_TYPE.IMAGE)
                _global.setRoomState(
                    widget.chatRoomUser.id,
                    getRoomStateByMessageType(
                        getMessageTypeByInt(chatRecvMessageModel.messageType)));

              chatRecvMessageModel.isRead = 1;
              isRebuild = true;
            } else {
              chatRecvMessageModel.isRead = 0;
              isRebuild = false;
              addNotiByChatRecvMessageModel(chatRecvMessageModel);
              Future.microtask(() async => await _localNotification.showNoti(
                  title:
                  GlobalProfile.getUserByUserID(chatRecvMessageModel.from)
                      .name,
                  des: GetLocalNotiMessageByChat(chatRecvMessageModel)));
            }

            //채팅방 sorting용
            for (int i = 0; i < chatRoomUserList.length; ++i) {
              if (widget.chatRoomUser.id == chatRoomUserList[i].id) {
                chatRoomUserList[i].updatedAt = chatRecvMessageModel.updatedAt;
              }
            }

            processRecvMessage(chatRecvMessageModel, 0, isRebuild);
          }
        });
*/
    return WillPopScope(
      onWillPop: (){
       // _socket.setRoomStatus(ROOM_STATUS_ETC);

        for (int i = 0; i < globalRoomSalesInfoList.length; ++i) {
          for (int j = 0;
          j < globalRoomSalesInfoList[i].chatRoomUserList.length;
          ++j) {
            if (globalRoomSalesInfoList[i].chatRoomUserList[j].id ==
                widget.chatRoomUser.id) {
              globalRoomSalesInfoList[i].chatRoomUserList[j].roomState =
                  getValueByRoomState(
                      _global.getRoomInfoList[roomIndex].roomState);
            }
          }
        }

        chatRoomUserListSort();
        Navigator.pop(context);
        if (widget.isProposal) Navigator.pop(context);
        return;
      },
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: hexToColor("#FFFFFF"),
            elevation: 0.0,
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.033333, 0, 0, 0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 0),
                elevation: 0,
                color: Colors.white,
                onPressed: () {
               //   _socket.setRoomStatus(ROOM_STATUS_ETC);

                  for (int i = 0; i < globalRoomSalesInfoList.length; ++i) {
                    for (int j = 0;
                    j < globalRoomSalesInfoList[i].chatRoomUserList.length;
                    ++j) {
                      if (globalRoomSalesInfoList[i].chatRoomUserList[j].id ==
                          widget.chatRoomUser.id) {
                        globalRoomSalesInfoList[i].chatRoomUserList[j].roomState =
                            getValueByRoomState(
                                _global.getRoomInfoList[roomIndex].roomState);
                      }
                    }
                  }

                  chatRoomUserListSort();
                  Navigator.pop(context);
                  if (widget.isProposal) Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    navigatorBackArrowName,
                    width: screenWidth * 0.057777,
                    height: screenWidth * 0.057777,
                  ),
                ),
              ),
            ),
            title: SvgPicture.asset(
              MryrLogo,
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  _settingModalBottomSheet(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth * 0.033333),
                  child: SvgPicture.asset(
                    moreForRoomWannaLive,
                    width: screenWidth * 0.077777,
                    height: screenWidth * 0.077777,
                  ),
                ),
              ),
            ],
          ),
          body: WillPopScope(
            onWillPop: () {
            //  _socket.setRoomStatus(ROOM_STATUS_ETC);

              for (int i = 0; i < globalRoomSalesInfoList.length; ++i) {
                for (int j = 0;
                j < globalRoomSalesInfoList[i].chatRoomUserList.length;
                ++j) {
                  if (globalRoomSalesInfoList[i].chatRoomUserList[j].id ==
                      widget.chatRoomUser.id) {
                    globalRoomSalesInfoList[i].chatRoomUserList[j].roomState =
                        getValueByRoomState(
                            _global.getRoomInfoList[roomIndex].roomState);
                  }
                }
              }

              Navigator.pop(context);
              if (widget.isProposal) Navigator.pop(context);
              return;
            },
            child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        width: screenWidth,
                        height: 1,
                        decoration: BoxDecoration(color: hexToColor('#F8F8F8'))),
                    GestureDetector(
                      onTap: () {
                //        _socket.setRoomStatus(ROOM_STATUS_ETC);
                        Navigator.push(
                            context, // 기본 파라미터, SecondRoute로 전달
                            MaterialPageRoute(
                                builder: (context) => DetailedRoomInformation(
                                  isParentChat: true,
                                  roomSalesInfo: widget.roomSalesInfo,
                                )) // SecondRoute를 생성하여 적재
                        );
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * (80 / 640),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * (12 / 360),
                              top: screenHeight * (8 / 640)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * (76 / 360),
                                height: screenHeight * (64 / 640),
                                child: ClipRRect(
                                    borderRadius: new BorderRadius.circular(4.0),
                                    child:
                                    widget.roomSalesInfo.imageUrl1 == "BasicImage"
                                        ? SvgPicture.asset(
                                      ProfileIconInMoreScreen,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                    )
                                        : FittedBox(
                                      fit: BoxFit.cover,
                                      child: getExtendedImage(
                                          get_resize_image_name(widget.roomSalesInfo.imageUrl1,360),
                                          0,
                                          extendedController),
                                    )),
                              ),
                              SizedBox(
                                width: screenWidth * 0.033333,
                              ),
                              Container(
                                width: screenWidth * (168 / 360),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: screenHeight * (6 / 640),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: screenWidth * (6 / 360),
                                              right: screenWidth * (6 / 360)),
                                          height: screenHeight * (22 / 640),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.circular(
                                                screenHeight * (4 / 640)),
                                          ),
                                          child: Center(
                                              child: Text(
                                                widget.roomSalesInfo.preferenceTerm == 2 ? "하루가능" :widget.roomSalesInfo.preferenceTerm == 1 ? "1개월이상" : "기관무관",

                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kPrimaryColor,
                                                    fontSize: screenWidth * TagFontSize),
                                              )),
                                        ),
                                        SizedBox(
                                          width: screenWidth * (4 / 360),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: screenWidth * (6 / 360),
                                              right: screenWidth * (6 / 360)),
                                          height: screenHeight * (22 / 640),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.circular(
                                                screenHeight * (4 / 640)),
                                          ),
                                          child: Center(
                                              child: Text(
                                                widget.roomSalesInfo.preferenceSmoking ==
                                                    2
                                                    ? "흡연가능"
                                                    : widget.roomSalesInfo
                                                    .preferenceSmoking ==
                                                    1
                                                    ? "흡연불가"
                                                    : "흡연무관",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kPrimaryColor,
                                                    fontSize: screenWidth * TagFontSize),
                                              )),
                                        ),
                                        SizedBox(
                                          width: screenWidth * (4 / 360),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: screenWidth * (6 / 360),
                                              right: screenWidth * (6 / 360)),
                                          height: screenHeight * (22 / 640),
                                          decoration: BoxDecoration(
                                            color: Color(0xffeeeeee),
                                            borderRadius: BorderRadius.circular(
                                                screenHeight * (4 / 640)),
                                          ),
                                          child: Center(
                                              child: Text(
                                                widget.roomSalesInfo.preferenceSex == 2
                                                    ? "남자 선호"
                                                    : widget.roomSalesInfo
                                                    .preferenceSex ==
                                                    1
                                                    ? "여자 선호"
                                                    : "성별 무관",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kPrimaryColor,
                                                    fontSize: screenWidth * TagFontSize),
                                              )),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * (8 / 640),
                                    ),
                                    Text(
                                      widget.roomSalesInfo.monthlyRentFeesOffer
                                          .toString() +
                                          '만원 / 월',
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.025,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.00625,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * (8 / 360),
                              ),
                              bannerFlatButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: screenWidth,
                        height: 1,
                        decoration: BoxDecoration(color: hexToColor('#F8F8F8'))),
                    _chatList(),
                    Container(
                        width: screenWidth,
                        height: 1,
                        decoration: BoxDecoration(color: hexToColor('#F8F8F8'))),
                    _bottomChatArea(),
                  ],
                )),
          )),
    );
  }

  _sendButtonTap() async {
    if (_chatTfController.text.isEmpty) {
      return;
    }

    String date = DateFormat('HH').format(DateTime.now());
    int dateHour = int.parse(date);

    date = dateHour.toString() + ":" + DateFormat('mm').format(DateTime.now());

    ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
      chatId: 0,
      to: widget.chatUser.userID,
      from: GlobalProfile.loggedInUser.userID,
      fromName: GlobalProfile.loggedInUser.nickName,
      roomId: widget.chatRoomUser.id,
      message: _chatTfController.text,
      messageType: getMessageType(MESSAGE_TYPE.MESSAGE),
      date: date,
      updatedAt: DateTime.now().toString(),
      createdAt: DateTime.now().toString(),
    );

    chatRecvMessageModel.isRead = 1;
    chatRecvMessageModel.isContinue = true;
    chatRecvMessageModel.roomSalesID = widget.roomSalesInfo.id;

    //_global.getRoomInfoList[widget.chatRoomUser.id].chatList.add(chatRecvMessageModel);
    _global.getRoomInfoList[widget.chatRoomUser.id].lastMessage =
        chatRecvMessageModel.message;
    _global.getRoomInfoList[widget.chatRoomUser.id].date =
        getRoomTime(DateTime.now().toLocal());

    //채팅방 sorting용
    for (int i = 0; i < chatRoomUserList.length; ++i) {
      if (widget.chatRoomUser.id == chatRoomUserList[i].id) {
        chatRoomUserList[i].updatedAt = getRoomTime(DateTime.now().toLocal());
      }
    }

  //  _socket..socket.emit("roomChatMessage", [chatRecvMessageModel.toJson()]);

    _addRecvMessage(0, chatRecvMessageModel,
        _global.getRoomInfoList[roomIndex].chatList.length - 1, true);
    _clearMessage();
  }

  _clearMessage() {
    _chatTfController.text = '';
  }

  _isFromMe(User1 fromUser) {
    return fromUser.userID == GlobalProfile.loggedInUser.userID;
  }

  processRecvMessage(
      ChatRecvMessageModel chatRecvMessageModel, int index, isRebuild) {
    //ChatGlobal.addChatRecvMessage(chatRecvMessageModel, index);

    if (false == isRebuild) return;

    _addRecvMessage(0, chatRecvMessageModel,
        _global.getRoomInfoList[roomIndex].chatList.length - 1, isRebuild);
  }

  _addRecvMessage(id, ChatRecvMessageModel chatRecvMessageModel, int prevIndex,
      isRebuild) async {
    print('Adding Message to UI ${chatRecvMessageModel.message}');

    chatRecvMessageModel.isContinue =
    chatRecvMessageModel.from == CENTER_MESSAGE ? false : true;

    _global.addRoomInfoChat(roomIndex, chatRecvMessageModel);
    //_global.setChatActive(roomIndex, prevIndex, false);

    if (prevIndex > 0) {
      if (chatRecvMessageModel.isContinue == false) return;
      if (_global.getRoomInfoList[roomIndex].chatList[prevIndex].from !=
          CENTER_MESSAGE) {
        bool isContinue = (chatRecvMessageModel.from ==
            _global.getRoomInfoList[roomIndex].chatList[prevIndex].from) &&
            (chatRecvMessageModel.date ==
                _global.getRoomInfoList[roomIndex].chatList[prevIndex].date);
        if (true == isContinue) {
          _global.getRoomInfoList[roomIndex].chatList[prevIndex].isContinue =
          false;
        } else {
          _global.getRoomInfoList[roomIndex].chatList[prevIndex].isContinue =
          true;
        }
      }
    }

    if (this.mounted && isRebuild) {
      setState(() {});
    }

    if (isRebuild) _chatListScrollToBottom();
  }

  /// Scroll the Chat List when it goes to bottom
  _chatListScrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatLVController.hasClients) {
        _chatLVController.animateTo(
          _chatLVController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
      }
    });
  }

  void _settingModalBottomSheet(context) {
    final String GreyCircularLine = 'assets/images/Public/GreyCircularLine.svg';

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(8.0),
                topRight: const Radius.circular(8.0))),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            height: screenHeight * 0.1525,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * .0125,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    GreyCircularLine,
                    width: screenWidth * 0.055555,
                    height: screenHeight * 0.003125,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.040625,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) => ChatReportScreen(
                              chatRoomUser: widget.chatRoomUser,
                            )) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.075,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.033333),
                        child: Text(
                          '신고하기',
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
