import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/Setting/tutorial/TutorialMainScreenInSetting.dart';
import 'package:mryr/utils/DefaultButton.dart';
import 'package:mryr/widget/TutorialScreen/AppTutorialScreen/StringForAppTutorialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialScreenInSetting extends StatefulWidget {
  @override
  _TutorialScreenInSettingState createState() => _TutorialScreenInSettingState();
}

class _TutorialScreenInSettingState extends State<TutorialScreenInSetting> {
  int currentPage = 0;
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(
        [
          SystemUiOverlay.bottom, //This line is used for showing the bottom bar
        ]
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
  List<Map<String, String>> splashData = [
    {
      "image": firstInAppTutorialScreen
    },
    {
      "image": secondInAppTutorialScreen
    },
    {
      "image": thirdInAppTutorialScreen
    },
    {
      "image": fourthInAppTutorialScreen
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

    return Scaffold(
      backgroundColor: Colors.black,

      body: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return;
        },
        child: Container(
          height:  MediaQuery
              .of(context)
              .size
              .height,
          width: screenWidth,
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) =>
                      Image.asset(
                        splashData[index]["image"],
                        fit: BoxFit.fitWidth,
                      ),
                ),
              ),
              Positioned(
                bottom: screenHeight*(65/640),
                child: Container(
                  width: screenWidth,
                  child: Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 400),
                      opacity: currentPage==3?1:0,
                      child:currentPage == 3 ?
                      Center(
                        child: Container(
                          width: screenWidth*(292/360),
                          child: FlatButton(onPressed: () async {
                            Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TutorialMainScreenInSetting()) // SecondRoute를 생성하여 적재
                            );
                          }, child:Container(width: screenWidth*(292/360),height: screenWidth*(48/360),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              border: Border.all(width: 2, color: Color(0xffffffff)),
                            ),
                            child: Center(child: Text("시작하기",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold,color: Colors.white),)),
                          )),
                        ),
                      )

                          : Container(
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight*(50/640),
                child: Container(
                  width: screenWidth,
                  child: Center(
                    child: Row(
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
                  ),
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
        color: currentPage == index ? Color(0xffFAD143) : Color(0xFFf2f2f2),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
