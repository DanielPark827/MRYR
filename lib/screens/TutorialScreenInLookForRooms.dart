import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/utils/DefaultButton.dart';
import 'package:mryr/utils/StatusBar.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/TutorialScreen/LookForRoomsTutorialScreen/StringForLookForRoomsTutorialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialScreenInLookForRooms extends StatefulWidget {
  @override
  _TutorialScreenInLookForRoomsState createState() =>
      _TutorialScreenInLookForRoomsState();
}

class _TutorialScreenInLookForRoomsState extends State<TutorialScreenInLookForRooms> {
  int currentPage = 0;

  List<Map<String, String>> splashData = [
    {
      "text1": "내가 살고 싶은 방 찾기",
      "text2": "내가 살 방 직접 찾지 마세요!\n제안 받아보세요!",
      'image': LookForRoomsTutorialScreen1
    },
    {
      "text1": "내가 원하는 조건 제시하기",
      "text2": "내가 살고 싶은 방의 조건을\n방을 가진 사람들에게 먼저 알려주세요!",
      "image": LookForRoomsTutorialScreen3
    },
    {
      "text1": "조건에 맞는 방 제안받기",
      "text2": "방을 가진 사람들로부터\n나에게 맞는 방을 제안 받아보세요!",
      "image": LookForRoomsTutorialScreen2
    },
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    StatusBar(Colors.white);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: currentPage == 0? Icon(Icons.arrow_back_ios, color: Colors.black): Icon(Icons.arrow_back_ios, color: Colors.transparent),
              onPressed: () {
                if(currentPage == 0)
                  Navigator.of(context).pop();
              }
          ),
        ),
        body: WillPopScope(
          onWillPop: (){
            if(currentPage == 0)
              Navigator.of(context).pop();
            return;
          },
          child: Column(
            children: [
              Container(
                height:  MediaQuery
                    .of(context)
                    .size
                    .height *(548/640)-60,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      height:currentPage == 1 ?MediaQuery
                          .of(context)
                          .size
                          .height *(466/640) : MediaQuery
                          .of(context)
                          .size
                          .height *(406/640),
                      child: PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: splashData.length,
                        itemBuilder: (context, index) =>
                            Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * (6 / 640),
                                  ),
                                  SvgPicture.asset(
                                    splashData[index]["image"],
                                    width: screenHeight * (300 / 640),
                                    height: screenHeight * (240 / 640),
                                  ),
                                  SizedBox(
                                    height: screenHeight * (24 / 640),
                                  ),
                                  Container(
                                    height: screenHeight*(38/640),
                                    child: Text(
                                      splashData[index]["text1"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth*( 28/360),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * (16 / 640),
                                  ),
                                  Container(
                                    // width: screenWidth*(261/360),
                                    //height: screenHeight*(44/640),
                                    child: Text(
                                      splashData[index]["text2"],

                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:screenWidth*(16 /360),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                      ),
                    ),
                    AnimatedOpacity(
                      duration: Duration(milliseconds: 400),
                      opacity: currentPage==2?1:0,
                      child:currentPage == 2 ?
                      GestureDetector(

                        onTap: ()async{

                          SharedPreferences _prefs = await SharedPreferences.getInstance();
                          _prefs.setBool(ReleaseRoom_Splash,true);
                          Navigator.pop(context);
                          Navigator.push(
                              context, // 기본 파라미터, SecondRoute로 전달
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LookForRoomsScreen()) // SecondRoute를 생성하여 적재
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width*(320/360),
                          height: MediaQuery.of(context).size.height*(40/640),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.0),
                            border: Border.all(color: kPrimaryColor),
                            color: kPrimaryColor,
                          ),

                          child: Center(
                            child: Text(
                              "나중에 살 방 제안 받으러가기",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height*(16/640),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      )
                          : Container(
                      ),
                    ),

                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  splashData.length,
                      (index) =>
                      buildDot(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          index: index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({var screenHeight, var screenWidth, int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: screenHeight * (4 / 640)),
      height: screenHeight * (8 / 640),
      width: currentPage == index
          ? screenHeight * (24 / 640)
          : screenHeight * (8 / 640),
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFf2f2f2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
