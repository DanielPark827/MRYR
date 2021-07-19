import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/LoginBloc.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/Login/FindPassword.dart';
import 'package:mryr/screens/Login/ModifyPWComplete.dart';
import 'package:mryr/screens/Login/model/GetFindId.dart';
import 'package:mryr/screens/Login/model/GetUserIID.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/LoginScreen.dart';
import 'package:mryr/screens/Registration/Agreement.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class Certification_FindId_Result extends StatefulWidget {
  static const Color successColor = Color(0xff52c41a);
  static const Color failureColor = Color(0xfff5222d);

  @override
  _Certification_FindId_ResultState createState() => _Certification_FindId_ResultState();
}

class _Certification_FindId_ResultState extends State<Certification_FindId_Result> {
  final _pwContriller = TextEditingController();
  final _ConfirmPwController = TextEditingController();

  bool CheckFlag = false;

  bool ValidationForPw = false;
  bool ValidationForConfirmPW = false;

  final message = '회원님의 휴대전화로\n가입된 아이디가 없습니다';
  final Description = '인증을 다시 시도해주세요';
  final img = 'assets/images/releaseRoomScreen/RedErrorIcon.svg';
  final navMsg = '되돌아가기';
  final isErrorMessageRendering = false;

  var result;
  GetFindID item;
  bool FindIdSuccess = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    (() async {
//      phone_findPw;
//      result = await ApiProvider().post('/User/findID', jsonEncode(
//          {
//            "phone" : phone_findPw,
//          }
//      ));
//
//      if(result == false) {
//        return;
//      } else {
//        FindIdSuccess = true;
//      }
//
//      item = await GetFindID.fromJson(result);
//    })();

  }

  Future<bool> init() async{
    result = await ApiProvider().post('/User/findID', jsonEncode(
        {
          "phone" : phone_findPw,
        }
    ));

    if(result == false) {
      return false;
    } else {
      FindIdSuccess = true;
    }

    item = await GetFindID.fromJson(result);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> result = ModalRoute.of(context).settings.arguments;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return     MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: FutureBuilder(
          future: init(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            }
            //error가 발생하게 될 경우 반환하게 되는 부분
            else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 15),
                ),
              );
            }
            // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
            else {
              return result['success'] != 'true' ?
              Scaffold(
                  backgroundColor: Colors.white,
                //  resizeToAvoidBottomPadding: false,
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
                        color: kPrimaryColor,
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '다시 시도하기',
                          style: TextStyle(
                              fontSize: screenWidth*0.0444444,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
              ) :
              result['success'] == 'true' && FindIdSuccess ?
              Scaffold(
                  backgroundColor: Colors.white,
               //   resizeToAvoidBottomPadding: false,
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
                  body:  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight*(40/640),),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '아이디 찾기 결과',
                            style: TextStyle(
                              fontSize: screenWidth*0.066666,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight*(88/640),),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '회원님의 휴대전화로\n가입된 아이디가 있습니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth*(16/360),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight*0.025,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: screenHeight*0.075,
                            decoration: BoxDecoration(
                                color: hexToColor('#F8F8F8'),
                                borderRadius: BorderRadius.circular(4.0)
                            ),
                            child: Align(
                              child: Text(
                                item.EmailID,
                                style: TextStyle(
                                  fontSize: screenWidth*0.03888,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            '비밀번호 찾으러 가기',
                            style: TextStyle(
                              fontSize: screenWidth*0.0333333,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight*0.05625,),
                      ],
                    ),
                  ),
                  bottomNavigationBar: GestureDetector(
                    onTap: () async {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => LoginMainScreen()
                      )
                      );
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
                          '로그인',
                          style: TextStyle(
                              fontSize: screenWidth*0.0444444,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  )
              ) :
              Scaffold(
                backgroundColor: Colors.white,
              //  resizeToAvoidBottomPadding: false,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight*(40/640),),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '아이디 찾기 결과',
                          style: TextStyle(
                            fontSize: screenWidth*0.066666,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight*(88/640),),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          img,
                          width: screenHeight*0.140625,
                          height: screenHeight*0.140625,
                        ),
                      ),
                      SizedBox(height: screenHeight*0.025,),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*(16/360),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                bottomNavigationBar: GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                          builder: (context) =>
                              Agreement(),
                        ) // SecondRoute를 생성하여 적재
                    );
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
                        '회원가입 하러 가기',
                        style: TextStyle(
                            fontSize: screenWidth*0.0444444,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
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