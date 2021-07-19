import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';

class AskScreen extends StatefulWidget {

  AskScreen({Key key}) : super(key : key);

  @override

  _AskScreenState createState() => _AskScreenState();

}

class _AskScreenState extends State<AskScreen> {
  final pNumController = TextEditingController();
  final AskController = TextEditingController();

  @override
  void initState() {
    if(null != GlobalProfile.loggedInUser.phone) {
      pNumController.text = GlobalProfile.loggedInUser.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: (){
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
            backgroundColor: hexToColor("#FFFFFF"),
            elevation: 0.0,
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth*0.033333, 0, 0, 0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    backArrow,
                    width: screenWidth * 0.057777,
                    height: screenWidth * 0.057777,
                  ),
                ),
              ),
            ),
            title: SvgPicture.asset(
              MryrLogo,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight*0.03125,),
                  Text(
                    '문의 내용',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: screenHeight*0.025,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(
                    height: screenHeight*0.0125,
                  ),
                  TextField(
                    controller: AskController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    maxLines: 14,
                    maxLength: 500,
                    maxLengthEnforced: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: '문의 할 내용을 적어주세요. (최대 500자)',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                      ),
                    ),
                    onChanged: (text){
                      setState(() {

                      });
                    },
                  ),
                  heightPadding(screenHeight,12),
                  Text(
                    '답변 받으실 휴대폰 번호를 적어주세요',
                    style: TextStyle(
                      fontSize: screenWidth*(16/360),
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  heightPadding(screenHeight,8),
                  SizedBox(
                    height: screenHeight * 0.11,
                    child: TextField(
                      controller: pNumController,
                      textInputAction: TextInputAction.done,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],

                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: "-를 제외한 숫자만 입력해주세요.",
                        hintStyle: TextStyle(
                          fontSize: screenWidth*(14/360),
                          color: hexToColor('#D2D2D2'),
                        ),
                        contentPadding:
                        EdgeInsets.fromLTRB(
                            screenWidth * 0.0333333,
                            screenHeight * 0.0234375,
                            0,
                            screenHeight * 0.0234375),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1,
                              color: kPrimaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1,
                              color: hexToColor(
                                  ("#CCCCCC"))),
                        ),
                      ),
                      onChanged: (text) {
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: ()async{//OKDialog(context, "입주 날짜부터 입력해주세요!", "", "알겠어요!",okFunc);
              if(AskController.text =="") {

              }else {
                Function okFunc = () async{
                  EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                  var res = await ApiProvider().post('/ReportWrite/Question',jsonEncode({
                    "userID" : GlobalProfile.loggedInUser.userID,
                    "contents" : AskController.text,
                    "phone":pNumController.text,
                  }));
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                  Navigator.pop(context);

                };

                OKDialog(context, "문의하신 내용이 접수되었습니다.", "문의주신 내용에 대해\n빠르게 답변드리겠습니다 :)", "확인",okFunc);
              }

            },
            child: Container(
                height: screenHeight*0.09375,
                decoration: BoxDecoration(
                  color: AskController.text ==""? Color(0xffcccccc): kPrimaryColor,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '앱에 문의하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight*0.025,
                    ),
                  ),
                )
            ),
          ),
      ),
          ),
    );
  }
}




