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

import 'OpenChatLinkPage.dart';
import 'StudentIdentification.dart';

class ItemImg extends StatefulWidget {
  @override
  _ItemImgState createState() => _ItemImgState();
}

class _ItemImgState extends State<ItemImg> {
  TextEditingController addressController;
  bool roomPictureCheckBox = false;
  final originalMonthlyRent = TextEditingController();
  final originalDeposit = TextEditingController();
  final maintenanceCost = TextEditingController();
  final averageUtilityCharge = TextEditingController();

  FormData formData;
  FormData Student_formdata = new FormData();

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
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

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
//                        SizedBox(
//                          width: screenWidth * (8 / 360),
//                        ),
//                        Container(
//                          width: screenWidth * (20 / 360),
//                          child: Checkbox(
//                            checkColor: Colors.white,
//                            activeColor: kPrimaryColor,
//                            value: roomPictureCheckBox,
//                            onChanged: (bool value) {
//                              setState(() {
//                                roomPictureCheckBox = value;
//                              });
//                            },
//                          ),
//                        ),
//                        SizedBox(
//                          width: screenWidth * (4 / 360),
//                        ),
//                        Padding(
//                          padding: EdgeInsets.only(
//                              bottom: screenHeight * (1.5 / 640)),
//                          child: Text(
//                            "건너뛰기",
//                            style: TextStyle(
//                                fontSize: screenWidth * (12 / 360),
//                                color: roomPictureCheckBox == true
//                                    ? kPrimaryColor
//                                    : Color(0xffE9E8E6)),
//                          ),
//                        )
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
                          onTap: () async {
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
          onTap: ()async{


              EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
              Dio dio = new Dio();
              dio.options.headers = {
                'Content-Type': 'application/json',
                'user': 'codeforgeek',
              };


              var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(data.Address.toString());
              var first = addresses.first;



              Future.microtask(() async {
                formData = new FormData.fromMap({
                  "userID": GlobalProfile.loggedInUser.userID,
                  "type": data.ItemCategory,
                  "location": data.Address.toString(),
                  "locationdetail": data.DetailAddress.toString(),
                  "jeonse" : data.transferType ==0 ?false: true,

                  "monthlyrentfees": data.ExistingMonthlyRent,
                  "managementfees": data.AdministrativeExpenses,
                  "depositfees": data.ExistingDeposit,
                  "utilityfees": data.AverageUtilityBill,
                  "square": data.AreaSize,
                  "depositfeesoffer": data.depositCheckBox == true ? 0 : data.ProposedDeposit,
                  "monthlyrentfeesoffer": data.ProposedMonthlyRent,
                  "rentstart": data.rentStart,
                  "rentdone": data.rentDone,
                  "condition": data.condition,
                  "floor":data.floor,
                  "bed": data.OptionList[0],
                  "desk": data.OptionList[1],
                  "chair": data.OptionList[2],
                  "closet": data.OptionList[3],
                  "aircon": data.OptionList[4],
                  "induction": data.OptionList[5],
                  "refrigerator": data.OptionList[6],
                  "tv": data.OptionList[7],
                  "doorlock": data.OptionList[8],
                  "microwave": data.OptionList[9],
                  "washingmachine": data.OptionList[10],
                  "hallwaycctv": data.OptionList[11],
                  "wifi": data.OptionList[12],
                  "parking":data.OptionList[13],
                  "information": data.ItemDescription,
                  "openchat" : "",
                  "longitude": first.coordinates.longitude,
                  "latitude" : first.coordinates.latitude
                });
                int len = data.ItemImgList.length;
                for (int i = 0; i <  len; ++i) { //파일 형식에 대한 처릴 ex) png, jpeg
                  int rand = new Math.Random().nextInt(100000);
                  formData.files.add(MapEntry("img", MultipartFile.fromFileSync(data.ItemImgList[i].path, filename: GlobalProfile.loggedInUser.userID.toString()+"_$rand.jpeg")));
                }


                data.transferType;
                formData;

                Student_formdata = new FormData.fromMap({
                  "userID": GlobalProfile.loggedInUser.userID,
                });

                if(null != f) {
                  int rand = new Math.Random().nextInt(100000);
                  Student_formdata.files.add(MapEntry("img", MultipartFile.fromFileSync(f.path, filename: GlobalProfile.loggedInUser.userID.toString()+"_image_$rand.jpeg")));
                  var res2 = await dio.post(ApiProvider().getUrl+"/Information/S3addProfileAuthImg",  data: Student_formdata).timeout(const Duration(seconds: 17));
                }
                formData;


                var res = await dio.post(ApiProvider().getUrl+"/RoomsalesInfo/TransferInsert",  data: formData).timeout(const Duration(seconds: 17));

                data.ResetEnterRoomInfoProvider();
                _UserProvider.ResetDummyUser();
                f = null;

                var list = await ApiProvider().post('/RoomSalesInfo/myroomInfo', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));

                Map<String, dynamic> dummyItem = list[0];
                ModelModifyReleaseRoom dummyRoom = ModelModifyReleaseRoom.fromJson(dummyItem);



                GlobalProfile.roomSalesInfo = new RoomSalesInfo(
                  id:dummyRoom.id,
                  userID: dummyRoom.userID,
                  type: dummyRoom.type,
                  location: dummyRoom.location,
                  locationDetail: dummyRoom.locationDetail,
                  square: dummyRoom.square,
                  monthlyRentFees: dummyRoom.monthlyRentFees,
                  depositFees: dummyRoom.depositFees,
                  depositFeesOffer : dummyRoom.depositFeesOffer,
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
                  imageUrl2:   dummyRoom.imageUrl2,
                  imageUrl3: dummyRoom.imageUrl3,
                  imageUrl4:  dummyRoom.imageUrl4,
                  imageUrl5:  dummyRoom.imageUrl5,
                  tradingState: dummyRoom.tradingState,
                  createdAt:  dummyRoom.createdAt,
                  updatedAt:  dummyRoom.updatedAt,
                  openchat: "",

                );
                //자기 매물 정보
                var list5 = await ApiProvider().post('/RoomSalesInfo/myroomInfo', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID
                    }
                ));

                GlobalProfile.roomSalesInfoList.clear();
                if (list5 != null && list5  != false) {
                  for (int i = 0; i < list5.length; ++i) {
                    GlobalProfile.roomSalesInfoList.add(RoomSalesInfo.fromJson(list5[i]));
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
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
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
                            width: screenWidth * (290/360),
                            height: screenHeight * (400/640),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: screenHeight*(28/640),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: screenWidth*(28/360),),
                                        SvgPicture.asset(
                                          'assets/images/releaseRoomScreen/imgText1.svg',
                                          height: screenHeight*(28/640),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*(4/640),),
                                    Row(
                                      children: [
                                        SizedBox(width: screenWidth*(28/360),),
                                        SvgPicture.asset(
                                          'assets/images/releaseRoomScreen/imgText2.svg',
                                          height: screenHeight*(84/640),
                                          width: screenWidth*(100/360),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom:screenHeight*(64/640),
                                  child:
                                  Row(
                                    children: [
                                      SizedBox(width: screenWidth*(22/360),),
                                      SvgPicture.asset(
                                        'assets/images/releaseRoomScreen/imgImg1.svg',
                                        width:screenWidth*(256/360),
                                        // height: screenHeight*(257/640),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom:0,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Timer(Duration(milliseconds: 1000), () {
                                          });
                                          navigationNumProvider.setNum(7);
                                          Navigator.pushReplacement(
                                              context, // 기본 파라미터, SecondRoute로 전달
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage()) // SecondRoute를 생성하여 적재
                                          );
                                        },
                                        child: Container(
                                          width: screenWidth * (290/360),
                                          height: screenHeight * (60/640),
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(8.0))
                                          ),

                                          child: Center(
                                            child: Text(
                                                '내놓은 매물 보러가기',
                                                style: TextStyle(
                                                  fontSize: screenWidth*(18/360),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
    EnterRoomInfoProvider _UserProvider = Provider.of<EnterRoomInfoProvider>(context, listen: false);
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {
      _UserProvider.ItemImgList.add(imageFile);
    } else {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      _UserProvider.ItemImgList.add(compressImg);
    }
    setState(() {

    });
    EasyLoading.dismiss();
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
      _UserProvider.ItemImgList.add(imageFile);
    } else {
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      _UserProvider.ItemImgList.add(compressImg);
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

    setState(() {

    });
    return;
  }

  Future getImageCamera2(BuildContext context, int index) async {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      data.ChangeItemImgList(index, imageFile);//이미지 들어가는 경우
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      data.ChangeItemImgList(index, compressImg);//이미지 들어가는
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