import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:permission_handler/permission_handler.dart';

class MainSetting extends StatefulWidget {
  @override
  _MainSettingState createState() => _MainSettingState();
}

class _MainSettingState extends State<MainSetting> {
  bool AllFlag = true;
  bool PushFlag = true;
  bool SMSFlag = true;

  String version = 'MRTR v0.4';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Future.microtask(() async {
        AllNotification = await getNotiByStatus();
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: hexToColor("#E5E5E5"),
        appBar: AppBar(
            brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            '앱 설정',
            style: TextStyle(
              fontSize: screenWidth*0.04444444,
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          )
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              height: screenHeight*0.075,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.0333333),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '전체 알림',
                        style: TextStyle(
                          fontSize: screenHeight*0.025,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: AllNotification,
                      onChanged: (bool value) async {

                        await openAppSettings();

                        setState(() {
                          AllNotification = !AllNotification;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
            Container(
              color: Colors.white,
              height: screenHeight*0.075,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.0333333),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '푸시 알림 받기',
                        style: TextStyle(
                          fontSize: screenHeight*0.025,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: PushFlag,
                      onChanged: (bool value) {
                        setState(() {
                          PushFlag = !PushFlag;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
            Container(
              color: Colors.white,
              height: screenHeight*0.075,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.0333333),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'SMS 알림 받기',
                        style: TextStyle(
                          fontSize: screenHeight*0.025,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: SMSFlag,
                      onChanged: (bool value) {
                        setState(() {
                          SMSFlag = !SMSFlag;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight*0.03125,),
            Container(
              color: Colors.white,
              height: screenHeight*0.075,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.0333333),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '앱 버전',
                        style: TextStyle(
                          fontSize: screenHeight*0.025,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Text(
                      version,
                    style: TextStyle(
                      fontSize: screenWidth*0.04444,
                      color: hexToColor('#888888'),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.03333,)
                ],
              ),
            ),
            Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
            buildGoNextPage(context, screenHeight,screenWidth,'ClientCenter','고객 센터'),
            SizedBox(height: screenHeight*0.03125,),
            buildGoNextPage(context,screenHeight,screenWidth,'/TermsOfUse','이용약관'),
            Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
            buildGoNextPage(context,screenHeight,screenWidth,'/PrivacyOfStatement','개인정보취급방침'),
          ],
        ),

      ),
    );
  }


}
