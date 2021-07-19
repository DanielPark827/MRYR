import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:mryr/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/EnterRoomInfo.dart';
import 'package:mryr/screens/MoreScreen/AskScreen.dart';
import 'package:mryr/constants/GlobalAsset.dart';



class WarningBeforeTransfer extends StatefulWidget {
  @override
  _WarningBeforeTransferState createState() => _WarningBeforeTransferState();
}

class _WarningBeforeTransferState extends State<WarningBeforeTransfer> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                new BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(1.5, 1.5),
                ),
              ],
            ),
            width: screenWidth * (290/360),
            height: MediaQuery.of(context).size.height * (520/640),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                AskScreen()) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Image.asset(
                    dialogImageBeforeTransfer,
                    height: screenHeight*(400/640),
                    width: screenWidth*(300/360),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: screenWidth * (300/360),
                    height: screenHeight * (60/640),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(8.0))
                    ),

                    child: Center(
                      child: Text(
                          '닫기',
                          style: TextStyle(
                            fontSize: screenWidth*(18/360),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),
                ),
                heightPadding(screenHeight,92),
              ],
            ),
          );

        }));
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
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
      body: Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightPadding(screenHeight,38),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*(20/360)),
              child: Text(
                "방 양도하기 안내",
                style: TextStyle(
                  fontSize: screenWidth*(24/360),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            heightPadding(screenHeight,6),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*(20/360)),
              child: Text(
                "궁금한 점이 있으시면 문의 사항으로 보내주세요",
                style: TextStyle(
                  fontSize: screenWidth*(12/360),
                ),
              ),
            ),
            heightPadding(screenHeight,20),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*(20/360)),
              child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: "1.방을 양도 할 때는 ",style: defaultDescription(screenWidth)),
                      TextSpan(text: "집주인 / 건물주의 동의",style: boldDescription(screenWidth)),
                      TextSpan(text: "가 반드시\n필요합니다.",style: defaultDescription(screenWidth)),
                    ]
                ),
              ),
            ),
            heightPadding(screenHeight,20),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*(20/360)),
              child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: "2. 방 양도를 위해서 ",style: defaultDescription(screenWidth)),
                      TextSpan(text: "\‘사전동의\’",style: boldDescription(screenWidth)),
                      TextSpan(text: " 혹은 ",style: defaultDescription(screenWidth)),
                      TextSpan(text: "\‘전대동의서\’",style: boldDescription(screenWidth)),
                      TextSpan(text: "를\n받아 주세요!",style: defaultDescription(screenWidth)),
                    ]
                ),
              ),
            ),
            heightPadding(screenHeight,20),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*(20/360)),
              child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: "3. 전대동의서는 ‘문의하기'를 통해 요청하시면 ",style: defaultDescription(screenWidth)),
                      TextSpan(text: "1일 이내\n",style: boldDescription(screenWidth)),
                      TextSpan(text: "로 보내드립니다.",style: defaultDescription(screenWidth)),
                    ]
                ),
              ),
            ),
            heightPadding(screenHeight,20),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*(20/360)),
              child: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: "4.방은 ",style: defaultDescription(screenWidth)),
                      TextSpan(text: "5개",style: boldDescription(screenWidth)),
                      TextSpan(text: "까지 양도할 수 있고, 이 이상은 제한됩니다.\n",style: defaultDescription(screenWidth)),
                    ]
                ),
              ),
            ),
            heightPadding(screenHeight,120),
            Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                        builder: (context) =>
                            EnterRoomInfo(),
                      ) // SecondRoute를 생성하여 적재
                  );
                },
                child: Container(
                  width: screenWidth*(292/360),
                  height: screenHeight*(48/640),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: kPrimaryColor
                  ),
                  child: Center(
                    child: Text(
                      "시작하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            heightPadding(screenHeight,12),
            Align(
              alignment: Alignment.topCenter,
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
                  );
                },
                child: Text(
                  "처음으로 돌아가기",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: hexToColor('#888888')
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle boldDescription(double screenWidth) {
    return TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                );
  }

  TextStyle defaultDescription(double screenWidth) {
    return TextStyle(
                  fontSize: screenWidth*(14/360),
                );
  }
}
