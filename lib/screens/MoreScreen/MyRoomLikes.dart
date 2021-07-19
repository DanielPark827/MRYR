import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/DetailRoomWannaLive.dart';
import 'package:mryr/screens/MoreScreen/model/ModelReverse.dart';
import 'package:mryr/screens/NeedRoomSalesInfo/model/NeedRoomSalesInfoLikes.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/userData/Review.dart';

class MyRoomLikes extends StatefulWidget {
  final int current;

  MyRoomLikes({Key key, this.current,}) : super(key : key);

  @override
  _MyRoomLikesState createState() => _MyRoomLikesState();
}

SharedPreferences localStorage;
String KeyForLikes = 'RoomLikesList';
String KeyForRecent = 'RecentLIst';

class _MyRoomLikesState extends State<MyRoomLikes> with SingleTickerProviderStateMixin{

  int selectedLeft;
  List<String> LikesList = [];
  List<String> RecentList = [];
  int ListIndex = 0;
  int RecentListIndex = 0;

  Future<bool> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    RecentList = await prefs.getStringList(KeyForRecent);
    RecentListIndex = await RecentList.length;
    print("RecentListIndex : "+" ${RecentList}");
    return true;
  }
  AnimationController extendedController;
  @override
  void initState() {
    selectedLeft = widget.current;
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    selectedLeft = 1;

  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }
  List<ModelRoomLikes> RoomLikesList = [];
  List<int> RoomLikesIdList = [];


  List<NeedRoomSalesInfoLikes> NLikesList = [];
  List<int> LikesidList = [];
  Future<bool> initReverse(BuildContext context) async {
    var list = await ApiProvider().post('/NeedRoomSalesInfo/SelectLike', jsonEncode(
        {
          "userID" : GlobalProfile.loggedInUser.userID,
        }
    ));

    if(null != list) {
      NLikesList.clear();
      LikesidList.clear();
      for(int i = 0; i < list.length; ++i){
        Map<String, dynamic> data = list[i];

        NeedRoomSalesInfoLikes item = NeedRoomSalesInfoLikes.fromJson(data);
        NLikesList.add(item);
        LikesidList.add(item.NeedRoomSaleID);
      }
      int len = needRoomSalesInfoList.length;
      for(int i= 0; i < len; i++) {
        if(LikesidList.contains(needRoomSalesInfoList[i].id)) {
          needRoomSalesInfoList[i].ChangeLikes(true);
          needRoomSalesInfoList[i].Likes;
        }
      }

      print('sdfs6');
      return true;
    } else {
      print('no');
      return false;
    }
  }


  void AddRecent(int index) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subList = await getRecentList();
    if(subList == null) {
      subList = [];
    }

    if(subList.contains(index.toString())) {
      return;
    }
    if(subList.length == 10) {
      subList.removeAt(9);
      subList.add(index.toString());
      prefs.setStringList(KeyForRecent, subList);
    } else {
      subList.add(index.toString());
      prefs.setStringList(KeyForRecent, subList);
    }

    print("ddddddddddddddddd"+"${subList.length.toString()}"+"    ${subList}");
  }



  Future<List<String>> getRecentList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(KeyForRecent);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {

    });

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: hexToColor('#F8F8F8'),
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
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedLeft = 1;
                      });
                    },
                    child: Container(
                      height: screenHeight*0.0675,
                      width: screenWidth /2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight*0.0140625,
                          ),
                          Text(
                            '관심 목록',
                            style: TextStyle(
                              fontSize: screenWidth*0.044444,
                              color: selectedLeft == 1? kPrimaryColor: hexToColor('#888888'),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.0109375,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedLeft = 0;
                      });
                    },
                    child: Container(
                      height: screenHeight*0.0675,
                      width: screenWidth /2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight*0.0140625,
                          ),
                          Text(
                            '최근 본 방',
                            style: TextStyle(
                              fontSize: screenWidth*0.044444,
                              color: selectedLeft == 0 ? kPrimaryColor : hexToColor('#888888'),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.0109375,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 200),
                alignment: selectedLeft == 1 ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  height: screenHeight*0.003125,
                  width: screenWidth /2,
                  decoration: BoxDecoration(
                      color: kPrimaryColor
                  ),
                )
            ),
            SizedBox(height: screenHeight*0.0125,),
            selectedLeft == 0 ?
            FutureBuilder(

                future: init(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                  if (snapshot.hasData == false) {
                    return SizedBox();
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }
                  // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                  else {
                    return RecentListIndex == 0 ? Padding(
                      padding: EdgeInsets.only(top:screenHeight*(118/640)),
                      child: emptySnail(screenHeight, screenWidth, "내놓은 방이 아직 없어요!"),
                    ) : Expanded(
                      child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: RecentListIndex ,
                        itemBuilder: (BuildContext context, int index) => getRoomSalesInfoByID(int.parse(RecentList[index])) == null ? SizedBox() :
                        GestureDetector(
                          onTap: () async {
//                                  await AddRecent(index);
                            var tmp = await ApiProvider().post('/RoomSalesInfo/RoomSelectWithLike', jsonEncode(
                                {
                                  "roomID" : getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                  "userID" : GlobalProfile.loggedInUser.userID
                                }
                            ));
                            RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(tmp);

                            GlobalProfile.detailReviewList.clear();
                            double finalLat;
                            double finalLng;
                            if (null ==
                                tmpRoom.lng ||
                                null == tmpRoom
                                    .lat) {
                              var addresses = await Geocoder.google(
                                  'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                  .findAddressesFromQuery(
                                  tmpRoom
                                      .location);
                              var first = addresses.first;
                              tmpRoom.lat = first.coordinates.latitude;
                              tmpRoom.lng = first.coordinates.longitude;
                            } else {
                              finalLat =
                                  tmpRoom.lat;
                              finalLng =
                                  tmpRoom.lng;
                            }
                            var detailReviewList = await ApiProvider()
                                .post('/Review/ReviewListLngLat',
                                jsonEncode({
                                  "longitude": finalLng,
                                  "latitude": finalLat,
                                }));

                            if (detailReviewList != null) {
                              for (int i = 0;
                              i < detailReviewList.length;
                              ++i) {
                                GlobalProfile.detailReviewList.add(
                                    DetailReview.fromJson(
                                        detailReviewList[i]));
                              }
                            }
                            await AddRecent(
                                tmpRoom.id);
                            var res = await Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailedRoomInformation(
                                          roomSalesInfo: tmpRoom,
                                          nbnb: tmpRoom.ShortTerm,
                                        )) // SecondRoute를 생성하여 적재
                            ).then((value) {
                              if (value == false) {
                                getRoomSalesInfoByID(int.parse(RecentList[index]))
                                    .ChangeLikesWithValue(false);
                                getRoomSalesInfoByIDFromMainTransfer(int.parse(RecentList[index])).ChangeLikesWithValue(false);
                                return;
                              } else {
                                getRoomSalesInfoByID(int.parse(RecentList[index]))
                                    .ChangeLikesWithValue(value);
                                getRoomSalesInfoByIDFromMainTransfer(int.parse(RecentList[index])).ChangeLikesWithValue(value);
                              }
                              setState(() {

                              });
                              return;
                            });
                          },
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * 0.19375,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: screenWidth * 0.033333,
                                  right: screenWidth * 0.033333,
                                  top: screenHeight * 0.01875),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: screenWidth * 0.3333333,
                                    height: screenHeight * 0.15625,
                                    child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(4.0),
                                        child:   getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1=="BasicImage"
                                            ?
                                        SvgPicture.asset(
                                          ProfileIconInMoreScreen,
                                          width: screenHeight * (60 / 640),
                                          height: screenHeight * (60 / 640),
                                        )
                                            :
                                        FittedBox(
                                          fit: BoxFit.cover,
                                          child:  getExtendedImage(  get_resize_image_name(getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1,360), 0,extendedController),

                                        )

                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.033333,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: screenWidth*0.503888,//가로 사이즈에 따라 다이나믹하게 가로에 배치되게 처리하자~!
                                        child: Row(
                                          children: [
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: screenWidth * 0.011111,
                                              children: [
                                                Container(
                                                  height: screenHeight * 0.028125,
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        screenWidth * 0.022222,
                                                        screenHeight * 0.000225,
                                                        screenWidth * 0.022222,
                                                        screenHeight * 0.003225),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        globalRoomSalesInfoList[index].tradingState == 1 ? "구축건물" :"신축건물",
                                                        style: TextStyle(
                                                            fontSize:
                                                            screenWidth*TagFontSize,
                                                            color: kPrimaryColor,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    new BorderRadius.circular(4.0),
                                                    color: hexToColor("#E5E5E5"),
                                                  ),
                                                ),
                                                Container(
                                                  height: screenHeight * 0.028125,
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(
                                                        screenWidth * 0.022222,
                                                        screenHeight * 0.000225,
                                                        screenWidth * 0.022222,
                                                        screenHeight * 0.003225),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        globalRoomSalesInfoList[index].Floor == 1 ? "반지하" : globalRoomSalesInfoList[index].Floor == 2 ? "1층" : "2층 이상",
                                                        style: TextStyle(
                                                            fontSize:
                                                            screenWidth*TagFontSize,
                                                            color: kPrimaryColor,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    new BorderRadius.circular(4.0),
                                                    color: hexToColor("#E5E5E5"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.00625,
                                      ),
                                      Text(
                                        globalRoomSalesInfoList[index].monthlyRentFeesOffer.toString() +
                                            '만원 / 월',
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.025,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.00625,
                                      ),
//                                  Text(
//                                    globalRoomSalesInfoList[index].termOfLeaseMin +
//                                        '~' +
//                                        globalRoomSalesInfoList[index].termOfLeaseMax,
//                                    style: TextStyle(color: hexToColor("#888888")),
//                                  ),
                                      Container(
                                        width: screenWidth*0.45,
                                        child: Text(
                                          getRoomSalesInfoByID(int.parse(RecentList[index])).information,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: hexToColor("#888888")),
                                        ),
                                      )
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                })
                :
            selectedLeft == 1 ?
            RoomLikesList.length == 0 ? Padding(
                padding: EdgeInsets.only(top:screenHeight*(118/640)),
                child: emptySnail(screenHeight, screenWidth, "관심 목록이 아직 없어요!")) : Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: RoomLikesList.length ,
                itemBuilder: (BuildContext context, int index) =>
                    GestureDetector(
                      onTap: () async {
                        await AddRecent(index);


                        var tmp = await ApiProvider().post('/RoomSalesInfo/RoomSelectWithLike', jsonEncode(
                            {
                              "roomID" : getRoomSalesInfoByID(RoomLikesIdList[index]).id,
                              "userID" : GlobalProfile.loggedInUser.userID
                            }
                        ));
                        RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(tmp);

                        GlobalProfile.detailReviewList.clear();
                        double finalLat;
                        double finalLng;
                        if (null ==
                            tmpRoom.lng ||
                            null == tmpRoom
                                .lat) {
                          var addresses = await Geocoder.google(
                              'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                              .findAddressesFromQuery(
                              tmpRoom
                                  .location);
                          var first = addresses.first;
                          tmpRoom.lat = first.coordinates.latitude;
                          tmpRoom.lng = first.coordinates.longitude;
                        } else {
                          finalLat =
                              tmpRoom.lat;
                          finalLng =
                              tmpRoom.lng;
                        }
                        var detailReviewList = await ApiProvider()
                            .post('/Review/ReviewListLngLat',
                            jsonEncode({
                              "longitude": finalLng,
                              "latitude": finalLat,
                            }));

                        if (detailReviewList != null) {
                          for (int i = 0;
                          i < detailReviewList.length;
                          ++i) {
                            GlobalProfile.detailReviewList.add(
                                DetailReview.fromJson(
                                    detailReviewList[i]));
                          }
                        }
                        await AddRecent(
                            tmpRoom.id);
                        var res = await Navigator.push(
                            context, // 기본 파라미터, SecondRoute로 전달
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailedRoomInformation(
                                      roomSalesInfo: tmpRoom,
                                      nbnb: tmpRoom.ShortTerm,
                                    )) // SecondRoute를 생성하여 적재
                        ).then((value) {
                          if (value == false) {
                            getRoomSalesInfoByID(RoomLikesIdList[index])
                                .ChangeLikesWithValue(false);
                            getRoomSalesInfoByIDFromMainTransfer(RoomLikesIdList[index]).ChangeLikesWithValue(false);
                            return;
                          } else {
                            getRoomSalesInfoByID(RoomLikesIdList[index])
                                .ChangeLikesWithValue(value);
                            getRoomSalesInfoByIDFromMainTransfer(RoomLikesIdList[index]).ChangeLikesWithValue(value);
                          }
                          setState(() {

                          });
                          return;
                        });
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.19375,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.033333,
                              right: screenWidth * 0.033333,
                              top: screenHeight * 0.01875),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.3333333,
                                height: screenHeight * 0.15625,
                                child: ClipRRect(
                                    borderRadius: new BorderRadius.circular(4.0),
                                    child:  getRoomSalesInfoByID(RoomLikesIdList[index]).imageUrl1=="BasicImage"
                                        ?
                                    SvgPicture.asset(
                                      ProfileIconInMoreScreen,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                    )
                                        :

                                    FittedBox(
                                      fit: BoxFit.cover,
                                      child:  getExtendedImage( get_resize_image_name(getRoomSalesInfoByID(RoomLikesIdList[index]).imageUrl1,360), 0,extendedController),

                                    )


                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.033333,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
//                                          width: screenWidth*0.503888,//가로 사이즈에 따라 다이나믹하게 가로에 배치되게 처리하자~!
                                    child: Row(
                                      children: [
                                        Wrap(
                                          alignment: WrapAlignment.center,
                                          spacing: screenWidth * 0.011111,
                                          children: [
                                            Container(
                                              height: screenHeight * 0.028125,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    screenWidth * 0.022222,
                                                    screenHeight * 0.000225,
                                                    screenWidth * 0.022222,
                                                    screenHeight * 0.003225),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    getRoomSalesInfoByID(RoomLikesIdList[index]).tradingState == 1 ? "신축 건물" :"구축 건물",
                                                    style: TextStyle(
                                                        fontSize:
                                                        screenWidth*TagFontSize,
                                                        color: kPrimaryColor,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                new BorderRadius.circular(4.0),
                                                color: hexToColor("#E5E5E5"),
                                              ),
                                            ),
                                            Container(
                                              height: screenHeight * 0.028125,
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    screenWidth * 0.022222,
                                                    screenHeight * 0.000225,
                                                    screenWidth * 0.022222,
                                                    screenHeight * 0.003225),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    getRoomSalesInfoByID(RoomLikesIdList[index]).Floor == 1 ? "반지하" : getRoomSalesInfoByID(RoomLikesIdList[index]).Floor == 2 ? "1층" : "2층 이상",
                                                    style: TextStyle(
                                                        fontSize:
                                                        screenWidth*TagFontSize,
                                                        color: kPrimaryColor,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                new BorderRadius.circular(4.0),
                                                color: hexToColor("#E5E5E5"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.00625,
                                  ),
                                  Text(

                                    getRoomSalesInfoByID(RoomLikesIdList[index]).monthlyRentFees.toString() +
                                        '만원 / 월',
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.025,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.00625,
                                  ),
//                                  Text(
//                                    globalRoomSalesInfoList[index].termOfLeaseMin +
//                                        '~' +
//                                        globalRoomSalesInfoList[index].termOfLeaseMax,
//                                    style: TextStyle(color: hexToColor("#888888")),
//                                  ),
                                  Container(
                                    width: screenWidth*0.45,
                                    child: Text(
                                      getRoomSalesInfoByID(RoomLikesIdList[index]).information,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(

                                          color: hexToColor("#888888")),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              GestureDetector(

                                  onTap: () async {
                                    var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                        {
                                          "userID" : GlobalProfile.loggedInUser.userID,
                                          "roomSaleID": getRoomSalesInfoByID(RoomLikesIdList[index]).id,
                                        }
                                    ));

                                    getRoomSalesInfoByID(RoomLikesIdList[index]).ChangeLikesWithValue(!getRoomSalesInfoByID(RoomLikesIdList[index]).Likes);
                                    setState(() {
                                    });
                                  },
                                  child:  getRoomSalesInfoByID(RoomLikesIdList[index]).Likes ?
                                  SvgPicture.asset(
                                    PurpleFilledHeartIcon,
                                    width: screenHeight * 0.0375,
                                    height: screenHeight * 0.0375,
                                    color: kPrimaryColor,
                                  )
                                      : SvgPicture.asset(
                                    GreyEmptyHeartIcon,
                                    width: screenHeight * 0.0375,
                                    height: screenHeight * 0.0375,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            )  :
            FutureBuilder(
                future: initReverse(context),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                  if (snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }
                  // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                  else {
                    return Expanded(child:
                    ListView.builder(
                        itemCount: LikesidList.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder:(BuildContext context, int index) {
                          return getRoomSalesInfoById(LikesidList[index]) == null ? SizedBox() : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  var tmp = await ApiProvider().post('/RoomSalesInfo/RoomSelectWithLike', jsonEncode(
                                      {
                                        "roomID" : getRoomSalesInfoById(LikesidList[index]).id,
                                        "userID" : GlobalProfile.loggedInUser.userID
                                      }
                                  ));
                                  RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(tmp);

                                  GlobalProfile.detailReviewList.clear();
                                  double finalLat;
                                  double finalLng;
                                  if (null ==
                                      tmpRoom.lng ||
                                      null == tmpRoom
                                          .lat) {
                                    var addresses = await Geocoder.google(
                                        'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                        .findAddressesFromQuery(
                                        tmpRoom
                                            .location);
                                    var first = addresses.first;
                                    finalLat = first.coordinates.latitude;
                                    finalLng = first.coordinates.longitude;
                                  } else {
                                    finalLat =
                                        tmpRoom.lat;
                                    finalLng =
                                        tmpRoom.lng;
                                  }
                                  var detailReviewList = await ApiProvider()
                                      .post('/Review/ReviewListLngLat',
                                      jsonEncode({
                                        "longitude": finalLng,
                                        "latitude": finalLat,
                                      }));

                                  if (detailReviewList != null) {
                                    for (int i = 0;
                                    i < detailReviewList.length;
                                    ++i) {
                                      GlobalProfile.detailReviewList.add(
                                          DetailReview.fromJson(
                                              detailReviewList[i]));
                                    }
                                  }
                                  await AddRecent(
                                      tmpRoom.id);
                                  var res = await Navigator.push(
                                      context, // 기본 파라미터, SecondRoute로 전달
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailedRoomInformation(
                                                roomSalesInfo: tmpRoom,
                                                nbnb: tmpRoom.ShortTerm,
                                              )) // SecondRoute를 생성하여 적재
                                  ).then((value) {
                                    if (value == false) {
                                      mainTransferList[index]
                                          .ChangeLikesWithValue(false);
                                      return;
                                    }
                                    mainTransferList[index]
                                        .ChangeLikesWithValue(value);
                                    setState(() {

                                    });
                                    return;
                                  });

                                  Navigator.push(
                                      context, // 기본 파라미터, SecondRoute로 전달
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailRoomWannaLive( needRoomInfo : getRoomSalesInfoById(LikesidList[index]),Likes: getRoomSalesInfoById(LikesidList[index]).Likes,)) // SecondRoute를 생성하여 적재
                                  ).then((value) {
                                    getRoomSalesInfoById(LikesidList[index]).ChangeLikes(value);
                                    setState(() {

                                    });
                                  });

                                },
                                child: Container(
                                  height: screenHeight * (136/640),
                                  color: Colors.white,
                                  child: Row(

                                    children: [
                                      SizedBox(width: screenWidth *(12/360),),
                                      Column(
                                        children: [
                                          SizedBox(height: screenHeight*(12/640),),
                                          SvgPicture.asset(
                                            PersonalProfileImage,
                                            width: screenWidth * (100/360),
                                            height: screenHeight * (100/640),
                                          ),
                                        ],
                                      ),
                                      Container(
                                          child: SizedBox(width: screenWidth * (12/360),)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: screenHeight * (12/640),),
                                            Row(children: [
                                              Container(
                                                width: screenWidth*(53/360),
                                                height: screenHeight*(22/640),
                                                decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                                child: Center(child: Text(
                                                  getRoomSalesInfoById(LikesidList[index]).Type == null?"error":getRoomSalesInfoById(LikesidList[index]).Type == 0?"원룸": getRoomSalesInfoById(LikesidList[index]).Type == 1?"투룸이상": getRoomSalesInfoById(LikesidList[index]).Type == 2?"오피스텔":"아파트"
                                                  ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                              ),
                                              SizedBox(width: screenWidth*(4/360),),
                                              Container(
                                                width: screenWidth*(53/360),
                                                height: screenHeight*(22/640),
                                                decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                                child: Center(child: Text( getRoomSalesInfoById(LikesidList[index]).SmokingPossible == 0?"흡연 O":getRoomSalesInfoById(LikesidList[index]).SmokingPossible == 1?"흡연 X": "흡연 무관"
                                                  ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                              ),
                                              SizedBox(width: screenWidth*(4/360),),
                                              Container(
                                                width: screenWidth*(53/360),
                                                height: screenHeight*(22/640),
                                                decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                                child: Center(child: Text(getRoomSalesInfoById(LikesidList[index]).PreferSex== 0?"남자 선호":getRoomSalesInfoById(LikesidList[index]).PreferSex == 1?"여자 선호": "성별 무관",
                                                  style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                              ),
                                              Expanded(child: SizedBox()),
                                              GestureDetector(
                                                  onTap: () async {
                                                    LikesidList[index];
                                                    var res = await ApiProvider().post('/NeedRoomSalesInfo/InsertLike', jsonEncode(
                                                        {
                                                          "userID" : GlobalProfile.loggedInUser.userID,
                                                          "needRoomSaleID": LikesidList[index],
                                                        }
                                                    ));
                                                    getRoomSalesInfoById(LikesidList[index]).ChangeLikes(!getRoomSalesInfoById(LikesidList[index]).Likes);
                                                    setState(() {
                                                    });
                                                  },
                                                  child:  getRoomSalesInfoById(LikesidList[index]).Likes ?
                                                  SvgPicture.asset(
                                                    PurpleFilledHeartIcon,
                                                    width: screenHeight * 0.0375,
                                                    height: screenHeight * 0.0375,
                                                    color: kPrimaryColor,
                                                  )
                                                      : SvgPicture.asset(
                                                    GreyEmptyHeartIcon,
                                                    width: screenHeight * 0.0375,
                                                    height: screenHeight * 0.0375,
                                                  )),
                                              SizedBox(width: screenWidth*0.03333,),
                                            ],),
                                            SizedBox(height: screenHeight * (4/640),),
                                            Row(children: [
                                              Text(getRoomSalesInfoById(LikesidList[index]).MonthlyFeesMin.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                              Text("만원",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                              Text(" ~ ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                              Text(getRoomSalesInfoById(LikesidList[index]).MonthlyFeesMax.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                              Text("만원 / 월",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                            ],),
                                            SizedBox(height: screenHeight*(4/640),),
                                            Row(
                                              children: [
                                                Container(
                                                    width: screenWidth*(75/360),
                                                    child: Text("임대희망기간",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*ListContentsFontSize),)),
                                                getRoomSalesInfoById(LikesidList[index]).TermOfLeaseMin ==null? Text(" - ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),)
                                                    : Row(children: [
                                                  Text(getMonthAndDay(getRoomSalesInfoById(LikesidList[index]).TermOfLeaseMin),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  Text(" ~ ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  Text(getMonthAndDay(getRoomSalesInfoById(LikesidList[index]).TermOfLeaseMax),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                ],),
                                              ],
                                            ),
                                            SizedBox(height: screenHeight*(4/640),),
                                            Row(
                                              children: [
                                                Container(
                                                    width: screenWidth*(75/360),
                                                    child: Text("희망보증금",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*ListContentsFontSize),)),
                                                Row(children: [
                                                  Text(getRoomSalesInfoById(LikesidList[index]).DepositeFeesMin.toString(),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  Text("만원",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  Text(" ~ ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  Text(getRoomSalesInfoById(LikesidList[index]).DepositeFeesMax.toString(),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  Text("만원",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                ],),
                                              ],
                                            ),
                                            SizedBox(height: screenHeight*(2/640),),
                                            Row(children: [
                                              Spacer(),
                                              Text(timeCheck( getRoomSalesInfoById(LikesidList[index]).updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),
                                              SizedBox(width: screenWidth*(12/360),)
                                            ],)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * (8/640),),
                            ],
                          );
                        }
                    )
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
