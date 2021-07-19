import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/constants/AppConfig.dart';

class UserOut extends StatefulWidget {
  @override
  _UserOutState createState() => _UserOutState();
}

class _UserOutState extends State<UserOut> {
  final c = TextEditingController();

  bool FlagForComplete = false;
  bool depositCheckBox = false;

  final RedTriangle = 'assets/images/public/RedTriangle.svg';

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight*0.0625,),
            Padding(
              padding: EdgeInsets.only(left:screenWidth*0.0333333),
              child: Text(
                '회원탈퇴',
                style: TextStyle(
                  fontSize: screenWidth*0.0666666666666667,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.0125,),
            Padding(
              padding: EdgeInsets.only(left:screenWidth*0.0333333),
              child: Text(
                '회원탈퇴를 하시려면 아래 문구를 따라 입력해주세요',
                style: TextStyle(
                  fontSize: screenWidth*0.0333333,
                  color: hexToColor('#888888'),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.090625,),
            Align(
              alignment: Alignment.center,
              child: Container(
                  width: screenWidth * (190 / 360),
                  height: screenHeight * (36 / 640),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: c,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * (20 / 360),
                      color: Color(0xff222222),
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                      errorBorder: InputBorder.none,
                      hintText: '내방니방을 탈퇴합니다',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * (20 / 360),
                        color: hexToColor("#cccccc"),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (text){
                      CheckUserOut();

                    },
                  )),
            ),
            SizedBox(height: screenHeight*0.0125,),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 1,
                width: screenWidth*0.933333,
                decoration: BoxDecoration(
                  color: hexToColor('#CCCCCC'),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Row(
              children: [
                SizedBox(width: screenWidth*0.061111,),
                Text(
                  '회원을 탈퇴하는 것에 대하여 동의합니다',
                  style: TextStyle(
                    color: hexToColor('#888888'),
                  ),
                ),
                Expanded(child: SizedBox()),
                Container(
                  width: screenWidth * (20 / 360),
                  child: Checkbox(
                    checkColor: Colors.white,
                    activeColor: kPrimaryColor,
                    value: depositCheckBox,
                    onChanged: (bool value) {
                      setState(() {
                        depositCheckBox = value;
                      });
                      CheckUserOut();
                    },
                  ),
                ),
                SizedBox(width:screenWidth*0.07222222),
              ],
            )
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            if(FlagForComplete) {
              Function okFunc = () async {
                var list = await ApiProvider().post("/User/Delete", jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.id
                    }
                ));
              };
              Function cancelFunc = () {
                Navigator.pop(context);
              };
              OKCancelDialog(context,'회원탈퇴를 계속하시겠습니까?','지금까지 내방니방 어플 내에\n저장되어 있던 모든 정보가 삭제됩니다',"확인","취소", okFunc,cancelFunc);
            }
          },
          child: GestureDetector(
            onTap: () async{
              var res = await ApiProvider().post('/User/Delete',jsonEncode({
                "userID" : GlobalProfile.loggedInUser.userID,
              }));
              Navigator.pushNamedAndRemoveUntil(context, "/LoginScreen", (r) => false);
            },
            child: Container(
              width: screenWidth,
              height: screenHeight * (60 / 640),
              color: FlagForComplete ? kPrimaryColor : hexToColor('#CCCCCC'),
              //((one==true||two==true||op==true||apt==true))?kPrimaryColor:Color(0xffcccccc),
              child: Center(
                child: Text(
                  "회원탈퇴",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * (16 / 640)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void CheckUserOut() {
    if(c.text == "내방니방을 탈퇴합니다" && depositCheckBox) {
      setState(() {
        FlagForComplete = true;
      });
    } else {FlagForComplete = false;}
  }
}