import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:mryr/chat/models/ChatDatabase.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mryr/constants/GlobalAsset.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

var globalPhoneNumber;

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  final NameController = TextEditingController();

  final NickNameController = TextEditingController();

  final PhoneNumController = TextEditingController();
  final RedTriangle = 'assets/images/public/RedTriangle.svg';

  AnimationController extendedController;

  bool ValidationFlagForNickName = false;
  bool ValidationFlagForPhoneNum = false;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    NameController.text = GlobalProfile.loggedInUser.name;
    NickNameController.text = GlobalProfile.loggedInUser.nickName;
    PhoneNumController.text = GlobalProfile.loggedInUser.phone;
    // extendedController = AnimationController();
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    extendedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DummyUser _UserProvider = Provider.of<DummyUser>(context);
    //SocketProvider socket = Provider.of<SocketProvider>(context);
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          Text(
                            "마이페이지",
                            style: TextStyle(
                                fontSize: screenWidth * (16 / 360),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(
                                color: Colors.transparent,
                                width: screenWidth,
                                height: screenHeight * (173 / 640),
                                child: Column(
                                  children: [
                                    Container(
                                      width: screenWidth * (336 / 360),
                                      height: screenHeight * (97 / 640),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        boxShadow: [
                                          new BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 4,
                                            offset: Offset(1.5, 1.5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          FlatButton(
                                            onPressed: () {
                                              getImageGallery(context)
                                                  .then((value) {
                                                setState(() {});
                                              });

                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  // 기본 파라미터, SecondRoute로 전달
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyPage(),
                                                  ) // SecondRoute를 생성하여 적재
                                                  );
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: screenHeight *
                                                      (8.6667 / 640),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Icon(
                                                      Icons.image,
                                                      size: 25,
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth *
                                                          (2 / 360),
                                                    ),
                                                    Container(
                                                      height: screenHeight *
                                                          (30 / 640),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                screenHeight *
                                                                    (2 /
                                                                        640)),
                                                        child: Center(
                                                          child: Text(
                                                            "갤러리",
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                        (16 /
                                                                            360),
                                                                color: Color(
                                                                    0xff222222)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: screenHeight *
                                                      (8.6667 / 640),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            height: 1,
                                            color: Color(0xfffafafa),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              getImageCamera(context)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: screenHeight *
                                                      (8.6667 / 640),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                  children: [
                                                    Spacer(),
                                                    Icon(
                                                      Icons.photo_camera,
                                                      size: 25,
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth *
                                                          (2 / 360),
                                                    ),
                                                    Container(
                                                      height: screenHeight *
                                                          (30 / 640),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                screenHeight *
                                                                    (2 /
                                                                        640)),
                                                        child: Center(
                                                          child: Text(
                                                            "카메라",
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                        (16 /
                                                                            360),
                                                                color: Color(
                                                                    0xff222222)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Spacer(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: screenHeight *
                                                      (8.6667 / 640),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: screenWidth,
                                            height: 1,
                                            color: Color(0xfffafafa),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * (8 / 640),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: screenWidth * (336 / 360),
                                        height: screenHeight * (48 / 640),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(1.5, 1.5),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "취소",
                                            style: TextStyle(
                                                fontSize:
                                                    screenWidth * (16 / 360),
                                                color: Color(0xff222222)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * (20 / 640),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        width: screenHeight * (60 / 640),
                        height: screenHeight * (60 / 640),
                        child: Stack(
                          children: [
                            Container(
                              width: screenHeight * (60 / 640),
                              height: screenHeight * (60 / 640),
                              child:
                                  GlobalProfile.loggedInUser.profileUrlList ==
                                          "BasicImage"
                                      ? SvgPicture.asset(
                                          ProfileIconInMoreScreen,
                                          width: screenHeight * (60 / 640),
                                          height: screenHeight * (60 / 640),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              new BorderRadius.circular(4.0),
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: getExtendedImage(
                                                get_resize_image_name(
                                                    GlobalProfile.loggedInUser
                                                        .profileUrlList,
                                                    120),
                                                0,
                                                extendedController),
                                          )),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      new BorderRadius.circular(100.0),
                                  color: kPrimaryColor,
                                ),
                                width: screenHeight * (20 / 640),
                                height: screenHeight * (20 / 640),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CameraIconInMoreScreen,
                                    //width: screenHeight * (10 / 640),
                                    height: screenHeight * (10 / 640),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (4 / 640),
                    ),
                    Text(
                      GlobalProfile.loggedInUser.name == null
                          ? "null"
                          : GlobalProfile.loggedInUser.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          //fontSize: screenHeight * (16 / 640),
                          fontSize: screenWidth * (16 / 360),
                          color: Color(0xff222222)),
                    ),
                    SizedBox(
                      height: screenHeight * (4 / 640),
                    ),
                    Text(
                      GlobalProfile.loggedInUser.id,
                      style: TextStyle(
                          // fontSize: screenHeight * (12 / 640),
                          fontSize: screenWidth * (12 / 360),
                          color: Color(0xff888888)),
                    ),
                    SizedBox(
                      height: screenHeight * (16 / 640),
                    ),
                    Container(
                      // height: screenHeight*0.6375,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.0333333),
                            child: Container(
                              height: screenHeight * 0.55,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.03125,
                                  ),
                                  Text(
                                    "이름",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * (16 / 360),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.0125,
                                  ),
                                  Container(
                                    width: screenWidth * 0.93333,
                                    height: screenHeight * 0.075,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(4.0),
                                      border: Border.all(
                                        color: hexToColor('#CCCCCC'),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.0333333),
                                        child: Text(
                                          GlobalProfile.loggedInUser.name,
                                          style: TextStyle(
                                            fontSize: screenWidth *
                                                0.0388888888888889,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.01875,
                                  ),
                                  Text(
                                    '닉네임',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.044444,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.0125,
                                  ),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.11,
                                        child: TextField(
                                          controller: NickNameController,
                                          textInputAction:
                                              TextInputAction.done,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: true,
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
                                            errorText:
                                                ValidationFlagForNickName
                                                    ? '특수문자가 들어갈 수 없습니다.'
                                                    : null,
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.red),
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        (0.01875 - 0.0030),
                                                color: hexToColor('#F9423A')),
                                          ),
                                          onChanged: (text) {
                                            Validation_NoSpecialChar(text);
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        left: screenWidth * 0.780555,
                                        top: screenHeight * 0.015625,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (!ValidationFlagForNickName) {
                                              EasyLoading.show(
                                                  status: "",
                                                  maskType:
                                                      EasyLoadingMaskType
                                                          .black);
                                              GlobalProfile
                                                      .loggedInUser.nickName =
                                                  NickNameController.text;
                                              var tmp = await ApiProvider().post(
                                                  '/Information/changeNickname',
                                                  jsonEncode({
                                                    "userID": GlobalProfile
                                                        .loggedInUser.userID,
                                                    "nickname": GlobalProfile
                                                        .loggedInUser
                                                        .nickName,
                                                  }));
                                              if(tmp == "7"){
                                                Function okFunc = () async{
                                                  Navigator.pop(context);
                                                };
                                                OKDialog(context,"중복된 닉네임 입니다!","다른 닉네임을 입력해주세요 :D ","확인", okFunc);

                                              }
                                              else{
                                                dialog(context, "닉네임 변경 완료",
                                                    screenWidth, screenHeight);
                                              }

                                              EasyLoading.dismiss();
                                            }
                                          },
                                          child: Container(
                                            width: screenWidth * 0.11944,
                                            height: screenHeight * 0.04375,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '변경',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: screenWidth *
                                                        0.033333,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    '휴대폰 번호',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.044444,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.0125,
                                  ),
                                  Stack(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.11,
                                        child: TextField(
                                          controller: PhoneNumController,
                                          keyboardType: TextInputType.number,
                                          textInputAction:
                                              TextInputAction.done,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: true,
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
                                            hintText: '휴대폰 번호를 인증해주세요.',
                                            hintStyle: TextStyle(
                                                color: hexToColor('#CCCCCC'),
                                                fontSize:
                                                    screenWidth * 0.038888),
                                            errorText:
                                                ValidationFlagForPhoneNum
                                                    ? '특수문자가 들어갈 수 없습니다.'
                                                    : null,
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.red),
                                            ),
                                            errorStyle: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        (0.01875 - 0.0030),
                                                color: hexToColor('#F9423A')),
                                          ),
                                          onChanged: (text) {
                                            Validation_OnlyNumber(text);
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        left: screenWidth * 0.780555,
                                        top: screenHeight * 0.015625,
                                        child: GestureDetector(
                                          onTap: () async {
                                            EasyLoading.show(
                                                status: "",
                                                maskType: EasyLoadingMaskType
                                                    .black);
                                            if (!ValidationFlagForPhoneNum) {
                                              CertificationData data =
                                                  CertificationData.fromJson({
                                                'merchantUid':
                                                    'mid_${DateTime.now().millisecondsSinceEpoch}',
                                                // 주문번호
                                                'company': '아임포트',
                                                // 이름
                                                'phone':
                                                    PhoneNumController.text,
                                              });

                                              globalPhoneNumber =
                                                  PhoneNumController.text;

                                              Navigator.pushNamed(context,
                                                      '/Certiciation_ModifyPhoneNum',
                                                      arguments: data)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            }
                                            EasyLoading.dismiss();
                                          },
                                          child: Container(
                                            width: screenWidth * 0.11944,
                                            height: screenHeight * 0.04375,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                '변경',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: screenWidth *
                                                        0.033333,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.0375,
                    ),
                    Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.025,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel:
                                    MaterialLocalizations.of(context)
                                        .modalBarrierDismissLabel,
                                barrierColor: Colors.black12.withOpacity(0.6),
                                transitionDuration:
                                    Duration(milliseconds: 150),
                                pageBuilder: (BuildContext context,
                                    Animation first, Animation second) {
                                  return Center(
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(8.0)),
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.7222,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3153125,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.025,
                                          ),
                                          SvgPicture.asset(
                                            RedTriangle,
                                            width: screenHeight * 0.0875,
                                            height: screenHeight * 0.0875,
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.00625,
                                          ),
                                          Material(
                                            color: Colors.white,
                                            child: Text(
                                              '정말 로그아웃 하시겠습니까?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth *
                                                      DialogNameFontSize,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Spacer(),
                                          Material(
                                            color: Colors.white,
                                            child: Text(
                                              '이전 채팅 내역은 모두 삭제되며, \n복구할 수 없습니다. 계속 하시겠습니까?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: hexToColor('#888888'),
                                                fontSize: screenWidth *
                                                    DialogContentsFontSize,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              // SizedBox(width: screenWidth*0.011111,),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: screenWidth * 0.3611,
                                                  height: screenHeight *
                                                      (44 / 640),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        hexToColor('#EEEEEE'),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(8)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '취소',
                                                      style: TextStyle(
                                                        color: hexToColor(
                                                            '#888888'),
                                                        fontSize:
                                                            screenWidth *
                                                                0.038888,
                                                        decoration:
                                                            TextDecoration
                                                                .none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //  Spacer(),
                                              GestureDetector(
                                                onTap: () async {
                                                  EasyLoading.show(
                                                      status: "",
                                                      maskType:
                                                          EasyLoadingMaskType
                                                              .black);
                                                  final SharedPreferences
                                                      prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setString(
                                                      'autoLoginKey', null);
                                                  prefs.setString(
                                                      'autoLoginId', null);
                                                  prefs.setString(
                                                      'autoLoginPw', null);
                                                  print("임시 로그아웃 완료");

                                                  ChatDBHelper().dropTable();
                                                  //   socket.disconnect();
                                                  navigationNumProvider
                                                      .setNum(0);

                                                  if (GlobalProfile
                                                          .loggedInUser
                                                          .kakao ==
                                                      true) {
                                                    try {
                                                      var code = await UserApi
                                                          .instance
                                                          .logout();
                                                      print(code.toString());
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  }
                                                  EasyLoading.dismiss();
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          "/LoginScreen",
                                                          (route) => false);
                                                },
                                                child: Container(
                                                  width: screenWidth * 0.3611,
                                                  height: screenHeight *
                                                      (44 / 640),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight:
                                                                Radius
                                                                    .circular(
                                                                        8)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '확인',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            screenWidth *
                                                                0.038888,
                                                        decoration:
                                                            TextDecoration
                                                                .none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              '로그아웃',
                              style: TextStyle(
                                fontSize: screenWidth * 0.0305,
                                color: hexToColor('#888888'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.033333,
                          ),
                          Text(
                            '|',
                            style: TextStyle(
                              fontSize: screenWidth * 0.0305,
                              color: hexToColor('#888888'),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.033333,
                          ),
                          GestureDetector(
                            onTap: () async {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel:
                                    MaterialLocalizations.of(context)
                                        .modalBarrierDismissLabel,
                                barrierColor: Colors.black12.withOpacity(0.6),
                                transitionDuration:
                                    Duration(milliseconds: 150),
                                pageBuilder: (BuildContext context,
                                    Animation first, Animation second) {
                                  return Center(
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.all(
                                            new Radius.circular(8.0)),
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.7222,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3153125,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.025,
                                          ),
                                          SvgPicture.asset(
                                            RedTriangle,
                                            width: screenHeight * 0.0875,
                                            height: screenHeight * 0.0875,
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.00625,
                                          ),
                                          Material(
                                            color: Colors.white,
                                            child: Text(
                                              '정말 회원탈퇴 하시겠습니까?',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth *
                                                      DialogNameFontSize,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Spacer(),
                                          Material(
                                            color: Colors.white,
                                            child: Text(
                                              '모든 정보가 삭제되며, \n복구할 수 없습니다. 계속 하시겠습니까?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: hexToColor('#888888'),
                                                fontSize: screenWidth *
                                                    DialogContentsFontSize,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              // SizedBox(width: screenWidth*0.011111,),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  width: screenWidth * 0.3611,
                                                  height: screenHeight *
                                                      (44 / 640),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        hexToColor('#EEEEEE'),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(8)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '취소',
                                                      style: TextStyle(
                                                        color: hexToColor(
                                                            '#888888'),
                                                        fontSize:
                                                            screenWidth *
                                                                0.038888,
                                                        decoration:
                                                            TextDecoration
                                                                .none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //  Spacer(),
                                              GestureDetector(
                                                onTap: () async {
                                                  var tmp =
                                                      await ApiProvider()
                                                          .post(
                                                              '/User/Signout',
                                                              jsonEncode({
                                                                "userID": GlobalProfile
                                                                    .loggedInUser
                                                                    .userID,
                                                              }));
                                                  if (tmp == true) {
                                                    EasyLoading.show(
                                                        status: "",
                                                        maskType:
                                                            EasyLoadingMaskType
                                                                .black);
                                                    final SharedPreferences
                                                        prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    prefs.setString(
                                                        'autoLoginKey', null);
                                                    prefs.setString(
                                                        'autoLoginId', null);
                                                    prefs.setString(
                                                        'autoLoginPw', null);
                                                    print("임시 로그아웃 완료");

                                                    ChatDBHelper()
                                                        .dropTable();
                                                    //   socket.disconnect();
                                                    navigationNumProvider
                                                        .setNum(0);

                                                    if (GlobalProfile
                                                            .loggedInUser
                                                            .kakao ==
                                                        true) {
                                                      try {
                                                        var code =
                                                            await UserApi
                                                                .instance
                                                                .logout();
                                                        print(
                                                            code.toString());
                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    }
                                                    EasyLoading.dismiss();
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            "/LoginScreen",
                                                            (route) => false);
                                                  }
                                                  else{

                                                  }
                                                },
                                                child: Container(
                                                  width: screenWidth * 0.3611,
                                                  height: screenHeight *
                                                      (44 / 640),
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight:
                                                                Radius
                                                                    .circular(
                                                                        8)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '확인',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            screenWidth *
                                                                0.038888,
                                                        decoration:
                                                            TextDecoration
                                                                .none,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text(
                              '회원탈퇴',
                              style: TextStyle(
                                fontSize: screenWidth * 0.0305,
                                color: hexToColor('#888888'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                isLoading
                    ? SpinKitRotatingCircle(
                        color: kPrimaryColor,
                        size: 50.0,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImageGallery(BuildContext context) async {
    var imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery); //camera
    print(imageFile);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(100000);
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image,
        width: (image.width * 0.7).toInt(),
        height: (image.height * 0.7.toInt()));
    var compressImg =
        new File("$path/" + GlobalProfile.loggedInUser.id + "_image_$rand.jpg")
          ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));

    GlobalProfile.loggedInUser;
    Dio dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'user': 'codeforgeek'
    };
    FormData formData = new FormData.fromMap({
      "userID": GlobalProfile.loggedInUser.userID,
      "img": await MultipartFile.fromFile(compressImg.path,
          filename: GlobalProfile.loggedInUser.userID.toString() +
              "_image_$rand.jpeg"),
    });
    var response = await dio.post(
        ApiProvider().getUrl + "/Information/S3addProfilePhoto",
        data: formData).timeout(const Duration(seconds: 17));

    User1 tmp = User1.fromJson(response.data);
    GlobalProfile.loggedInUser.profileUrlList = tmp.profileUrlList;
    setState(() {});
    return;
  }

  Future getImageCamera(BuildContext context) async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image,
        width: (image.width * 0.7).toInt(),
        height: (image.height * 0.7.toInt()));

    var compressImg =
        new File("$path/" + GlobalProfile.loggedInUser.id + "_image_$rand.jpg")
          ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));

    Dio dio = new Dio();
    dio.options.headers = {
      'Content-Type': 'application/json',
      'user': 'codeforgeek'
    };

    FormData formData = new FormData.fromMap({
      "userID": GlobalProfile.loggedInUser.userID,
      "img": await MultipartFile.fromFile(compressImg.path,
          filename: GlobalProfile.loggedInUser.userID.toString() +
              "_image_$rand.jpeg"),
    });
    var response = await dio.post(
        ApiProvider().getUrl + "/Information/S3addProfilePhoto",
        data: formData).timeout(const Duration(seconds: 17));

    User1 tmp = User1.fromJson(response.data);
    GlobalProfile.loggedInUser.profileUrlList = tmp.profileUrlList;
    setState(() {});
    return;
  }

  bool Validation_NoSpecialChar(String value) {
    String p = r'[$./!@#<>?":_`~;[\]\\|=+)(*&^%]';

    RegExp regExp = new RegExp(p);
    setState(() {
      ValidationFlagForNickName = regExp.hasMatch(value);
    });
    return regExp.hasMatch(value);
  }

  bool Validation_OnlyNumber(String value) {
    String p = r'[$./!@#<>?":_`~;[\]\\|=+)(*&^%]';

    RegExp regExp = new RegExp(p);
    setState(() {
      ValidationFlagForPhoneNum = regExp.hasMatch(value);
    });
    return regExp.hasMatch(value);
  }

  void dialog(BuildContext context, String text, double screenWidth,
      double screenHeight) {
    showDialog(
        barrierColor: Color(0x01000000),
        context: context,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 1000), () {
            Navigator.of(context).pop(true);
          });

          return Material(
            type: MaterialType.transparency,
            child: Center(
              // Aligns the container to center
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * (400 / 640)),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xff707070),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                  width: 200.0,
                  height: 32.0,
                  child: Center(
                      child: Text(
                    '$text',
                    style: TextStyle(
                        fontSize: screenWidth * (12 / 360),
                        color: Colors.white),
                  )),
                ),
              ),
            ),
          );
        });
  }
}
