import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/chat/models/ChatInquireBubble.dart';
import 'package:mryr/chat/models/ImageChatBubble.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:page_transition/page_transition.dart';
import '../models/ChatRecvMessageModel.dart';
import '../models/ChatGlobal.dart';
import '../models/RowChatBubble.dart';

class ChatItem extends StatelessWidget {
  final ChatRecvMessageModel message;
  final bool isContinue;
  final String chatIconName;


  const ChatItem({Key key, @required this.message, @required this.isContinue, @required this.chatIconName}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    bool isMe;
    User1 chatUser;
    MainAxisAlignment mainAxisAlignment;

    if(this.message.from == CENTER_MESSAGE){
      isMe = true;
      chatUser = GlobalProfile.loggedInUser;
      mainAxisAlignment = MainAxisAlignment.center;
    }else{
      isMe = this.message.from == GlobalProfile.loggedInUser.userID;
      chatUser = isMe ? GlobalProfile.loggedInUser : GlobalProfile.getUserByUserID(this.message.from);
      mainAxisAlignment = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    }

    if(message.isContinue == null) message.isContinue = true;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        isMe
            ? Container()
            : isContinue
            ? Container(padding: EdgeInsets.symmetric(horizontal: screenWidth * (0.0625 - 0.005)),)
            : chatIconName == "BasicImage" ?
              Container(
                width: screenHeight * 0.0625,
                height: screenHeight * 0.0625,
                child: SvgPicture.asset(PersonalProfileImage),
              )
              :
              Container(
                width: screenHeight * 0.0625,
                height: screenHeight * 0.0625,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: ExtendedImage.network(chatIconName),
                ),
              ),
        (false == isContinue) && (false == isMe)
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,       //default는 center
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget> [
            Container(
              margin: EdgeInsets.fromLTRB(screenWidth * 0.0222222222222222, 0, 0, 0),
              child: Text(
                  chatUser.nickName, style: TextStyle(fontSize: screenHeight * 0.0125, color: Color(0xff888888))
              ),
            ),
            SizedBox(height: screenHeight * 0.00625,),
            isMessageType(this.message.messageType, MESSAGE_TYPE.MESSAGE)
            ? RowChatBubble(
              isMe: isMe,
              isContinue: isContinue,
              message: this.message,
            )
            : isMessageType(this.message.messageType, MESSAGE_TYPE.IMAGE)
            ? ImageChatBubble(
              isMe: isMe,
              isContinue: isContinue,
              message: this.message,
            )
            : ChatInquireBubble(
              isMe: isMe,
              isContinue: isContinue,
              message: this.message,
            ),
          ],
        )
        : isMessageType(this.message.messageType, MESSAGE_TYPE.MESSAGE)
          ? RowChatBubble(
            isMe: isMe,
            isContinue: isContinue,
            message: this.message,
          )
          : isMessageType(this.message.messageType, MESSAGE_TYPE.IMAGE)
          ? ImageChatBubble(
          isMe: isMe,
          isContinue: isContinue,
          message: this.message,
        )
            : ChatInquireBubble(
          isMe: isMe,
          isContinue: isContinue,
          message: this.message,
        ),
      ],
    );
  }
}
