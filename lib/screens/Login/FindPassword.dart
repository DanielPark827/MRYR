import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/Login/Certification_FindPW.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class FindPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() => _FindPasswordState();
}

String Email_findPw;
String Name_findPw;
String phone_findPw;

class _FindPasswordState extends State<FindPassword> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool ValidationFlagForPhoneNum= false;
  bool CheckFlag = false;
  String merchantUid;

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
                  Navigator.pop(context);
                }),
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight*0.0625,),
                  Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      fontSize: screenWidth*0.066666,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.0125,),
                  Text(
                    '비밀번호를 찾기 위한 가입된 아이디를 입력해주세요',
                    style: TextStyle(
                      fontSize: screenWidth*0.0333333333,
                      color: hexToColor('#888888'),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.04375,),
                  Text(
                    '아이디(이메일)',
                    style: TextStyle(
                      fontSize: screenWidth*0.04444,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.0125,),
                  SizedBox(
                    height: screenHeight*0.11,
                    child: TextField(
                      controller: _idController,
                      textInputAction: TextInputAction.done,
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
                        hintText: '이메일 입력',
                        hintStyle: TextStyle(
                            color: hexToColor('#CCCCCC'),
                            fontSize: screenWidth*0.038888
                        ),
                    ),
                      onChanged: (text){
                        if(!Validation_OnlyNumber(text)) {
                          if(_idController.text != null && _nameController.text != null && _phoneController.text != null  &&
                              _idController.text != "" && _nameController.text != "" && _phoneController.text != "") {
                            CheckFlag = true;
                          } else {
                            CheckFlag = false;
                          }
                          setState(() {

                          });
                        }
                      },
                  )
                  ),
                  SizedBox(height: screenHeight*0.01875,),
                  Text(
                    '이름',
                    style: TextStyle(
                      fontSize: screenWidth*0.04444,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.0125,),
                  SizedBox(
                      height: screenHeight*0.11,
                      child: TextField(
                        controller: _nameController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          suffixIcon: _nameController.text.length > 0
                              ? IconButton(
                              onPressed: () {
                                _nameController.clear();
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
                          hintText: '실명 입력',
                          hintStyle: TextStyle(
                              color: hexToColor('#CCCCCC'),
                              fontSize: screenWidth*0.038888
                          ),
                        ),
                        onChanged: (text){
                          if(!Validation_OnlyNumber(text)) {
                            if(_idController.text != null && _nameController.text != null && _phoneController.text != null  &&
                                _idController.text != "" && _nameController.text != "" && _phoneController.text != "") {
                              CheckFlag = true;
                            } else {
                              CheckFlag = false;
                            }
                            setState(() {

                            });
                          }
                        },
                      )
                  ),
                  SizedBox(height: screenHeight*0.01875,),
                  Text(
                    '핸드폰 번호',
                    style: TextStyle(
                      fontSize: screenWidth*0.04444,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight*0.0125,),
                  SizedBox(
                      height: screenHeight*0.11,
                      child: TextField(
                        controller: _phoneController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: _phoneController.text.length > 0
                              ? IconButton(
                              onPressed: () {
                                _phoneController.clear();
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
                          hintText: '- 없이 숫자만 입력',
                          hintStyle: TextStyle(
                              color: hexToColor('#CCCCCC'),
                              fontSize: screenWidth*0.038888
                          ),
                          errorText: ValidationFlagForPhoneNum ? '특수문자가 들어갈 수 없습니다.' : null,
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
                          phone_findPw = text;
                          setState(() {

                          });
                          if(_idController.text != null && _nameController.text != null && _phoneController.text != null  &&
                              _idController.text != "" && _nameController.text != "" && _phoneController.text != "") {
                            CheckFlag = true;
                          } else {
                            CheckFlag = false;
                          }
                        },
                      )
                  ),
                ],
              ),
            ),
          ),
            bottomNavigationBar: GestureDetector(
              onTap: (){
                if(CheckFlag) {
                  Email_findPw = _idController.text;
                  Name_findPw = _nameController.text;
                  phone_findPw = _phoneController.text;

                  CertificationData data = CertificationData.fromJson({
                    'merchantUid': merchantUid,
                    'company': '아임포트',                                              // 통신사
                    'name': _nameController.text,                                                 // 이름
                    'phone': _phoneController.text,
                  });
                  Navigator.pushNamed(
                      context,
                      '/certification-pw',
                      arguments: data
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
      ),
    );
  }

  bool Validation_OnlyNumber(String value) {
    String p = r'[$./!@#<>?":_`~;[\]\\|=+)(*&^%]';

    RegExp regExp = new RegExp(p);
    setState(() {
      ValidationFlagForPhoneNum = regExp.hasMatch(value);
    });
    return regExp.hasMatch(value);
  }
}
