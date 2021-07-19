import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/screens/Setting/CompanyInfo.dart';
import 'package:mryr/screens/Setting/PersonalInfoRule.dart';
import 'package:mryr/screens/Setting/UsingRule.dart';
import 'package:mryr/screens/Setting/UsingRuleBasedOnLocation.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mryr/constants/AppConfig.dart';

bool PushNotification = true;
bool SMSNotification = false;
bool MarketNotification = false;

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  PackageInfo packageInfo;

  void initState() {
    super.initState();
    setState(() {
      Future.microtask(() async {
        packageInfo = await PackageInfo.fromPlatform();
        setState(() {

        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {

  //  var screenHeight = MediaQuery.of(context).size.height;
  //  var screenWidth = MediaQuery.of(context).size.width;
    return  WillPopScope(
      onWillPop: (){
        setState(() {
          Future.microtask(() async {
            AllNotification = await getNotiByStatus();
          });
        });
        Navigator.pop(context);
        return;
      },
      child: SafeArea(
        child: Scaffold(

          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  height: screenHeight*(60/640),
                  child: Row(
                    children: [

                      SizedBox(width: screenWidth*(8/360),),
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              Future.microtask(() async {
                                AllNotification = await getNotiByStatus();
                              });
                            });
                            Navigator.pop(context);
                          }),

                      SizedBox(width: screenWidth*(8/360),),
                      Text('앱 설정',
                        style: TextStyle(
                          color: hexToColor("#222222"),
                          fontSize:screenWidth*( 16/360),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
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
                              fontSize:screenWidth*(16 /360),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: AllNotification,
                          onChanged: (bool value) {
                            setState(() {
                              AllNotification = !AllNotification;

                              openAppSettings();
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
                              fontSize:screenWidth*(16 /360),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: AllNotification,
                          onChanged: (bool value) {
                            setState(() {
                              AllNotification = !AllNotification;

                              openAppSettings();
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
                            'SMS 알림받기',
                            style: TextStyle(
                              fontSize:screenWidth*(16 /360),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: SMSNotification,
                          onChanged: (bool value) {
                            setState(() {
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
                            '마켓 알림받기',
                            style: TextStyle(
                              fontSize:screenWidth*(16 /360),
                              color: Color(0xffBEBEBE),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Transform.scale(
                        scale: 0.7,
                        child: CupertinoSwitch(
                          value: MarketNotification,
                          onChanged: (bool value) async {
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: hexToColor("#E5E5E5"),height: 0.5,),

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
                              fontSize:screenWidth*(16 /360),
                              color: Color(0xffBEBEBE),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        //padding: EdgeInsets.only(right: screenWidth*0.0333333),
                        child: Text(
                          'MRYR v' + packageInfo.version,
                          style: TextStyle(
                            fontSize:screenWidth*(16 /360),
                            color: Color(0xff888888),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth*(12/360),)
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.03125,),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  UsingRule()) // SecondRoute를 생성하여 적재
                      );
                    },
                    child: buildGotoNextPage('서비스 이용약관')),
                Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  PersonalInfoRule()) // SecondRoute를 생성하여 적재
                      );
                    },
                    child: buildGotoNextPage('개인정보처리방침')),
                Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                CompanyInfo()) // SecondRoute를 생성하여 적재
                    );
                  },
                    child: buildGotoNextPage('사업자정보')),
                Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  UsingRuleBasedOnLocation()) // SecondRoute를 생성하여 적재
                      );
                    },
                    child: buildGotoNextPage('위치기반 서비스 이용약관')),
                Divider(color: hexToColor("#E5E5E5"),height: 0.5,),
                GestureDetector(
                    onTap: (){
                    /*  Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  UsingRuleBasedOnLocation()) // SecondRoute를 생성하여 적재
                      );*/
                    },
                    child: buildGotoNextPage('매물관리규정')),
                SizedBox(height: screenHeight*0.03125,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Container buildGotoNextPage(String Title) {
  return Container(
    color: Colors.white,
    height: screenHeight * 0.075,
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.0333333),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              Title,
              style: TextStyle(
                fontSize: screenWidth * (16 / 360),
              ),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.044444),
          child: SvgPicture.asset(
            GreyNextIcon,
            width: screenWidth * 0.04444,
            height: screenWidth * 0.04444,
          ),
        ),
      ],
    ),
  );
}
