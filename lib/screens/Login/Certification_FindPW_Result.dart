import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/Login/FindPassword.dart';
import 'package:mryr/screens/Login/ModifyPWComplete.dart';
import 'package:mryr/screens/Login/model/GetUserIID.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class Certification_FindPW_Result extends StatefulWidget {
  static const Color successColor = Color(0xff52c41a);
  static const Color failureColor = Color(0xfff5222d);

  @override
  _Certification_FindPW_ResultState createState() => _Certification_FindPW_ResultState();
}

class _Certification_FindPW_ResultState extends State<Certification_FindPW_Result> {
  final _pwContriller = TextEditingController();
  final _ConfirmPwController = TextEditingController();

  bool CheckFlag = false;

  bool ValidationForPw = false;
  bool ValidationForConfirmPW = false;

  final message = '인증 실패';
  final Description = '인증을 다시 시도해주세요';
  final img = 'assets/images/releaseRoomScreen/RedErrorIcon.svg';
  final navMsg = '되돌아가기';
  final isErrorMessageRendering = false;

  @override
  Widget build(BuildContext context) {
    Map<String, String> result = ModalRoute.of(context).settings.arguments;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return result['success'] == 'true' ?
    MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
          child: Scaffold(
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                brightness: Brightness.light,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
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
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight*0.0625,),
                    Text(
                      '비밀번호 재설정',
                      style: TextStyle(
                        fontSize: screenWidth*0.066666,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.0125,),
                    Text(
                      '비밀번호 재설정을 위한 새로운 비밀번호를 입력해주세요',
                      style: TextStyle(
                        fontSize: screenWidth*0.0333333333,
                        color: hexToColor('#888888'),
                      ),
                    ),
                    SizedBox(height: screenHeight*0.04375,),
                    Text(
                      '비밀번호',
                      style: TextStyle(
                        fontSize: screenWidth*0.04444,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.0125,),
                    SizedBox(
                        height: screenHeight*0.11,
                        child: TextField(
                          controller: _pwContriller,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: _pwContriller.text.length > 0
                                ? IconButton(
                                onPressed: () {
                                  _pwContriller.clear();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Color(0xFFCCCCCC),
                                  size: screenWidth * 0.0333333333333333,
                                ))
                                : null,
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(screenWidth*0.0333333,  screenHeight*0.0234375, 0,screenHeight*0.0234375),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: kPrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: hexToColor(("#CCCCCC"))),
                            ),
                            hintText: '비밀번호 입력 (숫자+특수문자 포함 5~15자)',
                            hintStyle: TextStyle(
                                color: hexToColor('#CCCCCC'),
                                fontSize: screenWidth*0.038888
                            ),
                            errorText: !ValidationForPw ? '숫자+특수문자 포함 5~15자입니다.' : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.red),
                            ),
                            errorStyle: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    (0.01875 - 0.0030),
                                color: hexToColor('#F9423A')),
                          ),
                          onChanged: (text){
                            print(Validation_PW(text).toString());
                            if(Validation_PW(text)) {
                              if(_pwContriller.text != null && _ConfirmPwController.text != null &&
                                  _pwContriller.text != "" && _ConfirmPwController.text != "" && ValidationForConfirmPW) {
                                CheckFlag = true;
                              } else {
                                CheckFlag = false;
                              }
                            }
                            if(ValidationForPw && ValidationForConfirmPW) {
                              CheckFlag = true;
                            } else {
                              CheckFlag = false;
                            }
                            setState(() {

                            });
                          },
                        )
                    ),
                    SizedBox(height: screenHeight*0.01875,),
                    Text(
                      '비밀번호 확인',
                      style: TextStyle(
                        fontSize: screenWidth*0.04444,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.0125,),
                    SizedBox(
                        height: screenHeight*0.11,
                        child: TextField(
                          controller: _ConfirmPwController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: _ConfirmPwController.text.length > 0
                                ? IconButton(
                                onPressed: () {
                                  _ConfirmPwController.clear();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Color(0xFFCCCCCC),
                                  size: screenWidth * 0.0333333333333333,
                                ))
                                : null,
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(screenWidth*0.0333333,  screenHeight*0.0234375, 0,screenHeight*0.0234375),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: kPrimaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: hexToColor(("#CCCCCC"))),
                            ),
                            hintText: '비밀번호 확인',
                            hintStyle: TextStyle(
                                color: hexToColor('#CCCCCC'),
                                fontSize: screenWidth*0.038888
                            ),
                            errorText: !ValidationForConfirmPW ? '비밀번호가 일치하지 않습니다.' : null,
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(width: 1,color: Colors.red),
                            ),
                            errorStyle: TextStyle(
                                fontSize: MediaQuery.of(context).size.height *
                                    (0.01875 - 0.0030),
                                color: hexToColor('#F9423A')),
                          ),
                          onChanged: (text){
                            print('${_pwContriller.text == _ConfirmPwController.text}');
                            if(_pwContriller.text == _ConfirmPwController.text) {
                              ValidationForConfirmPW = true;
                            } else {
                              ValidationForConfirmPW = false;
                            }
                            if(ValidationForPw && ValidationForConfirmPW) {
                              CheckFlag = true;
                            } else {
                              CheckFlag = false;
                            }
                            setState(() {

                            });
                          },
                        )
                    ),
                  ],
                ),
              ),


              bottomNavigationBar: GestureDetector(


                onTap: () async {
                  if(CheckFlag) {
                    Email_findPw;
                    Name_findPw;
                    phone_findPw;

                    String emailID = Email_findPw;
                    String name = Name_findPw;
                    String phone = phone_findPw;

                    var myRoom = await ApiProvider().post('/User/findPassword', jsonEncode(
                        {
                          "emailID" : emailID,
                          "name": name,
                          "phone":phone,
                        }
                    ));

                    if(!myRoom) {//비밀번호 없을때
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ModifyPWComplete(Success: false,),
                          ) // SecondRoute를 생성하여 적재
                      );
                      return;
                    }

                    var result_pw = await ApiProvider().post('/User/PasswordEdit', jsonEncode(
                        {
                          "userID" : emailID,
                          "password": _pwContriller.text,
                        }
                    ));


                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                          builder: (context) =>
                              ModifyPWComplete(Success: true),
                        ) // SecondRoute를 생성하여 적재
                    );
                  }
                },


                child: Container(
                  height: screenHeight*0.09375,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: CheckFlag == true ? kPrimaryColor : hexToColor("#CCCCCC")
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
              )
          ),
        ) :
    MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 0,
              title: SvgPicture.asset(
                MryrLogoInReleaseRoomTutorialScreen,
                width: screenHeight * (110 / 640),
                height: screenHeight * (27 / 640),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.194448),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight*0.1875,),
                  SvgPicture.asset(
                    img,
                    width: screenHeight*0.140625,
                    height: screenHeight*0.140625,
                  ),
                  SizedBox(height: screenHeight*0.025,),
                  Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*0.06666,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.00625,),
                  Text(
                    Description,
                    style: TextStyle(
                      fontSize: screenWidth*0.0333333,
                      color: hexToColor('#888888'),
                    ),
                  ),

                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: screenHeight*0.09375,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: kPrimaryColor
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    navMsg,
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
        );
  }

  bool Validation_PW(String value) {
    String p = r'(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}';

    RegExp regExp = new RegExp(p);
    setState(() {
      ValidationForPw = regExp.hasMatch(value);
    });
    return regExp.hasMatch(value);
  }
}