import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;

class ModifyImg extends StatefulWidget {
  @override
  _ModifyImgState createState() => _ModifyImgState();
}

class _ModifyImgState extends State<ModifyImg> {
  TextEditingController addressController;
  bool roomPictureCheckBox = false;
  final originalMonthlyRent = TextEditingController();
  final originalDeposit = TextEditingController();
  final maintenanceCost = TextEditingController();
  final averageUtilityCharge = TextEditingController();

  FormData formData;

  bool one = false;
  bool two = false;
  bool op = false;
  bool apt = false;

  List<bool> ImgFlagList = [false,false,false,false,false];

  final GreyXIcon= 'assets/images/public/GreyXIcon.svg';

  void ChangeFlagForItem(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('FlagForItem', value);
  }

  @override
  Widget build(BuildContext context) {
    DummyUser _UserProvider = Provider.of<DummyUser>(context);
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider =
    Provider.of<DateInReleaseRoomsScreenProvider>(context);
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
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//            onPressed: () {
//              Navigator.of(context).pop();
//            }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
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
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
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
                        data.ItemImgList.length == 0
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
                                  image: FileImage(data.ItemImgList[0]),
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
                  data.ItemImgList.length == 0
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
                        data.ItemImgList.length < 1
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              BottomSheetMoreScreen(
                                  context, screenWidth, screenHeight).then((value) {
                                setState(() {
                                  ImgFlagList[0] = true;
                                });
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
                                    image: FileImage(data.ItemImgList[0]),
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
                        data.ItemImgList.length < 2
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (data.ItemImgList.length ==
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
                                    image: FileImage(data.ItemImgList[1]),
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
                        data.ItemImgList.length < 3
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (data.ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (data.ItemImgList.length ==
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
                                    image: FileImage(data.ItemImgList[2]),
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
                        data.ItemImgList.length < 4
                            ? GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (data.ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (data.ItemImgList.length ==
                                  1) {
                                dialog(context, "화장실사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (data.ItemImgList.length ==
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
                                        image: FileImage(data.ItemImgList[3]),
                                        fit: BoxFit.cover)),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    data.RemoveItemImgList(3);
                                  },
                                  child: SvgPicture.asset(
                                    GreyXIcon,
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
                        if (data.ItemImgList.length < 5) GestureDetector(
                          onTap: () {
                            if (roomPictureCheckBox == false) {
                              if (data.ItemImgList.length ==
                                  0) {
                                dialog(context, "대표사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (data.ItemImgList.length ==
                                  1) {
                                dialog(context, "화장실사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (data.ItemImgList.length ==
                                  2) {
                                dialog(context, "부엌사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else if (data.ItemImgList.length ==
                                  3) {
                                dialog(context, "방1사진을 넣어주세요", screenWidth,
                                    screenHeight);
                              } else {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight);
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
                                        image: FileImage(data.ItemImgList[4]),
                                        fit: BoxFit.cover)),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: (){
                                    data.RemoveItemImgList(4);
                                  },
                                  child: SvgPicture.asset(
                                    GreyXIcon,
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
              )
            ],
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            width: screenWidth,
            height: screenHeight * (60 / 640),
            color: data.ItemImgList.length >= 3 ? kPrimaryColor : hexToColor(
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
  EnterRoomInfoProvider _UserProvider = Provider.of<EnterRoomInfoProvider>(context, listen: false);

  var imageFile =
  await ImagePicker.pickImage(source: ImageSource.gallery); //camera
  print(imageFile);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000000);
  if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
    _UserProvider.AddItemImgList(imageFile);
  } else {
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
    _UserProvider.AddItemImgList(compressImg);
  }

  return;

}

Future getImageCamera(BuildContext context) async {
  EnterRoomInfoProvider _UserProvider = Provider.of<EnterRoomInfoProvider>(context, listen: false);
  var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000000);
  if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
    _UserProvider.AddItemImgList(imageFile);
  } else {
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
    _UserProvider.AddItemImgList(compressImg);
  }

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
  EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);

  var imageFile =
  await ImagePicker.pickImage(source: ImageSource.gallery); //camera
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000000);
  if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
    data.ChangeItemImgList(index, imageFile);
  } else {
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
    data.ChangeItemImgList(index, compressImg);
  }


  return;
}

Future getImageCamera2(BuildContext context, int index) async {
  EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);
  var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000000);
  if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
    data.ChangeItemImgList(index, imageFile);
  } else {
    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
    data.ChangeItemImgList(index, compressImg);
  }

  return;
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
                          fontSize: screenWidth * (12 / 360), color: Colors.white),
                    )),
              ),
            ),
          ),
        );
      });
}