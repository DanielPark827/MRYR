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
import 'package:mryr/userData/User.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
        backgroundColor: (selectedLeft == 1 &&
            RoomLikesList.length != 0) ? Colors.white : (RecentListIndex != 0 && selectedLeft == 1) ? Colors.white : hexToColor('#F8F8F8'),
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white ,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () async {
                EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                //내방니방직영
                nbnbRoom.clear();
                var tmp = await ApiProvider().post('/RoomSalesInfo/ShortListWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));
                if(null != tmp){
                  for(int i = 0;i<tmp.length;i++){
                    nbnbRoom.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                  }
                }



                //메인 단기매물 리스트
                mainShortList.clear();
                tmp = await ApiProvider().post('/RoomSalesInfo/MainShortWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }
                ));
                if(null != tmp){
                  for(int i = 0;i<tmp.length;i++){
                    mainShortList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                  }
                }


                //메인 양도매물 리스트
                mainTransferList.clear();
                tmp = await ApiProvider().post('/RoomSalesInfo/MainTransferWithLike', jsonEncode(
                    {
                      "userID" : GlobalProfile.loggedInUser.userID
                    }
                ));
                if(null != tmp){
                  for(int i = 0;i<tmp.length;i++){
                    mainTransferList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                  }
                }

                var list = await ApiProvider().post(
                    '/RoomSalesInfo/TransferListWithLike', jsonEncode(
                    {
                      "userID": GlobalProfile.loggedInUser.userID,
                    }
                ));

                globalRoomSalesInfoList.clear();
                if (list != null) {
                  for (int i = 0; i < list.length; ++i) {
                    RoomSalesInfo tmp = RoomSalesInfo.fromJsonLittle(list[i]);
                    globalRoomSalesInfoList.add(tmp);
                  }
                }
                Navigator.pop(context);
                EasyLoading.dismiss();
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
                    onTap: ()async{
                      var list = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
                          {
                            "userID" : GlobalProfile.loggedInUser.userID,
                          }
                      ));

                      if(null != list) {
                        GlobalProfile.RoomLikesList.clear();
                        GlobalProfile.RoomLikesIdList.clear();
                        for (int i = 0; i < list.length; ++i) {
                          Map<String, dynamic> data = list[i];

                          ModelRoomLikes item = ModelRoomLikes.fromJson(data);
                          GlobalProfile.RoomLikesIdList.add(item.RoomSaleID);
                          GlobalProfile.RoomLikesList.add(item);
                          //await NotiDBHelper().createData(noti);
                        }
                        for (int i = 0; i < globalRoomSalesInfoList.length; i++) {
                          if (GlobalProfile.RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
                            globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
                          }
                        }

                        print('sdfs5');
                      }
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
                        getRoomSalesInfoByID(int.parse(RecentList[index])).ShortTerm ?  GestureDetector(
                          onTap: () async {

                            if(doubleCheck == false) {
                              doubleCheck = true;

                              //내방니방 직영 예약 날짜 받아오기
                              var tmp9 = await ApiProvider()
                                  .post(
                                  '/RoomSalesInfo/NbnbRoomDateSelect',
                                  jsonEncode(
                                      {"roomID":getRoomSalesInfoByID(int.parse(RecentList[index]))
                                          .id.toString()}));
                              GlobalProfile.reserveDateList
                                  .clear();
                              if(tmp9 != null && tmp9.length !=0){
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
                              // if (null ==
                              //    getRoomSalesInfoByID(int.parse(RecentList[index])).lng ||
                              //     null ==getRoomSalesInfoByID(int.parse(RecentList[index]))
                              //         .lat) {
                              //   var addresses = await Geocoder.google(
                              //       'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                              //       .findAddressesFromQuery(
                              //      getRoomSalesInfoByID(int.parse(RecentList[index]))
                              //           .location);
                              //   var first = addresses.first;
                              //  getRoomSalesInfoByID(int.parse(RecentList[index])).lat = first.coordinates.latitude;
                              //  getRoomSalesInfoByID(int.parse(RecentList[index])).lng = first.coordinates.longitude;
                              // }
                              await AddRecent(
                                 getRoomSalesInfoByID(int.parse(RecentList[index])).id);

                              GlobalProfile.detailReviewList
                                  .clear();

                              var detailReviewList = await ApiProvider()
                                  .post('/Review/SelectRoom',
                                  jsonEncode({
                                    "location":getRoomSalesInfoByID(int.parse(RecentList[index]))
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

                              var tmp = await ApiProvider()
                                  .post('/RoomSalesInfo/RoomSelectWithLike',
                                  jsonEncode({
                                    "roomID":getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                    "userID": GlobalProfile.loggedInUser.userID,
                                  }));

                              RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(tmp);

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
                              }


                              var res = await Navigator.push(
                                  context,
                                  // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedRoomInformation(
                                            roomSalesInfo: tmpRoom,
                                            nbnb:tmpRoom.ShortTerm,
                                          )) // SecondRoute를 생성하여 적재
                              ).then((value) {
                                if(null == value) {
                                  return;
                                }
                                if (value == false) {
                                 getRoomSalesInfoByID(int.parse(RecentList[index]))
                                      .ChangeLikesWithValue(false);
                                  return;
                                }
                               getRoomSalesInfoByID(int.parse(RecentList[index]))
                                    .ChangeLikesWithValue(value);
                                setState(() {

                                });
                                return;
                              });;;
                              extendedController.reset();
                              setState(() {

                              });
                            }
                          },
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * (110/620),
                            decoration: BoxDecoration(
                              /* boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],*/


                              color: Color(0xffffffff),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: screenWidth*(12/360),),
                                Column(
                                  children: [
                                    SizedBox(height: screenHeight * 0.00875),

                                    Container(
                                      width: screenWidth * 0.3333333,
                                      height: screenWidth * (100/360),
                                      child: ClipRRect(
                                          borderRadius: new BorderRadius.circular(4.0),
                                          child:     (getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1=="BasicImage" ||getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1 == null)
                                              ?
                                          FittedBox(
                                            fit: BoxFit.cover,
                                            child: SvgPicture.asset(
                                              mryrInReviewScreen,

                                            ),
                                          )
                                              :  Stack(
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.cover,
                                                child:    getExtendedImage(get_resize_image_name(getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1,360), 0,extendedController),
                                              ),
                                              Center(
                                                child: SvgPicture.asset(
                                                    RoomWaterMark,
                                                    width: screenWidth*(56/360),
                                                    height:screenHeight*(16/640)
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: screenWidth * 0.033333,
                                ),
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(height: screenHeight * 0.01875),
                                                SizedBox(
                                                  width: screenWidth*(180/360),
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
                                                                  screenWidth * 0.022222,0),
                                                              child: Align(
                                                                alignment: Alignment.center,
                                                                child: Text(
                                                                  "내방니방 직영",
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
                                                              color: hexToColor('#EEEEEE'),
                                                            ),
                                                          ),

                                                          Container(
                                                            height: screenHeight * 0.028125,
                                                            child: Padding(
                                                              padding: EdgeInsets.fromLTRB(
                                                                  screenWidth * 0.022222,
                                                                  screenHeight * 0.000225,
                                                                  screenWidth * 0.022222,
                                                                  0),
                                                              child: Align(
                                                                alignment: Alignment.center,
                                                                child: Text(
                                                                  "하루 가능",
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
                                                              color: hexToColor('#EEEEEE'),
                                                            ),
                                                          )
                                                        ],
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.00625,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                             getRoomSalesInfoByID(int.parse(RecentList[index])).DailyRentFeesOffer.toString() +
                                                  '만원 / 일',
                                              style: TextStyle(
                                                  fontSize: screenHeight * 0.025,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                            Text(
                                              ' ( '+getRoomSalesInfoByID(int.parse(RecentList[index])).WeeklyRentFeesOffer.toString() +
                                                  '만원 / 주 )',
                                              style: TextStyle(
                                                  fontSize: screenWidth * (12/360),
                                                  color: Color(0xff888888)),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: screenHeight * 0.00625,
                                        ),
                                        Container(
                                          width:screenWidth*(205/360),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: screenWidth*0.45,
                                                height: screenHeight*(36/640),
                                                child: Text(
                                                 getRoomSalesInfoByID(int.parse(RecentList[index])).information==null?"":getRoomSalesInfoByID(int.parse(RecentList[index])).information,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: hexToColor("#888888")),
                                                ),
                                              ),
                                              Expanded(child: SizedBox()),
                                              Text(timeCheck(getRoomSalesInfoByID(int.parse(RecentList[index])).updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                    Positioned(
                                      top: screenWidth*(8/360),
                                      right:screenWidth*(4/360),
                                      child: GestureDetector(

                                          onTap: () async {
                                            var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                {
                                                  "userID" : GlobalProfile.loggedInUser.userID,
                                                  "roomSaleID":getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                                }
                                            ));
                                            bool sub = !getRoomSalesInfoByID(int.parse(RecentList[index])).Likes;
                                           getRoomSalesInfoByID(int.parse(RecentList[index])).ChangeLikesWithValue(sub);
                                            getRoomSalesInfoByIDFromMainTransfer(getRoomSalesInfoByID(int.parse(RecentList[index])).id).ChangeLikesWithValue(sub);
                                            setState(() {

                                            });

                                          },
                                          child:  (getRoomSalesInfoByID(int.parse(RecentList[index])).Likes == null || !getRoomSalesInfoByID(int.parse(RecentList[index])).Likes) ?
                                          SvgPicture.asset(
                                            GreyEmptyHeartIcon,

                                            width: screenHeight * 0.0375,
                                            height: screenHeight * 0.0375,
                                            color: Color(0xffEEEEEE),
                                          )
                                              : SvgPicture.asset(
                                            PurpleFilledHeartIcon,
                                            width: screenHeight * 0.0375,
                                            height: screenHeight * 0.0375,
                                            color: kPrimaryColor,
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),

                          ),
                        ) : GestureDetector(
                          onTap: () async {
                            if(doubleCheck  ==false) {
                              doubleCheck = true;

                              var t = await ApiProvider()
                                  .post('/RoomSalesInfo/RoomSelectWithLike',
                                  jsonEncode({
                                    "roomID": getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                    "userID": GlobalProfile.loggedInUser.userID,
                                  }));

                              RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(t);

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
                                tmpRoom
                                    .lat = first.coordinates.latitude;
                                tmpRoom
                                    .lng = first.coordinates.longitude;
                              }
                              else{
                                finalLng = tmpRoom.lng;
                                finalLat = tmpRoom.lat;
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
                                            nbnb:tmpRoom.ShortTerm,
                                          )) // SecondRoute를 생성하여 적재
                              ).then((value) {
                                if (value == false) {
                                  getRoomSalesInfoByID(int.parse(RecentList[index]))
                                      .ChangeLikesWithValue(false);
                                  return;
                                }
                                getRoomSalesInfoByID(int.parse(RecentList[index]))
                                    .ChangeLikesWithValue(value);
                                setState(() {

                                });
                                return;
                              });
                            }

                          },
                          child: Container(
                            width: screenWidth,
                            height: screenHeight * (110/620),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.033333,
                                //  right: screenWidth * 0.033333,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: screenHeight * 0.00875),
                                      Container(
                                        width: screenWidth * 0.3333333,
                                        height: screenWidth * (100/360),
                                        child: ClipRRect(
                                            borderRadius: new BorderRadius.circular(4.0),
                                            child:      getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1=="BasicImage"
                                                ?
                                            FittedBox(
                                              fit: BoxFit.cover,
                                              child: SvgPicture.asset(
                                                mryrInReviewScreen,

                                              ),
                                            )
                                                :  Stack(
                                              children: [
                                                FittedBox(
                                                  fit: BoxFit.cover,
                                                  child:    getExtendedImage(get_resize_image_name(getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1,360), 0,extendedController),
                                                ),
                                                Center(
                                                  child: SvgPicture.asset(
                                                      RoomWaterMark,
                                                      width: screenWidth*(56/360),
                                                      height:screenHeight*(16/640)
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.033333,
                                  ),
                                  Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: screenHeight * 0.01875),
                                                  SizedBox(
                                                    width: screenWidth*(185/360),
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
                                                                    screenHeight * 0.000225),
                                                                child: Align(
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    getRoomSalesInfoByID(int.parse(RecentList[index])).Condition == 1 ? "신축 건물" : "구축 건물",
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
                                                                    0),
                                                                child: Align(
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    getRoomSalesInfoByID(int.parse(RecentList[index])).Floor == 1 ? "반지하" : getRoomSalesInfoByID(int.parse(RecentList[index])).Floor == 2 ? "1층" : "2층 이상",
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
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.00625,
                                          ),

                                          Text(
                                            getRoomSalesInfoByID(int.parse(RecentList[index])).jeonse == true?    getRoomSalesInfoByID(int.parse(RecentList[index])).depositFeesOffer.toString()+"만원 / 전세" :      getRoomSalesInfoByID(int.parse(RecentList[index])).monthlyRentFeesOffer.toString()+"만원 / 월세",

                                            style: TextStyle(
                                                fontSize: screenHeight * 0.025,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.00625,
                                          ),
                                          Text(
                                              getRoomSalesInfoByID(int.parse(RecentList[index])).termOfLeaseMin.toString() + " ~ "+getRoomSalesInfoByID(int.parse(RecentList[index])).termOfLeaseMax.toString(),
                                              style:TextStyle(
                                                fontSize: screenWidth*(12/360),
                                                color:hexToColor("#44444444"),
                                              )
                                          ),
                                          Container(
                                            width:screenWidth*(205/360),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: screenWidth*0.45,
                                                  height: screenHeight*(36/640),
                                                  child: Text(
                                                    getRoomSalesInfoByID(int.parse(RecentList[index])).information==null?"":getRoomSalesInfoByID(int.parse(RecentList[index])).information,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: hexToColor("#888888")),
                                                  ),
                                                ),
                                                Expanded(child: SizedBox()),
                                                Text(timeCheck( getRoomSalesInfoByID(int.parse(RecentList[index])).updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

                                              ],
                                            ),
                                          ),



                                        ],
                                      ),
                                      Positioned(
                                        top: screenWidth*(8/360),
                                        right:screenWidth*(4/360),
                                        child: GestureDetector(

                                            onTap: () async {
                                              var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                  {
                                                    "userID" : GlobalProfile.loggedInUser.userID,
                                                    "roomSaleID": getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                                  }
                                              ));
                                              bool sub = !getRoomSalesInfoByID(int.parse(RecentList[index])).Likes;
                                              getRoomSalesInfoByID(int.parse(RecentList[index])).ChangeLikesWithValue(sub);
                                              getRoomSalesInfoByIDFromMainTransfer(getRoomSalesInfoByID(int.parse(RecentList[index])).id).ChangeLikesWithValue(sub);
                                              setState(() {

                                              });
                                            },
                                            child:  ( getRoomSalesInfoByID(int.parse(RecentList[index])).Likes == null || !getRoomSalesInfoByID(int.parse(RecentList[index])).Likes) ?
                                            SvgPicture.asset(
                                              GreyEmptyHeartIcon,

                                              width: screenHeight * 0.0375,
                                              height: screenHeight * 0.0375,
                                              color: Color(0xffEEEEEE),
                                            )
                                                : SvgPicture.asset(
                                              PurpleFilledHeartIcon,
                                              width: screenHeight * 0.0375,
                                              height: screenHeight * 0.0375,
                                              color: kPrimaryColor,
                                            )),
                                      )
                                    ],
                                  ),
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
              child: ListView.separated(
                physics: ClampingScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) => Container(
                  height:screenHeight*(4/640),
                  color:hexToColor('#F8F8F8')
                ),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: RoomLikesList.length ,
                itemBuilder: (BuildContext context, int index) =>
                RoomLikesList[index].ShortTerm ? GestureDetector(
                  onTap: () async {

                    if(doubleCheck == false) {
                      doubleCheck = true;

                      //내방니방 직영 예약 날짜 받아오기
                      var tmp9 = await ApiProvider()
                          .post(
                          '/RoomSalesInfo/NbnbRoomDateSelect',
                          jsonEncode(
                              {"roomID": RoomLikesList[index]
                                  .id.toString()}));
                      GlobalProfile.reserveDateList
                          .clear();
                      if(tmp9 != null && tmp9.length !=0){
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
                      // if (null ==
                      //     RoomLikesList[index].lng ||
                      //     null == RoomLikesList[index]
                      //         .lat) {
                      //   var addresses = await Geocoder.google(
                      //       'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                      //       .findAddressesFromQuery(
                      //       RoomLikesList[index]
                      //           .location);
                      //   var first = addresses.first;
                      //   RoomLikesList[index].lat = first.coordinates.latitude;
                      //   RoomLikesList[index].lng = first.coordinates.longitude;
                      // }
                      await AddRecent(
                          RoomLikesList[index].id);

                      GlobalProfile.detailReviewList
                          .clear();

                      var detailReviewList = await ApiProvider()
                          .post('/Review/SelectRoom',
                          jsonEncode({
                            "location": RoomLikesList[index]
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

                      var tmp = await ApiProvider()
                          .post('/RoomSalesInfo/RoomSelectWithLike',
                          jsonEncode({
                            "roomID": RoomLikesList[index].id,
                            "userID": GlobalProfile.loggedInUser.userID,
                          }));

                      RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(tmp);

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
                      }


                      var res = await Navigator.push(
                          context,
                          // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailedRoomInformation(
                                    roomSalesInfo: tmpRoom,
                                    nbnb:tmpRoom.ShortTerm,
                                  )) // SecondRoute를 생성하여 적재
                      ).then((value) {
                        if(null == value) {
                          return;
                        }
                        if (value == false) {
                          RoomLikesList[index]
                              .ChangeLikesWithValue(false);
                          return;
                        }
                        RoomLikesList[index]
                            .ChangeLikesWithValue(value);
                        setState(() {

                        });
                        return;
                      });;;
                      extendedController.reset();
                      setState(() {

                      });
                    }
                  },
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * (110/620),
                    decoration: BoxDecoration(
                      /* boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(
                                              1, 1), // changes position of shadow
                                        ),
                                      ],*/


                      color: Color(0xffffffff),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: screenWidth*(12/360),),
                        Column(
                          children: [
                            SizedBox(height: screenHeight * 0.00875),

                            Container(
                              width: screenWidth * 0.3333333,
                              height: screenWidth * (100/360),
                              child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  child:     (RoomLikesList[index].imageUrl1=="BasicImage" || RoomLikesList[index].imageUrl1 == null)
                                      ?
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: SvgPicture.asset(
                                      mryrInReviewScreen,

                                    ),
                                  )
                                      :  Stack(
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child:    getExtendedImage(get_resize_image_name(RoomLikesList[index].imageUrl1,360), 0,extendedController),
                                      ),
                                      Center(
                                        child: SvgPicture.asset(
                                            RoomWaterMark,
                                            width: screenWidth*(56/360),
                                            height:screenHeight*(16/640)
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: screenWidth * 0.033333,
                        ),
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: screenHeight * 0.01875),
                                        SizedBox(
                                          width: screenWidth*(180/360),
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
                                                          screenWidth * 0.022222,0),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "내방니방 직영",
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
                                                      color: hexToColor('#EEEEEE'),
                                                    ),
                                                  ),

                                                  Container(
                                                    height: screenHeight * 0.028125,
                                                    child: Padding(
                                                      padding: EdgeInsets.fromLTRB(
                                                          screenWidth * 0.022222,
                                                          screenHeight * 0.000225,
                                                          screenWidth * 0.022222,
                                                          0),
                                                      child: Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "하루 가능",
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
                                                      color: hexToColor('#EEEEEE'),
                                                    ),
                                                  )
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.00625,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      RoomLikesList[index].DailyRentFeesOffer.toString() +
                                          '만원 / 일',
                                      style: TextStyle(
                                          fontSize: screenHeight * 0.025,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text(
                                      ' ( '+RoomLikesList[index].WeeklyRentFeesOffer.toString() +
                                          '만원 / 주 )',
                                      style: TextStyle(
                                          fontSize: screenWidth * (12/360),
                                          color: Color(0xff888888)),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: screenHeight * 0.00625,
                                ),
                                Container(
                                  width:screenWidth*(205/360),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: screenWidth*0.45,
                                        height: screenHeight*(36/640),
                                        child: Text(
                                          RoomLikesList[index].information==null?"":RoomLikesList[index].information,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: hexToColor("#888888")),
                                        ),
                                      ),
                                      Text(timeCheck( RoomLikesList[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Positioned(
                              top: screenWidth*(8/360),
                              right:screenWidth*(4/360),
                              child: GestureDetector(

                                  onTap: () async {
                                    var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                        {
                                          "userID" : GlobalProfile.loggedInUser.userID,
                                          "roomSaleID": RoomLikesList[index].id,
                                        }
                                    ));
                                    bool sub = !RoomLikesList[index].Likes;
                                    RoomLikesList[index].ChangeLikesWithValue(sub);
                                    getRoomSalesInfoByIDFromMainTransfer(RoomLikesList[index].id).ChangeLikesWithValue(sub);
                                    setState(() {
                                      RoomLikesList[index].Likes = sub;
                                    });

                                  },
                                  child:  ( RoomLikesList[index].Likes == null || !RoomLikesList[index].Likes) ?
                                  SvgPicture.asset(
                                    GreyEmptyHeartIcon,

                                    width: screenHeight * 0.0375,
                                    height: screenHeight * 0.0375,
                                    color: Color(0xffEEEEEE),
                                  )
                                      : SvgPicture.asset(
                                    PurpleFilledHeartIcon,
                                    width: screenHeight * 0.0375,
                                    height: screenHeight * 0.0375,
                                    color: kPrimaryColor,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),

                  ),
                ) : GestureDetector(
                  onTap: () async {
                    if(doubleCheck  ==false) {
                      doubleCheck = true;

                      var t = await ApiProvider()
                          .post('/RoomSalesInfo/RoomSelectWithLike',
                          jsonEncode({
                            "roomID": RoomLikesList[index].id,
                            "userID": GlobalProfile.loggedInUser.userID,
                          }));

                      RoomSalesInfo tmpRoom = RoomSalesInfo.fromJson(t);

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
                        tmpRoom
                            .lat = first.coordinates.latitude;
                        tmpRoom
                            .lng = first.coordinates.longitude;
                      }
                      else{
                        finalLng = tmpRoom.lng;
                        finalLat = tmpRoom.lat;
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
                                    nbnb:tmpRoom.ShortTerm,
                                  )) // SecondRoute를 생성하여 적재
                      ).then((value) {
                        if (value == false) {
                          RoomLikesList[index]
                              .ChangeLikesWithValue(false);
                          return;
                        }
                        RoomLikesList[index]
                            .ChangeLikesWithValue(value);
                        setState(() {

                        });
                        return;
                      });
                    }

                  },
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * (110/620),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.033333,
                        //  right: screenWidth * 0.033333,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.00875),
                              Container(
                                width: screenWidth * 0.3333333,
                                height: screenWidth * (100/360),
                                child: ClipRRect(
                                    borderRadius: new BorderRadius.circular(4.0),
                                    child:      RoomLikesList[index].imageUrl1=="BasicImage"
                                        ?
                                    FittedBox(
                                      fit: BoxFit.cover,
                                      child: SvgPicture.asset(
                                        mryrInReviewScreen,

                                      ),
                                    )
                                        :  Stack(
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.cover,
                                          child:    getExtendedImage(get_resize_image_name(RoomLikesList[index].imageUrl1,360), 0,extendedController),
                                        ),
                                        Center(
                                          child: SvgPicture.asset(
                                              RoomWaterMark,
                                              width: screenWidth*(56/360),
                                              height:screenHeight*(16/640)
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 0.033333,
                          ),
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: screenHeight * 0.01875),
                                          SizedBox(
                                            width: screenWidth*(185/360),
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
                                                            screenHeight * 0.000225),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            RoomLikesList[index].Condition == 1 ? "신축 건물" : "구축 건물",
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
                                                            0),
                                                        child: Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            RoomLikesList[index].Floor == 1 ? "반지하" : RoomLikesList[index].Floor == 2 ? "1층" : "2층 이상",
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
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.00625,
                                  ),

                                  Text(
                                    RoomLikesList[index].jeonse == true?    RoomLikesList[index].depositFeesOffer.toString()+"만원 / 전세" :      RoomLikesList[index].monthlyRentFeesOffer.toString()+"만원 / 월세",

                                    style: TextStyle(
                                        fontSize: screenHeight * 0.025,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.00625,
                                  ),
                                  Text(
                                      RoomLikesList[index].termOfLeaseMin.toString() + " ~ "+RoomLikesList[index].termOfLeaseMax.toString(),
                                      style:TextStyle(
                                        fontSize: screenWidth*(12/360),
                                        color:hexToColor("#44444444"),
                                      )
                                  ),
                                  Container(
                                    width:screenWidth*(205/360),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: screenWidth*0.45,
                                          height: screenHeight*(36/640),
                                          child: Text(
                                            RoomLikesList[index].information==null?"":RoomLikesList[index].information,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: hexToColor("#888888")),
                                          ),
                                        ),
                                        Text(timeCheck( RoomLikesList[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

                                      ],
                                    ),
                                  ),



                                ],
                              ),
                              Positioned(
                                top: screenWidth*(8/360),
                                right:screenWidth*(4/360),
                                child: GestureDetector(

                                    onTap: () async {
                                      var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                          {
                                            "userID" : GlobalProfile.loggedInUser.userID,
                                            "roomSaleID": RoomLikesList[index].id,
                                          }
                                      ));
                                      bool sub = !RoomLikesList[index].Likes;
                                      RoomLikesList[index].ChangeLikesWithValue(sub);
                                      getRoomSalesInfoByIDFromMainTransfer(RoomLikesList[index].id).ChangeLikesWithValue(sub);
                                      setState(() {

                                      });
                                    },
                                    child:  ( RoomLikesList[index].Likes == null || !RoomLikesList[index].Likes) ?
                                    SvgPicture.asset(
                                      GreyEmptyHeartIcon,

                                      width: screenHeight * 0.0375,
                                      height: screenHeight * 0.0375,
                                      color: Color(0xffEEEEEE),
                                    )
                                        : SvgPicture.asset(
                                      PurpleFilledHeartIcon,
                                      width: screenHeight * 0.0375,
                                      height: screenHeight * 0.0375,
                                      color: kPrimaryColor,
                                    )),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
