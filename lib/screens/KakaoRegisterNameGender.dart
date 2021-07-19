import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';
import 'package:provider/provider.dart';

import 'LoginMainScreen.dart';

class KakaoRegisterNameGender extends StatefulWidget {
  @override
  _KakaoRegisterNameGenderState createState() => _KakaoRegisterNameGenderState();
}

class _KakaoRegisterNameGenderState extends State<KakaoRegisterNameGender> {
  final nameTextField = TextEditingController();
  final nickNameTextField = TextEditingController();

  int sex = -1;

  int none = -1;
  int woman = 0;
  int man = 1;
  @override
  Widget build(BuildContext context) {
  //  SocketProvider provider = Provider.of<SocketProvider>(context);
    var screenWidth = MediaQuery

        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return  WillPopScope(
      onWillPop: (){
        return;
      },
      child: SafeArea(
        child: Material(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
            child: Container(
              width: screenWidth,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBar(context,"회원가입",screenWidth),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (20 / 640),
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Container(
                              child: Text(
                                '이름',
                                style: TextStyle(
                                    fontSize: screenWidth * (16 / 360),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (8 / 640),
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Container(
                              width: screenWidth * (336 / 360),
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.09375,

                              child: TextField(
                                controller: nameTextField,
                                obscureText: false,
                                textInputAction: TextInputAction.done,
                                /*  onChanged: (val) =>
                                        registrationBloc.add(UserNameChanged(val)),*/ /*  onChanged: (val) =>
                                        registrationBloc.add(UserNameChanged(val)),*/
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "이름",
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
                                  contentPadding: EdgeInsets.fromLTRB(
                                      screenWidth * 0.03333,
                                      0,
                                      0,
                                      0),
                                  hintStyle: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      color: Color(0xffCCCCCC)),
                                  errorText: nameTextField.text != "" &&
                                      validateName(nameTextField.text) == true
                                      ? "이름은 숫자, 특수 문자, 공백을 사용할 수 없습니다."
                                      : null,
                                  errorStyle: TextStyle(
                                      fontSize: screenWidth * (10 / 360),
                                      color: Color(0xffF9423A)),
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
                                            :
                                        validateName(nameTextField.text)
                                            ? Color(0xffF9423A) : kPrimaryColor,
                                      )),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Container(width: screenWidth*(336/360),
                              child:Text("※ 이름에 실명을 적어주세요. 실명이 아닐 시 앱 사용에 제한이 있을 수 있습니다. :)",
                                style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xffDA3D3D)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (16 / 640),
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (16 / 640),
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Text(
                              '닉네임',
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (8 / 640),
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Container(
                              width: screenWidth * (336 / 360),
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.09375,
                              child: TextField(
                                controller: nickNameTextField,
                                obscureText: false,
                                /*  onChanged: (val) =>
                                    registrationBloc.add(UserNickNameChanged(val)),*/
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "이름",
                                  suffixIcon: nickNameTextField.text.length > 0
                                      ? IconButton(
                                      onPressed: () {
                                        nickNameTextField.clear();
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFCCCCCC),
                                        size: screenWidth * 0.0333333333333333,
                                      ))
                                      : null,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.fromLTRB(
                                      screenWidth * 0.03333,
                                      0,
                                      0, 0),
                                  hintStyle: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      color: Color(0xffCCCCCC)),
                                  errorText: nickNameTextField.text != "" &&
                                      validateNickName(nickNameTextField.text)
                                      ? "닉네임은 특수 문자나 공백을 사용할 수 없습니다."
                                      : null,
                                  errorStyle: TextStyle(
                                      fontSize: screenWidth * (10 / 360),
                                      color: Color(0xffF9423A)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: Color(0xffF9423A),
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      borderSide: BorderSide(
                                        color: nickNameTextField.text == ""
                                            ? Color(0xffCCCCCC)
                                            :
                                        validateNickName(nickNameTextField.text)
                                            ? Color(0xffF9423A) : kPrimaryColor,
                                      )),
                                ),
                              ),
                            ),
                            Container(width: screenWidth * (12 / 360),),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (9 / 640),
                        ),
                        Row(

                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Text(
                              '성별',
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (8 / 640),
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            GestureDetector(
                              onTap: () {
                                if (sex == woman) {
                                  sex = none;
                                }
                                else {
                                  sex = woman;
                                }
                                setState(() {

                                });
                              },
                              child: Container(
                                width: screenWidth * (164 / 360),
                                height: screenHeight * (48 / 640),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(color: sex == woman ? Color(
                                      0xff6F22D2) : Color(0xff888888)),
                                ),
                                child: Center(child: Text("여성", style: TextStyle(
                                    fontSize: screenWidth * (14 / 360),
                                    color: sex == woman ? Color(0xff6F22D2) : Color(
                                        0xff888888)),),),
                              ),
                            ),
                            Container(width: screenWidth * (8 / 360),),
                            GestureDetector(
                              onTap: () {
                                if (sex == man) {
                                  sex = none;
                                }
                                else {
                                  sex = man;
                                }
                                setState(() {

                                });
                              },
                              child: Container(
                                width: screenWidth * (164 / 360),
                                height: screenHeight * (48 / 640),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(color: sex == man ? Color(
                                      0xff6F22D2) : Color(0xff888888)),
                                ),
                                child: Center(child: Text("남성", style: TextStyle(
                                    fontSize: screenWidth * (14 / 360),
                                    color: sex == man ? Color(0xff6F22D2) : Color(
                                        0xff888888)),),),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * (8 / 640),
                        ),
                        Row(
                          children: [
                            Container(width: screenWidth * (12 / 360),),
                            Container(width: screenWidth*(336/360),
                              child:Text("※ 사용자의 실명과 성별 정보는 내방니방의 주요기능인 방구하기와 방내놓기를 보다 안전하게 이용하도록 하기위해 수집됩니다. 수집된 개인정보는 앱의 고유기능 이외에 별로도 사용되지 않습니다.",
                                style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xffDA3D3D)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        // useProvision(screenWidth),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.03125,
                        ),
                        Container(
                            width: screenWidth,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.09375,
                            child: FlatButton(
                                color:
                                validateName(nameTextField.text) == false
                                    && validateNickName(nickNameTextField.text) == false
                                    && sex != none
                                    ? kPrimaryColor : Color(0xffcccccc),
                                textColor: Colors.white,
                                onPressed:
                                validateName(nameTextField.text) == false &&
                                    validateNickName(nickNameTextField.text) == false &&
                                    sex != none
                                    ? () async{
                                  var res = await ApiProvider().post('/User/KakaoInsert',jsonEncode({
                                    "id" : GlobalProfile.kakaoInfo.kakaoAccount.email.toString(),
                                    "name":nameTextField.text,
                                    "nickname":nickNameTextField.text,
                                    "sex": sex==0?false:true,
                                  }));


                                  if(res !=null){
                                    try{

                                      var result = await ApiProvider().post('/User/KakaoLogin', jsonEncode(
                                          {
                                            "id" : GlobalProfile.kakaoInfo.kakaoAccount.email.toString(),
                                            "password" : "",
                                          }
                                      ));
                                      if(false != result && null != result){
                                        loginFunc(GlobalProfile.kakaoInfo.kakaoAccount.email.toString(),"", context/*, provider*/, result,"kakao");
                                      }
                                    }  catch (e) {
                                      EasyLoading.showError(e.toString());
                                      print(e);
                                    }

                                  }
                                  else{

                                  }


                                  setState(() {

                                  });
                                }
                                    : () {},
                                child: Text("회원가입 완료",
                                    style: TextStyle(
                                      fontSize: screenWidth * (16 / 360),
                                    ))))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget appBar(BuildContext context,String text, var screenWidth) {
    return Column(
      children: [
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.09375,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * (12 / 360),
              ),
              GestureDetector(
                  onTap: () {

                  },
                  child: Container(

                    width: MediaQuery
                        .of(context)
                        .size
                        .height * 0.044,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.044,
                  )),
              SizedBox(
                width: screenWidth * (8 / 360),
              ),
              Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.025,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

}




bool validateName(String value) {
  String p = r'[$./!@#<>?":_`~;[\]\\|=+)(*&^%0-9-\s-]';


  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(value);
}

bool validateNickName(String value) {
  String p = r'[$./!@#<>?":_`~;[\]\\|=+)(*&^%\s-]';

  RegExp regExp = new RegExp(p);
  return regExp.hasMatch(value);
}

