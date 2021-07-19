import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/NeedRoomSalesInfoListScreen.dart';
import 'package:mryr/screens/ReleaseRoom/MainReleaseRoomScreen.dart';
import 'package:mryr/screens/ReleaseRoom/ReleaseRoomTutorialScreen.dart';
import 'package:mryr/screens/Setting/tutorial/TutorialShortInSetting.dart';
import 'package:mryr/screens/TutorialScreen.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/NoticeInMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TutorialLongInSetting.dart';
import 'TutorialReviewInSetting.dart';

class TutorialMainScreenInSetting extends StatelessWidget {
  Future<bool> init() async {

    if(null != GlobalProfile.roomSalesInfo) {
      return true;
    } else {
      print('no');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
             /* Navigator.push(
                  context, // 기본 파라미터, SecondRoute로 전달
                  MaterialPageRoute(
                      builder: (context) =>
                          TutorialScreenInLookForRooms()) // SecondRoute를 생성하여 적재
              );*/
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
          Container(
            width: screenWidth,
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * (20 / 360),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * (40 / 640),
                    ),
                    Text(
                      "앱 사용 가이드",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (24 / 640),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (20 / 640),
                    ),

                    Notice(context, "1.", "내방니방", "만의 새로운 기능을 알려드립니다."),
                    Notice(context, "2.", "내방니방", "의 다양한 기능들로 편리하게 직거래를 해보세요."),
                    Notice(context, "3.문의사항이 있으시면 ", "고객센터", "로 연락주세요."),
                    SizedBox(
                      height: screenHeight * (40 / 640),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth,
              ),
              SizedBox(
                height: screenHeight * (20 / 640),
              ),
              InkWell(
                  onTap: () async {
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                          builder: (context) =>
                              TutorialShortInSetting(),
                        ) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Container(
                    width: screenWidth * (320 / 360),
                    height: screenWidth * (60 / 360),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "잠깐 살 방 찾기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * (16 / 640),
                          ),
                        ),

                      ],
                    ),
                  )),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              InkWell(
                  onTap: () async {
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                          builder: (context) =>
                              TutorialLongInSetting(),
                        ) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Container(
                    width: screenWidth * (320 / 360),
                    height: screenWidth * (60 / 360),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "양도하기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * (16 / 640),
                          ),
                        ),

                      ],
                    ),
                  )),
              SizedBox(
                height: screenHeight * (10 / 640),
              ),
              InkWell(
                  onTap: () async {
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                          builder: (context) =>
                              TutorialReviewInSetting(),
                        ) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Container(
                    width: screenWidth * (320 / 360),
                    height: screenWidth * (60 / 360),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "솔직한 자취방 후기",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * (16 / 640),
                          ),
                        ),
                        /*    Spacer(),
                        SvgPicture.asset(
                          ReviewIconInDashBoardScreen,
                          width: screenHeight * (80 / 640),
                          height: screenHeight * (80 / 640),
                        ),*/
                      ],
                    ),
                  )),
              SizedBox(
                height: screenHeight * (10 / 640),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) =>
                              MainPage()) // SecondRoute를 생성하여 적재
                  );
                },
                child: Container(
                  height: screenHeight * (36 / 640),
                  width: screenWidth * (120 / 360),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "처음으로 돌아가기",
                          style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            // color: Colors.white
                          ),
                        ),
                        Container(
                          width: screenWidth * (95 / 360),
                          height: 1,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * (65 / 640),
              ),
              Text(
                "매물관리 규정 | 고객센터 070-1234-1234",
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: screenHeight * (10 / 640),
                ),
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Text(
                "© Copyright 2020, 내방니방(MRYR)",
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: screenHeight * (10 / 640),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
