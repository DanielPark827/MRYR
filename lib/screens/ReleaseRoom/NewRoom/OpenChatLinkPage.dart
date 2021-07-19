import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:geocoder/geocoder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:url_launcher/url_launcher.dart';

import 'MyRoomList.dart';
import 'ProposalRoomInfo.dart';
import 'ProposeTerm.dart';
import 'StudentIdentification.dart';

class OpenChatLinkPage extends StatefulWidget {
  @override
  _OpenChatLinkPageState createState() => _OpenChatLinkPageState();
}

class _OpenChatLinkPageState extends State<OpenChatLinkPage> {
  final TextEditingController _controller = TextEditingController();



  FormData formData;
  FormData Student_formdata = new FormData();


  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    void _launchUrl(String Url)async{
      if(await canLaunch(Url)){
        await launch(Url);
      }
      else{
        throw 'Could not open Url';
      }
    }
    DummyUser _UserProvider = Provider.of<DummyUser>(context);
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider =
    Provider.of<DateInReleaseRoomsScreenProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
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
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
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
              child: Row(
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
                        "오픈채팅 링크",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * (24 / 360)),
                      ),
                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
                      Text(
                        "직거래를 위해 카카오톡 오픈채팅 링크를 입력해주세요.",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: Color(0xff888888)),
                      ),
                      SizedBox(
                        height: screenHeight * (4 / 640),
                      ),
                      Text(
                        "※추후 오픈채팅은 앱 내 채팅기능으로 업데이트 될 예정입니다",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                            fontSize: screenWidth * (12 / 360),
                            color: kPrimaryColor),
                      ),
                      SizedBox(
                        height: screenHeight * (64 / 640),
                      ),
                      Container(
                        height: screenHeight * (38 / 640),
                        width: screenWidth * (340 / 360),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * (19 / 360),
                            ),
                            Container(
                              width: screenWidth * (320 / 360),
                              child: TextField(
                                controller: _controller,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                maxLines: 4,
                                style: TextStyle(
                                      fontSize: screenWidth*(16/360),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF424242)
                                ),
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText:
                                      "https://open.kakao.com/o/s184fddcs",
                                  hintStyle: TextStyle(
                                      fontSize: screenWidth * (16 / 360),
                                      color: Color(0xffd2d2d2)),
                                  // isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth * (336 / 360),
                        height: 1,
                        color: Color(0xffd2d2d2),
                      ),
                      SizedBox(
                        height: screenHeight * (16 / 640),
                      ),
                      InkWell(
                        onTap: (){

                          if (Platform.isAndroid) {
                            _launchUrl('https://tv.kakao.com/v/390647067');
                          } else if (Platform.isIOS) {
                            _launchUrl('https://tv.kakao.com/v/390647074');
                          }
                        },
                        child: Container(
                          width: screenWidth * (224 / 360),
                          height: screenHeight * (32 / 640),
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(22),
                              border: Border.all(
                                width: 1,
                                color: kPrimaryColor,
                              ),
                              boxShadow: [
                                new BoxShadow(
                                  color: Color.fromRGBO(
                                      116, 125, 130, 0.49),
                                  blurRadius: 4,
                                ),
                              ],
                            color: Colors.white
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                SizedBox(width: screenWidth*(12/360),),
                                Text(
                                  "카카오톡 오픈채팅 만드는법 알아보기",
                                  style: TextStyle(
                                      fontSize: screenWidth * (12 / 360),
                                      color: kPrimaryColor),
                                ),
                                SizedBox(width: screenWidth*(5/360),),
                                Icon(Icons.arrow_forward_ios, size: 12.0,color: kPrimaryColor,),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: InkWell(
              onTap: () async {
                if (_controller.text != "") {
                  EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                  Dio dio = new Dio();
                  dio.options.headers = {
                    'Content-Type': 'application/json',
                    'user': 'codeforgeek',
                  };
                  _controller.text;

                  var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(data.Address.toString());
                  var first = addresses.first;

                  Future.microtask(() async {
                    formData = new FormData.fromMap({
                      "userID": GlobalProfile.loggedInUser.userID,
                      "type": data.ItemCategory,
                      "location": data.Address.toString(),
                      "locationdetail": data.DetailAddress.toString(),
                      "monthlyrentfees": data.ExistingMonthlyRent,
                      "depositfees": data.ExistingDeposit,
                      "managementfees": data.AdministrativeExpenses,
                      "utilityfees": data.AverageUtilityBill,
                      "square": data.AreaSize,
                      "depositfeesoffer": data.depositCheckBox == true ? 0 : data.ProposedDeposit,
                      "monthlyrentfeesoffer": data.ProposedMonthlyRent,
                      "rentstart": data.rentStart,
                      "rentdone": data.rentDone,

                      "preferenceterm": data.condition,
                      "preferencesex": data.floor,
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
                      "information": data.ItemDescription,
                      "openchat" : _controller.text,
                      "longitude": first.coordinates.longitude,
                      "latitude" : first.coordinates.latitude
                    });
                    int len = data.ItemImgList.length;
                    for (int i = 0; i <  len; ++i) { //파일 형식에 대한 처릴 ex) png, jpeg
                      int rand = new Math.Random().nextInt(100000);
                      formData.files.add(MapEntry("img", MultipartFile.fromFileSync(data.ItemImgList[i].path, filename: GlobalProfile.loggedInUser.userID.toString()+"_$rand.jpeg")));
                    }

                    Student_formdata = new FormData.fromMap({
                      "userID": GlobalProfile.loggedInUser.userID,
                    });

                    if(null != f) {
                      int rand = new Math.Random().nextInt(100000);
                      Student_formdata.files.add(MapEntry("img", MultipartFile.fromFileSync(f.path, filename: GlobalProfile.loggedInUser.userID.toString()+"_image_$rand.jpeg")));
                      var res2 = await dio.post(ApiProvider().getUrl+"/Information/S3addProfileAuthImg",  data: Student_formdata).timeout(const Duration(seconds: 17));
                    }

                    var res = await dio.post(ApiProvider().getUrl+"/RoomsalesInfo/S3roomInfosInsert",  data: formData).timeout(const Duration(seconds: 17));

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
                      openchat: dummyRoom.openchat,

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


                }
              },
              child: Container(
                width: screenWidth,
                height: screenHeight * (60 / 640),
                color:
                    _controller.text != "" ? kPrimaryColor : Color(0xffcccccc),
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
        ),
      ),
    );
  }
}
