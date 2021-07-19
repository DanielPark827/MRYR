import 'dart:convert';
import 'dart:ffi';

//import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/chat/models/ChatDatabase.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/LoginBloc.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/screens/Login/FindId.dart';
import 'package:mryr/screens/Login/FindPassword.dart';
import 'package:mryr/screens/Registration/Agreement.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginMainScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

bool CheckNotification;

class _LoginScreenState extends State<LoginScreen> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  final int OrderInrecentConnection = 0;
  final int OrderInHavingBadge = 1;
  final int OrderInSignUp = 2;

  bool checkBoxValue = false;
  bool boolLogin = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  LoginBloc loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    loginBloc = BlocProvider.of<LoginBloc>(context);

//    if(!kReleaseMode){
//      _idController.text = "qkrdustjd15@naver.com";
//      _passwordController.text = "1234123";
//    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

   // SocketProvider provider = Provider.of<SocketProvider>(context);


    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        child: Scaffold(
        //  resizeToAvoidBottomPadding: false,
          body: Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: screenHeight*(60/640),
                  child: Row(
                    children: [
                      ButtonTheme(
                        minWidth: screenHeight * 0.05,
                        height: screenHeight * 0.05,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        buttonColor: Colors.white,
                        child: RaisedButton(
                          elevation: 0,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            backArrow,
                            width: screenHeight * 0.03125,
                            height: screenHeight * 0.03125,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth*(8/360),),
                      Text("로그인",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (36/640),
                ),
                Row(
                  children: [
                    SizedBox(width: screenWidth*(12/360),),
                    Text("아이디(이메일)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (8/640),
                ),
                Row(
                  children: [
                    SizedBox(width: screenWidth*(12/360),),
                    Container(
                      width: screenWidth*(336/360),
                      height: screenHeight *(48/640),

                      child: BlocBuilder(
                          bloc: loginBloc,
                          condition: (oldState, newState) =>
                          oldState.loginModel.isValidForLogin !=
                              newState.loginModel.isValidForLogin,
                          builder: (context, state) {
                            return TextField(
                              controller: _idController,
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              onChanged: (val) => loginBloc.add(LoginIDChanged(val)),

                              decoration: InputDecoration(

                                suffixIcon: _idController.text.length > 0
                                    ? IconButton(
                                    onPressed: () {
                                      _idController.clear();
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Color(0xFFCCCCCC),
                                      size: screenWidth * 0.0333333333333333,
                                    ))
                                    : null,
                                filled: true,
                                hintText: "이메일 입력",
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.03333,
                                    0, 0,0),
                                hintStyle: TextStyle(
                                    fontSize: screenWidth*( 14/360),
                                    color: Color(0xffCCCCCC)),
                                errorText: state != null && (state.loginModel.loginID == "")
                                    ? null
                                    : state != null && state.loginModel.isValidForLogin
                                    ? null
                                    : "아이디가 잘못되었습니다ㅠㅠ",
                                errorStyle: TextStyle(
                                    fontSize: screenWidth*DialogContentsFontSize,
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
                                      color: _idController.text!=""?kPrimaryColor: state != null && (state.loginModel.loginID == "")
                                          ? Color(0xffCCCCCC)
                                          : state != null &&
                                          state.loginModel.isValidForLogin
                                          ? kPrimaryColor
                                          : Color(0xffF9423A),
                                    )),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (12/640),
                ),
                Row(
                  children: [
                    SizedBox(width: screenWidth*(12/360),),
                    Text("비밀번호",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (8/640),
                ),

                Row(
                  children: [
                    SizedBox(width: screenWidth*(12/360),),
                    Container(
                      width: screenWidth*(336/360),
                      height: screenHeight *(48/640),

                      child: BlocBuilder(
                        bloc: loginBloc,
                        condition: (oldState, newState) =>
                        oldState.loginModel.isValidForLogin !=
                            newState.loginModel.isValidForLogin,
                        builder: (context, state) {
                          return TextField(
                            controller: _passwordController,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            onChanged: (val) => loginBloc.add(LoginPasswordChanged(val)),
                            decoration: InputDecoration(
                              suffixIcon: _passwordController.text.length > 0
                                  ? IconButton(
                                  onPressed: () {
                                    _passwordController.clear();
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Color(0xFFCCCCCC),
                                    size: screenWidth * 0.0333333333333333,
                                  ))
                                  : null,
                              filled: true,
                              hintText: "비밀번호 입력",
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(screenWidth * 0.03333,
                                  0, 0,0),
                              hintStyle: TextStyle(
                                  fontSize:screenWidth*(14/360),
                                  color: Color(0xffCCCCCC)),
                              errorText:
                              state != null && (state.loginModel.loginPassword == "")
                                  ? null
                                  : state != null && state.loginModel.isValidForLogin
                                  ? null
                                  : null,
                              errorStyle: TextStyle(
                                  fontSize: screenWidth*(10 /360),
                                  color:Color(0xffF9423A)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                    color:Color(0xffF9423A),
                                  )),
                              focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  borderSide: BorderSide(
                                    color:
                                    _passwordController.text!=""?kPrimaryColor: state != null && (state.loginModel.loginPassword == "")
                                        ? Color(0xffCCCCCC)
                                        : state != null &&
                                        state.loginModel.isValidForLogin
                                        ? kPrimaryColor
                                        : Color(0xffF9423A),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
//                Row(children: [
//                  SizedBox(
//                    width: screenWidth * (12/360),
//                  ),
//                  Container(
//                    width: screenHeight*(16/640),
//                    height:screenHeight*(16/640),
//                    child: Checkbox(
//                      checkColor: kPrimaryColor,
//                      activeColor: Colors.transparent,
//
//                      value: checkBoxValue,
//                      onChanged: (bool value) {
//                        setState(() {
//                          checkBoxValue = value;
//                        });
//                      },
//                    ),
//                  ),
//                  SizedBox(
//                    width: screenWidth * (4/640),
//                  ),
//                  Text("로그인 상태 유지",style: TextStyle(fontSize: screenWidth*(12/360),),)
//                ],),
                boolLogin == true?  SizedBox(
                  height: screenHeight * (60/640),
                ):
                Column(children: [
                  SizedBox(height: screenHeight*(4/640),),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*(16/360),),
                      Container(
                          height: screenHeight*(48/640),
                          child: Text("등록되지 않은 아이디이거나, \n아이디 또는 비밀번호를 잘못 입력하였습니다  :(",style: TextStyle(fontSize: screenWidth*(10/360),color: Colors.red),)),
                    ],
                  ),
                  SizedBox(height: screenHeight*(8/640),),
                ],)
                ,
                Center(
                  child: BlocBuilder<LoginBloc, LoginState>(
                    condition: (oldState, newState) =>
                    oldState.loginModel.isValidForLogin !=
                        newState.loginModel.isValidForLogin,
                    builder: (context, state) {
                      return Container(
                          width: MediaQuery.of(context).size.width * 0.8888,
                          height: MediaQuery.of(context).size.height * 0.0625,
                          child: new FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            color: kPrimaryColor,
                            onPressed:
                            state != null && state.loginModel.isValidForLogin
                                ? () {
                              (() async {
                                try{
                                  if(GlobalProfile.booleanButton == true){}
                                  else{
                                    GlobalProfile.booleanButton = true;
                                    _idController.text;
                                    _passwordController.text;


                                    var result = await ApiProvider().post("/User/DebugLogin", jsonEncode(
                                        {
                                          "id" : _idController.text,
                                          "password" : _passwordController.text,
                                        }
                                    ));
                                    if(false != result && null != result){

                                      loginFunc( _idController.text,_passwordController.text, context,/* provider,*/ result, "normal");

                                    }
                                    else{

                                      setState(() {
                                        boolLogin = false;
                                      });
                                    }
                                    GlobalProfile.booleanButton = false;
                                  }


                                }   catch (e) {
                                  GlobalProfile.booleanButton = false;
                                  EasyLoading.showError(e.toString());
                                  print(e+"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
                                }
                              })();
                            }
                                : () {},
                            child: Text(
                              "로그인",
                              style: TextStyle(
                                fontSize:screenWidth*( 16/360),
                                color: Colors.white,
                              ),
                            ),));
                    },
                  ),
                ),

                SizedBox(
                  height: screenHeight * 0.03125,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  FindId()) // SecondRoute를 생성하여 적재
                      );
                    },
                    child: Container(width: screenWidth*(109/360),
                      height: screenHeight*0.03125,
                      child: Center(child:
                      Text("아이디 찾기",style: TextStyle(fontSize: screenWidth*(12/360)),)
                        ,),),
                  )  ,
                  Container(width: 1 ,height: screenHeight*(10/640),color: Color(0xffd2d2d2),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  FindPassword()) // SecondRoute를 생성하여 적재
                      );
                    },
                    child: Container(width: screenWidth*(109/360),
                      height: screenHeight*0.03125,
                      child: Center(child:
                      Text("비밀번호 찾기",style: TextStyle(fontSize: screenWidth*(12/360)),)
                        ,),),
                  ),

                  Container(width: 1 ,height: screenHeight*(10/640),color: Color(0xffd2d2d2),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                            builder: (context) =>
                                Agreement(),
                          ) // SecondRoute를 생성하여 적재
                      );

                    },
                    child: Container(width: screenWidth*(109/360),
                      height: screenHeight*0.03125,
                      child: Center(child:
                      Text("회원가입",style: TextStyle(fontSize: screenWidth*(12/360)),)
                        ,),),
                  )
                ],),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField buildTextField(TextEditingController controller, String hintText,
      bool isObscure, ValueChanged<String> onChangedCallback) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      textInputAction: TextInputAction.done,
      onChanged: onChangedCallback,
      decoration: InputDecoration(
        filled: true,
        hintText: hintText,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(
            screenWidth * 0.03333,
            MediaQuery.of(context).size.height * 0.0203,
            0,
            MediaQuery.of(context).size.height * 0.0203),
        hintStyle: TextStyle(
            fontSize: screenWidth*( 16/360), color: hexToColor('#CCCCCC')),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(color: hexToColor('#CCCCCC')),
        ),
      ),
    );
  }

  BlocBuilder buildBlocTextField(
      TextEditingController controller,
      String fieldText,
      String hintText,
      String errorText,
      bool isObscure,
      ValueChanged<String> onChangedCallback) {
    return BlocBuilder(
      bloc: loginBloc,
      condition: (oldState, newState) =>
      oldState.model.isValidForLogin != newState.model.isValidForLogin,
      builder: (context, state) {
        return Container(
          width: screenWidth,
          height: MediaQuery.of(context).size.height * 0.09375,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            textInputAction: TextInputAction.done,
            onChanged: onChangedCallback,
            decoration: InputDecoration(
              filled: true,
              hintText: hintText,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(
                  screenWidth * 0.03333,
                  MediaQuery.of(context).size.height * 0.0203,
                  0,
                  MediaQuery.of(context).size.height * 0.0203),
              hintStyle: TextStyle(
                  fontSize: screenWidth*( 16/360),
                  color: hexToColor('#CCCCCC')),
              errorText: state != null && (fieldText == "")
                  ? null
                  : state != null && state.model.isValidForRegistration
                  ? null
                  : errorText,
              errorStyle: TextStyle(
                  fontSize:
                  screenWidth*( 10/360),
                  color: hexToColor('#F9423A')),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: hexToColor('#F9423A'),
                  )),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(
                    color: state != null && (fieldText == "")
                        ? hexToColor('#CCCCCC')
                        : state != null && state.model.isValidForRegistration
                        ? hexToColor('#61C680')
                        : hexToColor('#F9423A'),
                  )),
            ),
          ),
        );
      },
    );
  }
}
