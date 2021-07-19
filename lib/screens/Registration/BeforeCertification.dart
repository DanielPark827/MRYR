import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:flutter/services.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class BeforeCertification extends StatefulWidget {
  @override
  _BeforeCertificationState createState() => _BeforeCertificationState();
}

String globalPNum = null;

class _BeforeCertificationState extends State<BeforeCertification> {
  List<String> phoneCompanyList = ["선택", "SKT", "KTF", "LGT","MVNO"];

  double animatedHeight1 = 0.0;

  final nameTextField = TextEditingController();

  final phoneNumberField = TextEditingController();

  bool checkBoxValue1 = false;

  bool checkBoxValue2 = false;

  bool checkBoxValue3 = false;

  String merchantUid;
  String company = '아임포트';
  String carrier = 'SKT';
  String name;
  String phone;
  String minAge;

  bool PhoneAuthComplete() {
    if(
    validatePhoneNum(phoneNumberField.text) == true &&
        validateNameForPhone(nameTextField.text) == false){
      return true;
    }else{
      return false;
    }
  }

  bool AgreementComplete() =>
      checkBoxValue1 == true &&
          checkBoxValue2 == true &&
          checkBoxValue3 == true;

  bool validateNameForPhone(String value) {
    String p = r'[$./!@#<>?":_`~;[\]\\|=+)(*&^%0-9-\s-]';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(value);
  }

  bool validatePhoneNum(String value) {
    if (value.length != 11)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
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
            body: SingleChildScrollView(
              child: Column(
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
                              "본인 인증",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (24 / 360),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Text(
                              "본인 인증을 위한 이름과 핸드폰 번호를 입력해 주세요",
                              style: TextStyle(
                                color: Color(0xff888888),
                                fontSize: screenWidth * (12 / 360),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (28 / 640),
                            ),
                            Text(
                              "이름",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (16 / 360),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Container(
                              width: screenWidth * (336 / 360),
                              height: MediaQuery.of(context).size.height *(60/640),
                              child:


                              TextField(
                                controller: nameTextField,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "실명 입력",
                                  suffixIcon: nameTextField.text.length > 0
                                      ? IconButton(
                                      onPressed: () {
                                        nameTextField.clear();
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFCCCCCC),
                                        size: screenWidth * 0.0333333333333333,
                                      ))
                                      : null,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.03333,
                                      0, 0,0),
                                  hintStyle: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      color: Color(0xffCCCCCC)),
                                  errorText: validateNameForPhone(nameTextField.text)
                                      ? "이름은 숫자, 특수 문자, 공백을 사용할 수 없습니다."
                                      : null,
                                  errorStyle: TextStyle(
                                      fontSize: screenWidth * TagFontSize,
                                      color: Color(0xffF9423A)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Color(0xff888888),
                                      )),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Color(0xffCCCCCC),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Color(0xffF9423A),
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: nameTextField.text == ""
                                            ? Color(0xffCCCCCC)
                                            : validateNameForPhone(nameTextField.text)
                                            ? Color(0xffF9423A)
                                            : kPrimaryColor,
                                      )),
                                ),
                                onChanged: (value){
                                  setState(() {
                                    name = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (20 / 640),
                            ),
                            Text(
                              "핸드폰 번호",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (16 / 360),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                      hintText: "- 없이 숫자만 입력",
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
                                      contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.03333,
                                          0, 0,0),
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
                  )
                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: ()async{
                if(PhoneAuthComplete() == true) {
                  globalPNum = phoneNumberField.text;

                  var res = await ApiProvider().post('/User/PhoneNumberCheck',jsonEncode({
                    "phone": phoneNumberField.text
                  }));

                  if(res) {
                    CertificationData data = CertificationData.fromJson({
                      'merchantUid': merchantUid,
                      'company': '아임포트',                                             // 통신사
                      'name': nameTextField.text,                                                 // 이름
                      'phone': phoneNumberField.text,
                    });

                    Navigator.pushNamed(
                        context,
                        '/certification',
                        arguments: data
                    ).then((value) {
                      setState(() {
                      });
                    });
                  } else {
                    Fluttertoast.showToast(msg: ("이미 등록된 번호입니다.\n기존 계정을 이용해주세요."),);
                  }
//                CertificationData data = CertificationData.fromJson({
//                  'merchantUid': merchantUid,
//                  'company': '아임포트',                                             // 통신사
//                  'name': nameTextField.text,                                                 // 이름
//                  'phone': phoneNumberField.text,
//                });
//
//                Navigator.pushNamed(
//                    context,
//                    '/certification',
//                    arguments: data
//                ).then((value) {
//                  setState(() {
//                  });
//                });
                }
              },
              child: Container(
                height: screenHeight*0.09375,
                width: screenWidth,
                decoration: BoxDecoration(
                    color:(nameTextField.text != ""&&phoneNumberField.text!= "") ?  kPrimaryColor : hexToColor('#CCCCCC')
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '본인인증하기',
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
      ),
    );
  }

}
