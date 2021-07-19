import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import '../models/ChatRecvMessageModel.dart';

class ImageChatBubble extends StatelessWidget {
  final bool isMe;
  final bool isContinue;
  final ChatRecvMessageModel message;

  ImageChatBubble({@required this.isMe, @required this.isContinue, @required this.message});

  @override
  Widget build(BuildContext context) {
    Color boxColor = isMe ? hexToColor('#EEEEEE') : hexToColor('#FFFFFF');
    TextStyle textStyle = TextStyle(
      fontSize: screenHeight * 0.01875,
      //color: fromMe ? Colors.white : Colors.black54,
      color: hexToColor('#222222'),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        isMe ? _bubbleEndWidget() : Container(),  //작성자에 따른 시간 표시
        Container(
          padding: const EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.0222222222222222),
          width: screenWidth * (120/360),
          height: screenHeight * (120/640),
          decoration: BoxDecoration(
              color: hexToColor("#EEEEEE"),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                  image: FileImage(File(message.fileMessage)),
                  fit: BoxFit.cover
              )
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
        message.isContinue ? Text(
          setDateAmPm(message.date, false),
          style: TextStyle(
            color: hexToColor('#888888'),
            fontSize: screenHeight * 0.0125,
          ),
        ) : Container(),
      ],
    );
  }
}
