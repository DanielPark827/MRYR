import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';

class ChatReportScreen extends StatefulWidget {
  ChatRoomUser chatRoomUser;

  ChatReportScreen({Key key, this.chatRoomUser,}) : super(key : key);

  @override
  _ChatReportScreenState createState() => _ChatReportScreenState();
}

class _ChatReportScreenState extends State<ChatReportScreen> {
  final ReportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: hexToColor("#FFFFFF"),
          elevation: 0.0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(screenWidth*0.033333, 0, 0, 0),
            child: GestureDetector(
              onTap: (){
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.03125,),
              Text(
                '신고 이유',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: screenHeight*0.025,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: screenHeight*0.0125,
              ),
              TextField(
                controller: ReportController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,

                maxLines: 14,
                maxLength: 500,
                maxLengthEnforced: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: '신고 이유를 작성해주세요. (최대 500자)',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                  ),
                ),
                onChanged: (text){
                  setState(() {

                  });
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            Function okFunc = () async {
              int targetID = GlobalProfile.loggedInUser.userID == widget.chatRoomUser.chatID ? widget.chatRoomUser.userID : widget.chatRoomUser.chatID;

              var res = await ApiProvider().post('/ReportWrite/ChatroomReportInsert',jsonEncode({
                "fromID" : GlobalProfile.loggedInUser.userID,
                "toID" : targetID,
                "contents" : ReportController.text,
                "chatRoomID" : widget.chatRoomUser.id
              }));

              if(null != res) {
                Fluttertoast.showToast(msg: "채팅 신고가 완료되었습니다");
              }

              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            };

            Function cancelFunc = () {
              Navigator.pop(context);
            };

            OKCancelDialog(context, "신고하시겠습니까?", "불편하신 사항을 신고해주시면\n빠르게 수정하겠습니다.", "확인", "취소", okFunc, cancelFunc);
          },
          child: Container(
              height: screenHeight*0.09375,
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '신고하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenHeight*0.025,

                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}