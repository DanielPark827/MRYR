import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/RegistrationBloc.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/Registration/BeforeCertification.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String navigatorBackArrowName = 'assets/images/public/backArrow.svg';
  String ClearButtonIcon = 'assets/images/clearButtonIcon.svg';
  final RegistrationComplete= 'assets/images/public/RegistrationComplete.svg';
  int currentPage = 0;

  final nameTextField = TextEditingController();
  final nickNameTextField = TextEditingController();

  int sex = -1;

  final idTextField = TextEditingController();

  //0=시작, 1=이메일형식오류, 2=중복된이메일, 3=올바름,
  int idFieldState = 0;

  final passwordTextField = TextEditingController();
  final passwordConfirmTextField = TextEditingController();

  int none = -1;
  int woman = 0;
  int man = 1;


  RegistrationBloc registrationBloc;

  RegExp regExp = new RegExp(
      r'^[0-9a-zA-Z][0-9a-zA-Z\_\-\.\+]+[0-9a-zA-Z]@[0-9a-zA-Z][0-9a-zA-Z\_\-]*[0-9a-zA-Z](\.[a-zA-Z]{2,6}){1,2}$');

  bool idCheck = false;
  @override
  void initState() {
    // TODO: implement initState
    registrationBloc = BlocProvider.of<RegistrationBloc>(context);
    super.initState();
  }

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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: SafeArea(
          child:currentPage == 0?
          registraionNameNickNameGender(context, screenWidth)
              :
          currentPage == 1?
          registrationIdPassword(context, screenWidth, screenHeight)
          /*  else if (registrationBloc.state.model.pageState == "PASSWORD")
                  registrationPassword(context, screenWidth, screenHeight)*/
              :
          registrationSuccess(context, screenWidth, screenHeight)
      ),
    );
  }

  GestureDetector registraionNameNickNameGender(BuildContext context, var screenWidth) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body :   Container(
          width: screenWidth,
          height: MediaQuery
              .of(context)
              .size
              .height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBar("회원가입"),
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
                        textInputAction: TextInputAction.done,
                        obscureText: false,
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
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: kPrimaryColor
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
                                    :
                                validateName(nameTextField.text)
                                    ? Color(0xffF9423A) : kPrimaryColor,
                              )),
                        ),
                      ),
                    )
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
                        textInputAction: TextInputAction.done,
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
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: kPrimaryColor
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
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar:  Container(
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
                    ? () {
                  currentPage = 1;
                  setState(() {

                  });
                }
                    : () {},
                child: Text("다음",
                    style: TextStyle(
                      fontSize: screenWidth * (16 / 360),
                    )))),
      ),
    );

  }

  GestureDetector registrationIdPassword(BuildContext context, var screenWidth,
      var screenHeight) {
    bool isIDCheck = false;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: Container(
          width: screenWidth,
          height: MediaQuery
              .of(context)
              .size
              .height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appBar("회원가입"),
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
                        '아이디(이메일)',
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
                      width: screenWidth * (249 / 360),
                       height: screenHeight * 0.12,
                      child: TextField(
                        controller: idTextField,
                        textInputAction: TextInputAction.done,
                        obscureText: false,
                        onChanged: (val){
                          idCheck = false;
                          return;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "아이디 입력",
                          suffixIcon: idTextField.text.length > 0
                              ? IconButton(
                              onPressed: () {
                                idTextField.clear();
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
                              0, 0, 0),
                          hintStyle: TextStyle(
                              fontSize: screenWidth * (14 / 360),
                              color: Color(0xffCCCCCC)),
                          errorText: idTextField.text != ""&& EmailValidator.validate(idTextField.text)!= true
                              ? "잘못된 형식의 이메일입니다."
                              : null,
                          errorStyle: TextStyle(
                              fontSize: screenHeight *
                                  (0.01875 - 0.0030),
                              color: Color(0xffF9423A)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: Color(0xffF9423A),
                              )),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: kPrimaryColor
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: idTextField.text == ""
                                    ? Color(0xffCCCCCC)
                                    :EmailValidator.validate(idTextField.text)== true
                                    ? kPrimaryColor : Color(0xffF9423A),
                              )),
                        ),
                      ),
                    ),
                    Container(width: screenWidth * (25 / 360),),
                    InkWell(
                      onTap: ()async{
                        if(idTextField.text == null || idTextField.text == ""){
                          CustomOKDialog(context, "아이디가 없습니다! :D", "아이디를 입력해주세요! ^^");
                        }
                        else {
                          idTextField.text;
                          var tmp = await ApiProvider().post(
                              "/User/IDCheck", jsonEncode(
                              {
                                "id": idTextField.text,
                              }
                          ));
                          if (tmp["result"] == false) {
                            setState(() {
                              CustomOKDialog(context, "이미 등록된 아이디입니다 :(", "다른 아이디를 입력해주세요! ^^");
                              idCheck = false;
                            });
                          }
                          else {
                            setState(() {
                              CustomOKDialog(context, "사용할 수 있는 아이디입니다 :D", "회원가입을 계속 진행해주세요! ^^");
                              idCheck = true;
                            });
                          }
                        }
                      },
                      child: Container(
                        height: screenHeight * 0.12,
                        child: Column(
                          children: [
                            Container(height: screenHeight * (7/ 360),),
                            Container(
                              decoration: BoxDecoration(
                              //  color: kPrimaryColor,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: Text("중복 확인",style: TextStyle(fontSize:screenWidth*ListContentsFontSize,color:idCheck?kPrimaryColor:Color(0xffcccccc),fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * (12 / 640),
                ),
                Row(
                  children: [
                    Container(width: screenWidth * (12 / 360),),
                    Container(
                      child: Text(
                        '비밀번호',
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
                      height: screenHeight * 0.12,
                      child: TextField(
                        controller: passwordTextField,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "비밀번호 입력 (숫자+특수문자 포함 5~15자)",
                          suffixIcon: passwordTextField.text.length > 0
                              ? IconButton(
                              onPressed: () {
                                passwordTextField.clear();
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
                              0, 0, 0),
                          hintStyle: TextStyle(
                              fontSize: screenWidth * (14 / 360),
                              color: Color(0xffCCCCCC)),
                          errorText:
                          passwordTextField.text != "" &&
                              validatePassword(passwordTextField.text) == false
                              ? "비밀번호는 숫자+특수문자 포함 5~15자입니다."
                              : null,
                          errorStyle: TextStyle(
                              fontSize: screenHeight * (0.01875 - 0.0030),
                              color: Color(0xffF9423A)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: Color(0xffF9423A),
                              )),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: kPrimaryColor
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: passwordTextField.text == ""
                                    ? Color(0xffCCCCCC)
                                    : validatePassword(
                                    passwordTextField.text) == true
                                    ? kPrimaryColor : Color(0xffF9423A),
                              )),

                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * (12 / 640),
                ),
                Row(
                  children: [
                    Container(width: screenWidth * (12 / 360),),
                    Container(
                      child: Text(
                        '비밀번호 확인',
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
                      height: screenHeight * 0.12,
                      child: TextField(
                        controller: passwordConfirmTextField,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "비밀번호 확인 입력 (숫자+특수문자 포함 5~15자)",
                          suffixIcon: passwordConfirmTextField.text.length >
                              0
                              ? IconButton(
                              onPressed: () {
                                passwordConfirmTextField.clear();
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
                              0, 0, 0),
                          hintStyle: TextStyle(
                              fontSize: screenWidth * (14 / 360),
                              color: Color(0xffCCCCCC)),
                          errorText:
                          passwordConfirmTextField.text != "" &&
                              passwordTextField.text !=
                                  passwordConfirmTextField.text
                              ? "비밀번호가 일치하지 않습니다!"
                              : null,
                          errorStyle: TextStyle(
                              fontSize: screenHeight * (0.01875 - 0.0030),
                              color: Color(0xffF9423A)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: Color(0xffF9423A),
                              )),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                  color: kPrimaryColor
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                color: passwordConfirmTextField.text == ""
                                    ? Color(0xffCCCCCC)
                                    : passwordTextField.text !=
                                    passwordConfirmTextField.text
                                    ? Color(0xffF9423A) : kPrimaryColor,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:  Container(
            width: screenWidth,
            height: screenHeight * 0.09375,
            child: new FlatButton(
                color:
                    validatePassword(passwordTextField.text) == true &&
                    passwordTextField.text ==
                        passwordConfirmTextField.text &&idCheck == true
                    ? kPrimaryColor
                    : Color(0xffCCCCCC),
                textColor: Colors.white,
                onPressed:
                    validatePassword(passwordTextField.text) == true &&
                    passwordTextField.text ==
                        passwordConfirmTextField.text &&idCheck == true
                    ? () async{
                  currentPage = 2;
                  await ApiProvider().post(
                      "/User/Insert", jsonEncode(//
                      {
                        "id": idTextField.text,
                        "name": nameTextField.text,
                        "phone": globalPNum,
                        "nickname":nickNameTextField.text,
                        "password":passwordTextField.text,
                        "sex":sex,
                        "kakao":false,
                      }));
                  setState(() {

                  });

                }
                    : () {},
                child: Text(
                  currentPage == 0 ? "다음" : "회원가입 완료",
                  style: TextStyle(fontSize: screenHeight * 0.025),
                ))),
      ),
    );

  }


  GestureDetector registrationSuccess(BuildContext context, var screenWidth,
      var screenHeight) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body:   Column(
          children: [
            SizedBox(height: screenHeight*(80/640),),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                RegistrationComplete,
//                height: screenHeight*(368/640),
                width: screenWidth*(340/360),
              ),
            ),
            SizedBox(height: screenHeight*(24/640),),
            Align(
              alignment: Alignment.center,
              child: Text(
                '회원 가입이 완료되었습니다.',
                style: TextStyle(
                  fontSize: screenWidth*ListContentsFontSize,
                ),
              ),
            ),
            SizedBox(height: screenHeight*(28/640),),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginMainScreen(),
                    ));
              },
              child: Container(
                width: screenWidth*(320/360),
                height: screenHeight*(40/640),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: kPrimaryColor
                ),
                child: Center(
                  child: Text(
                    '시작하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget appBar(String text) {
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
                    if (currentPage == 0)
                      Navigator.pop(context);
                    else if (currentPage == 1) {
                      currentPage = 0;
                      setState(() {

                      });
                    }
                    else
                      Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    navigatorBackArrowName,
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

bool validatePassword(String value) {
  if ((!(value.length >= 5) || !(value.length <= 15)) && value.isNotEmpty) {
    return false;
  }
  return true;
}

Future<int> emailCheck(value) async {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  if (regExp.hasMatch(value) == true) {
    var tmp = await ApiProvider().post("/User/IDCheck", jsonEncode(
        {
          "id": value,
        }));
    if (tmp == null) {
      return 1;
    }
    else
      return 2;
  }
  else {
    return 0;
  }
}

int validateEmail(String value) {
  int tmp;
  emailCheck(value).then((v) {
    tmp = v;
  });
  return tmp;
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


CustomOKDialog(BuildContext context,@required String title, @required String description) {
  var screenWidth = MediaQuery.of(context).size.width;
  var screenHeight = MediaQuery.of(context).size.height;

  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {

        return CupertinoAlertDialog(
            title: Text(title+"\n"),
            content: Text(description),
            actions: <Widget>[

              CupertinoDialogAction(
                child: Text('확인'),
                onPressed:(){
                  Navigator.pop(context);
                },
                textStyle: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          );
      }
  );
}

