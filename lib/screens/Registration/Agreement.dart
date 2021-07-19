import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/screens/Registration/BeforeCertification.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/screens/Registration/Agreement.dart';


class Agreement extends StatefulWidget {
  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  bool checkBoxValue1 = false;

  bool checkBoxValue2 = false;

  bool checkBoxValue3 = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        DialogForExitRegistration(context, screenHeight, screenWidth);
        return;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  DialogForExitRegistration(context, screenHeight, screenWidth);
                }),
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                // height: screenHeight,
                width: screenWidth,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * (12 / 360),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * (40 / 640),
                        ),
                        Text(
                          "약관동의",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * (24 / 640),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * (8 / 640),
                        ),
                        Text(
                          "서비스 사용을 위한 약관에 동의해주세요",
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: screenHeight * (12 / 640),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * (29 / 640),
                        ),
                        Container(
                          width: screenWidth * (336 / 360),
                          height: screenHeight * (48 / 640),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffeeeeee)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              GestureDetector(
                                onTap: (){
                                  dialogDialog(context, 0);
                                },
                                child: Text(
                                  "서비스 이용약관",
                                  style: TextStyle(
                                      fontSize: screenHeight * (12 / 640),
                                      color: Color(0xff222222)),
                                ),
                              ),
                              Spacer(),
                              Checkbox(
                                checkColor: kPrimaryColor,
                                activeColor: Colors.transparent,
                                value: checkBoxValue1,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkBoxValue1 = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * (4 / 640),
                        ),
                        Container(
                          width: screenWidth * (336 / 360),
                          height: screenHeight * (48 / 640),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffeeeeee)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              GestureDetector(
                                onTap: (){
                                  dialogDialog(context, 1);
                                },
                                child: Text(
                                  "개인정보 처리 방침",
                                  style: TextStyle(
                                      fontSize: screenHeight * (12 / 640),
                                      color: Color(0xff222222)),
                                ),
                              ),
                              Spacer(),
                              Checkbox(
                                checkColor: kPrimaryColor,
                                activeColor: Colors.transparent,
                                value: checkBoxValue2,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkBoxValue2 = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * (4 / 640),
                        ),
                        Container(
                          width: screenWidth * (336 / 360),
                          height: screenHeight * (48 / 640),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffeeeeee)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              GestureDetector(
                                onTap: (){
                                  dialogDialog(context,2);
                                },
                                child: Text(
                                  "마케팅 정보 수신에 대한 동의(선택)",
                                  style: TextStyle(
                                      fontSize: screenHeight * (12 / 640),
                                      color: Color(0xff222222)),
                                ),
                              ),
                              Spacer(),
                              Checkbox(
                                checkColor: kPrimaryColor,
                                activeColor: Colors.transparent,
                                value: checkBoxValue3,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkBoxValue3 = value;
                                  });
                                },
                              ),
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: GestureDetector(
            onTap: (){
              if(checkBoxValue1 && checkBoxValue2 ) {
                Navigator.push(
                    context, // 기본 파라미터, SecondRoute로 전달
                    MaterialPageRoute(
                      builder: (context) =>
                          BeforeCertification(),
                    ) // SecondRoute를 생성하여 적재
                );
              }
            },
            child: Container(
              height: screenHeight*0.09375,
              width: screenWidth,
              decoration: BoxDecoration(
                  color: (checkBoxValue1 && checkBoxValue2) ? kPrimaryColor : hexToColor("#CCCCCC")
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '완료',
                  style: TextStyle(
                      fontSize: screenWidth*0.0444444,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}


dialogDialog(BuildContext context, @required int current) {

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        var screenWidth = MediaQuery.of(context).size.width;
        var screenHeight = MediaQuery.of(context).size.height;

        return
          new AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
            content: Container(
              height: screenHeight*(500/640),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      width: screenWidth * (300/360),
                      child:  Image.asset(
                        current == 0 ?ServiceInfo2InMoreScreen : current ==1?PersonalInfo2InMoreScreen:PersonalInfo2InMoreScreen,
                        width: screenWidth * (336 / 360),
                        //  color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      }
  );
}