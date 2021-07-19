import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import '../models/ChatRecvMessageModel.dart';

class RowChatBubble extends StatelessWidget {
  final bool isMe;
  final bool isContinue;
  final ChatRecvMessageModel message;

  RowChatBubble({@required this.isMe, @required this.isContinue, @required this.message});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    Color boxColor = isMe ? Color(0xffEEEEEE) :  Color(0xffFFFFFF);
    TextStyle textStyle = TextStyle(
      fontSize: screenHeight * 0.01875,
      //color: fromMe ? Colors.white : Colors.black54,
      color:  Color(0xff222222),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        isMe ? _bubbleEndWidget() : Container(),  //작성자에 따른 시간 표시
        Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
          decoration: BoxDecoration(
            border: Border.all(color:  Color(0xffEEEEEE)),
            color:  boxColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minHeight: 30),
          child: Text(
            message.message,
            style: textStyle,
          ),
        ),
        !isMe ? _bubbleEndWidget() : Container(), //작성자에 따른 시간 표시
      ],
    );
  }

  Widget _bubbleEndWidget() {
    return Column(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        /*Text(
          message.unread ? '1' : '',
          style: TextStyle(
            color: Colors.amber,
            fontSize: 10,
          ),
        ),*/
        message.isContinue ? Text(
          setDateAmPm(message.date, false),
          style: TextStyle(
            color:  Color(0xff888888),
            fontSize: screenHeight * 0.0125,
          ),
        ) : Container(),
      ],
    );
  }
}
