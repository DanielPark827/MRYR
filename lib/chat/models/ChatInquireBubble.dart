import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:provider/provider.dart';
import '../models/ChatRecvMessageModel.dart';


class ChatInquireBubble extends StatefulWidget {
  final bool isMe;
  final bool isContinue;
  final ChatRecvMessageModel message;

  ChatInquireBubble({@required this.isMe, @required this.isContinue, @required this.message});

  @override
  _ChatInquireBubbleState createState() => _ChatInquireBubbleState();
}

class _ChatInquireBubbleState extends State<ChatInquireBubble> {
  final String inquireActiveLogo = "assets/images/Chat/InquireActiveLogo.svg";
  final String inquireUnActiveLogo = "assets/images/Chat/InquireUnActiveLogo.svg";

  final Color activeColor = hexToColor('#6F22D2');
  final Color unActiveColor = hexToColor('#EEEEEE');

  final Color activeTextColor = hexToColor('#6F22D2');
  final Color unActiveTextColor = hexToColor('#FFFFFF');
  
  final Color activeButtonColor = hexToColor('#FFFFFF');
  final Color unActiveButtonColor = hexToColor('#EEEEEE');

  String logo;
  Color boxColor;
  Color textColor;
  Color buttonColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

 // SocketProvider socket;

  bool localIsMe;

  Widget inquireOkWidget(context){
    return Column(
      children: [
        Container(
          width: screenWidth * (240/360),
          height: screenHeight * (40/640),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
          decoration: BoxDecoration(
            border: Border.all(color: boxColor),
            color:  boxColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0),),
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minHeight: 30),
          child: SvgPicture.asset(
              logo
          ),
        ),
        Container(
            width: screenWidth * (240/360),
            height: screenHeight * (90/640),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
            decoration: BoxDecoration(
              border: Border.all(color:  Color(0xffEEEEEE)),
              color:  Color(0xffFFFFFF),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4),),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
                minHeight: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * (8/640),),
                Text("거래확정 완료!", style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (16/360), fontWeight: FontWeight.bold),),
                SizedBox(height: screenHeight * (4/640),),
                Text("매물거래가 확정되었습니다!\n상대방과 임대차계약서를 작성해주세요",
                  style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (12/360), fontWeight: FontWeight.normal),),
                /*SizedBox(height: screenHeight * (28/640),),
                Container(
                  width: screenWidth * (224/360),
                  height: screenHeight * (32/640),
                  padding: EdgeInsets.only(left: 8.0,right: 8.0),
                  color: buttonColor,
                  child: FlatButton(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: boxColor),
                    ),
                    color: buttonColor,
                    child: Text(
                      "계약서 작성하러가기",
                      style: TextStyle(color: textColor, fontSize: screenWidth * (12/360), fontWeight: FontWeight.bold),
                    ),
                  ),
                )*/
              ],
            )
        ),
        //!widget.isMe ? _bubbleEndWidget() : Container(), //작성자에 따른 시간 표시
      ],
    );
  }

  Widget inquireCancelWidget(context){
    return Column(
      children: [
        Container(
          width: screenWidth * (240/360),
          height: screenHeight * (40/640),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
          decoration: BoxDecoration(
            border: Border.all(color:  boxColor),
            color:  boxColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0),),
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minHeight: 30),
          child: SvgPicture.asset(
              logo
          ),
        ),
        Container(
            width: screenWidth * (240/360),
            height: screenHeight * (142/640),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
            decoration: BoxDecoration(
              border: Border.all(color:  Color(0xffEEEEEE)),
              color:  Color(0xffFFFFFF),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4),),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
                minHeight: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * (8/640),),
                Text("거래확정 취소", style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (16/360), fontWeight: FontWeight.bold),),
                SizedBox(height: screenHeight * (4/640),),
                Text( widget.isMe ? "매물거래가 취소되었습니다.\n새로운 거래완료 요청을 진행해주세요." : "상대방이 매물거래를 취소하였습니다.\n 새로운 거래완료 요청을 진행해주세요.",
                  style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (12/360), fontWeight: FontWeight.normal),),
                SizedBox(height: screenHeight * (28/640),),
                Container(
                  width: screenWidth * (224/360),
                  height: screenHeight * (32/640),
                  padding: EdgeInsets.only(left: 8.0,right: 8.0),
                  child: FlatButton(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: boxColor),
                    ),
                    onPressed: () {
                      if(widget.message.isActive == 0) return;
                      //매물상세페이지 보기

                      RoomSalesInfo roomSalesInfo = null;

                      for(int i = 0 ; i < globalRoomSalesInfoList.length; ++i){
                        for(int j = 0 ; j < globalRoomSalesInfoList[i].chatRoomUserList.length; ++j){
                          if(globalRoomSalesInfoList[i].chatRoomUserList[j].id == widget.message.roomId){
                            roomSalesInfo = globalRoomSalesInfoList[i];
                            break;
                          }
                        }
                      }

                      if(null == roomSalesInfo) return;

                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailedRoomInformation(
                                    isParentChat: true,
                                    roomSalesInfo: roomSalesInfo,
                                  )) // SecondRoute를 생성하여 적재
                      );
                    },
                    color: buttonColor,
                    child: Text(
                      "매물 상세페이지 보기",
                      style: TextStyle(color: textColor, fontSize: screenWidth * (12/360), fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            )
        ),
        //!widget.isMe ? _bubbleEndWidget() : Container(), //작성자에 따른 시간 표시
      ],
    );
  }

  Widget inquireWidget(context, strList){
    ChatGlobal global = Provider.of<ChatGlobal>(context);

    return Column(
      children: [
        Container(
          width: screenWidth * (240/360),
          height: screenHeight * (40/640),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
          decoration: BoxDecoration(
            border: Border.all(color: boxColor),
            color: boxColor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0),),
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minHeight: 30),
          child: SvgPicture.asset(
              logo
          ),
        ),
        Container(
            width: screenWidth * (240/360),
            height: screenHeight * (154/640),
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
            decoration: BoxDecoration(
              border: Border.all(color:  Color(0xffEEEEEE)),
              color:  Color(0xffFFFFFF),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(4),),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
                minHeight: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*SvgPicture.asset(
                tempImageName,
                width: screenWidth * (240 / 360),
                height: screenHeight * (100 / 640),
              ),*/
                SizedBox(height: screenHeight * (8/640),),
                Text(strList[0] + "만 / 월", style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (16/360), fontWeight: FontWeight.bold),),
                SizedBox(height: screenHeight * (4/640),),
                Text(strList[1] + " ~ " + strList[2], style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (16/360), fontWeight: FontWeight.bold),),
                SizedBox(height: screenHeight * (12/640),),
                Text("해당 매물 문의합니다.", style: TextStyle(color: hexToColor('#222222'), fontSize: screenWidth * (12/360), fontWeight: FontWeight.normal),),
                SizedBox(height: screenHeight * (28/640),),
                Container(
                  width: screenWidth,
                  height: screenHeight * (32/640),
                  padding: EdgeInsets.only(left: 8.0,right: 8.0),
                  child: FlatButton(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(color: boxColor),
                    ),
                    color: buttonColor,
                    child: Text(
                      localIsMe == false ? "보낸 확정 취소하기" : "거래 확정하기",
                      style: TextStyle(color: textColor, fontSize: screenWidth * (12/360), fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if(widget.message.isActive == 0) return;

                      Function okFunc;
                      String title = localIsMe == false ?  "거래 확정을 취소하시겠습니까?" :  "거래를 확정하시겠습니까?";
                      String description = localIsMe == false ? "거래 확정을 취소하면\n임대료와 기간을 다시 조정할 수 있습니다." : "매물에 대한 정확한 정보를\n확인한 후 거래를 확정해주세요.";
                      if(localIsMe == false){
                        okFunc = () {

                          String date = DateFormat('HH').format(DateTime.now());
                          int dateHour = int.parse(date);

                          date = dateHour.toString() + ":" + DateFormat('mm').format(DateTime.now());

                          ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
                            roomId: widget.message.roomId,
                            to: widget.message.to,
                            from: widget.message.from,
                            fromName : widget.message.fromName,
                            message: " ",
                            messageType: getMessageType(MESSAGE_TYPE.INQUIRE_CANCEL),
                            date: date,
                            isRead: 0,
                            updatedAt: DateTime.now().toLocal().toString(),
                            createdAt: DateTime.now().toLocal().toString(),
                          );
                          chatRecvMessageModel.isContinue = true;
                          chatRecvMessageModel.isRead = 1;

                          setState(() {
                            global.setRoomState(widget.message.roomId, ROOM_STATE.INQUIRE);
                            global.addRoomInfoChat(widget.message.roomId, chatRecvMessageModel);
                          });


                        //  socket..socket.emit("roomChatMessage", [chatRecvMessageModel.toJson()]);

                          Navigator.pop(context);
                        };
                      }else{
                       okFunc = () {
                          String date = DateFormat('HH').format(DateTime.now());
                          int dateHour = int.parse(date);

                          date = dateHour.toString() + ":" + DateFormat('mm').format(DateTime.now());

                          ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
                            roomId: widget.message.roomId,
                            to: widget.message.from,
                            from: widget.message.to,
                            fromName : GlobalProfile.loggedInUser.nickName,
                            message: " ",
                            messageType: getMessageType(MESSAGE_TYPE.INQUIRE_OK),
                            date: date,
                            isRead: 0,
                            updatedAt: DateTime.now().toLocal().toString(),
                            createdAt: DateTime.now().toLocal().toString(),
                          );
                          chatRecvMessageModel.isContinue = true;
                          chatRecvMessageModel.isRead = 1;

                          setState(() {
                            global.setRoomState(widget.message.roomId, ROOM_STATE.DONE);
                            global.addRoomInfoChat(widget.message.roomId, chatRecvMessageModel);
                          });

                         // socket..socket.emit("roomChatMessage", [chatRecvMessageModel.toJson()]);

                          Navigator.pop(context);
                        };
                      }


                      Function cancelFunc = () {
                        Navigator.pop(context);
                      };

                      OKCancelDialog(context, title, description ,"확인", "취소", okFunc, cancelFunc);
                    },
                  ),
                )
              ],
            )
        ),

      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    List<String> strList = widget.message.message.split('|');

   // if(null == socket) socket = Provider.of<SocketProvider>(context);

    localIsMe = GlobalProfile.loggedInUser.userID == widget.message.to;

    logo = (widget.message.isActive == 1) ? inquireActiveLogo : inquireUnActiveLogo;
    boxColor = (widget.message.isActive == 1) ? activeColor : unActiveColor;
    textColor = (widget.message.isActive == 1) ? activeTextColor : unActiveTextColor;
    buttonColor = (widget.message.isActive == 1) ? activeButtonColor : unActiveButtonColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        widget.isMe ? _bubbleEndWidget() : Container(),  //작성자에 따른 시간 표시
        isMessageType(widget.message.messageType, MESSAGE_TYPE.INQUIRE) || isMessageType(widget.message.messageType, MESSAGE_TYPE.INQUIRE_REQUEST)
            ? inquireWidget(context, strList)
            : isMessageType(widget.message.messageType, MESSAGE_TYPE.INQUIRE_OK)
            ? inquireOkWidget(context)
            : inquireCancelWidget(context),
        !widget.isMe ? _bubbleEndWidget() : Container(), //작성자에 따른 시간 표시
      ],
    );
  }

  Widget _bubbleEndWidget() {
    return Column(
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        /*Text(
          message.unread ? '1' : '',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 10,
          ),
        ),*/
        widget.message.isContinue ? Text(
          setDateAmPm(widget.message.date, false),
          style: TextStyle(
            color:  Color(0xff888888),
            fontSize: screenHeight * 0.0125,
          ),
        ) : Container(),
      ],
    );
  }
}


