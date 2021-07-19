import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyProposeForBorrow.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/CustomTextInputFormatter.dart';
import 'package:provider/provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class ProposalConditionForBorrow extends StatefulWidget {
  RoomSalesInfo roomSalesInfo;

  ProposalConditionForBorrow({Key key, this.roomSalesInfo}) : super(key: key);

  @override
  _ProposalConditionForBorrowState createState() =>
      _ProposalConditionForBorrowState();
}

class _ProposalConditionForBorrowState
    extends State<ProposalConditionForBorrow> {
  bool FlagForMapSwitch = false;
  TextEditingController RoomPriceController = TextEditingController();

  //SocketProvider _socket;

  @override
  void initState() {
    super.initState();
    DummyProposeForBorrow data = Provider.of<DummyProposeForBorrow>(context,listen: false);
    final text = RoomPriceController.text.toLowerCase();
    RoomPriceController.addListener(() {
      final text = RoomPriceController.text.toLowerCase();
      RoomPriceController.value = RoomPriceController.value.copyWith(text: text,
      selection:TextSelection(baseOffset: text.length,extentOffset: text.length),
      composing: TextRange.empty);
    });
   // RoomPriceController.text = widget.roomSalesInfo.monthlyRentFeesOffer.toString();
    RoomPriceController.text = data.Price;
  }


  @override
  Widget build(BuildContext context) {
    DummyProposeForBorrow data = Provider.of<DummyProposeForBorrow>(context);
   // SocketProvider socket = Provider.of<SocketProvider>(context);
  //  RoomPriceController.text = data.Price;

    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;

   // if (null == _socket) _socket = Provider.of<SocketProvider>(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
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
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    backArrow,
                    width: screenWidth * 0.057777,
                    height: screenWidth * 0.057777,
                  ),
                ),
              ),
            ),
            title: SvgPicture.asset(
              MryrLogo,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.033333),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.0625,),
                Row(
                  children: [
                    Container(
                      width: screenWidth * (245 / 360),
                      child: Text(
                        '임대료 및 기간 제안',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * 0.0375
                        ),
                      ),
                    ),

//                Row(
//                  children: [
//                    GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          FlagForMapSwitch = false;
//                        });
//                      },
//                      child: Container(
//                        width: screenWidth * 0.125,
//                        height: screenHeight * 0.05,
//                        decoration: BoxDecoration(
//                            borderRadius: new BorderRadius.only(topLeft: Radius
//                                .circular(8.0), bottomLeft: Radius.circular(
//                                8.0)),
//                            border: Border.all(
//                              width: 1,
//                              color: hexToColor("#EEEEEE"),
//                            ),
//                            color: FlagForMapSwitch == true
//                                ? Colors.white
//                                : kPrimaryColor
//                        ),
//                        child: Align(
//                          alignment: Alignment.center,
//                          child: Text(
//                            '월세',
//                            style: TextStyle(
//                                fontSize: screenHeight * 0.01875,
//                                color: FlagForMapSwitch == true ? hexToColor(
//                                    "#888888") : Colors.white
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          FlagForMapSwitch = true;
//                          print(FlagForMapSwitch);
//                        });
//                      },
//                      child: Container(
//                        width: screenWidth * 0.125,
//                        height: screenHeight * 0.05,
//                        decoration: BoxDecoration(
//                            borderRadius: new BorderRadius.only(topRight: Radius
//                                .circular(8.0), bottomRight: Radius.circular(
//                                8.0)),
//                            border: Border.all(
//                              width: 1,
//                              color: hexToColor("#EEEEEE"),
//                            ),
//                            color: FlagForMapSwitch == true
//                                ? kPrimaryColor
//                                : Colors.white
//                        ),
//                        child: Align(
//                          alignment: Alignment.center,
//                          child: Text(
//                            '총합',
//                            style: TextStyle(
//                                fontSize: screenHeight * 0.01875,
//                                color: FlagForMapSwitch == true
//                                    ? Colors.white
//                                    : hexToColor("#888888")
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.0125,),
                Text(
                  '임대료와 임대 기간을 입력해주세요.',
                  style: TextStyle(
                    fontSize: screenHeight * 0.01875,
                    color: hexToColor("#888888"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.090625,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: screenHeight * 0.05,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.277777,
                        child:
                        TextField(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * (20 / 360),
                            color: hexToColor("#222222"),
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(8)],

                          textInputAction: TextInputAction.done,
                          controller: RoomPriceController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 6),
                            hintText: '4',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * (20 / 360),
                              color: hexToColor("#CCCCCC"),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onSubmitted: (string) {
                            data.ChangePrice(string);
                          },
                        )
                    ),
                    SizedBox(width: screenWidth * 0.02222,),
                    Text(
                      '만원 / 월',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * (20 / 360),
                      ),
                    ),
                    SizedBox(width: screenWidth * (40 / 360),),
                  ],
                ),
                SizedBox(height: screenHeight * 0.0125,),
                Container(
                  height: 1,
                  color: hexToColor("#CCCCCC"),
                ),
                SizedBox(height: screenHeight * 0.0625,),
                Stack(
                  children: [
                    Container(
                      width: screenWidth * (336 / 360),
                      child: Row(
                        children: [
                          Spacer(),
                          // SizedBox(width: screenWidth*(20/360),),
                          Column(
                            children: [
                              Container(
                                  width: screenWidth * (120 / 360),
                                  child: Center(
                                      child: Text(
                                        data.Start==null?"입주" :data.Start,
                                        style: TextStyle(
                                            fontSize: screenWidth * (20 / 360),
                                            fontWeight: FontWeight.bold,
                                            color: data.Start==null?Color(0xffcccccc): Colors.black),
                                      ))),
                              Container(
                                height: screenHeight*(8/640),
                              ),
                              Container(
                                width: screenWidth*(120/360),
                                height: 1,
                                color: hexToColor("#CCCCCC"),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * (55 / 640),
                          ),
                          Text(
                            "~",
                            style: TextStyle(
                                fontSize: screenWidth * (20 / 360),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: screenWidth * (55 / 640),
                          ),
                          Column(
                            children: [
                              Container(
                                  width: screenWidth * (120 / 360),
                                  child: Center(
                                      child: Text(
                                        data.End== null?"퇴실":data.End,
                                        style: TextStyle(
                                            fontSize: screenWidth * (20 / 360),
                                            fontWeight: FontWeight.bold,
                                            color:data.End==null?Color(0xffcccccc): Colors.black),
                                      ))),
                              Container(
                                height: screenHeight*(8/640),
                              ),
                              Container(
                                width: screenWidth*(120/360),
                                height: 1,
                                color: hexToColor("#CCCCCC"),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Positioned(
                      child: FlatButton(
                          color: Colors.transparent,
                          onPressed: () async {
                            List<DateTime> picked2 =
                            await DateRagePicker.showDatePicker(
                                context: context,
                                initialFirstDate: DateTime.now(),
                                initialLastDate: (DateTime.now())
                                    .add(Duration(days: 1)),
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(DateTime.now().year + 3));
                            if (picked2.length == 1) {
                              picked2.add(picked2[0]);
                            }
                            data.Start = termChange( picked2[0].toString());
                            data.End = termChange( picked2[1].toString());
                            setState(() {});
                          },
                          child: Container(
                            height: screenHeight * (35 / 640),
                            width: screenWidth * (300 / 360),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar:
          GestureDetector(
            onTap: () async {
              if (RoomPriceController.text.isEmpty ||
                  data.Start.isEmpty || data.End.isEmpty) {
                return;
              }

            //  socket.setRoomStatus(ROOM_STATUS_CHAT);

              if (null == widget.roomSalesInfo.chatRoomUserList){
                widget.roomSalesInfo.chatRoomUserList = new List<ChatRoomUser>();
                for(int i = 0 ; i < globalRoomSalesInfoList.length; ++i) {
                  if(globalRoomSalesInfoList[i].id == widget.roomSalesInfo.id){
                    globalRoomSalesInfoList[i].chatRoomUserList = new List<ChatRoomUser>();
                    break;
                  }
                }
              }


              ChatRoomUser roomUser;
              var lastData = await ApiProvider().get("/ChatRoomUser/Count");

              int id = null == lastData ? 1 : (lastData['id'] + 1);

              //현재 등록되어있는 최대값을 가져온다.
              roomUser = ChatRoomUser(
                id: id,
                roomSaleID: widget.roomSalesInfo.id,
                userID: widget.roomSalesInfo.userID,
                chatID: GlobalProfile.loggedInUser.userID,
                roomState: getValueByRoomState(ROOM_STATE.INQUIRE),
                updatedAt: getRoomTime(DateTime.now().toLocal()),
                createdAt: getRoomTime(DateTime.now().toLocal())
              );

              widget.roomSalesInfo.chatRoomUserList.add(roomUser);

              for(int i = 0 ; i < globalRoomSalesInfoList.length; ++i) {
                if(globalRoomSalesInfoList[i].id == widget.roomSalesInfo.id){
                  globalRoomSalesInfoList[i].chatRoomUserList.add(roomUser);
                  break;
                }
              }

              String date = DateFormat('HH').format(DateTime.now());
              int dateHour = int.parse(date);

              date = dateHour.toString() + ":" +
                  DateFormat('mm').format(DateTime.now());

              ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
                roomId: roomUser.id,
                to: widget.roomSalesInfo.userID,
                from: GlobalProfile.loggedInUser.userID,
                fromName: GlobalProfile.loggedInUser.name,
                message: RoomPriceController.text + "|" + data.Start + "|" +
                    data.End,
                messageType: getMessageType(MESSAGE_TYPE.INQUIRE),
                date: date,
                isRead: 0,
              );
              chatRecvMessageModel.isContinue = true;
              chatRecvMessageModel.roomSalesID = roomUser.roomSaleID;
              chatRecvMessageModel.isActive = 1;

              List<ChatRecvMessageModel> chatList = List<ChatRecvMessageModel>();
              chatList.add(chatRecvMessageModel);

              RoomInfo roomInfo = RoomInfo(
                  lastMessage: "문의를 보냈습니다.",
                  date: getRoomTime(DateTime.now().toLocal()),
                  chatList: chatList,
                  messageCount: 0,
                  roomState: ROOM_STATE.INQUIRE
              );
              ChatGlobal.roomInfoList[roomUser.id] = roomInfo;
              chatRoomUserList.add(roomUser);

              /*_socket
                ..socket.emit("joinRoom", [
                  chatRecvMessageModel.toJson(),
                ]);*/

              User1 user = GlobalProfile.getUserByUserIDLogin(widget.roomSalesInfo.userID);

              if(user == null){
                var selectUser =  await ApiProvider().post('/User/UserSelect', jsonEncode({
                  "userID" : widget.roomSalesInfo.userID,
                }));

                GlobalProfile.personalProfile.add(selectUser);
              }

              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                  new ChatPage(
                    chatUser: GlobalProfile.getUserByUserID(
                        widget.roomSalesInfo.userID),
                    chatRoomUser: roomUser,
                    roomSalesInfo: widget.roomSalesInfo,
                    isProposal: true,
                  )
              ));

              return;
            },
            child: Container(
                height: screenHeight * 0.09375,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '매물 문의하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.025,

                    ),
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }
}
