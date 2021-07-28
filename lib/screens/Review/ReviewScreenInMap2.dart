import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kopo/kopo.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/main.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/Review/ReviewScreenInMap5_phone.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/utils/CustomTextInputFormatter.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:geocoder/geocoder.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

class ReviewScreenInMap2 extends StatefulWidget {
  @override
  _ReviewScreenInMap2State createState() => _ReviewScreenInMap2State();
}

class _ReviewScreenInMap2State extends State<ReviewScreenInMap2> {
  int currentPage = 0;

  int type = -1;
  String location = "주소를 검색해주세요";
  final locationdetail = TextEditingController();
  final monthlyrentfees = TextEditingController();
  final depositfees = TextEditingController();
  final managementfees = TextEditingController();
  final utilityfees = TextEditingController();
  int starrating=0;
  int hownoise=-1;
  final noisedetail = TextEditingController();
  int howbug=-1;
  final bugdetail = TextEditingController();
  int howkind=-1;
  final kinddetail = TextEditingController();
  final infodetail = TextEditingController();
  List<File> Images = [];

  bool roomPictureCheckBox = false;
  var color1 = false;
  var color2 = false;
  var color3 = false;
  var color4 = false;
  var color5 = false;
  bool review_1_1 = false;
  bool review_1_2 = false;
  bool review_1_3 = false;
  bool review_2_1 = false;
  bool review_2_2 = false;
  bool review_2_3 = false;
  bool review_3_1 = false;
  bool review_3_2 = false;
  bool review_3_3 = false;
  String rentStart;
  String rentDone;
  ScrollController c;
  var starColor = Color(0xffeeeeee);
  List<Map<String, String>> reviewData = [
    {
      "title": "집 주변이 시끄러웠나요?",
      "text1": "조용했어요",
      "text2": "보통이었어요",
      "text3": "시끄러웠어요",
    },
    {
      "title": "집에 벌레가 있었나요?",
      "text1": "벌레가 없었어요",
      "text2": "보통이었어요",
      "text3": "벌레가 많이 나왔어요",
    },
    {
      "title": "집주인이 친절했나요?",
      "text1": "친절했어요",
      "text2": "보통이었어요",
      "text3": "불친절했어요",
    },
  ];

  bool isReady = true;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  KeyboardActionsItem returnKeyboardActionItem(FocusNode item) {
    return KeyboardActionsItem(
      focusNode: item,
      onTapAction: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          returnKeyboardActionItem(_nodeText1),
          returnKeyboardActionItem(_nodeText2),
          returnKeyboardActionItem(_nodeText3),
          returnKeyboardActionItem(_nodeText4),
        ]
    );
  }

  @override
  void initState() {
    super.initState();
    c = new PageController();
  }

  final _controller = TextEditingController();
  static const _locale = 'kr';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale : _locale).currencySymbol;


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return currentPage == 0
        ? typeLocationBaseinfo(context, screenHeight, screenWidth)
        : currentPage == 9
        ? term(context, screenHeight, screenWidth)
        :  currentPage == 1
        ? roomPictures(context, screenHeight, screenWidth)
        : noiseBugKindDetail(context, screenHeight, screenWidth);
  }

  WillPopScope typeLocationBaseinfo(
      BuildContext context, double screenHeight, double screenWidth) {
    return WillPopScope(
      onWillPop: () {},
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
                    Navigator.of(context).pop();
                  }),
              title: SvgPicture.asset(
                MryrLogoInReleaseRoomTutorialScreen,
                width: screenHeight * (110 / 640),
                height: screenHeight * (27 / 640),
              ),
              centerTitle: true,
            ),
            body: KeyboardActions(
              config: _buildConfig(context),
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
                              "매물 종류 선택",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * (24 / 640),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Text(
                              "살았던 매물의 종류를 선택해주세요",
                              style: TextStyle(
                                color: Color(0xff888888),
                                fontSize: screenHeight * (12 / 640),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (36 / 640),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (type == 0)
                                      type = -1;
                                    else
                                      type = 0;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (164 / 360),
                                    height: screenHeight * (48 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:type == 0
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),

                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (8 / 360),
                                          ),
                                          SvgPicture.asset(
                                            OneRoomInReleaseRoomScreen,
                                            color: type == 0
                                                ? kPrimaryColor
                                                : Colors.black,
                                            width: screenHeight * (24 / 640),
                                            height: screenHeight * (24 / 640),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (12 / 360),
                                          ),
                                          Text(
                                            "원룸",
                                            style: TextStyle(
                                              fontSize: screenHeight * (12 / 640),
                                              color: type == 0? kPrimaryColor
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * (8 / 360),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (type == 1)
                                      type = -1;
                                    else
                                      type = 1;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (164 / 360),
                                    height: screenHeight * (48 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:type == 1
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),

                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (8 / 360),
                                          ),
                                          SvgPicture.asset(
                                            TwoRoomInReleaseRoomScreen,
                                            color: type == 1
                                                ? kPrimaryColor
                                                : Colors.black,
                                            width: screenHeight * (24 / 640),
                                            height: screenHeight * (24 / 640),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (12 / 360),
                                          ),
                                          Text(
                                            "투룸 이상",
                                            style: TextStyle(
                                              fontSize: screenHeight * (12 / 640),
                                              color: type == 1
                                                  ? kPrimaryColor
                                                  : Colors.black,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (type == 2)
                                      type = -1;
                                    else
                                      type = 2;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (164 / 360),
                                    height: screenHeight * (48 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:type == 2
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),

                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (8 / 360),
                                          ),
                                          SvgPicture.asset(
                                            OpInReleaseRoomScreen,
                                            color: type == 2
                                                ? kPrimaryColor
                                                : Colors.black,
                                            width: screenHeight * (24 / 640),
                                            height: screenHeight * (24 / 640),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (12 / 360),
                                          ),
                                          Text(
                                            "오피스텔",
                                            style: TextStyle(
                                              fontSize: screenHeight * (12 / 640),
                                              color: type == 2
                                                  ? kPrimaryColor
                                                  : Colors.black,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * (8 / 360),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (type == 3)
                                      type = -1;
                                    else
                                      type = 3;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (164 / 360),
                                    height: screenHeight * (48 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:type == 3
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),

                                    child: Center(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (8 / 360),
                                          ),
                                          SvgPicture.asset(
                                            AptInReleaseRoomScreen,
                                            color:type == 3
                                                ? kPrimaryColor
                                                : Colors.black,
                                            width: screenHeight * (24 / 640),
                                            height: screenHeight * (24 / 640),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (12 / 360),
                                          ),
                                          Text(
                                            "아파트",
                                            style: TextStyle(
                                              fontSize: screenHeight * (12 / 640),
                                              color:type == 3
                                                  ? kPrimaryColor
                                                  : Colors.black,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * (40 / 640),
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight * (20 / 640),
                      color: Color(0xfff8f8f8),
                    ),
                    SizedBox(
                      height: screenHeight * (20 / 640),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "매물 위치 입력",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * (24 / 640),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "건물의 위치를 입력해주세요 (상세주소는 생략 가능합니다)",
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: screenHeight * (12 / 640),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * (36 / 640),
                    ),
                    GestureDetector(
                      onTap: () async {
                        KopoModel model = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Kopo(),
                          ),
                        );
                        setState(() {
                          location =
                          '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}'; // ${model.zonecode} ';
                        });
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (16 / 360),
                          ),
                          Text(
                            '$location',
                            style: TextStyle(
                                fontSize: screenWidth * (14 / 360),
                                color: location == "주소를 검색해주세요"
                                    ? Color(0xff928E8E)
                                    : Colors.black),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            GreyMagnifyingGlass,
                            width: screenHeight * 0.025,
                            height: screenHeight * 0.025,
                          ),
                          SizedBox(
                            width: screenWidth * (20 / 360),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Container(
                      width: screenWidth * (328 / 360),
                      height: 1,
                      color: Color(0xffcccccc),
                    ),
                    Container(
                      width: screenWidth * (328 / 360),
                      child: TextField(
                        controller: locationdetail,
                        textInputAction: TextInputAction.done,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          /* enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffe7e7e7)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffe7e7e7)),
                        ),*/
                          hintText: "상세 주소를 입력하세요",
                          hintStyle: TextStyle(fontSize: screenWidth * (14 / 360)),
                          labelStyle: new TextStyle(color: const Color(0xFF424242)),
                          // isDense: true,
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * (40 / 640),
                      color: Color(0xffffffff),
                    ),
                    Container(
                      height: screenHeight * (20 / 640),
                      color: Color(0xfff8f8f8),
                    ),
                    SizedBox(
                      height: screenHeight * (20 / 640),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "기본 정보",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenHeight * (24 / 640),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Text(
                          "매물의 기본적인 정보를 입력해주세요",
                          style: TextStyle(
                            color: Color(0xff888888),
                            fontSize: screenHeight * (12 / 640),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * (36 / 640),
                    ),
                    Container(
                      height: 1,
                      color: Color(0xfff8f8f8),
                    ),
                    Container(
                      height: screenHeight * (160 / 640),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              Container(
                                  width: screenWidth * (124 / 360),
                                  height: screenHeight * (30 / 640),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "기존 월세",
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff222222)),
                                      ),
                                    ],
                                  )),
                              Padding(

                                padding: Platform.isIOS? EdgeInsets.only(bottom:4.0):EdgeInsets.only(top:0.0),
                                child: Container(
                                    width: screenWidth * (80 / 360),
                                    height: screenHeight * (30 / 640),
                                    child: TextField(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * (14 / 360),
                                        color: hexToColor("#222222"),
                                      ),
                                      textAlign: TextAlign.center,
                                      inputFormatters: <TextInputFormatter> [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      focusNode: _nodeText1,

                                      controller: monthlyrentfees,
                                      decoration: InputDecoration(
                                        hintText: '50',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * (14 / 360),
                                          color: hexToColor("#cccccc"),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    )),
                              ),
                              Container(
                                height: screenHeight * (30 / 640),
                                child: Column(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "만원",

                                      style: TextStyle(
                                          fontSize: screenWidth * (12 / 360),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 1,
                            color: Color(0xfff8f8f8),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              Container(
                                  width: screenWidth * (124 / 360),
                                  height: screenHeight * (30 / 640),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "기존 보증금",
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff222222)),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: Platform.isIOS? EdgeInsets.only(bottom:4.0):EdgeInsets.only(top:0.0),
                                child: Container(
                                    width: screenWidth * (80 / 360),
                                    height: screenHeight * (30 / 640),
                                    child: TextField(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * (14 / 360),
                                        color: hexToColor("#222222"),
                                      ),
                                      textAlign: TextAlign.center,
                                      inputFormatters: <TextInputFormatter> [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      focusNode: _nodeText2,

                                      controller: depositfees,
                                      decoration: InputDecoration(
                                        hintText: '500',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * (14 / 360),
                                          color: hexToColor("#cccccc"),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    )),
                              ),
                              Text(
                                "만원",
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 1,
                            color: Color(0xfff8f8f8),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              Container(
                                  width: screenWidth * (124 / 360),
                                  height: screenHeight * (30 / 640),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "관리비",
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff222222)),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: Platform.isIOS? EdgeInsets.only(bottom:4.0):EdgeInsets.only(top:0.0),
                                child: Container(
                                    width: screenWidth * (80 / 360),
                                    height: screenHeight * (30 / 640),
                                    child: TextField(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * (14 / 360),
                                        color: hexToColor("#222222"),
                                      ),
                                      textAlign: TextAlign.center,
                                      inputFormatters: <TextInputFormatter> [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      focusNode: _nodeText3,

                                      controller: managementfees,
                                      decoration: InputDecoration(
                                        hintText: '5',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * (14 / 360),
                                          color: hexToColor("#cccccc"),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    )),
                              ),
                              Text(
                                "만원",
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            height: 1,
                            color: Color(0xfff8f8f8),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * (12 / 360),
                              ),
                              Container(
                                  width: screenWidth * (124 / 360),
                                  height: screenHeight * (30 / 640),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "평균 공과금",
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff222222)),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: Platform.isIOS? EdgeInsets.only(bottom:4.0):EdgeInsets.only(top:0.0),
                                child: Container(
                                    width: screenWidth * (80 / 360),
                                    height: screenHeight * (30 / 640),
                                    child: TextField(
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * (14 / 360),
                                        color: hexToColor("#222222"),
                                      ),
                                      textAlign: TextAlign.center,
                                      inputFormatters: <TextInputFormatter> [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      keyboardType: TextInputType.number,
                                      focusNode: _nodeText4,

                                      controller: utilityfees,
                                      decoration: InputDecoration(
                                        hintText: '3',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * (14 / 360),
                                          color: hexToColor("#cccccc"),
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    )),
                              ),
                              Text(
                                "만원",
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Container(
                      height: screenHeight * (20 / 640),
                      color: Color(0xfff8f8f8),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                if (checkTypeLocationBaseinfo() == true) {
                  currentPage = 9;
                  setState(() {});
                } else {
                  print("error!!!!!!!!!!!!!!!!!!!!!!!");
                }
              },
              child: Container(
                width: screenWidth,
                height: screenHeight * (60 / 640),
                color: checkTypeLocationBaseinfo() == true
                    ? kPrimaryColor
                    : Color(0xffcccccc),
                //((one==true||two==true||op==true||apt==true))?kPrimaryColor:Color(0xffcccccc),
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


  WillPopScope term(
      BuildContext context, double screenHeight, double screenWidth) {
    return WillPopScope(
      onWillPop: () {},
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
                    currentPage =0;
                    setState(() {

                    });
                  }),
              title: SvgPicture.asset(
                MryrLogoInReleaseRoomTutorialScreen,
                width: screenHeight * (110 / 640),
                height: screenHeight * (27 / 640),
              ),
              centerTitle: true,
            ),
            body: KeyboardActions(
              config: _buildConfig(context),
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
                              "거주 기간",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenHeight * (24 / 640),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Text(
                              "자취방에 거주했던 기간을 입력해주세요",
                              style: TextStyle(
                                color: Color(0xff888888),
                                fontSize: screenHeight * (12 / 640),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * (36 / 640),
                            ),
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: screenWidth * (336 / 360),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          // SizedBox(width: screenWidth*(20/360),),
                                          GestureDetector(
                                            onTap: (){
                                              DatePicker.showDatePicker(context,
                                                  showTitleActions: true,
                                                  minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                                                  //시작 날짜가 끝 날짜를 넘지 못하도록
                                                  maxTime: rentDone != null ? DateTime(DateFormat('y.MM.d').parse(rentDone).year, DateFormat('y.MM.d').parse(rentDone).month,DateFormat('y.MM.d').parse(rentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                                  theme: DatePickerTheme(
                                                      headerColor: Colors.white,
                                                      backgroundColor: Colors.white,
                                                      itemStyle: TextStyle(
                                                          color: Colors.black, fontSize: 18),
                                                      doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                                  onChanged: (date) {

                                                    rentStart = (DateFormat('y.MM.d').format(date));
                                                  },
                                                  currentTime: DateTime.now(), locale: LocaleType.ko);
                                              CheckForProposeTerm(rentStart,rentDone);
                                            },
                                            child: Container(
                                              width: screenWidth * (120 / 360),
                                              child: Center(
                                                child: Text(
                                                  rentStart == null ? "입주" :rentStart,
                                                  style: TextStyle(
                                                    fontSize: screenWidth * (20 / 360),
                                                    fontWeight: FontWeight.bold,
                                                    color: rentStart == null ? hexToColor('#CCCCCC') : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (55 / 640),
                                          ),
                                          Text(
                                            "~",
                                            style: TextStyle(
                                                fontSize: screenWidth * (20 / 360),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (55 / 640),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              if(rentStart == null) {
                                                Function okFunc = () {
                                                  Navigator.pop(context);
                                                };
                                                OKDialog(context, "입주 날짜부터 입력해주세요!", "", "알겠어요!",okFunc);
                                              }
                                              else {
                                                DatePicker.showDatePicker(context,
                                                    showTitleActions: true,
                                                    //끝날짜가 시작날짜를 넘지 않도록
                                                    minTime: rentStart != null ? DateTime(DateFormat('y.MM.d').parse(rentStart).year, DateFormat('y.MM.d').parse(rentStart).month,DateFormat('y.MM.d').parse(rentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                                    maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                                    theme: DatePickerTheme(
                                                        headerColor: Colors.white,
                                                        backgroundColor: Colors.white,
                                                        itemStyle: TextStyle(
                                                            color: Colors.black, fontSize: 18),
                                                        doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                                    onChanged: (date) {
                                                      rentDone = (DateFormat('y.MM.d').format(date));
                                                    },
                                                    currentTime: DateTime.now(), locale: LocaleType.ko);
                                                CheckForProposeTerm(rentStart, rentDone);
                                              }
                                            },
                                            child: Container(
                                              width: screenWidth * (120 / 360),
                                              child: Center(
                                                child: Text(
                                                  rentDone == null ? "퇴실" :rentDone,
                                                  style: TextStyle(
                                                    fontSize: screenWidth * (20 / 360),
                                                    fontWeight: FontWeight.bold,
                                                    color: rentDone == null ? hexToColor('#CCCCCC') : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * (336 / 360),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          // SizedBox(width: screenWidth*(20/360),),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom:9.0),
                                            child: Container(
                                              width: screenWidth * (120 / 360),
                                              height: 1,
                                              color:  rentStart == null ?  hexToColor('#CCCCCC') : Colors.black,

                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (55 / 640),
                                          ),
                                          Text(
                                            "~",
                                            style: TextStyle(
                                              color: Colors.transparent,
                                                fontSize: screenWidth * (20 / 360),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: screenWidth * (55 / 640),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom:9.0),
                                            child: Container(
                                              width: screenWidth * (120 / 360),
                                              height: 1,
                                              color:  rentDone == null ?  hexToColor('#CCCCCC') : Colors.black,
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () {
                if (rentStart != null && rentDone != null) {
                  currentPage =1;
                  setState(() {});
                } else {
                  print("error!!!!!!!!!!!!!!!!!!!!!!!");
                }
              },
              child: Container(
                width: screenWidth,
                height: screenHeight * (60 / 640),
                color: rentStart != null && rentDone != null
                    ? kPrimaryColor
                    : Color(0xffcccccc),
                //((one==true||two==true||op==true||apt==true))?kPrimaryColor:Color(0xffcccccc),
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

  WillPopScope roomPictures(
      BuildContext context, double screenHeight, double screenWidth) {
    return WillPopScope(
      onWillPop: () {},
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  currentPage = 9;
                  setState(() {});
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
                        Row(
                          children: [
                            Text(
                              "방 사진 추가",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (24 / 360),
                                  color: roomPictureCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff222222)),
                            ),
                            SizedBox(
                              width: screenWidth * (8 / 360),
                            ),
                            Container(
                              width: screenWidth * (20 / 360),
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: kPrimaryColor,
                                value: roomPictureCheckBox,
                                onChanged: (bool value) {
                                  setState(() {
                                    roomPictureCheckBox = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * (4 / 360),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: screenHeight * (1.5 / 640)),
                              child: Text(
                                "건너뛰기",
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    color: roomPictureCheckBox == true
                                        ? kPrimaryColor
                                        : Color(0xffE9E8E6)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * (8 / 640),
                        ),
                        Text(
                          "침대, 책상이 나오도록 사진을 찍어주세요.",
                          style: TextStyle(
                            color: roomPictureCheckBox == true
                                ? Color(0xffE9E8E6)
                                : Color(0xff888888),
                            fontSize: screenHeight * (12 / 640),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * (40 / 640),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: screenHeight * (180 / 640),
                      height: screenHeight * (180 / 640),
                      child: Stack(
                        children: [
                          Images.length == 0
                              ? Container(
                            width: screenHeight * (180 / 640),
                            height: screenHeight * (180 / 640),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Color(0xffE5E5E5),
                                  width: 1,
                                )),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(gallary,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                      color: roomPictureCheckBox == true
                                          ? Color(0xffE9E8E6)
                                          : Color(0xff222222)),
                                  SizedBox(
                                    height: screenHeight * (8 / 640),
                                  ),
                                  Text(
                                    '사진 추가하기',
                                    style: TextStyle(
                                        fontSize: screenWidth * (12 / 360),
                                        color: roomPictureCheckBox == true
                                            ? Color(0xffE9E8E6)
                                            : Color(0xff888888)),
                                  )
                                ],
                              ),
                            ),
                          )
                              : Container(
                            width: screenHeight * (180 / 640),
                            height: screenHeight * (180 / 640),
                            decoration: BoxDecoration(
                                color: hexToColor("#EEEEEE"),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                    colorFilter: new ColorFilter.mode(
                                        roomPictureCheckBox == true
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                    image: FileImage(Images[0]),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                Row(
                  children: [
                    Spacer(),
                    Images.length == 0
                        ? Container(
                      height: screenHeight * (25 / 640),
                    )
                        : Container(
                        height: screenHeight * (25 / 640),
                        child: Text(
                          "대표사진 (첫번째 사진)",
                          style: TextStyle(
                              fontSize: screenWidth * (12 / 360),
                              fontWeight: FontWeight.bold,
                              color: roomPictureCheckBox == true
                                  ? Color(0xffE9E8E6)
                                  : kPrimaryColor),
                        )),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (26 / 640),
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: screenWidth * (60 / 360),
                      height: screenWidth * (60 / 360),
                      child: Stack(
                        children: [
                          Images.length < 1
                              ? GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight);
                                setState(() {

                                });
                              }
                            },
                            child: Container(
                              width: screenWidth * (60 / 360),
                              height: screenWidth * (60 / 360),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xffeeeeee),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Color(0xffcccccc),
                                      size: screenWidth * (16 / 360),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                BottomSheetMoreScreen2(
                                    context, screenWidth, screenHeight, 0);
                                setState(() {});
                              }
                            },
                            child: Container(
                              width: screenHeight * (180 / 640),
                              height: screenHeight * (180 / 640),
                              decoration: BoxDecoration(
                                  color: hexToColor("#EEEEEE"),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          roomPictureCheckBox == true
                                              ? Colors.black
                                              .withOpacity(0.4)
                                              : Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      image: FileImage(Images[0]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                      width: screenWidth * (60 / 360),
                      height: screenWidth * (60 / 360),
                      child: Stack(
                        children: [
                          Images.length < 2
                              ? GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                if (Images.length == 0) {
                                  dialog(context, "대표사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else {
                                  BottomSheetMoreScreen(
                                      context, screenWidth, screenHeight);
                                  setState(() {

                                  });
                                }
                              }
                            },
                            child: Container(
                              width: screenWidth * (60 / 360),
                              height: screenWidth * (60 / 360),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xffeeeeee),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Color(0xffcccccc),
                                      size: screenWidth * (16 / 360),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                BottomSheetMoreScreen2(
                                    context, screenWidth, screenHeight, 1);
                                setState(() {

                                });
                              }
                            },
                            child: Container(
                              width: screenHeight * (180 / 640),
                              height: screenHeight * (180 / 640),
                              decoration: BoxDecoration(
                                  color: hexToColor("#EEEEEE"),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          roomPictureCheckBox == true
                                              ? Colors.black
                                              .withOpacity(0.4)
                                              : Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      image: FileImage(Images[1]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                      width: screenWidth * (60 / 360),
                      height: screenWidth * (60 / 360),
                      child: Stack(
                        children: [
                          Images.length < 3
                              ? GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                if (Images.length == 0) {
                                  dialog(context, "대표사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else if (Images.length == 1) {
                                  dialog(context, "화장실사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else {
                                  BottomSheetMoreScreen(
                                      context, screenWidth, screenHeight);
                                  setState(() {

                                  });
                                }
                              }
                            },
                            child: Container(
                              width: screenWidth * (60 / 360),
                              height: screenWidth * (60 / 360),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xffeeeeee),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Color(0xffcccccc),
                                      size: screenWidth * (16 / 360),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                BottomSheetMoreScreen2(
                                    context, screenWidth, screenHeight, 2);
                                setState(() {

                                });
                              }
                            },
                            child: Container(
                              width: screenHeight * (180 / 640),
                              height: screenHeight * (180 / 640),
                              decoration: BoxDecoration(
                                  color: hexToColor("#EEEEEE"),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          roomPictureCheckBox == true
                                              ? Colors.black
                                              .withOpacity(0.4)
                                              : Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      image: FileImage(Images[2]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                      width: screenWidth * (60 / 360),
                      height: screenWidth * (60 / 360),
                      child: Stack(
                        children: [
                          Images.length < 4
                              ? GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                if (Images.length == 0) {
                                  dialog(context, "대표사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else if (Images.length == 1) {
                                  dialog(context, "화장실사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else if (Images.length == 2) {
                                  dialog(context, "부엌사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else {
                                  BottomSheetMoreScreen(
                                      context, screenWidth, screenHeight);
                                  setState(() {

                                  });
                                }
                              }
                            },
                            child: Container(
                              width: screenWidth * (60 / 360),
                              height: screenWidth * (60 / 360),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xffeeeeee),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Color(0xffcccccc),
                                      size: screenWidth * (16 / 360),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                BottomSheetMoreScreen2(
                                    context, screenWidth, screenHeight, 3);
                                setState(() {

                                });
                              }
                            },
                            child: Container(
                              width: screenHeight * (180 / 640),
                              height: screenHeight * (180 / 640),
                              decoration: BoxDecoration(
                                  color: hexToColor("#EEEEEE"),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          roomPictureCheckBox == true
                                              ? Colors.black
                                              .withOpacity(0.4)
                                              : Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      image: FileImage(Images[3]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                      width: screenWidth * (60 / 360),
                      height: screenWidth * (60 / 360),
                      child: Stack(
                        children: [
                          Images.length < 5
                              ? GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                if (Images.length == 0) {
                                  dialog(context, "대표사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else if (Images.length == 1) {
                                  dialog(context, "화장실사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else if (Images.length == 2) {
                                  dialog(context, "부엌사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else if (Images.length == 3) {
                                  dialog(context, "방1사진을 넣어주세요",
                                      screenWidth, screenHeight);
                                } else {
                                  BottomSheetMoreScreen(
                                      context, screenWidth, screenHeight);
                                  setState(() {

                                  });
                                }
                              }
                            },
                            child: Container(
                              width: screenWidth * (60 / 360),
                              height: screenWidth * (60 / 360),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xffeeeeee),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Color(0xffcccccc),
                                      size: screenWidth * (16 / 360),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                              : GestureDetector(
                            onTap: () {
                              if (roomPictureCheckBox == false) {
                                BottomSheetMoreScreen2(
                                    context, screenWidth, screenHeight, 4);
                                setState(() {

                                });
                              }
                            },
                            child: Container(
                              width: screenHeight * (180 / 640),
                              height: screenHeight * (180 / 640),
                              decoration: BoxDecoration(
                                  color: hexToColor("#EEEEEE"),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          roomPictureCheckBox == true
                                              ? Colors.black
                                              .withOpacity(0.4)
                                              : Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      image: FileImage(Images[4]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (6 / 640),
                ),
                Row(
                  children: [
                    Spacer(),
                    Container(
                        width: screenWidth * (60 / 360),
                        child: Center(
                            child: Text(
                              "대표사진",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 360),
                                  color: roomPictureCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff888888)),
                            ))),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                        width: screenWidth * (60 / 360),
                        child: Center(
                            child: Text(
                              "화장실",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 360),
                                  color: roomPictureCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff888888)),
                            ))),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                        width: screenWidth * (60 / 360),
                        child: Center(
                            child: Text(
                              "부엌",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 360),
                                  color: roomPictureCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff888888)),
                            ))),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                        width: screenWidth * (60 / 360),
                        child: Center(
                            child: Text(
                              "방1",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 360),
                                  color: roomPictureCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff888888)),
                            ))),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    Container(
                        width: screenWidth * (60 / 360),
                        child: Center(
                            child: Text(
                              "방2",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 360),
                                  color: roomPictureCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff888888)),
                            ))),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (38 / 640),
                )
              ],
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              // Navigator.push(context, SlideRightRoute(page: ReviewScreenInMap4()));

              if (checkRoomPictures(context) == false) {
              } else {
                currentPage = 2;
                setState(() {});
              }
            },
            child: Container(
              width: screenWidth,
              height: screenHeight * (60 / 640),
              color: checkRoomPictures(context) == true
                  ? kPrimaryColor
                  : Color(0xffcccccc),
              //((one==true||two==true||op==true||apt==true))?kPrimaryColor:Color(0xffcccccc),
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
    );
  }

  WillPopScope noiseBugKindDetail(
      BuildContext context, double screenHeight, double screenWidth) {
    return WillPopScope(
      onWillPop: () {},
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  if (currentPage == 2) {
                    currentPage = 1;
                    setState(() {});
                  } else if (currentPage == 3) {
                    c.animateTo(0,
                        duration: new Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  } else if (currentPage == 4) {
                    c.animateTo(MediaQuery.of(context).size.width,
                        duration: new Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  } else if (currentPage == 5) {
                    c.animateTo(MediaQuery.of(context).size.width * 2,
                        duration: new Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }
                  // currentPage == 3|| currentPage == 1 ||currentPage == 2? c.jumpTo(0.0) :
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
                SizedBox(
                  height: screenHeight * (12 / 640),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * (12 / 360),
                    ),
                    roomPictureCheckBox == false?
                    Container(
                      width: screenWidth * (120 / 360),
                      height: screenHeight * (100 / 640),
                      decoration: BoxDecoration(
                          color: hexToColor("#EEEEEE"),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(1),
                                  BlendMode.dstATop),
                              image: FileImage(Images[0]),
                              fit: BoxFit.cover)),
                    ):
                    Container(
                      width: screenWidth * (120 / 360),
                      height: screenHeight * (100 / 640),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Color(0xffE5E5E5),
                            width: 1,
                          )),
                      child: Center(
                        child: SvgPicture.asset(type ==0?OneRoomInReleaseRoomScreen:type == 1?TwoRoomInReleaseRoomScreen:type ==2?OpInReleaseRoomScreen:AptInReleaseRoomScreen,
                            width: screenHeight * (55 / 640),
                            height: screenHeight * (55 / 640),
                            color: Color(0xffE9E8E6)
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * (12 / 360)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${monthlyrentfees.text}"+" 만원 / 월 ",
                            style: TextStyle(
                                fontSize: screenWidth * (16 / 360),
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: screenHeight * (8 / 640),
                        ),
                        Row(
                          children: [
                            Text("매물종류",
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: screenWidth * (8 / 360),
                            ),
                            Text(
                              type ==0?"원룸":type==1?"투룸 이상":type ==2?"오피스텔":"아파트",
                              style: TextStyle(
                                  fontSize: screenWidth * (12 / 360),
                                  color: Color(0xff888888)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * (4 / 640),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("매물위치",
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              width: screenWidth * (8 / 360),
                            ),
                            Container(
                              width: screenWidth*(152/360),
                              child: Text(
                                location + " " + (locationdetail.text==""?"":locationdetail.text),
                                style: TextStyle(
                                    fontSize: screenWidth * (12 / 360),
                                    color: Color(0xff888888)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: screenHeight * (12 / 640),
                ),
                Container(
                    width: screenWidth,
                    height: screenHeight * (8 / 640),
                    color: Color(0xfff8f8f8)),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                Text(
                  starrating.toString()+"점",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * (16 / 360),
                      color: starrating!=-1
                          ? kPrimaryColor
                          : Color(0xffeeeeee)),
                ),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        starrating=1;
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        star,
                        width: screenWidth * (40 / 360),
                        height: screenWidth * (40 / 360),
                        color: starrating>=1? kPrimaryColor : starColor,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    GestureDetector(
                      onTap: () {
                        starrating=2;
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        star,
                        width: screenWidth * (40 / 360),
                        height: screenWidth * (40 / 360),
                        color: starrating>=2? kPrimaryColor : starColor,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    GestureDetector(
                      onTap: () {
                        starrating=3;
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        star,
                        width: screenWidth * (40 / 360),
                        height: screenWidth * (40 / 360),
                        color:  starrating>=3? kPrimaryColor : starColor,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    GestureDetector(
                      onTap: () {
                        starrating=4;
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        star,
                        width: screenWidth * (40 / 360),
                        height: screenWidth * (40 / 360),
                        color:  starrating>=4? kPrimaryColor : starColor,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * (9 / 360),
                    ),
                    GestureDetector(
                      onTap: () {
                        starrating=5;
                        setState(() {});
                      },
                      child: SvgPicture.asset(
                        star,
                        width: screenWidth * (40 / 360),
                        height: screenWidth * (40 / 360),
                        color: starrating>=5? kPrimaryColor : starColor,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (10 / 640),
                ),
                Container(
                    width: screenWidth,
                    height: screenHeight * (8 / 640),
                    color: Color(0xfff8f8f8)),
                Container(
                  color: Colors.white,
                  width: screenWidth,
                  height: MediaQuery.of(context).size.height * (280 / 640),
                  child: new PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value + 2;
                      });
                    },
                    controller: c,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight * (20 / 640),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * (16 / 360),
                                ),
                                Container(
                                  //height: currentPage ==1 ?screenHeight*(76/640) : screenHeight*(38/640),
                                  child: Text(
                                    reviewData[0]["title"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * (14 / 360),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (24 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(hownoise ==0)hownoise = -1;
                                    else hownoise = 0;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:hownoise ==0
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[0]["text1"],
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            color: hownoise ==0
                                                ? kPrimaryColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(hownoise ==1)hownoise = -1;
                                    else hownoise = 1;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: hownoise ==1
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[0]["text2"],
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            color: hownoise ==1
                                                ? kPrimaryColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(hownoise ==2)hownoise = -1;
                                    else hownoise = 2;


                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:hownoise ==2
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[0]["text3"],
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            color: hownoise ==2
                                                ? kPrimaryColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            hownoise ==2
                                ? Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: screenWidth * (316 / 360),
                                  child: TextField(
                                    controller: noisedetail,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      isDense: true,
                                      hintText:
                                      '어떤 부분이 불만족스러웠나요?',
                                      hintStyle: TextStyle(
                                        fontSize: screenWidth * 0.0333333,
                                        color: hexToColor("#D2D2D2"),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#6F22D2"))),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#CCCCCC"))),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                                : Container(),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight * (20 / 640),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * (16 / 360),
                                ),
                                Container(
                                  //height: currentPage ==1 ?screenHeight*(76/640) : screenHeight*(38/640),
                                  child: Text(
                                    reviewData[1]["title"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * (14 / 360),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (24 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(howbug ==0)howbug = -1;
                                    else howbug = 0;


                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: howbug ==0
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[1]["text1"],
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            color: howbug ==0
                                                ? kPrimaryColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(howbug ==1)howbug = -1;
                                    else howbug = 1;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: howbug ==1
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[1]["text2"],
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            color: howbug ==1
                                                ? kPrimaryColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(howbug ==2)howbug = -1;
                                    else howbug = 2;


                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color:howbug ==2
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[1]["text3"],
                                        style: TextStyle(
                                            fontSize: screenWidth * (12 / 360),
                                            color: howbug ==2
                                                ? kPrimaryColor
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            howbug ==2
                                ? Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: screenWidth * (316 / 360),
                                  child: TextField(
                                    controller: bugdetail,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      isDense: true,
                                      hintText:
                                      '어떤 부분이 불만족스러웠나요?',
                                      hintStyle: TextStyle(
                                        fontSize: screenWidth * 0.0333333,
                                        color: hexToColor("#D2D2D2"),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#6F22D2"))),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#CCCCCC"))),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                                : Container(),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight * (20 / 640),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: screenWidth * (16 / 360),
                                ),
                                Container(
                                  //height: currentPage ==1 ?screenHeight*(76/640) : screenHeight*(38/640),
                                  child: Text(
                                    reviewData[2]["title"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * (14 / 360),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (24 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(howkind ==0)howkind = -1;
                                    else howkind = 0;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: howkind ==0
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[2]["text1"],
                                        style: TextStyle(
                                          fontSize: screenWidth * (12 / 360),
                                          color: howkind ==0
                                              ? kPrimaryColor
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(howkind ==1)howkind = -1;
                                    else howkind = 1;

                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: howkind ==1
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[2]["text2"],
                                        style: TextStyle(
                                          fontSize: screenWidth * (12 / 360),
                                          color: howkind ==1
                                              ? kPrimaryColor
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    if(howkind ==2)howkind = -1;
                                    else howkind = 2;


                                    setState(() {});
                                  },
                                  child: Container(
                                    width: screenWidth * (316 / 360),
                                    height: screenHeight * (40 / 640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],
                                      border: Border.all(
                                        color: howkind ==2
                                            ? kPrimaryColor
                                            : Colors.white,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                      ),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        reviewData[2]["text3"],
                                        style: TextStyle(
                                          fontSize: screenWidth * (12 / 360),
                                          color: howkind ==2
                                              ? kPrimaryColor
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            howkind ==2
                                ? Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: screenWidth * (316 / 360),
                                  child: TextField(
                                    controller: kinddetail,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      isDense: true,
                                      hintText:
                                      '어떤 부분이 불만족스러웠나요?',
                                      hintStyle: TextStyle(
                                        fontSize: screenWidth * 0.0333333,
                                        color: hexToColor("#D2D2D2"),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#6F22D2"))),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#CCCCCC"))),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            )
                                : Container(),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: screenHeight * (21 / 640),
                            ),
                            Row(
                              children: [
                                SizedBox(width: screenWidth * (12 / 360)),
                                Text(
                                  "상세 후기를 남겨주세요.",
                                  style: TextStyle(
                                      fontSize: screenWidth * (16 / 360),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8 / 640),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth * (332 / 360),
                                  height: screenHeight * (220 / 640),
                                  child: TextField(
                                    controller: infodetail,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 14,
                                    maxLength: 225,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      hintText: '방에 대한 상세한 후기를 남겨주세요 :)\n(최소 15자이상)',
                                      hintStyle: TextStyle(
                                        fontSize: screenWidth * 0.0333333,
                                        color: hexToColor("#D2D2D2"),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#6F22D2"))),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: hexToColor(("#CCCCCC"))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: ()async {
              if (currentPage == 2) {
                if (hownoise == -1) {
                }
                else {
                  c.animateTo(MediaQuery.of(context).size.width,
                      duration: new Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              } else if (currentPage == 3) {
                if (howbug == -1) {
                } else {
                  c.animateTo(MediaQuery.of(context).size.width * 2,
                      duration: new Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              } else if (currentPage == 4) {
                if (howkind== -1) {
                } else {
                  c.animateTo(MediaQuery.of(context).size.width * 3,
                      duration: new Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }
              } else {
                if (infodetail.text.length < 10||starrating==-1) {
                } else {
                  EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                  var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(location);
                  var first = addresses.first;


                  Dio dio = new Dio();
                  dio.options.headers = {
                    'Content-Type': 'application/json',
                    'user': 'codeforgeek'
                  };
                  FormData formData = new FormData.fromMap({
                    "userid": GlobalProfile.loggedInUser.userID,
                    "type": type,
                    "location": location,
                    "locationdetail": locationdetail.text,
                    "monthlyrentfees": int.parse(monthlyrentfees.text
                        .replaceAll(",", "")),
                    "depositfees": int.parse(depositfees.text.replaceAll(
                        ",", "")),
                    "managementfees": int.parse(managementfees.text
                        .replaceAll(",", "")),
                    "utilityfees": int.parse(utilityfees.text.replaceAll(
                        ",", "")),
                    "starrating": starrating,
                    "hownoise": hownoise,
                    "howbug": howbug,
                    "howkind": howkind,
                    "noisedetail": noisedetail.text,
                    "bugdetail": bugdetail.text,
                    "kinddetail": kinddetail.text,
                    "infodetail": infodetail.text,
                    "longitude": first.coordinates.longitude,
                    "latitude" : first.coordinates.latitude,
                    "startdate" : rentStart,
                    "enddate" : rentDone,
                  });

                  for (int i = 0; i < Images.length; ++i) {
                    int rand = new Math.Random(i).nextInt(100000);
                    formData.files.add(
                        MapEntry("img", MultipartFile.fromFileSync(Images[i]
                            .path, filename: GlobalProfile.loggedInUser.userID
                            .toString() + "_rand.jpeg")));
                  }
                  await dio.post(
                      ApiProvider().getUrl + "/Review/S3notuserReviewInsert",
                      data: formData).timeout(const Duration(seconds: 17));

                  EasyLoading.dismiss();
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black12.withOpacity(0.6),
                    pageBuilder: (BuildContext context, Animation first,
                        Animation second) {
                      return WillPopScope(
                        onWillPop: (){},
                        child: Center(
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                              new BorderRadius.all(new Radius.circular(8)),
                            ),
                            width: MediaQuery.of(context).size.width * (300 / 360),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * (300 / 360),

                                  decoration: new BoxDecoration(
                                    color: Color(0xff010722),
                                    borderRadius: new BorderRadius.only(topRight: Radius.circular(8.0),topLeft: Radius.circular(8.0)),
                                  ),

                                  child: ClipRRect(
                                    borderRadius: new BorderRadius.only(topRight: Radius.circular(8.0),topLeft: Radius.circular(8.0)),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child:Image.asset(
                                        "assets/images/review/dia.png",
                                      ),
                                    ),
                                  ),
                                ),

                                Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainPage()),
                                          );
                                        },
                                        child: Container(
                                          height: screenHeight * (60 / 640),
                                          decoration: new BoxDecoration(
                                            color: Color(0xffcccccc),
                                            borderRadius:
                                            new BorderRadius.only(
                                                bottomLeft:
                                                Radius.circular(8)),
                                          ),
                                          child: Center(
                                            child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  "홈으로 가기",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: screenWidth *
                                                          (16 / 360),
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              // 기본 파라미터, SecondRoute로 전달
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewScreenInMap5_phone(),
                                              ) // SecondRoute를 생성하여 적재
                                          );
                                        },
                                        child: Container(
                                          height: screenHeight * (60 / 640),
                                          decoration: new BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                            new BorderRadius.only(
                                                bottomRight:
                                                Radius.circular(8)),
                                          ),
                                          child: Center(
                                            child: Material(
                                                color: Colors.transparent,
                                                child: Text(
                                                  "번호 입력하기",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: screenWidth *
                                                          (16 / 360),
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
            },
            child: Container(
              width: screenWidth,
              height: screenHeight * (60 / 640),
              color: currentPage == 2
                  ? ((hownoise==-1) )
                  ? Color(0xffcccccc)
                  : kPrimaryColor
                  : currentPage == 3
                  ? ((howbug==-1) )
                  ? Color(0xffcccccc)
                  : kPrimaryColor
                  : currentPage == 4
                  ? ((howkind==-1) )
                  ? Color(0xffcccccc)
                  : kPrimaryColor
                  : ((starrating ==-1) ||
                  infodetail.text == "" ||
                  infodetail.text.length < 10)
                  ? Color(0xffcccccc)
                  : kPrimaryColor,
              child: Center(
                child: Text(
                  currentPage == 2 || currentPage == 3 || currentPage == 4
                      ? "다음"
                      : "작성 완료하기",
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
    );
  }

  bool checkTypeLocationBaseinfo() {
    bool tmp = true;
    if (type == -1) {
      tmp = false;
    }
    if (location == "주소를 검색해주세요") {
      tmp = false;
    }
    if (monthlyrentfees.text == "") {
      tmp = false;
    }
    if (depositfees.text == "") {
      tmp = false;
    }
    if (managementfees.text == "") {
      tmp = false;
    }
    if (utilityfees.text == "") {
      tmp = false;
    }
    return tmp;
  }

  bool checkRoomPictures(BuildContext context) {
    bool tmp = true;
    if (roomPictureCheckBox == false && Images.length < 1) {
      tmp = false;
    }
    return tmp;
  }

  Future BottomSheetMoreScreen(
      BuildContext context, double screenWidth, double screenHeight) {
    return showModalBottomSheet(
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
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
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
                          getImageGallery(context);

                          Navigator.pop(context);
                          setState(() {

                          });
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "갤러리",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
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
                          getImageCamera(context);

                          Navigator.pop(context);
                          setState(() {

                          });
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "카메라",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
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
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                            fontSize: screenWidth * (16 / 360),
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
  }
  Future getImageGallery(BuildContext context) async {

    var imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery); //camera
    print(imageFile);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      Images.add(imageFile);
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      Images.add(imageFile);//이미지 들어가는
    }
    setState(() {

    });
    return;
  }
  Future getImageCamera(BuildContext context) async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      Images.add(imageFile);
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      Images.add(imageFile);//이미지 들어가는
    }

    setState(() {

    });
    return;
  }
  Future BottomSheetMoreScreen2(BuildContext context, double screenWidth,
      double screenHeight, int index) {
    return showModalBottomSheet(
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
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
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
                          getImageGallery2(context, index);
                          Navigator.pop(context);
                          setState(() {

                          });
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "갤러리",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
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
                          getImageCamera2(context, index);
                          Navigator.pop(context);
                          setState(() {

                          });
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "카메라",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
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
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                            fontSize: screenWidth * (16 / 360),
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
  }
  Future getImageGallery2(BuildContext context, int index) async {
    var imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery); //camera
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      Images[index] = imageFile;
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      Images[index] = compressImg;//이미지 들어가는
    }

    setState(() {

    });
    return;
  }
  Future getImageCamera2(BuildContext context, int index) async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      Images[index] = imageFile;
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      Images[index] = compressImg;//이미지 들어가는
    }

    setState(() {

    });
    return;
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
                padding: EdgeInsets.only(top: screenHeight * (170 / 640)),
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
bool CheckForProposeTerm(String rentStart, String rentDone) {
  if(rentStart != null &&rentDone != null) {
    return true;
  }
  else {
    return false;
  }

}