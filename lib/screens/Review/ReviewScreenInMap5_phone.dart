import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kopo/kopo.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/main.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ReviewScreenInMap5_phone extends StatefulWidget {
  @override
  _ReviewScreenInMap5_phoneState createState() =>
      _ReviewScreenInMap5_phoneState();
}

class _ReviewScreenInMap5_phoneState extends State<ReviewScreenInMap5_phone> {
  final phoneNumberField = TextEditingController();
  String phone;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        Function okFunc = () async {
          Navigator.pushReplacement(
              context, // 기본 파라미터, SecondRoute로 전달
              MaterialPageRoute(
                  builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
          );
        };

        Function cancelFunc = () {
          Navigator.pop(context);
        };

        OKCancelDialog(context, "처음으로 돌아가시겠습니까?","", "확인", "취소", okFunc, cancelFunc);
        return;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    Function okFunc = () async {
                      Navigator.pushReplacement(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
                      );
                    };

                    Function cancelFunc = () {
                      Navigator.pop(context);
                    };

                    OKCancelDialog(context, "처음으로 돌아가시겠습니까?","", "확인", "취소", okFunc, cancelFunc);
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
                Function okFunc = () async {
                  Navigator.pushReplacement(
                      context, // 기본 파라미터, SecondRoute로 전달
                      MaterialPageRoute(
                          builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
                  );
                };

                Function cancelFunc = () {
                  Navigator.pop(context);
                };

                OKCancelDialog(context, "처음으로 돌아가시겠습니까?","", "확인", "취소", okFunc, cancelFunc);
                return;
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
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
                                "휴대폰 번호 입력",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenHeight * (24 / 640),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * (8 / 640),
                              ),
                              Text(
                                "당신의 휴대폰 번호를 입력해주세요",
                                style: TextStyle(
                                  color: Color(0xff888888),
                                  fontSize: screenHeight * (12 / 640),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * (36 / 640),
                              ),
                              Container(
                                width: screenWidth * (336 / 360),
                                height: screenHeight * (60 / 640),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: phoneNumberField,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: Color(0xffCCCCCC),
                                        )),
                                    filled: true,
                                    hintText: "-없이 숫자만 입력",
                                    suffixIcon: phoneNumberField.text.length > 0
                                        ? IconButton(
                                            onPressed: () {
                                              phoneNumberField.clear();
                                            },
                                            icon: Icon(
                                              Icons.cancel,
                                              color: Color(0xFFCCCCCC),
                                              size: screenWidth * 0.0333333333333333,
                                            ))
                                        : null,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.03333, 0, 0, 0),
                                    hintStyle: TextStyle(
                                        fontSize: screenWidth * (14 / 360),
                                        color: Color(0xffCCCCCC)),
                                    /*  errorStyle: TextStyle(
                                      fontSize: screenWidth * (10 / 360),
                                      color: Color(0xffF9423A)),*/
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: Color(0xff888888),
                                        )),
                                    /*  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Color(0xffF9423A),
                                      )),*/
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: phoneNumberField.text == ""
                                              ? Color(0xffCCCCCC)
                                              : validatePhoneNum(phoneNumberField.text) ==
                                                      false
                                                  ? Color(0xffF9423A)
                                                  : kPrimaryColor,
                                        )),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      phone = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () async{
                if (validatePhoneNum(phoneNumberField.text) == true) {
                  EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                 var result = await ApiProvider().post("/Review/notuserReview/addPhoneNumber", jsonEncode(
                      {
                        "userID" : GlobalProfile.loggedInUser.userID,
                        "reviewPhone" :phoneNumberField.text,
                      }
                  ));
                  EasyLoading.dismiss();
                 if(result == true){
                   Function okFunc = () async {
                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => MainPage()),

                     );
                   };
                   OKDialog(context,"휴대폰 번호 입력 완료!","후기 등록을 완료해 주셔서 감사합니다\n입력하신 번호로 기프티콘을 다음날 보내드립니다","확인", okFunc);
                  }
                 else{
                   Function okFunc = () async {
                     Navigator.pushReplacement(
                       context,
                       MaterialPageRoute(builder: (context) => MainPage()),
                     );
                   };
                   OKDialog(context,"이미 응모가 완료된 사용자입니다.","","확인", okFunc);
                 }

                } else {}
              },
              child: Container(
                width: screenWidth,
                height: screenHeight * (60 / 640),
                color: validatePhoneNum(phoneNumberField.text) == true
                    ? kPrimaryColor
                    : Color(0xffcccccc),
                child: Center(
                  child: Text(
                    "다음",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (16 / 640)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validatePhoneNum(String value) {
    if (value.length == 11 || value.length == 10) return true;
    return false;
  }
}
