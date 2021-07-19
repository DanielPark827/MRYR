import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:infinity_page_view/infinity_page_view.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/constants/MryrTextStyle.dart';
import 'package:mryr/model/DashBoardAdPagesProvider.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/FirebaseNotification.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/RoomForBorrowList.dart';
import 'package:mryr/screens/NewRoomScreen.dart';
import 'package:mryr/screens/ReleaseRoom/MainReleaseRoomScreen.dart';
import 'package:mryr/screens/ReleaseRoom/ReleaseRoomTutorialScreen.dart';
import 'package:mryr/screens/Review/ReviewScreenInMap.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/ExtendedImage.dart';import 'package:mryr/utils/StatusBar.dart';
import 'package:mryr/widget/DashBoardScreen/DashBoardAdPageViews.dart';
import 'package:mryr/widget/DashBoardScreen/DashBoardNotificationButton.dart';
import 'package:mryr/widget/DashBoardScreen/RecentSearchList.dart';
import 'package:mryr/widget/DashBoardScreen/ReleaseAndLookForRoom.dart';
import 'package:mryr/widget/DashBoardScreen/ReviewForRooms.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotiProvider.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotification.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/screens/BorrowRoom/GoogleMap/SearchMapForReleaseRoom.dart';
import 'package:mryr/screens/Review/SearchMapForReview.dart';
import 'BorrowRoom/model/ModelRoomLikes.dart';
import 'Review/ReviewScreenInMapDetail.dart';
import 'Review/ReviewScreenInMapMain.dart';
import 'Setting/tutorial/TutorialScreenInSetting.dart';

class newRoomScreen extends StatefulWidget {
  @override
  _newRoomScreenState createState() => _newRoomScreenState();
}

class _newRoomScreenState extends State<newRoomScreen> with SingleTickerProviderStateMixin {


  AnimationController extendedController;
  void initState() {
    super.initState();

    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
  }

  @override
  void dispose() {
    extendedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
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
        child: Column(children: [
          Container(width:screenWidth,

            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: getExtendedImage((GlobalProfile.banner['ImageUrl1'] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ (GlobalProfile.banner['ImageUrl1'] as String)) , 0,extendedController),
            ),),
          Container(
            color: Colors.white,
            child: Column(children: [

              Container(height: screenHeight*(15/640),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(width: screenWidth*(16/360),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      s1,
                      width: screenWidth*(125/360),
                    ),
                  ],
                ),
                Spacer(),
                FlatButton(
                    onPressed: ()async{
                      if(doubleCheck == false) {
                        doubleCheck = true;

                        RoomSalesInfo tttt;
                        for (int i = 0; i < nbnbRoom.length; i++) {
                          if (nbnbRoom[i].id == monthlyNewFst[0].id) {
                            tttt = nbnbRoom[i];
                          }
                        }
                        if (tttt != null) {
                          //내방니방 직영 예약 날짜 받아오기
                          var tmp9 = await ApiProvider()
                              .post(
                              '/RoomSalesInfo/NbnbRoomDateSelect',
                              jsonEncode(
                                  {"roomID": tttt
                                      .id.toString()}));
                          GlobalProfile.reserveDateList
                              .clear();
                          if (tmp9 != null && tmp9.length != 0) {
                            Map<String,
                                dynamic> data = tmp9[0];
                            String tmp = data["Date"] as String;
                            if (tmp == "") {}
                            else {
                              for (int i = 0; i <
                                  tmp9.length; i++) {
                                ReserveDate _reserveDate = ReserveDate
                                    .fromJson(tmp9[i]);

                                if ((DateTime
                                    .now()
                                    .year ==
                                    _reserveDate.year &&
                                    DateTime
                                        .now()
                                        .month <=
                                        _reserveDate.month)
                                    || (DateTime
                                        .now()
                                        .year + 1 ==
                                        _reserveDate.year &&
                                        DateTime
                                            .now()
                                            .month >
                                            _reserveDate
                                                .month))
                                  GlobalProfile
                                      .reserveDateList.add(
                                      _reserveDate);
                              }
                            }
                          }


                          GlobalProfile.detailReviewList
                              .clear();

                          var detailReviewList = await ApiProvider()
                              .post('/Review/SelectRoom',
                              jsonEncode({
                                "location": tttt
                                    .location
                              }));

                          if (detailReviewList != null) {
                            for (int i = 0;
                            i < detailReviewList.length;
                            ++i) {
                              GlobalProfile.detailReviewList
                                  .add(
                                  DetailReview.fromJson(
                                      detailReviewList[i]));
                            }
                          }

                          var res = await Navigator.push(
                              context,
                              // 기본 파라미터, SecondRoute로 전달
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailedRoomInformation(
                                        roomSalesInfo: tttt,
                                        nbnb: true,
                                      )) // SecondRoute를 생성하여 적재
                          );
                          extendedController.reset();
                          setState(() {

                          });
                        }
                      }
                    },
                    child: Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff7CC1CF)),)),


              ],),
              SizedBox(
                height: screenHeight * (12/ 640),
              ),

              (monthlyNewFst == null || monthlyNewFst.length == 0)? Container():  monthlyNewFst[0].imageUrl1 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewFst[0].imageUrl1, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),


              (monthlyNewFst == null || monthlyNewFst.length == 0)? Container():monthlyNewFst[0].imageUrl2 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewFst[0].imageUrl2, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
           :Container(),

              (monthlyNewFst == null || monthlyNewFst.length == 0)? Container():monthlyNewFst[0].imageUrl3 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewFst[0].imageUrl3, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),
            ],),
          ),
          Container(

            height: screenHeight * (8 / 640),
          ),
          Container(
            color: Colors.white,
            child: Column(children: [

              Container(height: screenHeight*(15/640),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: screenWidth*(16/360),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        s2,
                        width: screenWidth*(175/360),
                      ),
                    ],
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: ()async{
                        if(doubleCheck == false) {
                          doubleCheck = true;

                          RoomSalesInfo tttt;
                          for (int i = 0; i < nbnbRoom.length; i++) {
                            if (nbnbRoom[i].id == monthlyNewScd[0].id) {
                              tttt = nbnbRoom[i];
                            }
                          }
                          if (tttt != null) {
                            //내방니방 직영 예약 날짜 받아오기
                            var tmp9 = await ApiProvider()
                                .post(
                                '/RoomSalesInfo/NbnbRoomDateSelect',
                                jsonEncode(
                                    {"roomID": tttt
                                        .id.toString()}));
                            GlobalProfile.reserveDateList
                                .clear();
                            if (tmp9 != null && tmp9.length != 0) {
                              Map<String,
                                  dynamic> data = tmp9[0];
                              String tmp = data["Date"] as String;
                              if (tmp == "") {}
                              else {
                                for (int i = 0; i <
                                    tmp9.length; i++) {
                                  ReserveDate _reserveDate = ReserveDate
                                      .fromJson(tmp9[i]);

                                  if ((DateTime
                                      .now()
                                      .year ==
                                      _reserveDate.year &&
                                      DateTime
                                          .now()
                                          .month <=
                                          _reserveDate.month)
                                      || (DateTime
                                          .now()
                                          .year + 1 ==
                                          _reserveDate.year &&
                                          DateTime
                                              .now()
                                              .month >
                                              _reserveDate
                                                  .month))
                                    GlobalProfile
                                        .reserveDateList.add(
                                        _reserveDate);
                                }
                              }
                            }


                            GlobalProfile.detailReviewList
                                .clear();

                            var detailReviewList = await ApiProvider()
                                .post('/Review/SelectRoom',
                                jsonEncode({
                                  "location": tttt
                                      .location
                                }));

                            if (detailReviewList != null) {
                              for (int i = 0;
                              i < detailReviewList.length;
                              ++i) {
                                GlobalProfile.detailReviewList
                                    .add(
                                    DetailReview.fromJson(
                                        detailReviewList[i]));
                              }
                            }

                            var res = await Navigator.push(
                                context,
                                // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailedRoomInformation(
                                          roomSalesInfo: tttt,
                                          nbnb: true,
                                        )) // SecondRoute를 생성하여 적재
                            );
                            extendedController.reset();
                            setState(() {

                            });
                          }
                        }
                      },
                      child: Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff7CC1CF)),)),


                ],),
              SizedBox(
                height: screenHeight * (12/ 640),
              ),

              (monthlyNewScd == null || monthlyNewScd.length == 0)? Container():  monthlyNewScd[0].imageUrl1 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewScd[0].imageUrl1, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),
              (monthlyNewScd == null || monthlyNewScd.length == 0)? Container():  monthlyNewScd[0].imageUrl2 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewScd[0].imageUrl2, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),


              (monthlyNewScd == null || monthlyNewScd.length == 0)? Container(): monthlyNewScd[0].imageUrl3 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewScd[0].imageUrl3, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),
              SizedBox(
                height: screenHeight * (4/ 640),
              ),


            ],),
          ),
          Container(

            height: screenHeight * (8 / 640),
          ),
          Container(
            color: Colors.white,
            child: Column(children: [

              Container(height: screenHeight*(15/640),),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: screenWidth*(16/360),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        s3,
                     width: screenWidth*(165/360),
                      ),
                    ],
                  ),
                  Spacer(),
                  FlatButton(
                      onPressed: ()async{
                        if(doubleCheck == false) {
                          doubleCheck = true;

                          RoomSalesInfo tttt;
                          for (int i = 0; i < nbnbRoom.length; i++) {
                            if (nbnbRoom[i].id == monthlyNewTrd[0].id) {
                              tttt = nbnbRoom[i];
                            }
                          }
                          if (tttt != null) {
                            //내방니방 직영 예약 날짜 받아오기
                            var tmp9 = await ApiProvider()
                                .post(
                                '/RoomSalesInfo/NbnbRoomDateSelect',
                                jsonEncode(
                                    {"roomID": tttt
                                        .id.toString()}));
                            GlobalProfile.reserveDateList
                                .clear();
                            if (tmp9 != null && tmp9.length != 0) {
                              Map<String,
                                  dynamic> data = tmp9[0];
                              String tmp = data["Date"] as String;
                              if (tmp == "") {}
                              else {
                                for (int i = 0; i <
                                    tmp9.length; i++) {
                                  ReserveDate _reserveDate = ReserveDate
                                      .fromJson(tmp9[i]);

                                  if ((DateTime
                                      .now()
                                      .year ==
                                      _reserveDate.year &&
                                      DateTime
                                          .now()
                                          .month <=
                                          _reserveDate.month)
                                      || (DateTime
                                          .now()
                                          .year + 1 ==
                                          _reserveDate.year &&
                                          DateTime
                                              .now()
                                              .month >
                                              _reserveDate
                                                  .month))
                                    GlobalProfile
                                        .reserveDateList.add(
                                        _reserveDate);
                                }
                              }
                            }


                            GlobalProfile.detailReviewList
                                .clear();

                            var detailReviewList = await ApiProvider()
                                .post('/Review/SelectRoom',
                                jsonEncode({
                                  "location": tttt
                                      .location
                                }));

                            if (detailReviewList != null) {
                              for (int i = 0;
                              i < detailReviewList.length;
                              ++i) {
                                GlobalProfile.detailReviewList
                                    .add(
                                    DetailReview.fromJson(
                                        detailReviewList[i]));
                              }
                            }

                            var res = await Navigator.push(
                                context,
                                // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailedRoomInformation(
                                          roomSalesInfo: tttt,
                                          nbnb: true,
                                        )) // SecondRoute를 생성하여 적재
                            );
                            extendedController.reset();
                            setState(() {

                            });
                          }
                        }
                      },
                      child: Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff7CC1CF)),)),


                ],),
              SizedBox(
                height: screenHeight * (12/ 640),
              ),

              (monthlyNewTrd == null || monthlyNewTrd.length == 0)? Container(): monthlyNewTrd[0].imageUrl1 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewTrd[0].imageUrl1, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),

              (monthlyNewTrd == null || monthlyNewTrd.length == 0)? Container():monthlyNewTrd[0].imageUrl2 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewTrd[0].imageUrl2, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),

              (monthlyNewTrd == null || monthlyNewTrd.length == 0)? Container():monthlyNewTrd[0].imageUrl3 !="BasicImage" ?  Column(
                children: [
                  Container(
                    width: screenWidth*(300/360),
                    height: screenWidth*(210/360),


                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: getExtendedImage(monthlyNewTrd[0].imageUrl3, 0,extendedController),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (11/ 640),
                  )
                ],
              )
                  :Container(),
              SizedBox(
                height: screenHeight * (4/ 640),
              ),

            ],),
          ),
          Container(

            height: screenHeight * (8 / 640),
          ),
        ],),
      ),
    );
  }
}
