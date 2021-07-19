import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/MyPage.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class Certiciation_ModifyPhoneNum extends StatelessWidget {
  static const String userCode = 'imp27809320';

  @override
  Widget build(BuildContext context) {
    CertificationData data = ModalRoute.of(context).settings.arguments;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: IamportCertification(

        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        initialChild: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/iamport-logo.png'),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
        userCode: userCode,
        data: data,
        callback: (Map<String, String> result) async {
          if(result['success'] == 'true'){

            var res = await ApiProvider().post('/Informatiofn/changeNumber', jsonEncode(
                {
                  "userID" : GlobalProfile.loggedInUser.userID,
                  "phone" : globalPhoneNumber
                }
            ));
            GlobalProfile.loggedInUser.phone = globalPhoneNumber;

            Fluttertoast.showToast(msg: "휴대폰 번호를 변경하였습니다.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Color.fromRGBO(0, 0, 0, 0.51), textColor: hexToColor('#FFFFFF') );
            Navigator.pop(context);
          }else{
            Fluttertoast.showToast(msg: "핸드폰 인증에 실패하셨습니다. 다시 시도 해 주세요.", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: Color.fromRGBO(0, 0, 0, 0.51), textColor: hexToColor('#FFFFFF') );
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}