import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/NeedRoomSalesInfoListScreen.dart';
import 'package:mryr/screens/TutorialScreen.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/NoticeInMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/ProposeTerm.dart';

import 'NewRoom/StudentIdentification.dart';
import 'package:flutter/cupertino.dart';

class MainReleaseRoomScreen extends StatefulWidget {
  @override
  _MainReleaseRoomScreenState createState() => _MainReleaseRoomScreenState();
}

class _MainReleaseRoomScreenState extends State<MainReleaseRoomScreen> {
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DummyUser data2 = Provider.of<DummyUser>(context);
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);


    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Color(0xfff8f8f8),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Color(0xffffffff),
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                data.ResetEnterRoomInfoProvider();
                data2.ResetDummyUser();
                f= null;
                FlagForInitialDate = false;
                FlagForLastDate = false;
                setState(() {
                });
                Navigator.pop(context);
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: (){
            data.ResetEnterRoomInfoProvider();
            data2.ResetDummyUser();

            Navigator.pop(context);
            return;
          },
          child: SafeArea(
            child: Column(
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
                            "방 내놓기 안내",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight * (24 / 640),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (20 / 640),
                          ),
                          Notice(context, "1.등록한 매물은 ", "30일", " 동안 노출됩니다."),
                          Notice(context, "2.작성중인 내용은 자동으로 ", "임시저장", "됩니다."),
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
                          //내가 내놓은 방 정보 없으면
                          Function okFunc = () {
                            if(GlobalProfile.roomSalesInfo == null){


                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StudentIdentification()) // SecondRoute를 생성하여 적재
                              );
                            }else{
                              navigationNumProvider.setNum(7);
                              Navigator.pushReplacement(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainPage()) // SecondRoute를 생성하여 적재
                              );
                              setState(() {

                              });
                              // Navigator.push(
                              //     context, // 기본 파라미터, SecondRoute로 전달
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //           EnterRoomInfo(),
                              //     ) // SecondRoute를 생성하여 적재
                              // );
                            }
                          };

                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: CupertinoAlertDialog(
                                  title: Text('방 단기양도시 주의해주세요!'+"\n"),
                                  content: Text("살고있는 방을 양도할 때는\n 집주인/건물주의 동의가 반드시 필요합니다.\n 매물 양도를 위해서 집주인/건물주에게\n ‘사전동의’ 혹은 ‘전대동의서'를\n 받아주세요!\n 전대동의서는 ‘문의하기’를 통해 요청하시면\n 1일 이내에 보내드립니다"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('확인'),
                                     onPressed: okFunc,
                                      textStyle: TextStyle(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: screenWidth * (320 / 360),
                          height: screenHeight * (80 / 640),
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
                                "방 내놓기 등록",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * (16 / 640),
                                ),
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                ReviewIconInDashBoardScreen,
                                width: screenHeight * (80 / 640),
                                height: screenHeight * (80 / 640),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context, // 기본 파라미터, SecondRoute로 전달
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NeedRoomSalesInfoListScreen()) // SecondRoute를 생성하여 적재
                          );
                        },
                        child: Container(
                          width: screenWidth * (320 / 360),
                          height: screenHeight * (80 / 640),
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
                                "역제안 리스트 먼저보기",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * (16 / 640),
                                ),
                              ),
                              Spacer(),
                              SvgPicture.asset(
                                ReviewIconInDashBoardScreen,
                                width: screenHeight * (80 / 640),
                                height: screenHeight * (80 / 640),
                              ),
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
          ),
        ),
      ),
    );
  }
}
