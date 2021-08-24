
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/packages/kopo/kopo.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:image/image.dart' as Img;
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/utils/PageTransition.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:io';
import 'dart:convert';
import 'package:mryr/screens/ReleaseRoom/model/ModelModifyReleaseRoom.dart';

import 'package:shared_preferences/shared_preferences.dart';


import 'package:image_picker/image_picker.dart';



class ReleaseShortRoom extends StatefulWidget {
  @override
  _ReleaseShortRoomState createState() => _ReleaseShortRoomState();
}

class _ReleaseShortRoomState extends State<ReleaseShortRoom> {
  String adressValue = "주소를 검색해주세요";
  TextEditingController addressController;
  final FocusNode _nodeText5 = FocusNode();
  TextEditingController areaController;

  TextEditingController dayController;
  TextEditingController weekController;
  TextEditingController monthController;

  TextEditingController Description;

  List<bool> OptionList = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
  bool roomPictureCheckBox = false;

  FormData formData;
  FormData  Student_formdata;


  int type;
  String location = "";
  String locationdetail;
  int square;
  int dailyrentfeesoffer;
  int weeklyrentfeesoffer;
  int monthlyrentfeesoffer;
  String rentstart;
  String rentdone;
  int condition;
  int floor;
  int bed;
  int desk;
  int chair;
  int closet;
  int aircon;
  int induction;
  int refrigerator;
  int doorlock;
  int tv;
  int microwave;
  int washingmachine;
  int hallwaycctv;
  int wifi;
  int parking;
  String information;
  String longitude;
  String latitude;
  List<File> ItemImgList= [];

  List<bool> ImgFlagList = [false,false,false,false,false];

  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //type
              SizedBox(height: screenHeight*0.059375,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '매물 종류 선택',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth*(24/360),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.0125,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '구하실 매물의 종류를 선택해주세요',
                  style: TextStyle(
                    fontSize: screenWidth*0.033333,
                    color: hexToColor("#888888"),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                     type = 0;
                     setState(() {

                     });
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
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: type == 0 ? kPrimaryColor : Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
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
                              color: type == 0 ? kPrimaryColor : Colors.black,
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
                                  color: type == 0
                                      ? kPrimaryColor
                                      : Color(0xff222222)),
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
                      type = 1;
                      setState(() {

                      });
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
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: type == 1? kPrimaryColor : Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
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
                              color: type == 1 ? kPrimaryColor : Colors.black,
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
                                      : Color(0xff222222)),
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
                      type = 2;
                      setState(() {

                      });
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
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: type == 2? kPrimaryColor : Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
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
                              color: type == 2 ? kPrimaryColor : Colors.black,
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
                                  color:
                                  type == 2  ? kPrimaryColor : Color(0xff222222)),
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
                      type = 3;
                      setState(() {

                      });
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
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                        border: Border.all(
                          color: type == 3 ? kPrimaryColor : Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
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
                              color: type == 3 ? kPrimaryColor : Colors.black,
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
                                  color: type == 3
                                      ? kPrimaryColor
                                      : Color(0xff222222)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),


              //location, locationdetail
              SizedBox(height: screenHeight*0.0625,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Text(
                    "매물 위치 입력",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*(24/360),
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
                    "지도에서 정확한 매물의 위치를 확인해주세요",
                    style: TextStyle(
                      color: Color(0xff888888),
                      fontSize: screenHeight * (12 / 640),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              GestureDetector(
                onTap: () async {
                  /*KopoModel model = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Kopo(),
                          ),
                        );*/
                  KopoModel model = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Kopo(
                        useLocalServer: false,
                        localPort: 1024,
                      ),
                    ),
                  );

                  setState(() {
                    location =
                    '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}';
                  });

                },
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth * (16 / 360),
                    ),
                    Container(
                      width: screenWidth*(304/360),
                      child: Text(
                       location == '' ? '주소를 입력해주세요.' : '${location}' ,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: screenWidth*(14/360),
                            color: location == '' ? Color(0xff928E8E):Colors.black),),
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
              SizedBox(height: screenHeight*(8/640),),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Container(width: screenWidth*(328/360),height: 1,color: Color(0xffcccccc),),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Container(
                    width: screenWidth*(328/360),
                    child: TextField(
                      controller: this.addressController,
                      textInputAction: TextInputAction.done,
                      decoration: new InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffcccccc)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffcccccc)),
                        ),
                        hintText: "상세 주소를 입력하세요",
                        hintStyle: TextStyle(fontSize: screenWidth*(14/360),color: Color(0xff928E8E)),
                        labelStyle: new TextStyle(
                            color: const Color(0xFF424242)
                        ),
                        isDense: true,
                      ),
                      onChanged: (text){
                       locationdetail = text;
                       setState(() {

                       });
                      },
                    ),
                  ),
                ],
              ),



              //area

              SizedBox(height: screenHeight*0.0625,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '기본 정보',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth*0.066666,
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.0125,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '방의 기본적인 정보를 입력해주세요',
                  style: TextStyle(
                    fontSize: screenWidth*0.033333,
                    color: hexToColor("#888888"),
                  ),
                ),
              ),         SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 1,
                      color: Color(0xfff8f8f8),
                    ),

                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Container(
                            width: screenWidth * (124 / 360),
                            child: Text(
                              "면적",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222)),
                            )),
                        Container(
                            width: screenWidth * (80 / 360),
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
                              focusNode: _nodeText5,
                              controller: areaController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                hintText: '5',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (16 / 360),
                                  color: hexToColor("#cccccc"),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text){
                                if(text == "") {
                                  square = -1;
                                } else {
                                  square  = int.parse(text);
                                }
                                setState(() {

                                });
                              },
                            )),
                        Text(
                          "㎡",
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Color(0xfff8f8f8),
                    ),
                  ],
                ),
              ),


              //price


              SizedBox(height: screenHeight*0.0625,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * (2.5 / 640)),
                    child: Text(
                      "가격정보",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth*(24/360),
                      ),
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
        RichText(
          text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: "원하시는 ",style: TextStyle(color: Color(0xff888888),decoration: TextDecoration.none,fontSize: screenWidth*(12 /360),)),
                TextSpan(text: "일단위 가격",style: TextStyle(color: kPrimaryColor,decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
                TextSpan(text: "을 입력해주세요",style: TextStyle(color: Color(0xff888888),decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
              ]
          ),
        )
                ],
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                      width: screenWidth * (100 / 360),
                      height: screenHeight * (30 / 640),
                      child: TextField(
                        textAlign: TextAlign.center,
                        inputFormatters: <TextInputFormatter> [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        controller: dayController,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * (20 / 360),
                          color: Color(0xff222222),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          errorBorder: InputBorder.none,
                          hintText: '300,000',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * (20 / 360),
                            color: hexToColor("#cccccc"),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (text){
                          if(text == "") {
                           dailyrentfeesoffer = -1;
                          } else {
                            dailyrentfeesoffer = (int.parse(text));
                          }
                        },
                      )),
                  SizedBox(
                    width: screenWidth * (8 / 360),
                  ),
                  Container(
                      height: screenHeight * (30 / 640),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "원 / 일",
                          style: TextStyle(
                              fontSize: screenWidth * (20 / 360),
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222)),
                        ),
                      )),

                  Spacer(),
                ],
              ),
              SizedBox(
                height: screenHeight * (4 / 640),
              ),
              Divider(thickness: 1, color: hexToColor("#CCCCCC"), indent: screenWidth*0.03333, endIndent: screenWidth*0.03333,),

              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: "원하시는 ",style: TextStyle(color: Color(0xff888888),decoration: TextDecoration.none,fontSize: screenWidth*(12 /360),)),
                          TextSpan(text: "주단위 가격",style: TextStyle(color: kPrimaryColor,decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
                          TextSpan(text: "을 입력해주세요",style: TextStyle(color: Color(0xff888888),decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
                        ]
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                      width: screenWidth * (100 / 360),
                      height: screenHeight * (30 / 640),
                      child: TextField(
                        textAlign: TextAlign.center,
                        inputFormatters: <TextInputFormatter> [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        controller: weekController,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * (20 / 360),
                          color: Color(0xff222222),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          errorBorder: InputBorder.none,
                          hintText: '300,000',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * (20 / 360),
                            color: hexToColor("#cccccc"),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (text){
                          if(text == "") {
                            weeklyrentfeesoffer = -1;
                          } else {
                            weeklyrentfeesoffer = (int.parse(text));
                          }
                        },
                      )),
                  SizedBox(
                    width: screenWidth * (8 / 360),
                  ),
                  Container(
                      height: screenHeight * (30 / 640),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "원 / 주",
                          style: TextStyle(
                              fontSize: screenWidth * (20 / 360),
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222)),
                        ),
                      )),

                  Spacer(),
                ],
              ),
              SizedBox(
                height: screenHeight * (4 / 640),
              ),
              Divider(thickness: 1, color: hexToColor("#CCCCCC"), indent: screenWidth*0.03333, endIndent: screenWidth*0.03333,),

              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  RichText(
                    text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: "원하시는 ",style: TextStyle(color: Color(0xff888888),decoration: TextDecoration.none,fontSize: screenWidth*(12 /360),)),
                          TextSpan(text: "월단위 가격",style: TextStyle(color: kPrimaryColor,decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
                          TextSpan(text: "을 입력해주세요",style: TextStyle(color: Color(0xff888888),decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
                        ]
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                      width: screenWidth * (100 / 360),
                      height: screenHeight * (30 / 640),
                      child: TextField(
                        textAlign: TextAlign.center,
                        inputFormatters: <TextInputFormatter> [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        controller: monthController,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * (20 / 360),
                          color: Color(0xff222222),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          errorBorder: InputBorder.none,
                          hintText: '300,000',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * (20 / 360),
                            color: hexToColor("#cccccc"),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onChanged: (text){
                          if(text == "") {
                            monthlyrentfeesoffer = -1;
                          } else {
                            monthlyrentfeesoffer = (int.parse(text));
                          }
                        },
                      )),
                  SizedBox(
                    width: screenWidth * (8 / 360),
                  ),
                  Container(
                      height: screenHeight * (30 / 640),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "원 / 월",
                          style: TextStyle(
                              fontSize: screenWidth * (20 / 360),
                              fontWeight: FontWeight.bold,
                              color: Color(0xff222222)),
                        ),
                      )),

                  Spacer(),
                ],
              ),
              SizedBox(
                height: screenHeight * (4 / 640),
              ),
              Divider(thickness: 1, color: hexToColor("#CCCCCC"), indent: screenWidth*0.03333, endIndent: screenWidth*0.03333,),
              SizedBox(height: screenHeight*0.0625,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Text(
                    "양도 기간 제안",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*(24/360),
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
                    "원하시는 임대 기간을 입력해주세요",
                    style: TextStyle(
                      color: Color(0xff888888),
                      fontSize: screenHeight * (12 / 640),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Container(
                width: screenWidth * (360 / 360),
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
                            maxTime: rentdone != null ? DateTime(DateFormat('y.MM.d').parse(rentdone).year, DateFormat('y.MM.d').parse(rentdone).month,DateFormat('y.MM.d').parse(rentdone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                            theme: DatePickerTheme(
                                headerColor: Colors.white,
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
                                doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                            onChanged: (date) {

                             rentstart = (DateFormat('y.MM.d').format(date));
                            },
                            currentTime: DateTime.now(), locale: LocaleType.ko);
                        setState(() {

                        });
                      },
                      child: Container(
                        width: screenWidth * (120 / 360),
                        child: Center(
                          child: Text(
                            rentstart == null ? "입주" : rentstart,
                            style: TextStyle(
                              fontSize: screenWidth * (20 / 360),
                              fontWeight: FontWeight.bold,
                              color: rentstart == null ? hexToColor('#CCCCCC') : Colors.black,
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
                        if(rentstart == null) {
                          Function okFunc = () {
                            Navigator.pop(context);
                          };
                          OKDialog(context, "입주 날짜부터 입력해주세요!", "", "알겠어요!",okFunc);
                        }
                        else {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              //끝날짜가 시작날짜를 넘지 않도록
                              minTime: rentstart != null ? DateTime(DateFormat('y.MM.d').parse(rentstart).year, DateFormat('y.MM.d').parse(rentstart).month,DateFormat('y.MM.d').parse(rentstart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                              maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                              theme: DatePickerTheme(
                                  headerColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                              onChanged: (date) {
                                rentdone = (DateFormat('y.MM.d').format(date));
                              },
                              currentTime: DateTime.now(), locale: LocaleType.ko);

                          setState(() {

                          });
                        }
                      },
                      child: Container(
                        width: screenWidth * (120 / 360),
                        child: Center(
                          child: Text(
                            rentdone == null ? "퇴실" : rentdone,
                            style: TextStyle(
                              fontSize: screenWidth * (20 / 360),
                              fontWeight: FontWeight.bold,
                              color: rentdone == null ? hexToColor('#CCCCCC') : Colors.black,
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
                width: screenWidth * (360 / 360),
                child: Row(
                  children: [

                    Spacer(),
                    Container(
                      color: Color(0xffcccccc),
                      width: screenWidth * (140 / 360),
                      height: screenHeight * (1 / 640),
                    ),
                    SizedBox(
                      width: screenWidth * (40 / 360),
                    ),
                    Container(
                      color: Color(0xffcccccc),
                      width: screenWidth * (140 / 360),
                      height: screenHeight * (1 / 640),
                    ),
                    Spacer(),
                  ],
                ),
              ),


              //option
              SizedBox(height: screenHeight*0.059375,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*(12/360)),
                child: Text(
                  '옵션 선택',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth*(24/360),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.0125,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*(12/360)),
                child: Text(
                  '방에 포함된 옵션을 선택해주세요',
                  style: TextStyle(
                    fontSize: screenWidth*0.033333,
                    color: hexToColor("#888888"),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * (16 / 640),
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight, 0,BedIcon, '침대'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight, 1,DeskIcon, '책상'),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight, 2,ChairIcon, '의자'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight, 3,ClosetIcon, '옷장'),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight,  4,AirConditionerIcon, '에어컨'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight, 5,InductionIcon, '인덕션'),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight,6,RefrigeratorIcon, '냉장고'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight, 7,tvInReleaseRoomScreen, 'TV'),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight, 8,DoorLockIcon, '도어락'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight, 9,MicrowaveIcon, '전자레인지'),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight, 10,WasherIcon, '세탁기'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight,11,CCTVIcon, '복도 CCTV'),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  buildOptionComponent(screenWidth, screenHeight,  12,WifiIcon, '와이파이'),
                  SizedBox(width: screenWidth*0.02222222,),
                  buildOptionComponent(screenWidth, screenHeight, 13, ParkingIcon, '주차 가능'),
                ],
              ),


              //room detail explain
              SizedBox(height: screenHeight*0.0625,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Text(
                    '방 상세 설명',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*0.066666,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight*0.0125,),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * (12 / 360),
                  ),
                  Text(
                    '내놓을 방의 상세 설명을 작성해주세요',
                    style: TextStyle(
                      fontSize: screenWidth*0.033333,
                      color: hexToColor("#888888"),
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
                  Container(
                    width: screenWidth*(336/360),
                    child: TextField(
                      autofocus: false,
                      controller: Description,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: 15,
                      maxLength: 225,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: '방에 대한 설명을 225자 이내로 작성해주세요',
                        hintStyle: TextStyle(
                          fontSize: screenWidth*0.0333333,
                          color: hexToColor("#D2D2D2"),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: hexToColor(("#CCCCCC"))),
                        ),
                      ),
                      onChanged: (text){
                        information = (text);
                      },
                    ),
                  ),
                ],
              ),



              //room pictures
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
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
                      Row(
                        children: [
                          Text(
                            "대표사진, 화장실, 부엌",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: screenHeight * (12 / 640),
                            ),
                          ),
                          Text(
                            "을 반드시 찍어주세요!",
                            style: TextStyle(
                              color: hexToColor('#CCCCCC'),
                              fontSize: screenHeight * (12 / 640),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: screenHeight * (20 / 640),
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
                        ItemImgList.length == 0
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
                                SvgPicture.asset('assets/images/reviewScreenInMap/gallary.svg',
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
                                  image: FileImage(ItemImgList[0]),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: screenHeight * (30 / 640),
              ),
              Row(
                children: [
                  Spacer(),
                  Container(
                    width: screenWidth * (60 / 360),
                    height: screenWidth * (60 / 360),
                    child: Stack(
                      children: [
                        ItemImgList.length < 1
                            ? GestureDetector(
                          onTap: () async {
                            if (roomPictureCheckBox == false) {
                              // BottomSheetMoreScreen(
                              //     context, screenWidth, screenHeight);
                              await BottomSheetMoreScreen(context, screenWidth, screenHeight);
                              setState(() {
                                ImgFlagList[0] = true;
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                              setState(() {
                                ImgFlagList[0] = true;
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
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                    image: FileImage(ItemImgList[0]),
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
                        ItemImgList.length < 2
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight);
                                setState(() {
                                  ImgFlagList[1] = true;
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                ImgFlagList[1] = true;
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
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                    image: FileImage(ItemImgList[1]),
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
                        ItemImgList.length < 3
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (ItemImgList.length ==
                                  1) {
                                dialog(context, "화장실사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight).then((value) {
                                  setState(() {
                                    ImgFlagList[2] = true;
                                  });
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                ImgFlagList[2] = true;
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
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.black.withOpacity(1),
                                        BlendMode.dstATop),
                                    image: FileImage(ItemImgList[2]),
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
                        ItemImgList.length < 4
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (ItemImgList.length ==
                                  1) {
                                dialog(context, "화장실사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (ItemImgList.length ==
                                  2) {
                                dialog(context, "부엌사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight).then((value) {
                                  setState(() {
                                    ImgFlagList[3] = true;
                                  });
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                ImgFlagList[3] = true;
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
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
                                        image: FileImage(ItemImgList[3]),
                                        fit: BoxFit.cover)),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    ItemImgList.removeAt(3);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/public/GreyXIcon.svg',
                                    height: screenHeight*0.025,
                                    width: screenHeight*0.025,
                                  ),
                                ),
                              )
                            ],
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
                        if (ItemImgList.length < 5) GestureDetector(
                          onTap: () async {
                            if (roomPictureCheckBox == false) {
                              if (ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (ItemImgList.length ==
                                  1) {
                                dialog(context, "화장실사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (ItemImgList.length ==
                                  2) {
                                dialog(context, "부엌사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (ItemImgList.length ==
                                  3) {
                                dialog(context, "방1사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else {
                                await BottomSheetMoreScreen(context, screenWidth, screenHeight);
                                setState(() {
                                  ImgFlagList[4] = true;
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                        ) else GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              BottomSheetMoreScreen2(
                                  context, screenWidth, screenHeight, 4);
                              setState(() {
                                ImgFlagList[4] = true;
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
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
                                        image: FileImage(ItemImgList[4]),
                                        fit: BoxFit.cover)),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    ItemImgList.removeAt(4);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/images/public/GreyXIcon.svg',
                                    height: screenHeight*0.025,
                                    width: screenHeight*0.025,
                                  ),
                                ),
                              )
                            ],
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
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: ()async{

                if( ItemImgList.length >= 3 ) {
                  EasyLoading.show(
                      status: "", maskType: EasyLoadingMaskType.black);
                  Dio dio = new Dio();
                  dio.options.headers = {
                    'Content-Type': 'application/json',
                    'user': 'codeforgeek',
                  };


                  var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(location);
                  var first = addresses.first;


                  Future.microtask(() async {
                    formData = new FormData.fromMap({
                      "userID": GlobalProfile.loggedInUser.userID,
                      "type": type,
                      "location": location,
                      "locationdetail": locationdetail,
                      "jeonse": false,
                      "square": square,
                      "dailyrentfeesoffer": dailyrentfeesoffer,
                      "weeklyrentfeesoffer": weeklyrentfeesoffer,
                      "monthlyrentfeesoffer": monthlyrentfeesoffer,
                      "rentstart": rentstart,
                      "rentdone": rentdone,
                      "condition": condition,
                      "floor": floor,
                      "bed": OptionList[0],
                      "desk": OptionList[1],
                      "chair": OptionList[2],
                      "closet": OptionList[3],
                      "aircon": OptionList[4],
                      "induction": OptionList[5],
                      "refrigerator": OptionList[6],
                      "tv": OptionList[7],
                      "doorlock": OptionList[8],
                      "microwave": OptionList[9],
                      "washingmachine": OptionList[10],
                      "hallwaycctv": OptionList[11],
                      "wifi": OptionList[12],
                      "parking": OptionList[13],
                      "information": information,
                      "longitude": first.coordinates.longitude,
                      "latitude" : first.coordinates.latitude
                    });
                    int len = ItemImgList.length;
                    for (int i = 0; i < len; ++i) { //파일 형식에 대한 처릴 ex) png, jpeg
                      int rand = new Math.Random().nextInt(100000);
                      formData.files.add(MapEntry("img",
                          MultipartFile.fromFileSync(
                              ItemImgList[i].path, filename: GlobalProfile
                              .loggedInUser.userID.toString() +
                              "_$rand.jpeg")));
                    }

                    var res = await dio.post(ApiProvider().getUrl+"/RoomsalesInfo/ShortInsert",  data: formData).timeout(const Duration(seconds: 17));

                    var list = await ApiProvider().post(
                        '/RoomSalesInfo/myroomInfo', jsonEncode(
                        {
                          "userID": GlobalProfile.loggedInUser.userID,
                        }
                    ));

                    Map<String, dynamic> dummyItem = list[0];
                    ModelModifyReleaseRoom dummyRoom = ModelModifyReleaseRoom
                        .fromJson(dummyItem);


                    GlobalProfile.roomSalesInfo = new RoomSalesInfo(
                      id: dummyRoom.id,
                      userID: dummyRoom.userID,
                      type: dummyRoom.type,
                      jeonse: false,
                      location: dummyRoom.location,
                      locationDetail: dummyRoom.locationDetail,
                      square: dummyRoom.square,
                      monthlyRentFees: dummyRoom.monthlyRentFees,
                      depositFees: dummyRoom.depositFees,
                      depositFeesOffer: dummyRoom.depositFeesOffer,
                      managementFees: dummyRoom.managementFees,
                      utilityFees: dummyRoom.utilityFees,
                      monthlyRentFeesOffer: dummyRoom.monthlyRentFeesOffer,
                      termOfLeaseMin: dummyRoom.termOfLeaseMin,
                      termOfLeaseMax: dummyRoom.termOfLeaseMax,
                      preferenceSex: dummyRoom.preferenceSex,
                      preferenceSmoking: dummyRoom.preferenceSmoking,
                      preferenceTerm: dummyRoom.preferenceTerm,
                      bed: dummyRoom.bed,
                      desk: dummyRoom.desk,
                      chair: dummyRoom.chair,
                      closet: dummyRoom.closet,
                      aircon: dummyRoom.aircon,
                      induction: dummyRoom.induction,
                      refrigerator: dummyRoom.refrigerator,
                      doorLock: dummyRoom.doorLock,
                      tv: dummyRoom.tv,
                      microwave: dummyRoom.microwave,
                      washingMachine: dummyRoom.washingMachine,
                      hallwayCCTV: dummyRoom.hallwayCCTV,
                      wifi: dummyRoom.wifi,
                      information: dummyRoom.information,
                      imageUrl1: dummyRoom.imageUrl1,
                      imageUrl2: dummyRoom.imageUrl2,
                      imageUrl3: dummyRoom.imageUrl3,
                      imageUrl4: dummyRoom.imageUrl4,
                      imageUrl5: dummyRoom.imageUrl5,
                      tradingState: dummyRoom.tradingState,
                      createdAt: dummyRoom.createdAt,
                      updatedAt: dummyRoom.updatedAt,
                      openchat: "",

                    );
                    //자기 매물 정보
                    var list5 = await ApiProvider().post(
                        '/RoomSalesInfo/myroomInfo', jsonEncode(
                        {
                          "userID": GlobalProfile.loggedInUser.userID
                        }
                    ));

                    GlobalProfile.roomSalesInfoList.clear();
                    if (list5 != null && list5 != false) {
                      for (int i = 0; i < list5.length; ++i) {
                        GlobalProfile.roomSalesInfoList.add(
                            RoomSalesInfo.fromJson(list5[i]));
                      }
                    }


                    setState(() {

                    });

                    EasyLoading.dismiss();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return
                            new AlertDialog(
                              contentPadding: EdgeInsets.all(0.0),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8)),
                              content: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey.withOpacity(0.25),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],
                                ),
                                width: screenWidth * (290 / 360),
                                height: screenHeight * (400 / 640),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * (28 / 640),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * (28 / 360),),
                                            SvgPicture.asset(
                                              'assets/images/releaseRoomScreen/imgText1.svg',
                                              height: screenHeight * (28 / 640),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight * (4 / 640),),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * (28 / 360),),
                                            SvgPicture.asset(
                                              'assets/images/releaseRoomScreen/imgText2.svg',
                                              height: screenHeight * (84 / 640),
                                              width: screenWidth * (100 / 360),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      bottom: screenHeight * (64 / 640),
                                      child:
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (22 / 360),),
                                          SvgPicture.asset(
                                            'assets/images/releaseRoomScreen/imgImg1.svg',
                                            width: screenWidth * (256 / 360),
                                            // height: screenHeight*(257/640),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Timer(Duration(
                                                  milliseconds: 1000), () {});


                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: screenWidth * (290 / 360),
                                              height: screenHeight * (60 / 640),
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius: BorderRadius
                                                      .only(bottomLeft: Radius
                                                      .circular(8.0),
                                                      bottomRight: Radius
                                                          .circular(8.0))
                                              ),

                                              child: Center(
                                                child: Text(
                                                    '내놓은 매물 보러가기',
                                                    style: TextStyle(
                                                      fontSize: screenWidth *
                                                          (18 / 360),
                                                      color: Colors.white,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    )
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                        }
                    );
                  });
                }
          },
          child: Container(
            width: screenWidth,
            height: screenHeight * (60 / 640),
            color: ItemImgList.length >= 3 ? kPrimaryColor : hexToColor(
                '#CCCCCC'),
            //((one==true||two==true||op==true||apt==true))?kPrimaryColor:Color(0xffcccccc),
            child: Center(
              child: Text(
                "완료",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * (16 / 640)),
              ),
            ),
          ),
        ),
      ),
    );
  }


  GestureDetector buildOptionComponent(double screenWidth, double screenHeight, int index, String Img, String Title) {
    return GestureDetector(
      onTap: (){
        OptionList[index] =  !OptionList[index];
        setState(() {

        });
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
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
          border: Border.all(
            color:OptionList[index] == true ? kPrimaryColor : Colors.white,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(Radius.circular(
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
                Img,
                color: OptionList[index] == true ? kPrimaryColor : Colors.black,
                width: screenHeight * (24 / 640),
                height: screenHeight * (24 / 640),
              ),
              SizedBox(
                width: screenWidth * (12 / 360),
              ),
              Text(
                Title,
                style: TextStyle(
                    fontSize: screenHeight * (12 / 640),
                    color: OptionList[index] == true ? kPrimaryColor : Colors.black
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future BottomSheetMoreScreen(BuildContext context, double screenWidth, double screenHeight) async {
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
                        onPressed: () async {
                          // getImageGallery(context);
                          await getImageGallery(context);
                          Navigator.pop(context);
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
                        onPressed: () async {
                          await getImageCamera(context);
                          Navigator.pop(context);
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

  Future getImageCamera(BuildContext context) async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
      ItemImgList.add(imageFile);
    } else {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      ItemImgList.add(compressImg);
    }
    setState(() {

    });
    EasyLoading.dismiss();
  }

  Future getImageGallery(BuildContext context) async {
     var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery); //camera
    print(imageFile);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
      ItemImgList.add(imageFile);
    } else {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      ItemImgList.add(compressImg);
    }

    setState(() {

    });
    return;
  }


  Future BottomSheetMoreScreen2(
      BuildContext context, double screenWidth, double screenHeight, int index) {
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
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
      ItemImgList[index] = imageFile;
    } else {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      ItemImgList[index] = compressImg;
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
      ItemImgList[index] = imageFile;
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      ItemImgList[index] = compressImg;
    }
    setState(() {

    });
    return;
  }
}


void dialog(BuildContext context, String text, double screenWidth,
    double screenHeight) {
  showDialog(
      barrierColor: Color(0x01000000),
      context: context,
      builder: (context) {
        Future.delayed(Duration(milliseconds:1000), () {
          Navigator.of(context).pop(true);
        });

        return Material(
          type: MaterialType.transparency,
          child: Center(
            // Aligns the container to center
            child: Padding(
              padding: EdgeInsets.only(top: screenHeight * (265 / 640)),
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
                          fontSize: screenWidth * (12 / 360), color: Colors.white),
                    )),
              ),
            ),
          ),
        );
      });
}