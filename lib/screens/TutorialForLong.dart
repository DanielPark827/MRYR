import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/widget/TutorialScreen/AppTutorialScreen/StringForAppTutorialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BorrowRoom/GoogleMap/SearchMapForReleaseRoom.dart';

class TutorialForLong extends StatefulWidget {
  @override
  _TutorialForLongState createState() => _TutorialForLongState();
}

class _TutorialForLongState extends State<TutorialForLong> {
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
      'image': long1InAppTutorialScreen
    },
    {
      "image": long2InAppTutorialScreen
    },
    {
      "image": long3InAppTutorialScreen
    },
    {
      "image": short4InAppTutorialScreen
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
      backgroundColor: Color(0xff0000),

      body: WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return;
        },
        child: Container(
          color: Colors.white,
          //color: Color(0xff222222),
          height:  screenHeight,
          width: screenWidth,
          child: Stack(
            children: [
              Container(width: screenWidth,height: screenHeight,color: Color(0xff222222),),
              Column(
                children: [
                  Container(height:screenHeight*(58/640)),
                  Container(
                    width: screenWidth*(360/360),
                    height:screenHeight*(582/640) ,
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
                            fit:BoxFit.fitWidth,
                          ),
                    ),
                  ),
                ],
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
                             final SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setBool(forLong,true);
                            Navigator.pop(context);
                            Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchMapForBorrowRoom(flagForShort: false,)) // SecondRoute를 생성하여 적재
                            );
                          }, child:Container(width: screenWidth*(292/360),height: screenWidth*(48/360),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                              border: Border.all(width: 2, color: Color(0xffffffff)),
                            ),
                            child: Center(child: Text("방 보러가기",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold,color: Colors.white),)),
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
