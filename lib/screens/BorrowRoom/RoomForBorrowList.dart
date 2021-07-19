import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/model/RoomListScreenProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/SearchPageForMapForRoom.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/RoomWannaLive.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/widget/Public/floatButtonWithListIcon.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:mryr/userData/User.dart';
import 'package:transition/transition.dart';

import 'GoogleMap/SearchMapForReleaseRoom.dart';

import 'package:mryr/screens/BorrowRoom/model/FilterType.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mryr/screens/TransferRoom/WarningBeforeTransfer.dart';
import 'package:mryr/screens/BorrowRoom/model/FilterPacket.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';

final PurpleMenuIcon = 'assets/images/Map/PurpleMenuIcon.svg';

class RoomForBorrowList extends StatefulWidget {
  bool flagForShort;

  RoomForBorrowList({Key key, this.flagForShort,}) : super(key : key);

  @override
  _RoomForBorrowListState createState() => _RoomForBorrowListState();
}

SharedPreferences localStorage;
String KeyForLikes = 'RoomLikesList';
String KeyForRecent = 'RecentLIst';

List<ModelRoomLikes> RoomLikesList = [];
List<int> RoomLikesIdList = [];


class _RoomForBorrowListState extends State<RoomForBorrowList>with SingleTickerProviderStateMixin  {
  AnimationController extendedController;
  double animatedHeight1 = 0.0;
  double animatedHeight2 = 0.0;
  double animatedHeight3 = 0.0;

  bool res = false;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _scrollController = ScrollController();

  bool ShortFilterFlag = false;
  FilterPacket fp;

  bool flagForRoomInfo = false;

  bool flagForFilter = false;
  final Start = TextEditingController();
  final End = TextEditingController();

  String SearchLocation = '지역별 검색';


  String KeyForLikes = 'RoomLikesList';
  String KeyForRecent = 'RecentLIst';


  //단기
  //4가지 필터 카테고리
  // S : 단기, T : 양도
  bool isShort = true;

  List<FilterType> sFilterList = [new FilterType("방 종류"), new FilterType("가격"),new FilterType("임대 기간"),new FilterType("추가 옵션")];
  int sCurFilter = -1;

  //방 종류
  List<FilterType> sListRoomType = [new FilterType("원룸"), new FilterType("투룸 이상"),new FilterType("오피스텔"),new FilterType("아파트")];
  int sCurRoomType = -1;
  var sSubList = [];

  //가격
  double sPriceLowRange = 0;
  double sPriceHighRange = 310000;
  RangeValues sPriceValues = RangeValues(0, 310000);
  String sInfinity = "무제한";

  double extractNum(double v) {
    return v / 10000;
  }

  //임대 기간
  String sFilterRentStart = "";
  String sFilterRentDone = "";

  //추가옵션
  List<FilterType> sListOption = [new FilterType("주차 가능"), new FilterType("현관 CCTV"),new FilterType("와이파이")];


  //양도
  List<FilterType> tFilterList = [new FilterType("방 종류"), new FilterType("가격"),new FilterType("임대 기간"),new FilterType("추가 옵션")];
  int tCurFilter = -1;

  List<FilterType> tListRoomType = [new FilterType("원룸"), new FilterType("투룸 이상"),new FilterType("오피스텔"),new FilterType("아파트")];
  int tCurRoomType = -1;
  var tSubList = [];

  List<FilterType> tListContractType = [new FilterType("월세"), new FilterType("전세")];
  int tCurContractType = -1;
  int flagContractType = null;

  double tDepositLowRange = 0;
  double tDepositHighRange = 10100000;
  RangeValues tDepositValues = RangeValues(0, 10100000);
  String tDepositInfinity = "무제한";

  double tMonthlyFeeLowRange = 0;
  double tMonthlyFeeHighRange = 1010000;
  RangeValues tMonthlyFeeValues = RangeValues(0, 1010000);
  String tMonthlyInfinity = "무제한";

  //임대 기간
  String tFilterRentStart = "";
  String tFilterRentDone = "";

  //추가옵션
  List<FilterType> tListOption = [new FilterType("주차 가능"), new FilterType("현관 CCTV"),new FilterType("와이파이")];
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent-100){
        _getMoreData();
      }
    });
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

  }

  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  void AddRecent(int index) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subList = await getRecentList();
    if(subList == null) {
      subList = [];
      prefs.setStringList(KeyForRecent, subList);
    }
    print("ddddddddddddddddd"+"${subList.length.toString()}"+"    ${subList}");

    if(subList.contains(index.toString())) {
      subList.remove(index.toString());
    }
    subList.insert(0,index.toString());
    if(subList.length == 10) {
      subList.removeAt(0);
    }
    prefs.setStringList(KeyForRecent, subList);

    print("ddddddddddddddddd"+"${subList.length.toString()}"+"    ${subList}");
  }

  Future<List<String>> getRecentList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(KeyForRecent);
  }

  _getMoreData() async{
    Timer(Duration(milliseconds: 500), ()async{
      var tmp = await ApiProvider().post('/RoomSalesInfo/SelectList/Offset', jsonEncode(
          {
            "index": globalRoomSalesInfoList.length,
          }
      ));
      if(tmp != null){
        for(int i =0;i<tmp.length;i++){
          RoomSalesInfo _roomSalesInfo= RoomSalesInfo.fromJson(tmp[i]);
          globalRoomSalesInfoList.add(_roomSalesInfo);
        }
      }
      else
        print("error&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    });
  }



  bool FlagForFilter = false;
  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final SearchController = TextEditingController();

    RoomListScreenProvider data = Provider.of<RoomListScreenProvider>(context);


    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: SafeArea(
            child: RefreshIndicator(
              key: refreshKey,
              onRefresh: ()async{

                if(FlagForFilter ==false) {
                  var list = await ApiProvider().get('/RoomSalesInfo/SelectList');

                  globalRoomSalesInfoList.clear();
                  if (list != null) {
                    for (int i = 0; i < list.length; ++i) {
                      globalRoomSalesInfoList.add(RoomSalesInfo.fromJson(list[i]));
                    }

                    var Llist = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
                        {
                          "userID" : GlobalProfile.loggedInUser.userID,
                        }
                    ));

                    if(null != Llist) {
                      RoomLikesList.clear();
                      RoomLikesIdList.clear();
                      for(int i = 0; i < Llist.length; ++i){
                        Map<String, dynamic> data = Llist[i];

                        ModelRoomLikes item = ModelRoomLikes.fromJson(data);
                        RoomLikesIdList.add(item.RoomSaleID);
                        RoomLikesList.add(item);
                        //await NotiDBHelper().createData(noti);
                      }
                      for(int i= 0; i < globalRoomSalesInfoList.length; i++) {
                        if(RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
                          globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
                        }
                      }
                      return true;
                    }

                  }
                  setState(() {

                  });
                }
                else{

                }

              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * (18/640),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: screenWidth*(8/360),),
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                              onPressed: () {
                                if(navigationNumProvider.getPastNum() == -1) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  // Navigator.push(
                                  //   context,
                                  //   SearchMapForBorrowRoom()
                                  //       .builder(),
                                  // );
                              /*    Navigator.push(
                                      context,

                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchMapForBorrowRoom()),
                                     // 기본 파라미터, SecondRoute로 전달
                                 // SecondRoute를 생성하여 적재
                                  );*/
                                }
                              }),

                          GestureDetector(
                            onTap: () {

                              CustomOKDialog(context,"서비스 준비중입니다" , "다음 업데이트를 기다려주세요 :D");
                              /*  Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration: Duration(microseconds: 1),
                                    transitionsBuilder:





                                        (context, animation, animationTime, child) {
                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                    pageBuilder:
                                        (context, animation, animationTime) {
                                      return SearchPageForMapForRoom();
                                    }),
                              );*/
                            },
                            child: Container(
                              width: screenWidth * (299 / 360),
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(8.0),
                                color: hexToColor("#EEEEEE"),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.0222222,
                                  ),
                                  SvgPicture.asset(
                                    GreyMagnifyingGlass,
                                    width: screenHeight * 0.025,
                                    height: screenHeight * 0.025,
                                  ),
                                  SizedBox(width: screenWidth*(10/360),),
                                  //Text("인하대학교",style: TextStyle(fontSize: screenWidth*(12/360)),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight *(12/640),
                      ),
                      Container(
                        height: screenHeight*(44/640),
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: screenWidth*0.033333,),
                                    InkWell(
                                      onTap: () async {
                                        ShortFilterFlag = !ShortFilterFlag;
                                        // fp = new FilterPacket(sSubList,sPriceLowRange.toInt(),sPriceHighRange.toInt(),sFilterRentStart,sFilterRentDone,
                                        //     sListOption[0].selected ? 1 : 0,sListOption[1].selected ? 1 : 0,sListOption[2].selected ? 1 : 0);

                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth *0.175,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                GreyFilterIcon,
                                                width: screenHeight * 0.03125,
                                                height: screenHeight * 0.03125,
                                              ),
                                              Spacer(),
                                              Text(
                                                '필터',
                                                style: TextStyle(
                                                  fontSize: screenWidth*SearchCaseFontSize,
                                                  color: hexToColor('#888888'),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: new BorderRadius.circular(4.0),
                                          border: Border.all(
                                            width: 1,
                                            color: hexToColor("#EEEEEE"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    widthPadding(screenWidth,4),
                                    isShortForRoomList ?  Expanded(
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth*(228/360),
                                        child: ListView.separated(
                                          // controller: _scrollController,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                            itemCount:sFilterList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  if(sCurFilter != -1) {
                                                    //켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                                    if(sCurFilter == index){//내가 누른게 지금 현재 필터야
                                                      if(sFilterList[index].selected){
                                                        //근데 내가 누른 필터가 선택된 상태면 다시 눌러도 안꺼져야겠고
                                                      }else {
                                                        sFilterList[index].flag = false;
                                                      }
                                                      sCloseFilter();
                                                    }
                                                    else {
                                                      for(int i =0; i < sFilterList.length; i++) {
                                                        if(sFilterList[i].selected)
                                                          continue;
                                                        else
                                                          sFilterList[i].flag = false;
                                                      }
                                                      sFilterList[index].flag = true;
                                                      sCurFilter = index;
                                                    }
                                                    setState(() {

                                                    });
                                                  } else {
                                                    sFilterList[index].flag = !sFilterList[index].flag;

                                                    if(sCurFilter == index)//켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                                      sCurFilter = -1;
                                                    else
                                                      sCurFilter = index;

                                                    //선택된 필터말고 나머지는 다 끔
                                                    for(int i = 0; i < sFilterList.length; i++) {
                                                      if(sFilterList[i].selected)
                                                        continue;
                                                      else
                                                        sFilterList[i].flag = false;
                                                    }
                                                    sFilterList[index].flag = true;


                                                    setState(() {

                                                    });
                                                  }

                                                },
                                                child: Container(
                                                  height: screenHeight * 0.05,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                    child: Center(
                                                      child: Text(
                                                        '${sFilterList[index].title}',
                                                        style: TextStyle(
                                                          fontSize: screenWidth*SearchCaseFontSize,
                                                          color: sFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: sFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ) :
                                    Expanded(
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth*(228/360),
                                        child: ListView.separated(
                                          // controller: _scrollController,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                            itemCount:tFilterList.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return GestureDetector(
                                                onTap: (){
                                                  if(tCurFilter != -1) {
                                                    //켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                                    if(tCurFilter == index){//내가 누른게 지금 현재 필터야
                                                      if(tFilterList[index].selected){
                                                        //근데 내가 누른 필터가 선택된 상태면 다시 눌러도 안꺼져야겠고
                                                      }else {
                                                        tFilterList[index].flag = false;
                                                      }
                                                      tCloseFilter();
                                                    }
                                                    else {
                                                      for(int i =0; i < tFilterList.length; i++) {
                                                        if(tFilterList[i].selected)
                                                          continue;
                                                        else
                                                          tFilterList[i].flag = false;
                                                      }
                                                      tFilterList[index].flag = true;
                                                      tCurFilter = index;
                                                    }
                                                    setState(() {

                                                    });
                                                  } else {
                                                    tFilterList[index].flag = !tFilterList[index].flag;

                                                    if(tCurFilter == index)//켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                                      tCurFilter = -1;
                                                    else
                                                      tCurFilter = index;

                                                    //선택된 필터말고 나머지는 다 끔
                                                    for(int i = 0; i < tFilterList.length; i++) {
                                                      if(tFilterList[i].selected)
                                                        continue;
                                                      else
                                                        tFilterList[i].flag = false;
                                                    }
                                                    tFilterList[index].flag = true;


                                                    setState(() {

                                                    });
                                                  }

                                                },
                                                child: Container(
                                                  height: screenHeight * 0.05,
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                    child: Center(
                                                      child: Text(
                                                        '${tFilterList[index].title}',
                                                        style: TextStyle(
                                                          fontSize: screenWidth*SearchCaseFontSize,
                                                          color: tFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: tFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),


                                  ],
                                ),
                              ),

                              Container(
                                height: screenHeight*(12/640),
                                decoration: BoxDecoration(
                                    boxShadow: [

                                    ]
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      isShortForRoomList ? sReturnFilter(screenWidth, screenHeight) : tReturnFilter(screenWidth, screenHeight),
                      FlagForFilter == false?
                      (globalRoomSalesInfoList==null) ? Container():
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: globalRoomSalesInfoList.length,
                          itemBuilder: (BuildContext context, int index) {

                            return Column(
                              children: [
                                index == 0 && isShortForRoomList ?
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),

                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: nbnbRoom.length,
                                    itemBuilder: (BuildContext context, int index) {

                                      return Column(children: [
                                        GestureDetector(
                                          onTap: () async {

                                            if(doubleCheck == false) {
                                              doubleCheck = true;

                                              //내방니방 직영 예약 날짜 받아오기
                                              var tmp9 = await ApiProvider()
                                                  .post(
                                                  '/RoomSalesInfo/NbnbRoomDateSelect',
                                                  jsonEncode(
                                                      {"roomID": nbnbRoom[index]
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
                                              //     nbnbRoom[index].lng ||
                                              //     null == nbnbRoom[index]
                                              //         .lat) {
                                              //   var addresses = await Geocoder.google(
                                              //       'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                              //       .findAddressesFromQuery(
                                              //       nbnbRoom[index]
                                              //           .location);
                                              //   var first = addresses.first;
                                              //   nbnbRoom[index].lat = first.coordinates.latitude;
                                              //   nbnbRoom[index].lng = first.coordinates.longitude;
                                              // }
                                              await AddRecent(
                                                  nbnbRoom[index].id);

                                              GlobalProfile.detailReviewList
                                                  .clear();

                                              var detailReviewList = await ApiProvider()
                                                  .post('/Review/SelectRoom',
                                                  jsonEncode({
                                                    "location": nbnbRoom[index]
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
                                                    "roomID": nbnbRoom[index].id,
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


                                              res = await Navigator.push(
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
                                                  nbnbRoom[index]
                                                      .ChangeLikesWithValue(false);
                                                  return;
                                                }
                                                nbnbRoom[index]
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
                                            height: screenHeight * 0.19375,
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
                                                    SizedBox(height: screenHeight * 0.01875),
                                                    Container(
                                                      width: screenWidth * 0.3333333,
                                                      height: screenHeight * 0.15625,
                                                      child: ClipRRect(
                                                          borderRadius: new BorderRadius.circular(4.0),
                                                          child:     (nbnbRoom[index].imageUrl1=="BasicImage" || nbnbRoom[index].imageUrl1 == null)
                                                              ?
                                                          SvgPicture.asset(
                                                            mryrInReviewScreen,
                                                            width:
                                                            screenHeight *
                                                                (60 /
                                                                    640),
                                                            height:
                                                            screenHeight *
                                                                (60 /
                                                                    640),
                                                          )
                                                              :  Stack(
                                                                children: [
                                                                  FittedBox(
                                                            fit: BoxFit.cover,
                                                            child:    getExtendedImage(get_resize_image_name(nbnbRoom[index].imageUrl1,360), 0,extendedController),
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
                                                              nbnbRoom[index].DailyRentFeesOffer.toString() +
                                                                  '만원 / 일',
                                                              style: TextStyle(
                                                                  fontSize: screenHeight * 0.025,
                                                                  fontWeight: FontWeight.bold),
                                                            ),

                                                           Text(
                                                              ' ( '+nbnbRoom[index].WeeklyRentFeesOffer.toString() +
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
                                                                  nbnbRoom[index].information==null?"":nbnbRoom[index].information,
                                                                  maxLines: 2,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      color: hexToColor("#888888")),
                                                                ),
                                                              ),
                                                              Text(timeCheck( nbnbRoom[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

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
                                                                  "roomSaleID": nbnbRoom[index].id,
                                                                }
                                                            ));
                                                            bool sub = !nbnbRoom[index].Likes;
                                                            nbnbRoom[index].ChangeLikesWithValue(sub);
                                                            getRoomSalesInfoByIDFromMainTransfer(nbnbRoom[index].id).ChangeLikesWithValue(sub);
                                                            setState(() {

                                                            });

                                                          },
                                                          child:  ( nbnbRoom[index].Likes == null || !nbnbRoom[index].Likes) ?
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
                                        )
                                      ],);})
                                    : Container(),


                                !isShortForRoomList ? GestureDetector(
                                  onTap: () async {
                                    if(doubleCheck  ==false) {
                                      doubleCheck = true;

                                      var t = await ApiProvider()
                                          .post('/RoomSalesInfo/RoomSelectWithLike',
                                          jsonEncode({
                                            "roomID": globalRoomSalesInfoList[index].id,
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
                                      res = await Navigator.push(
                                          context, // 기본 파라미터, SecondRoute로 전달
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailedRoomInformation(
                                                      roomSalesInfo: tmpRoom,
                                                      nbnb:tmpRoom.ShortTerm,
                                                  )) // SecondRoute를 생성하여 적재
                                      ).then((value) {
                                        if (value == false) {
                                          globalRoomSalesInfoList[index]
                                              .ChangeLikesWithValue(false);
                                          return;
                                        }
                                        globalRoomSalesInfoList[index]
                                            .ChangeLikesWithValue(value);
                                        setState(() {

                                        });
                                        return;
                                      });
                                    }

                                  },
                                  child: Container(
                                    width: screenWidth,
                                    height: screenHeight * 0.19375,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: screenWidth * 0.033333,
                                        //  right: screenWidth * 0.033333,
                                          ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: screenHeight * 0.01875),
                                              Container(
                                                width: screenWidth * 0.3333333,
                                                height: screenHeight * 0.15625,
                                                child: ClipRRect(
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    child:      globalRoomSalesInfoList[index].imageUrl1=="BasicImage"
                                                        ?
                                                    SvgPicture.asset(
                                                      mryrInReviewScreen,
                                                      width:
                                                      screenHeight *
                                                          (60 /
                                                              640),
                                                      height:
                                                      screenHeight *
                                                          (60 /
                                                              640),
                                                    )
                                                        :  Stack(
                                                          children: [
                                                            FittedBox(
                                                      fit: BoxFit.cover,
                                                      child:    getExtendedImage(get_resize_image_name(globalRoomSalesInfoList[index].imageUrl1,360), 0,extendedController),
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
                                                                            screenHeight * 0.003225),
                                                                        child: Align(
                                                                          alignment: Alignment.center,
                                                                          child: Text(
                                                                            globalRoomSalesInfoList[index].Condition == 1 ? "신축 건물" : "구축 건물",
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
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: screenHeight * 0.00625,
                                                  ),
                                                  Text( globalRoomSalesInfoList[index].monthlyRentFeesOffer == null ? "0만원" :
                                                      globalRoomSalesInfoList[index].monthlyRentFeesOffer <= 0 ?
                                                    globalRoomSalesInfoList[index].depositFeesOffer.toString() +
                                                        '만원 / 전세' : globalRoomSalesInfoList[index].monthlyRentFeesOffer.toString() +
                                                          '만원 / 월세',
                                                    style: TextStyle(
                                                        fontSize: screenHeight * 0.025,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: screenHeight * 0.00625,
                                                  ),
                                                  Text(
                                                      globalRoomSalesInfoList[index].termOfLeaseMin.toString() + " ~ "+globalRoomSalesInfoList[index].termOfLeaseMax.toString(),
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
                                                            globalRoomSalesInfoList[index].information==null?"":globalRoomSalesInfoList[index].information,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                color: hexToColor("#888888")),
                                                          ),
                                                        ),
                                                        Text(timeCheck( globalRoomSalesInfoList[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

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
                                                            "roomSaleID": globalRoomSalesInfoList[index].id,
                                                          }
                                                      ));
                                                      bool sub = !globalRoomSalesInfoList[index].Likes;
                                                      globalRoomSalesInfoList[index].ChangeLikesWithValue(sub);
                                                      getRoomSalesInfoByIDFromMainTransfer(globalRoomSalesInfoList[index].id).ChangeLikesWithValue(sub);
                                                      setState(() {

                                                      });
                                                    },
                                                    child:  ( globalRoomSalesInfoList[index].Likes == null || !globalRoomSalesInfoList[index].Likes) ?
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
                                ) : SizedBox(),
                              ],
                            );
                          }


                        ),
                      ):
                      (globalRoomSalesInfoListFiltered==null)? Container(): Expanded(
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: globalRoomSalesInfoListFiltered.length ,
                          itemBuilder: (BuildContext context, int index) =>

                              Column(
                                children: [
                                  // index == 0?
                                  // ListView.builder(
                                  //     physics: NeverScrollableScrollPhysics(),
                                  //
                                  //     shrinkWrap: true,
                                  //     scrollDirection: Axis.vertical,
                                  //     itemCount: nbnbRoom.length,
                                  //     itemBuilder: (BuildContext context, int index) {
                                  //
                                  //       return Column(children: [
                                  //         GestureDetector(
                                  //           onTap: () async {
                                  //             //내방니방 직영 예약 날짜 받아오기
                                  //             var tmp9 = await ApiProvider().post('/RoomSalesInfo/NbnbRoomDateSelect',jsonEncode({"roomID":nbnbRoom[index].id.toString()}));
                                  //             GlobalProfile.reserveDateList.clear();
                                  //             if(tmp9 != null){
                                  //               for(int i =0 ; i< tmp9.length ;i++){
                                  //                 ReserveDate _reserveDate = ReserveDate.fromJson(tmp9[i]);
                                  //                 if((DateTime.now().year == _reserveDate.year && DateTime.now().month <= _reserveDate.month)
                                  //                     || (DateTime.now().year +1 == _reserveDate.year && DateTime.now().month>_reserveDate.month))
                                  //                   GlobalProfile.reserveDateList.add(_reserveDate);
                                  //               }
                                  //             }
                                  //
                                  //             GlobalProfile.detailReviewList.clear();
                                  //
                                  //             var detailReviewList = await ApiProvider()
                                  //                 .post('/Review/SelectRoom',
                                  //                 jsonEncode({"location":globalRoomSalesInfoList[index].location}));
                                  //
                                  //             if (detailReviewList != null) {
                                  //               for (int i = 0;
                                  //               i < detailReviewList.length;
                                  //               ++i) {
                                  //                 GlobalProfile.detailReviewList.add(
                                  //                     DetailReview.fromJson(
                                  //                         detailReviewList[i]));
                                  //               }
                                  //             }
                                  //
                                  //             res = await Navigator.push(
                                  //                 context, // 기본 파라미터, SecondRoute로 전달
                                  //                 MaterialPageRoute(
                                  //                     builder: (context) =>
                                  //                         DetailedRoomInformation(
                                  //                           roomSalesInfo: nbnbRoom[index],
                                  //                           nbnb: true,
                                  //                         )) // SecondRoute를 생성하여 적재
                                  //             );
                                  //             extendedController.reset();
                                  //             setState(() {
                                  //
                                  //             });
                                  //           },
                                  //           child: Container(
                                  //             width: screenWidth,
                                  //             height: screenHeight * 0.19375,
                                  //             decoration: BoxDecoration(
                                  //               /* boxShadow: [
                                  //       BoxShadow(
                                  //         color: Colors.grey.withOpacity(0.5),
                                  //         spreadRadius: 1,
                                  //         blurRadius: 2,
                                  //         offset: Offset(
                                  //             1, 1), // changes position of shadow
                                  //       ),
                                  //     ],*/
                                  //
                                  //
                                  //               color: Color(0xffffffff),
                                  //             ),
                                  //             child: Row(
                                  //               crossAxisAlignment: CrossAxisAlignment.start,
                                  //               children: [
                                  //                 SizedBox(width: screenWidth*(12/360),),
                                  //                 Column(
                                  //                   children: [
                                  //                     SizedBox(height: screenHeight * 0.01875),
                                  //                     Stack(
                                  //                       children: [
                                  //
                                  //                         Container(
                                  //                           width: screenWidth * 0.3333333,
                                  //                           height: screenHeight * 0.15625,
                                  //                           child: ClipRRect(
                                  //                               borderRadius: new BorderRadius.circular(4.0),
                                  //                               child:     (nbnbRoom[index].imageUrl1=="BasicImage" || nbnbRoom[index].imageUrl1 == null)
                                  //                                   ?
                                  //                               SvgPicture.asset(
                                  //                                 mryrInReviewScreen,
                                  //                                 width:
                                  //                                 screenHeight *
                                  //                                     (60 /
                                  //                                         640),
                                  //                                 height:
                                  //                                 screenHeight *
                                  //                                     (60 /
                                  //                                         640),
                                  //                               )
                                  //                                   :  FittedBox(
                                  //                                 fit: BoxFit.cover,
                                  //                                 child:    getExtendedImage(get_resize_image_name(nbnbRoom[index].imageUrl1,360), 0,extendedController),
                                  //                               )
                                  //                           ),
                                  //                         ),
                                  //                         Positioned(
                                  //                             right: 4,
                                  //                             bottom: 4,
                                  //                             child: Container(
                                  //                               height : screenHeight*(16/640),
                                  //                               decoration: BoxDecoration(
                                  //                                 borderRadius: BorderRadius.all(
                                  //                                     Radius.circular(
                                  //                                         4.0) //                 <--- border radius here
                                  //                                 ),
                                  //                                 color: kPrimaryColor,
                                  //                               ),
                                  //                               child: Center(child: Text("  내방니방 직영  ",style: TextStyle(fontSize: screenWidth*(10/360),fontWeight: FontWeight.bold, color: Colors.white),)),
                                  //                             ))
                                  //                       ],
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 SizedBox(
                                  //                   width: screenWidth * 0.033333,
                                  //                 ),
                                  //                 Column(
                                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                                  //                   children: [
                                  //                     Row(
                                  //                       crossAxisAlignment: CrossAxisAlignment.start,
                                  //                       children: [
                                  //                         Column(
                                  //                           mainAxisAlignment: MainAxisAlignment.start,
                                  //                           children: [
                                  //                             SizedBox(height: screenHeight * 0.01875),
                                  //                             SizedBox(
                                  //                               width: screenWidth*(180/360),
                                  //                               child: Row(
                                  //                                 children: [
                                  //                                   Wrap(
                                  //                                     alignment: WrapAlignment.center,
                                  //                                     spacing: screenWidth * 0.011111,
                                  //                                     children: [
                                  //                                       Container(
                                  //                                         height: screenHeight * 0.028125,
                                  //                                         child: Padding(
                                  //                                           padding: EdgeInsets.fromLTRB(
                                  //                                               screenWidth * 0.022222,
                                  //                                               screenHeight * 0.000225,
                                  //                                               screenWidth * 0.022222,0),
                                  //                                           child: Align(
                                  //                                             alignment: Alignment.center,
                                  //                                             child: Text(
                                  //                                               "단기임대",
                                  //                                               style: TextStyle(
                                  //                                                   fontSize:
                                  //                                                   screenWidth*TagFontSize,
                                  //                                                   color: Colors.white,
                                  //                                                   fontWeight: FontWeight.bold
                                  //                                               ),
                                  //                                             ),
                                  //                                           ),
                                  //                                         ),
                                  //                                         decoration: BoxDecoration(
                                  //                                           borderRadius:
                                  //                                           new BorderRadius.circular(4.0),
                                  //                                           color: kPrimaryColor,
                                  //                                         ),
                                  //                                       ),
                                  //                                       Container(
                                  //                                         height: screenHeight * 0.028125,
                                  //                                         child: Padding(
                                  //                                           padding: EdgeInsets.fromLTRB(
                                  //                                               screenWidth * 0.022222,
                                  //                                               screenHeight * 0.000225,
                                  //                                               screenWidth * 0.022222,
                                  //                                               0),
                                  //                                           child: Align(
                                  //                                             alignment: Alignment.center,
                                  //                                             child: Text(
                                  //                                               "이벤트",
                                  //                                               style: TextStyle(
                                  //                                                   fontSize:
                                  //                                                   screenWidth*TagFontSize,
                                  //                                                   color: Colors.white,
                                  //                                                   fontWeight: FontWeight.bold
                                  //                                               ),
                                  //                                             ),
                                  //                                           ),
                                  //                                         ),
                                  //                                         decoration: BoxDecoration(
                                  //                                           borderRadius:
                                  //                                           new BorderRadius.circular(4.0),
                                  //                                           color: kPrimaryColor,
                                  //                                         ),
                                  //                                       )
                                  //                                     ],
                                  //                                   ),
                                  //
                                  //                                 ],
                                  //                               ),
                                  //                             ),
                                  //                           ],
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                     SizedBox(
                                  //                       height: screenHeight * 0.00625,
                                  //                     ),
                                  //                     Text(
                                  //                       nbnbRoom[index].monthlyRentFeesOffer.toString() +
                                  //                           '원 / 일',
                                  //                       style: TextStyle(
                                  //                           fontSize: screenHeight * 0.025,
                                  //                           fontWeight: FontWeight.bold),
                                  //                     ),
                                  //                     SizedBox(
                                  //                       height: screenHeight * 0.00625,
                                  //                     ),
                                  //                     /*  Text(nbnbRoom.termOfLeaseMin + ' ~ ' + nbnbRoom.termOfLeaseMax,
                                  //             style: TextStyle(color: hexToColor("#44444444")),
                                  //           ),*/
                                  //                     Container(
                                  //                       width: screenWidth*0.45,
                                  //                       height: screenHeight*(50/640),
                                  //                       child: Text(
                                  //                         //   "rrrrjjrjrjrjrrjrjfsdjhfsdafjlksadhlkjsadhflkjdsalfj;alsdkfj;asldkjf;saldkjfas;ldfkjsal;dkfjsad;lfkjsad;flkjsdhflsajdhfasdjhfalskdjfhasdkfjhasdlkfjhasdkfjhasdlfkjhasdflkjash;sladkfjasl;dfkj",
                                  //                         nbnbRoom[index].information==null?"":nbnbRoom[index].information,
                                  //                         maxLines: 3,
                                  //                         overflow: TextOverflow.ellipsis,
                                  //                         style: TextStyle(
                                  //                             color: hexToColor("#888888")),
                                  //                       ),
                                  //                     ),
                                  //                     SizedBox(height: screenHeight*(3/640),),
                                  //
                                  //                   ],
                                  //                 ),
                                  //                 Spacer(),
                                  //                 ClipPath(
                                  //                     clipper:Triangle(),
                                  //                     child:Container(
                                  //                       width: screenWidth*(32/360),
                                  //                       height:screenWidth*(32/360),
                                  //                       color: kPrimaryColor,
                                  //                     )
                                  //                 )
                                  //               ],
                                  //             ),
                                  //
                                  //           ),
                                  //         ),
                                  //       ],);})
                                  //     : Container(),
                                  //
                                  // index == 0? Container(width:screenWidth,height:3, color:kPrimaryColor):Container(),


                                  GestureDetector(
                                    onTap: () async {
                                      if(doubleCheck == false) {
                                        doubleCheck = true;

                                        GlobalProfile.detailReviewList.clear();

                                        var detailReviewList = await ApiProvider()
                                            .post('/Review/SelectRoom',
                                            jsonEncode({
                                              "location": globalRoomSalesInfoListFiltered[index]
                                                  .location
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

                                        if (null ==
                                            globalRoomSalesInfoListFiltered[index].lng ||
                                            null == globalRoomSalesInfoListFiltered[index]
                                                .lat) {
                                          var addresses = await Geocoder.google(
                                              'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                              .findAddressesFromQuery(
                                              globalRoomSalesInfoListFiltered[index]
                                                  .location);
                                          var first = addresses.first;
                                          globalRoomSalesInfoListFiltered[index].lat = first.coordinates.latitude;
                                          globalRoomSalesInfoListFiltered[index].lng = first.coordinates.longitude;
                                        }

                                        await AddRecent(
                                            globalRoomSalesInfoListFiltered[index]
                                                .id);
                                        res = await Navigator.push(
                                            context, // 기본 파라미터, SecondRoute로 전달
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailedRoomInformation(
                                                        roomSalesInfo: globalRoomSalesInfoListFiltered[index],
                                                        nbnb: isShortForRoomList ? true : false,
                                                    )) // SecondRoute를 생성하여 적재
                                        ).then((value) {
                                          globalRoomSalesInfoListFiltered[index]
                                              .ChangeLikesWithValue(value);
                                          setState(() {

                                          });
                                          return;
                                        });
                                      }
                                    },
                                    child:
                                    Container(
                                      width: screenWidth,
                                      height: screenHeight * 0.19375,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: screenWidth * 0.033333,
                                          //  right: screenWidth * 0.033333,
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(height: screenHeight * 0.01875),
                                                Container(
                                                  width: screenWidth * 0.3333333,
                                                  height: screenHeight * 0.15625,
                                                  child: ClipRRect(
                                                      borderRadius: new BorderRadius.circular(4.0),
                                                      child:globalRoomSalesInfoListFiltered[index].imageUrl1=="BasicImage"
                                                          ?
                                                      SvgPicture.asset(
                                                        ProfileIconInMoreScreen,
                                                        width: screenHeight * (60 / 640),
                                                        height: screenHeight * (60 / 640),
                                                      )
                                                          :  Stack(
                                                            children: [
                                                              FittedBox(
                                                        fit: BoxFit.cover,
                                                        child:    getExtendedImage(get_resize_image_name(globalRoomSalesInfoListFiltered[index].imageUrl1,360), 0,extendedController),
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
                                                              isShortForRoomList ? Wrap(
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
                                                              ) :
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
                                                                          globalRoomSalesInfoList[index].tradingState == 1 ? "신축 건물" : "구축 건물",
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
                                                      ],
                                                    ),
                                                    // Column(
                                                    //   children: [
                                                    //     SizedBox(height: screenHeight * 0.014),
                                                    //     GestureDetector(
                                                    //
                                                    //         onTap: () async {
                                                    //           var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                    //               {
                                                    //                 "userID" : GlobalProfile.loggedInUser.userID,
                                                    //                 "roomSaleID": globalRoomSalesInfoListFiltered[index].id,
                                                    //               }
                                                    //           ));
                                                    //
                                                    //           globalRoomSalesInfoListFiltered[index].ChangeLikes(!globalRoomSalesInfoListFiltered[index].Likes);
                                                    //           setState(() {
                                                    //           });
                                                    //         },
                                                    //         child:  globalRoomSalesInfoListFiltered[index].Likes ?
                                                    //         SvgPicture.asset(
                                                    //           PurpleFilledHeartIcon,
                                                    //           width: screenHeight * 0.0375,
                                                    //           height: screenHeight * 0.0375,
                                                    //           color: kPrimaryColor,
                                                    //         )
                                                    //             : SvgPicture.asset(
                                                    //           GreyEmptyHeartIcon,
                                                    //           width: screenHeight * 0.0375,
                                                    //           height: screenHeight * 0.0375,
                                                    //         )),
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: screenHeight * 0.00625,
                                                ),
                                                Text(

                                                  globalRoomSalesInfoListFiltered[index].monthlyRentFeesOffer.toString() +
                                                      '만원 / 월',
                                                  style: TextStyle(
                                                      fontSize: screenHeight * 0.025,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: screenHeight * 0.00625,
                                                ),
                                                Text(
                                                  globalRoomSalesInfoListFiltered[index].termOfLeaseMin +
                                                      '~' +
                                                      globalRoomSalesInfoListFiltered[index].termOfLeaseMax,
                                                  style: TextStyle(color: hexToColor("#888888")),
                                                ),
                                                Container(
                                                  width: screenWidth*0.45,
                                                  height: screenHeight*(16/640),
                                                  child: Text(
                                                    globalRoomSalesInfoListFiltered[index].information,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(

                                                        color: hexToColor("#888888")),
                                                  ),
                                                ),
                                                SizedBox(height: screenHeight*(3/640),),
                                                // Container(
                                                //   width: screenWidth*(205/360),
                                                //   child: Row(
                                                //     children: [
                                                //       Spacer(),
                                                //       Text(timeCheck( globalRoomSalesInfoListFiltered[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),
                                                //     ],
                                                //   ),
                                                // ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ),
                                ],
                              ),
                        ),
                      ),
                    ],
                  ),
                  ShortFilterFlag && isShortForRoomList ? Container(
                    width :screenWidth,
                    height : screenHeight,
                    color:Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          heightPadding(screenHeight,14),
                          Row(
                            children: [
                              InkWell(
                                onTap:(){
                                  ShortFilterFlag = false;
                                  setState(() {

                                  });
                                },
                                child: SvgPicture.asset(
                                  FilterXIcon,
                                ),
                              ),
                              widthPadding(screenWidth,100),
                              Text(
                                  '전체 필터',
                                  style:TextStyle(
                                    fontSize:screenWidth*(18/360),
                                    fontWeight: FontWeight.bold,

                                  )
                              ),
                            ],
                          ),
                          heightPadding(screenHeight,14),
                          Container(
                            width: screenWidth,
                            height:screenHeight*(114/640),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightPadding(screenHeight,14),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Text(
                                    "방 종류",
                                    style:TextStyle(
                                        fontSize: screenWidth*(14/360),
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                  ),
                                ),
                                heightPadding(screenHeight,12),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Container(
                                    height: screenHeight * (34/640),
                                    child: ListView.separated(
                                      // controller: _scrollController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                        itemCount:sListRoomType.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              sListRoomType[index].flag = !sListRoomType[index].flag;
                                              sListRoomType[index].selected = !sListRoomType[index].selected;
                                              sCurRoomType = index;
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              height: screenHeight * 0.05,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                child: Center(
                                                  child: Text(
                                                    '${sListRoomType[index].title}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*SearchCaseFontSize,
                                                      color: sListRoomType[index].flag ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: sListRoomType[index].flag ? kPrimaryColor : Colors.white,
                                                borderRadius: new BorderRadius.circular(4.0),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(1.5, 1.5),
                                                  ),
                                                ],

                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height:screenHeight*(4/640),
                            width:screenWidth,
                            color:hexToColor('#FFFFFF'),
                          ),
                          Container(
                            width: screenWidth,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightPadding(screenHeight,14),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "가격 ",
                                        style:TextStyle(
                                            fontSize: screenWidth*(14/360),
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        ),
                                      ),
                                      Text(
                                        "(일 단위)",
                                        style:TextStyle(
                                            fontSize: screenWidth*(13.5/360),
                                            color:hexToColor('#888888')
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                heightPadding(screenHeight,12),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "전체",
                                        style:TextStyle(
                                            fontSize: screenWidth*(14/360),
                                            fontWeight: FontWeight.bold,
                                            color:kPrimaryColor
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        sInfinity,
                                        style:TextStyle(
                                            fontSize: screenWidth*(12/360),
                                            color:kPrimaryColor
                                        ),
                                      ),
                                      widthPadding(screenWidth,16),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: screenWidth * (336 / 360),
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        thumbColor: Colors.white,
                                      ),
                                      child: RangeSlider(
                                        min: 0,
                                        max: 310000,
                                        divisions: 31,
                                        inactiveColor: Color(0xffcccccc),
                                        activeColor: kPrimaryColor,
                                        labels: RangeLabels(sPriceLowRange.floor().toString(),
                                            sPriceHighRange.floor().toString()),
                                        values: sPriceValues,
                                        //RangeValues(_lowValue,_highValue),
                                        onChanged: (_range) {
                                          setState(() {
                                            if(_range.end.toInt() == 310000) {
                                              sInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                                            } else {
                                              sInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                                            }

                                            sPriceValues = _range;
                                            sPriceLowRange = _range.start;
                                            sPriceHighRange = _range.end;

                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                heightPadding(screenHeight,8),
                                Row(
                                  children: [
                                    widthPadding(screenWidth,14),
                                    Text(
                                      '최소',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Text(
                                      '최대',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    widthPadding(screenWidth,14),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height:screenHeight*(4/640),
                            width:screenWidth,
                            color:hexToColor('#FFFFFF'),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight*(126/640),
                            color: Colors.white,
                            child: Column(
                              children: [
                                heightPadding(screenHeight,22),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "임대 기간",
                                        style:TextStyle(
                                            fontSize: screenWidth*(14/360),
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                heightPadding(screenHeight,26),
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
                                              maxTime: sFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(sFilterRentDone).year, DateFormat('y.MM.d').parse(sFilterRentDone).month,DateFormat('y.MM.d').parse(sFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                              theme: DatePickerTheme(
                                                  headerColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                  itemStyle: TextStyle(
                                                      color: Colors.black, fontSize: 18),
                                                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                              onChanged: (date) {
                                                sFilterRentStart = DateFormat('y.MM.d').format(date);
                                                setState(() {

                                                });
                                              },
                                              currentTime: DateTime.now(), locale: LocaleType.ko);
                                        },
                                        child: Container(
                                          width: screenWidth * (120 / 360),
                                          child: Center(
                                            child: Text(
                                              sFilterRentStart == "" ? "입주" : sFilterRentStart,
                                              style: TextStyle(
                                                fontSize: screenWidth * (14 / 360),
                                                fontWeight: FontWeight.bold,
                                                color: sFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
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
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: sFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(sFilterRentStart).year, DateFormat('y.MM.d').parse(sFilterRentStart).month,DateFormat('y.MM.d').parse(sFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                              maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                              theme: DatePickerTheme(
                                                  headerColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                  itemStyle: TextStyle(
                                                      color: Colors.black, fontSize: 18),
                                                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                              onChanged: (date) {
                                                sFilterRentDone = DateFormat('y.MM.d').format(date);
                                                setState(() {

                                                });
                                              },
                                              currentTime: DateTime.now(), locale: LocaleType.ko);
                                        },
                                        child: Container(
                                          width: screenWidth * (120 / 360),
                                          child: Center(
                                            child: Text(
                                              sFilterRentDone == "" ? "퇴실" : sFilterRentDone,
                                              style: TextStyle(
                                                fontSize: screenWidth * (14 / 360),
                                                fontWeight: FontWeight.bold,
                                                color: sFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    widthPadding(screenWidth,12),
                                    Container(
                                      width: screenWidth*(148/360),
                                      height: 1,
                                      color: hexToColor('#CCCCCC'),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Container(
                                      width: screenWidth*(148/360),
                                      height: 1,
                                      color: hexToColor('#CCCCCC'),
                                    ),
                                    widthPadding(screenWidth,12),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height:screenHeight*(4/640),
                            width:screenWidth,
                            color:hexToColor('#FFFFFF'),
                          ),
                          Container(
                            width: screenWidth,
                            height:screenHeight*(114/640),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightPadding(screenHeight,14),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Text(
                                    "추가 옵션",
                                    style:TextStyle(
                                        fontSize: screenWidth*(14/360),
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                  ),
                                ),
                                heightPadding(screenHeight,12),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Container(
                                    height: screenHeight * (34/640),
                                    child: ListView.separated(
                                      // controller: _scrollController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                        itemCount:sListOption.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              sListOption[index].flag = !sListOption[index].flag;
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              height: screenHeight * 0.05,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                child: Center(
                                                  child: Text(
                                                    '${sListOption[index].title}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*SearchCaseFontSize,
                                                      color: sListOption[index].flag ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: sListOption[index].flag ? kPrimaryColor : Colors.white,
                                                borderRadius: new BorderRadius.circular(4.0),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(1.5, 1.5),
                                                  ),
                                                ],

                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height:screenHeight*(4/640),
                            width:screenWidth,
                            color:hexToColor('#FFFFFF'),
                          ),
                          GestureDetector(
                            onTap: () async {
                              //매물 리스트
                              // EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                              ShortFilterFlag = false;
                              sSubList.clear();
                              for(int i = 1; i <= sListRoomType.length; i++) {
                                if(sListRoomType[i-1].selected) {
                                  sSubList.add(i.toString());
                                }
                              }
                              if(sSubList.length == 0) {//아무것도 선택 안한 경우
                                sSubList = ["1","2","3","4"];
                                sFilterList[0].flag = false;
                                sFilterList[0].title = "방 종류";
                                sFilterList[0].selected = false;
                              }else {
                                sFilterList[0].title = "";
                                for(int i =0; i < sListRoomType.length; i++){
                                  if(sListRoomType[i].flag) {
                                    sFilterList[0].title += sListRoomType[i].title + "/";
                                  }
                                }
                                String s = sFilterList[0].title;
                                int l = sFilterList[0].title.length;
                                sFilterList[0].title = s.substring(0,l-1);
                                sFilterList[0].selected = true;
                                sFilterList[0].flag = true;
                                sCloseFilter();
                              }

                              if((sPriceLowRange == 0 && sPriceHighRange == 30000)) {
                                sFilterList[1].flag = false;
                                sFilterList[1].title = "가격";
                                sFilterList[1].selected = false;
                              }else {
                                sFilterList[1].title = "일 / " +  extractNum(sPriceLowRange).toInt().toString()+"만원-"+extractNum(sPriceHighRange).toInt().toString()+"만원";
                                sFilterList[1].selected = true;
                                sFilterList[1].flag = true;
                                sCloseFilter();
                              }

                              if(sFilterRentStart == "" || sFilterRentDone ==""){
                                Function okFunc = () async{
                                  Navigator.pop(context);

                                };
                                sFilterList[2].flag = false;
                                sFilterList[2].title = "임대 기간";
                                sFilterList[2].selected = false;
                                sCloseFilter();
                              }else {
                                sFilterList[2].title =
                                    sFilterRentStart + "-" + sFilterRentDone;
                                sFilterList[2].selected = true;
                                sFilterList[2].flag = true;
                              }

                              sFilterList[3].title = "";
                              for(int i =0; i < sListOption.length; i++){
                                if(sListOption[i].flag) {
                                  sFilterList[3].title += sListOption[i].title + "/";
                                }
                              }
                              String s = sFilterList[3].title;
                              int l = sFilterList[3].title.length;

                              if(l==0) {//아무것도 선택 안한 경우
                                sFilterList[3].flag = false;
                                sFilterList[3].title = "추가 옵션";
                                sFilterList[3].selected = false;
                              }else {
                                sFilterList[3].selected = true;
                                sFilterList[3].flag = true;
                                sFilterList[3].title = s.substring(0,l-1);
                                sCloseFilter();
                              }



                              bool subFlag = true;
                              for(int i = 0; i <sListOption.length; i++) {
                                if(sListOption[i].selected) {
                                  subFlag = false;
                                  break;
                                }
                              }

                              globalRoomSalesInfoListFiltered
                                  .clear();
                              var list = await ApiProvider().post("/RoomSalesInfo/ListShortFilter", jsonEncode(
                                  {
                                    "types" : sSubList.length == 0 ? null : sSubList,
                                    "feemin" : sPriceLowRange,
                                    "feemax" : sPriceHighRange == 310000 ? 9999999999 : sPriceHighRange,
                                    "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                                    "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                                    "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                                    "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                                    "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                                  }
                              ));

                              // var Llist = await ApiProvider()
                              //     .post(
                              //     '/RoomSalesInfo/Select/Like',
                              //     jsonEncode(
                              //         {
                              //           "userID": GlobalProfile
                              //               .loggedInUser
                              //               .userID,
                              //         }
                              //     ));

                              if (list != null && list != false) {
                                for (int i = 0; i <
                                    list.length; ++i) {
                                  RoomSalesInfo item = RoomSalesInfo
                                      .fromJson(list[i]);

                                  // for (int j = 0; j <
                                  //     Llist.length; j++) {
                                  //   Map<String,
                                  //       dynamic> data = Llist[j];
                                  //   ModelRoomLikes Litem = ModelRoomLikes
                                  //       .fromJson(data);
                                  //
                                  //   if (item.id ==
                                  //       Litem.RoomSaleID) {
                                  //     item.Likes = true;
                                  //     setState(() {});
                                  //     break;
                                  //   }
                                  // }

                                  globalRoomSalesInfoListFiltered
                                      .add(item);
                                }
                                FlagForFilter = true;
                              }
                              else {
                                Function okFunc = () async{
                                  Navigator.pop(context);

                                };
                                resetRoomAll();
                                OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                              }
                              sCloseFilter();


                              setState(() {

                              });
                              // EasyLoading.dismiss();
                            },
                            child: Container(
                              height: screenHeight*(60/640),
                              width: screenWidth,
                              color: kPrimaryColor,
                              child: Center(
                                child: Text(
                                  '적용하기',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width*(16/360),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):
                  ShortFilterFlag && !isShortForRoomList ? Container(
                    width :screenWidth,
                    height : screenHeight,
                    color:Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          heightPadding(screenHeight,14),
                          Row(
                            children: [
                              InkWell(
                                onTap:(){
                                  ShortFilterFlag = false;
                                  setState(() {

                                  });
                                },
                                child: SvgPicture.asset(
                                  FilterXIcon,
                                ),
                              ),
                              widthPadding(screenWidth,100),
                              Text(
                                  '전체 필터',
                                  style:TextStyle(
                                    fontSize:screenWidth*(18/360),
                                    fontWeight: FontWeight.bold,

                                  )
                              ),
                            ],
                          ),
                          heightPadding(screenHeight,14),
                          Container(
                            width: screenWidth,
                            height:screenHeight*(114/640),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightPadding(screenHeight,14),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Text(
                                    "방 종류",
                                    style:TextStyle(
                                        fontSize: screenWidth*(14/360),
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                  ),
                                ),
                                heightPadding(screenHeight,12),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Container(
                                    height: screenHeight * (34/640),
                                    child: ListView.separated(
                                      // controller: _scrollController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                        itemCount:tListRoomType.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              tListRoomType[index].flag = !tListRoomType[index].flag;
                                              tListRoomType[index].selected = !tListRoomType[index].selected;
                                              tCurRoomType = index;
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              height: screenHeight * 0.05,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                child: Center(
                                                  child: Text(
                                                    '${tListRoomType[index].title}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*SearchCaseFontSize,
                                                      color: tListRoomType[index].flag ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: tListRoomType[index].flag ? kPrimaryColor : Colors.white,
                                                borderRadius: new BorderRadius.circular(4.0),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(1.5, 1.5),
                                                  ),
                                                ],

                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width:screenWidth,
                            height:screenHeight*(4/640),
                            color:hexToColor('#FFFFFF'),
                          ),
                          Container(
                            width: screenWidth,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightPadding(screenHeight,14),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Text(
                                    "거래유형",
                                    style:TextStyle(
                                        fontSize: screenWidth*(14/360),
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                  ),
                                ),
                                heightPadding(screenHeight,12),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Container(
                                    height: screenHeight * (34/640),
                                    child: ListView.separated(
                                      // controller: _scrollController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                        itemCount:tListContractType.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              tListContractType[index].flag = !tListContractType[index].flag;
                                              tListContractType[index].selected = !tListContractType[index].selected;
                                              tCurContractType = index;

                                              for(int i = 0; i < tListContractType.length; i++){
                                                if(i != index) {
                                                  tListContractType[i].flag = false;
                                                  tListContractType[i].selected = false;
                                                }
                                              }

                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              height: screenHeight * 0.05,
                                              width: screenWidth*(47/360),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                child: Center(
                                                  child: Text(
                                                    '${tListContractType[index].title}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*SearchCaseFontSize,
                                                      color: tListContractType[index].flag ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: tListContractType[index].flag ? kPrimaryColor : Colors.white,
                                                borderRadius: new BorderRadius.circular(4.0),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(1.5, 1.5),
                                                  ),
                                                ],

                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                heightPadding(screenHeight,16),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "보증금",
                                        style:TextStyle(
                                            fontSize: screenWidth*(14/360),
                                            fontWeight: FontWeight.bold,
                                            color:kPrimaryColor
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        tDepositInfinity,
                                        style:TextStyle(
                                            fontSize: screenWidth*(12/360),
                                            color:kPrimaryColor
                                        ),
                                      ),
                                      widthPadding(screenWidth,16),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: screenWidth * (336 / 360),
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        thumbColor: Colors.white,
                                      ),
                                      child: RangeSlider(
                                        min: 0,
                                        max: 10100000,
                                        divisions: 101,
                                        inactiveColor: Color(0xffcccccc),
                                        activeColor: kPrimaryColor,
                                        labels: RangeLabels(tDepositLowRange.floor().toString(),
                                            tDepositHighRange.floor().toString()),
                                        values: tDepositValues,
                                        //RangeValues(_lowValue,_highValue),
                                        onChanged: (_range) {
                                          setState(() {
                                            if(_range.end.toInt() == 10100000) {
                                              tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                                            } else {
                                              tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                                            }

                                            tDepositValues = _range;
                                            tDepositLowRange = _range.start;
                                            tDepositHighRange = _range.end;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight*(8/640),
                                  width: 1,
                                  color: hexToColor('#888888'),
                                ),
                                Row(
                                  children: [
                                    widthPadding(screenWidth,14),
                                    Text(
                                      '최소',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '500만원',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '최대',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    widthPadding(screenWidth,14),
                                  ],
                                ),
                                heightPadding(screenHeight,20),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "월세",
                                        style:TextStyle(
                                            fontSize: screenWidth*(14/360),
                                            fontWeight: FontWeight.bold,
                                            color:kPrimaryColor
                                        ),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Text(
                                        tMonthlyInfinity,
                                        style:TextStyle(
                                            fontSize: screenWidth*(12/360),
                                            color:kPrimaryColor
                                        ),
                                      ),
                                      widthPadding(screenWidth,16),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: screenWidth * (336 / 360),
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        thumbColor: Colors.white,
                                      ),
                                      child: RangeSlider(
                                        min: 0,
                                        max: 1010000,
                                        divisions: 101,
                                        inactiveColor: Color(0xffcccccc),
                                        activeColor: kPrimaryColor,
                                        labels: RangeLabels(tMonthlyFeeLowRange.floor().toString(),
                                            tMonthlyFeeHighRange.floor().toString()),
                                        values: tMonthlyFeeValues,
                                        //RangeValues(_lowValue,_highValue),
                                        onChanged: (_range) {
                                          setState(() {

                                            if(_range.end.toInt() == 1010000) {
                                              tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                                            } else {
                                              tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                                            }

                                            tMonthlyFeeValues = _range;
                                            tMonthlyFeeLowRange = _range.start;
                                            tMonthlyFeeHighRange = _range.end;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: screenHeight*(8/640),
                                  width: 1,
                                  color: hexToColor('#888888'),
                                ),
                                Row(
                                  children: [
                                    widthPadding(screenWidth,14),
                                    Text(
                                      '최소',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '50만원',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '최대',
                                      style: TextStyle(
                                          fontSize: screenWidth*(10/360),
                                          color: hexToColor('#888888')
                                      ),
                                    ),
                                    widthPadding(screenWidth,14),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width:screenWidth,
                            height:screenHeight*(4/640),
                            color:hexToColor('#FFFFFF'),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight*(126/640),
                            color: Colors.white,
                            child: Column(
                              children: [
                                heightPadding(screenHeight,22),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "임대 기간",
                                        style:TextStyle(
                                            fontSize: screenWidth*(14/360),
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                heightPadding(screenHeight,26),
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
                                              maxTime: tFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(tFilterRentDone).year, DateFormat('y.MM.d').parse(tFilterRentDone).month,DateFormat('y.MM.d').parse(tFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                              theme: DatePickerTheme(
                                                  headerColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                  itemStyle: TextStyle(
                                                      color: Colors.black, fontSize: 18),
                                                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                              onChanged: (date) {
                                                tFilterRentStart = DateFormat('y.MM.d').format(date);
                                                setState(() {

                                                });
                                              },
                                              currentTime: DateTime.now(), locale: LocaleType.ko);
                                        },
                                        child: Container(
                                          width: screenWidth * (120 / 360),
                                          child: Center(
                                            child: Text(
                                              tFilterRentStart == "" ? "입주" : tFilterRentStart,
                                              style: TextStyle(
                                                fontSize: screenWidth * (14 / 360),
                                                fontWeight: FontWeight.bold,
                                                color: tFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
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
                                          DatePicker.showDatePicker(context,
                                              showTitleActions: true,
                                              minTime: tFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(tFilterRentStart).year, DateFormat('y.MM.d').parse(tFilterRentStart).month,DateFormat('y.MM.d').parse(tFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                              maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                              theme: DatePickerTheme(
                                                  headerColor: Colors.white,
                                                  backgroundColor: Colors.white,
                                                  itemStyle: TextStyle(
                                                      color: Colors.black, fontSize: 18),
                                                  doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                              onChanged: (date) {
                                                tFilterRentDone = DateFormat('y.MM.d').format(date);
                                                setState(() {

                                                });
                                              },
                                              currentTime: DateTime.now(), locale: LocaleType.ko);
                                        },
                                        child: Container(
                                          width: screenWidth * (120 / 360),
                                          child: Center(
                                            child: Text(
                                              tFilterRentDone == "" ? "퇴실" : tFilterRentDone,
                                              style: TextStyle(
                                                fontSize: screenWidth * (14 / 360),
                                                fontWeight: FontWeight.bold,
                                                color: tFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    widthPadding(screenWidth,12),
                                    Container(
                                      width: screenWidth*(148/360),
                                      height: 1,
                                      color: hexToColor('#CCCCCC'),
                                    ),
                                    Expanded(child: SizedBox()),
                                    Container(
                                      width: screenWidth*(148/360),
                                      height: 1,
                                      color: hexToColor('#CCCCCC'),
                                    ),
                                    widthPadding(screenWidth,12),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width:screenWidth,
                            height:screenHeight*(4/640),
                            color:hexToColor('#FFFFFF'),
                          ),
                          Container(
                            width: screenWidth,
                            height:screenHeight*(114/640),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightPadding(screenHeight,14),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Text(
                                    "추가 옵션",
                                    style:TextStyle(
                                        fontSize: screenWidth*(14/360),
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                  ),
                                ),
                                heightPadding(screenHeight,12),
                                Padding(
                                  padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                                  child: Container(
                                    height: screenHeight * (34/640),
                                    child: ListView.separated(
                                      // controller: _scrollController,
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                        itemCount:tListOption.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              tListOption[index].flag = !tListOption[index].flag;
                                              setState(() {

                                              });
                                            },
                                            child: Container(
                                              height: screenHeight * 0.05,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                                child: Center(
                                                  child: Text(
                                                    '${tListOption[index].title}',
                                                    style: TextStyle(
                                                      fontSize: screenWidth*SearchCaseFontSize,
                                                      color: tListOption[index].flag ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: tListOption[index].flag ? kPrimaryColor : Colors.white,
                                                borderRadius: new BorderRadius.circular(4.0),
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    spreadRadius: 0,
                                                    blurRadius: 4,
                                                    offset: Offset(1.5, 1.5),
                                                  ),
                                                ],

                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // EasyLoading.show(
                              //     status: "",
                              //     maskType:
                              //     EasyLoadingMaskType
                              //         .black);
                              ShortFilterFlag = false;
                              tSubList.clear();
                              for(int i = 1; i <= tListRoomType.length; i++) {
                                if(tListRoomType[i-1].selected) {
                                  tSubList.add(i.toString());
                                }
                              }
                              if(tSubList.length == 0) {//아무것도 선택 안한 경우
                                tFilterList[0].flag = false;
                                tFilterList[0].title = "방 종류";
                                tFilterList[0].selected = false;
                              }else {
                                for(int i =0; i < tListRoomType.length; i++){
                                  if(tListRoomType[i].flag) {
                                    tFilterList[0].title += tListRoomType[i].title + "/";
                                  }
                                }
                                String s = tFilterList[0].title;
                                int l = tFilterList[0].title.length;
                                tFilterList[0].title = s.substring(0,l-1);
                                tFilterList[0].selected = true;
                                tFilterList[0].flag = true;
                                tCloseFilter();
                              }

                              String contractType;

                              if(!tListContractType[0].selected && !tListContractType[1].selected) {
                                if(tDepositLowRange == 0 && tDepositHighRange == 10100000 && tMonthlyFeeLowRange == 0 && tMonthlyFeeHighRange == 1010000) {
                                  tFilterList[1].flag = false;
                                  tFilterList[1].title = "가격";
                                  tFilterList[1].selected = false;
                                  contractType="";
                                } else {
                                  tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                                      extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                                  tFilterList[1].selected = true;
                                  tFilterList[1].flag = true;
                                }

                                Function okFunc = () async{
                                  Navigator.pop(context);

                                };
                              } else if(tListContractType[0].selected && !tListContractType[1].selected) {
                                flagContractType = 1;
                                contractType = "월세";

                                tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                                    extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                                tFilterList[1].selected = true;
                                tFilterList[1].flag = true;
                              } else {
                                flagContractType = 2;
                                contractType = "전세";

                                tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                                    extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                                tFilterList[1].selected = true;
                                tFilterList[1].flag = true;
                              }

                              if(tFilterRentStart == "" || tFilterRentDone ==""){
                                Function okFunc = () async{
                                  Navigator.pop(context);

                                };
                                tFilterList[2].flag = false;
                                tFilterList[2].title = "임대 기간";
                                tFilterList[2].selected = false;
                                tCloseFilter();
                              }else {
                                tFilterList[2].title = tFilterRentStart + "-" + tFilterRentDone;
                                tFilterList[2].selected = true;
                                tFilterList[2].flag = true;
                              }

                              tFilterList[3].title = "";
                              for(int i =0; i < tListOption.length; i++){
                                if(tListOption[i].flag) {
                                  tFilterList[3].title += tListOption[i].title + "/";
                                }
                              }
                              String s = tFilterList[3].title;
                              int l = tFilterList[3].title.length;

                              if(l==0) {//아무것도 선택 안한 경우
                                tFilterList[3].flag = false;
                                tFilterList[3].title = "추가 옵션";
                                tFilterList[3].selected = false;
                              }else {
                                tFilterList[3].selected = true;
                                tFilterList[3].title = s.substring(0,l-1);
                                tFilterList[3].flag = true;
                                sCloseFilter();
                              }



                              int subFlag2 = -1;
                              for(int i = 0; i < tListContractType.length; i++) {
                                if(tListContractType[i].flag){
                                  subFlag2 = i+1;
                                  break;
                                }
                              }

                              bool subFlag = true;
                              for(int i = 0; i <tListOption.length; i++) {
                                if(tListOption[i].selected) {
                                  subFlag = false;
                                  break;
                                }
                              }

                              globalRoomSalesInfoListFiltered
                                  .clear();
                              var list = await ApiProvider().post("/RoomSalesInfo/ListTransferFilter", jsonEncode(
                                  {
                                    "types" : tSubList.length == 0 ? null : tSubList,
                                    "jeonse": subFlag2 == -1 ? null : subFlag2,
                                    "depositmin" : tDepositLowRange,
                                    "depositmax" : tDepositHighRange == 30000 ? 9999999999 : tDepositHighRange,
                                    "monthlyfeemin" : tMonthlyFeeLowRange,
                                    "monthlyfeemax" : tMonthlyFeeHighRange == 30000 ? 9999999999 : tDepositHighRange,
                                    "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                                    "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                                    "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                                    "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                                    "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                                  }
                              ));

                              // var Llist = await ApiProvider()
                              //     .post(
                              //     '/RoomSalesInfo/Select/Like',
                              //     jsonEncode(
                              //         {
                              //           "userID": GlobalProfile
                              //               .loggedInUser
                              //               .userID,
                              //         }
                              //     ));

                              if (list != null && list != false) {
                                for (int i = 0; i <
                                    list.length; ++i) {
                                  RoomSalesInfo item = RoomSalesInfo
                                      .fromJson(list[i]);

                                  // for (int j = 0; j <
                                  //     Llist.length; j++) {
                                  //   Map<String,
                                  //       dynamic> data = Llist[j];
                                  //   ModelRoomLikes Litem = ModelRoomLikes
                                  //       .fromJson(data);
                                  //
                                  //   if (item.id ==
                                  //       Litem.RoomSaleID) {
                                  //     item.Likes = true;
                                  //     setState(() {});
                                  //     break;
                                  //   }
                                  // }

                                  globalRoomSalesInfoListFiltered
                                      .add(item);
                                }
                                FlagForFilter = true;
                              }
                              else {
                                Function okFunc = () async{
                                  Navigator.pop(context);

                                };
                                resetTransferAll();
                                OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                              }

                              tCloseFilter();


                              setState(() {

                              });
                              // EasyLoading.dismiss();
                            },
                            child: Container(
                              height: screenHeight*(60/640),
                              width: screenWidth,
                              color: kPrimaryColor,
                              child: Center(
                                child: Text(
                                  '적용하기',
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width*(16/360),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ) : SizedBox(),
                  isShortForRoomList == false ? Positioned(//양도의 경우, 렌더링될 플로팅 버튼
                    bottom:0,
                    right:0,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (GlobalProfile.roomSalesInfoList.length <= 4) {
                                Navigator.push(
                                    context, // 기본 파라미터, SecondRoute로 전달
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WarningBeforeTransfer(),
                                    ) // SecondRoute를 생성하여 적재
                                );
                              } else {
                                CustomOKDialog(context, "방 등록은 5개까지 가능합니다", "올리셨던 방을 수정해주세요");
                              }
                            },
                            child: Stack(
                              children: [
                                Container(  height: 52,
                                  width:130
                                  ,decoration:BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(30))),),
                                Padding(
                                  padding: EdgeInsets.only(bottom:screenHeight*(12/640)),
                                  child: Container(
                                      height: 52,
                                      width:140,
                                      child: Row(
                                        children: <Widget>[
                                          Container(width:screenWidth*(14/360)),

                                          Container(child:Text("양도하기",style: TextStyle(color:Color(0xFF222222)),)),
                                          Container(width:screenWidth*(10/360)),

                                          FloatingActionButton(heroTag: "btn2",child:Icon(Icons.add,size: 30))],mainAxisAlignment: MainAxisAlignment.end,)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width:screenWidth*(8/360)),
                        ],
                      ),
                    ),
                  ) : SizedBox(),

                ],
              ),
            ),
          ),

        ),
      ),
    );
  }

  void sCloseFilter() {
    sCurFilter = -1;
  }

  void tCloseFilter() {
    tCurFilter = -1;
  }

  Container sReturnFilter(double screenWidth, double screenHeight) {
    return sCurFilter == -1 ? Container() :
    sCurFilter == 0 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "방 종류",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:sListRoomType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        sListRoomType[index].flag = !sListRoomType[index].flag;
                        sListRoomType[index].selected = !sListRoomType[index].selected;
                        sCurRoomType = index;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${sListRoomType[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: sListRoomType[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: sListRoomType[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: sFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    // EasyLoading.show(
                    //     status: "",
                    //     maskType:
                    //     EasyLoadingMaskType
                    //         .black);
                    sSubList.clear();
                    for(int i = 1; i <= sListRoomType.length; i++) {
                      if(sListRoomType[i-1].selected) {
                        sSubList.add(i.toString());
                      }
                    }
                    if(sSubList.length == 0) {//아무것도 선택 안한 경우
                      sFilterList[0].flag = false;
                      sFilterList[0].title = "방 종류";
                      sFilterList[0].selected = false;
                    }else {
                      sFilterList[0].title = "";
                      for(int i =0; i < sListRoomType.length; i++){
                        if(sListRoomType[i].flag) {
                          sFilterList[0].title += sListRoomType[i].title + "/";
                        }
                      }
                      String s = sFilterList[0].title;
                      int l = sFilterList[0].title.length;
                      sFilterList[0].title = s.substring(0,l-1);
                      sFilterList[0].selected = true;
                      sCloseFilter();
                    }

                    bool subFlag = true;
                    for(int i = 0; i <sListOption.length; i++) {
                      if(sListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    var list = await ApiProvider().post("/RoomSalesInfo/ListShortFilter", jsonEncode(
                        {
                          "types" : sSubList.length == 0 ? null : sSubList,
                          "feemin" : sPriceLowRange,
                          "feemax" : sPriceHighRange == 310000 ? 9999999999 : sPriceHighRange,
                          "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                          "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                          "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                        }
                    ));

                    // var Llist = await ApiProvider()
                    //     .post(
                    //     '/RoomSalesInfo/Select/Like',
                    //     jsonEncode(
                    //         {
                    //           "userID": GlobalProfile
                    //               .loggedInUser
                    //               .userID,
                    //         }
                    //     ));
                    globalRoomSalesInfoListFiltered
                        .clear();
                    if (list != null && list != false) {


                      for (int i = 0; i <
                          list.length; ++i) {
                        RoomSalesInfo item = RoomSalesInfo
                            .fromJson(list[i]);

                        // for (int j = 0; j <
                        //     Llist.length; j++) {
                        //   Map<String,
                        //       dynamic> data = Llist[j];
                        //   ModelRoomLikes Litem = ModelRoomLikes
                        //       .fromJson(data);
                        //
                        //   if (item.id ==
                        //       Litem.RoomSaleID) {
                        //     item.Likes = true;
                        //     setState(() {});
                        //     break;
                        //   }
                        // }

                        globalRoomSalesInfoListFiltered
                            .add(item);
                      }
                      FlagForFilter = true;
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetRoomType();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    sCloseFilter();


                    setState(() {

                    });
                    // EasyLoading.dismiss();
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    sCurFilter == 1 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "가격 ",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                  ),
                ),
                Text(
                  "(일 단위)",
                  style:TextStyle(
                      fontSize: screenWidth*(13.5/360),
                      color:hexToColor('#888888')
                  ),
                ),
              ],
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "전체",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:kPrimaryColor
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  sInfinity,
                  style:TextStyle(
                      fontSize: screenWidth*(12/360),
                      color:kPrimaryColor
                  ),
                ),
                widthPadding(screenWidth,16),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * (336 / 360),
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                ),
                child: RangeSlider(
                  min: 0,
                  max: 310000,
                  divisions: 31,
                  inactiveColor: Color(0xffcccccc),
                  activeColor: kPrimaryColor,
                  labels: RangeLabels(sPriceLowRange.floor().toString(),
                      sPriceHighRange.floor().toString()),
                  values: sPriceValues,
                  //RangeValues(_lowValue,_highValue),
                  onChanged: (_range) {
                    setState(() {
                      if(_range.end.toInt() == 310000) {
                        sInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                      } else {
                        sInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                      }

                      sPriceValues = _range;
                      sPriceLowRange = _range.start;
                      sPriceHighRange = _range.end;
                    });
                  },
                ),
              ),
            ),
          ),
          heightPadding(screenHeight,8),
          Row(
            children: [
              widthPadding(screenWidth,14),
              Text(
                '최소',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                '최대',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              widthPadding(screenWidth,14),
            ],
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: sFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {


                    if((sPriceLowRange == 0 && sPriceHighRange == 30000)) {
                      sFilterList[1].flag = false;
                      sFilterList[1].title = "가격";
                      sFilterList[1].selected = false;
                    }else {
                      sFilterList[sCurFilter].title = "일 / " +  extractNum(sPriceLowRange).toInt().toString()+"만원-"+extractNum(sPriceHighRange).toInt().toString()+"만원";
                      sFilterList[1].selected = true;
                      sCloseFilter();
                    }

                    bool subFlag = true;
                    for(int i = 0; i <sListOption.length; i++) {
                      if(sListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    globalRoomSalesInfoListFiltered
                        .clear();
                    var list = await ApiProvider().post("/RoomSalesInfo/ListShortFilter", jsonEncode(
                        {
                          "types" : sSubList.length == 0 ? null : sSubList,
                          "feemin" : sPriceLowRange,
                          "feemax" : sPriceHighRange == 310000 ? 9999999999 : sPriceHighRange,
                          "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                          "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                          "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                        }
                    ));

                    // var Llist = await ApiProvider()
                    //     .post(
                    //     '/RoomSalesInfo/Select/Like',
                    //     jsonEncode(
                    //         {
                    //           "userID": GlobalProfile
                    //               .loggedInUser
                    //               .userID,
                    //         }
                    //     ));

                    if (list != null && list != false) {
                      for (int i = 0; i <
                          list.length; ++i) {
                        RoomSalesInfo item = RoomSalesInfo
                            .fromJson(list[i]);

                        // for (int j = 0; j <
                        //     Llist.length; j++) {
                        //   Map<String,
                        //       dynamic> data = Llist[j];
                        //   ModelRoomLikes Litem = ModelRoomLikes
                        //       .fromJson(data);
                        //
                        //   if (item.id ==
                        //       Litem.RoomSaleID) {
                        //     item.Likes = true;
                        //     setState(() {});
                        //     break;
                        //   }
                        // }

                        globalRoomSalesInfoListFiltered
                            .add(item);
                      }
                      FlagForFilter = true;
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetRoomPrice();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    sCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    sCurFilter == 2 ? Container(
      width: screenWidth,
      height: screenHeight*(167/640),
      color: Colors.white,
      child: Column(
        children: [
          heightPadding(screenHeight,22),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "임대 기간",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                  ),
                ),
              ],
            ),
          ),
          heightPadding(screenHeight,26),
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
                        maxTime: sFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(sFilterRentDone).year, DateFormat('y.MM.d').parse(sFilterRentDone).month,DateFormat('y.MM.d').parse(sFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          sFilterRentStart = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        sFilterRentStart == "" ? "입주" : sFilterRentStart,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: sFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
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
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: sFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(sFilterRentStart).year, DateFormat('y.MM.d').parse(sFilterRentStart).month,DateFormat('y.MM.d').parse(sFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          sFilterRentDone = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        sFilterRentDone == "" ? "퇴실" : sFilterRentDone,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: sFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Row(
            children: [
              widthPadding(screenWidth,12),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              Expanded(child: SizedBox()),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              widthPadding(screenWidth,12),
            ],
          ),
          heightPadding(screenHeight,28),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: sFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if(sFilterRentStart == "" || sFilterRentDone ==""){
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      sFilterList[2].flag = false;
                      sFilterList[2].title = "임대 기간";
                      sFilterList[2].selected = false;
                      sCloseFilter();
                      OKDialog(context, "임대 기간을 입력해주세요!", "입주나 퇴실 기간을 선택해주세요", "확인",okFunc);
                    }else {
                      sFilterList[sCurFilter].title = sFilterRentStart + "-"+sFilterRentDone;
                      sFilterList[2].selected = true;

                      bool subFlag = true;
                      for(int i = 0; i <sListOption.length; i++) {
                        if(sListOption[i].selected) {
                          subFlag = false;
                          break;
                        }
                      }

                      globalRoomSalesInfoListFiltered
                          .clear();
                      var list = await ApiProvider().post("/RoomSalesInfo/ListShortFilter", jsonEncode(
                          {
                            "types" : sSubList.length == 0 ? null : sSubList,
                            "feemin" : sPriceLowRange,
                            "feemax" : sPriceHighRange == 310000 ? 9999999999 : sPriceHighRange,
                            "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                            "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                            "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                            "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                            "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                          }
                      ));

                      // var Llist = await ApiProvider()
                      //     .post(
                      //     '/RoomSalesInfo/Select/Like',
                      //     jsonEncode(
                      //         {
                      //           "userID": GlobalProfile
                      //               .loggedInUser
                      //               .userID,
                      //         }
                      //     ));

                      if (list != null&& list != false) {
                        for (int i = 0; i <
                            list.length; ++i) {
                          RoomSalesInfo item = RoomSalesInfo
                              .fromJson(list[i]);

                          // for (int j = 0; j <
                          //     Llist.length; j++) {
                          //   Map<String,
                          //       dynamic> data = Llist[j];
                          //   ModelRoomLikes Litem = ModelRoomLikes
                          //       .fromJson(data);
                          //
                          //   if (item.id ==
                          //       Litem.RoomSaleID) {
                          //     item.Likes = true;
                          //     setState(() {});
                          //     break;
                          //   }
                          // }

                          globalRoomSalesInfoListFiltered
                              .add(item);
                        }
                        FlagForFilter = true;
                      }
                      else {
                        Function okFunc = () async{
                          Navigator.pop(context);

                        };
                        resetRoomRent();
                        OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                      }
                      sCloseFilter();

                    }

                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    sCurFilter == 3 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "추가 옵션",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:sListOption.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        sListOption[index].flag = !sListOption[index].flag;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${sListOption[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: sListOption[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: sListOption[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: sFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    sFilterList[3].title = "";
                    for(int i =0; i < sListOption.length; i++){
                      if(sListOption[i].flag) {
                        sFilterList[3].title += sListOption[i].title + "/";
                      }
                    }
                    String s = sFilterList[3].title;
                    int l = sFilterList[3].title.length;

                    if(l==0) {//아무것도 선택 안한 경우
                      sFilterList[3].flag = false;
                      sFilterList[3].title = "추가 옵션";
                      sFilterList[3].selected = false;
                    }else {
                      sFilterList[3].selected = true;
                      sFilterList[3].title = s.substring(0,l-1);
                      sCloseFilter();
                    }

                    bool subFlag = true;
                    for(int i = 0; i <sListOption.length; i++) {
                      if(sListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    globalRoomSalesInfoListFiltered
                        .clear();
                    var list = await ApiProvider().post("/RoomSalesInfo/ListShortFilter", jsonEncode(
                        {
                          "types" : sSubList.length == 0 ? null : sSubList,
                          "feemin" : sPriceLowRange,
                          "feemax" : sPriceHighRange == 310000 ? 9999999999 : sPriceHighRange,
                          "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                          "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                          "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                        }
                    ));

                    // var Llist = await ApiProvider()
                    //     .post(
                    //     '/RoomSalesInfo/Select/Like',
                    //     jsonEncode(
                    //         {
                    //           "userID": GlobalProfile
                    //               .loggedInUser
                    //               .userID,
                    //         }
                    //     ));

                    if (list != null&& list != false ) {
                      for (int i = 0; i <
                          list.length; ++i) {
                        RoomSalesInfo item = RoomSalesInfo
                            .fromJson(list[i]);

                        // for (int j = 0; j <
                        //     Llist.length; j++) {
                        //   Map<String,
                        //       dynamic> data = Llist[j];
                        //   ModelRoomLikes Litem = ModelRoomLikes
                        //       .fromJson(data);
                        //
                        //   if (item.id ==
                        //       Litem.RoomSaleID) {
                        //     item.Likes = true;
                        //     setState(() {});
                        //     break;
                        //   }
                        // }

                        globalRoomSalesInfoListFiltered
                            .add(item);
                      }
                      FlagForFilter = true;
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetRoomOption();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }

                    sCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) : Container();
  }

  Container tReturnFilter(double screenWidth, double screenHeight) {
    return tCurFilter == -1 ? Container() :
    tCurFilter == 0 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "방 종류",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:tListRoomType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        tListRoomType[index].flag = !tListRoomType[index].flag;
                        tListRoomType[index].selected = !tListRoomType[index].selected;
                        tCurRoomType = index;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${tListRoomType[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: tListRoomType[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: tListRoomType[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: tFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    tSubList.clear();
                    for(int i = 1; i <= tListRoomType.length; i++) {
                      if(tListRoomType[i-1].selected) {
                        tSubList.add(i.toString());
                      }
                    }
                    if(tSubList.length == 0) {//아무것도 선택 안한 경우
                      tFilterList[0].flag = false;
                      tFilterList[0].title = "방 종류";
                      tFilterList[0].selected = false;
                    }else {
                      for(int i =0; i < tListRoomType.length; i++){
                        if(tListRoomType[i].flag) {
                          tFilterList[0].title += tListRoomType[i].title + "/";
                        }
                      }
                      String s = tFilterList[0].title;
                      int l = tFilterList[0].title.length;
                      tFilterList[0].title = s.substring(0,l-1);
                      tFilterList[0].selected = true;
                      tCloseFilter();
                    }

                    int subFlag2 = -1;
                    for(int i = 0; i < tListContractType.length; i++) {
                      if(tListContractType[i].flag){
                        subFlag2 = i+1;
                        break;
                      }
                    }

                    bool subFlag = true;
                    for(int i = 0; i <tListOption.length; i++) {
                      if(tListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    globalRoomSalesInfoListFiltered
                        .clear();
                    var list = await ApiProvider().post("/RoomSalesInfo/ListTransferFilter", jsonEncode(
                        {
                          "userID": GlobalProfile.loggedInUser.userID,
                          "types" : tSubList.length == 0 ? null : tSubList,
                          "jeonse": subFlag2 == -1 ? null : subFlag2,
                          "depositmin" : tDepositLowRange,
                          "depositmax" : tDepositHighRange == 30000 ? 9999999999 : tDepositHighRange,
                          "monthlyfeemin" : tMonthlyFeeLowRange,
                          "monthlyfeemax" : tMonthlyFeeHighRange == 30000 ? 9999999999 : tDepositHighRange,
                          "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                          "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                          "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                        }
                    ));

                    // var Llist = await ApiProvider()
                    //     .post(
                    //     '/RoomSalesInfo/Select/Like',
                    //     jsonEncode(
                    //         {
                    //           "userID": GlobalProfile
                    //               .loggedInUser
                    //               .userID,
                    //         }
                    //     ));

                    if (list != null && list != false) {
                      for (int i = 0; i <
                          list.length; ++i) {
                        RoomSalesInfo item = RoomSalesInfo
                            .fromJson(list[i]);

                        // for (int j = 0; j <
                        //     Llist.length; j++) {
                        //   Map<String,
                        //       dynamic> data = Llist[j];
                        //   ModelRoomLikes Litem = ModelRoomLikes
                        //       .fromJson(data);
                        //
                        //   if (item.id ==
                        //       Litem.RoomSaleID) {
                        //     item.Likes = true;
                        //     setState(() {});
                        //     break;
                        //   }
                        // }

                        globalRoomSalesInfoListFiltered
                            .add(item);
                      }
                      FlagForFilter = true;
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetTransferType();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    tCloseFilter();


                    setState(() {

                    });

                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    tCurFilter == 1 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "거래유형",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:tListContractType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        tListContractType[index].flag = !tListContractType[index].flag;
                        tListContractType[index].selected = !tListContractType[index].selected;
                        tCurContractType = index;

                        for(int i = 0; i < tListContractType.length; i++){
                          if(i != index) {
                            tListContractType[i].flag = false;
                            tListContractType[i].selected = false;
                          }
                        }

                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth*(47/360),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${tListContractType[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: tListContractType[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: tListContractType[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "보증금",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:kPrimaryColor
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  tDepositInfinity,
                  style:TextStyle(
                      fontSize: screenWidth*(12/360),
                      color:kPrimaryColor
                  ),
                ),
                widthPadding(screenWidth,16),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * (336 / 360),
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                ),
                child: RangeSlider(
                  min: 0,
                  max: 10100000,
                  divisions: 101,
                  inactiveColor: Color(0xffcccccc),
                  activeColor: kPrimaryColor,
                  labels: RangeLabels(tDepositLowRange.floor().toString(),
                      tDepositHighRange.floor().toString()),
                  values: tDepositValues,
                  //RangeValues(_lowValue,_highValue),
                  onChanged: (_range) {
                    setState(() {
                      if(_range.end.toInt() == 10100000) {
                        tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                      } else {
                        tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                      }

                      tDepositValues = _range;
                      tDepositLowRange = _range.start;
                      tDepositHighRange = _range.end;
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            height: screenHeight*(8/640),
            width: 1,
            color: hexToColor('#888888'),
          ),
          Row(
            children: [
              widthPadding(screenWidth,14),
              Text(
                '최소',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '1억 2000만원',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '최대',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              widthPadding(screenWidth,14),
            ],
          ),
          heightPadding(screenHeight,20),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "월세",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:kPrimaryColor
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  tMonthlyInfinity,
                  style:TextStyle(
                      fontSize: screenWidth*(12/360),
                      color:kPrimaryColor
                  ),
                ),
                widthPadding(screenWidth,16),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * (336 / 360),
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                ),
                child: RangeSlider(
                  min: 0,
                  max: 1010000,
                  divisions: 101,
                  inactiveColor: Color(0xffcccccc),
                  activeColor: kPrimaryColor,
                  labels: RangeLabels(tMonthlyFeeLowRange.floor().toString(),
                      tMonthlyFeeHighRange.floor().toString()),
                  values: tMonthlyFeeValues,
                  //RangeValues(_lowValue,_highValue),
                  onChanged: (_range) {
                    setState(() {
                      if(_range.end.toInt() == 1010000) {
                        tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                      } else {
                        tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                      }

                      tMonthlyFeeValues = _range;
                      tMonthlyFeeLowRange = _range.start;
                      tMonthlyFeeHighRange = _range.end;
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            height: screenHeight*(8/640),
            width: 1,
            color: hexToColor('#888888'),
          ),
          Row(
            children: [
              widthPadding(screenWidth,14),
              Text(
                '최소',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '50만원',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '최대',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              widthPadding(screenWidth,14),
            ],
          ),
          heightPadding(screenHeight,18),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: tFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    String contractType;

                    if(!tListContractType[0].selected && !tListContractType[1].selected) {
                      if(tDepositLowRange == 0 && tDepositHighRange == 10100000 && tMonthlyFeeLowRange == 0 && tMonthlyFeeHighRange == 1010000) {
                        tFilterList[1].flag = false;
                        tFilterList[1].title = "가격";
                        tFilterList[1].selected = false;
                        contractType="";
                      } else {
                        tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                            extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                        tFilterList[1].selected = true;
                        tFilterList[1].flag = true;
                      }

                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                    } else if(tListContractType[0].selected && !tListContractType[1].selected) {
                      flagContractType = 1;
                      contractType = "월세";

                      tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                          extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                      tFilterList[1].selected = true;
                      tFilterList[1].flag = true;
                    } else {
                      flagContractType = 2;
                      contractType = "전세";

                      tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                          extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                      tFilterList[1].selected = true;
                      tFilterList[1].flag = true;
                    }

                    int subFlag2 = -1;
                    for(int i = 0; i < tListContractType.length; i++) {
                      if(tListContractType[i].flag){
                        subFlag2 = i+1;
                        break;
                      }
                    }

                    bool subFlag = true;
                    for(int i = 0; i <tListOption.length; i++) {
                      if(tListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    globalRoomSalesInfoListFiltered
                        .clear();
                    var list = await ApiProvider().post("/RoomSalesInfo/ListTransferFilter", jsonEncode(
                        {
                          "types" : tSubList.length == 0 ? null : tSubList,
                          "jeonse": subFlag2 == -1 ? null : subFlag2,
                          "depositmin" : tDepositLowRange,
                          "depositmax" : tDepositHighRange == 10100000 ? 9999999999 : tDepositHighRange,
                          "monthlyfeemin" : tMonthlyFeeLowRange,
                          "monthlyfeemax" : tMonthlyFeeHighRange == 1010000 ? 9999999999 : tDepositHighRange,
                          "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                          "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                          "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                        }
                    ));

                    // var Llist = await ApiProvider()
                    //     .post(
                    //     '/RoomSalesInfo/Select/Like',
                    //     jsonEncode(
                    //         {
                    //           "userID": GlobalProfile
                    //               .loggedInUser
                    //               .userID,
                    //         }
                    //     ));

                    if (list != null && list != false) {
                      for (int i = 0; i <
                          list.length; ++i) {
                        RoomSalesInfo item = RoomSalesInfo
                            .fromJson(list[i]);

                        // for (int j = 0; j <
                        //     Llist.length; j++) {
                        //   Map<String,
                        //       dynamic> data = Llist[j];
                        //   ModelRoomLikes Litem = ModelRoomLikes
                        //       .fromJson(data);
                        //
                        //   if (item.id ==
                        //       Litem.RoomSaleID) {
                        //     item.Likes = true;
                        //     setState(() {});
                        //     break;
                        //   }
                        // }

                        globalRoomSalesInfoListFiltered
                            .add(item);
                      }
                      FlagForFilter = true;
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetTransferPrice();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }

                    tCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    tCurFilter == 2 ? Container(
      width: screenWidth,
      height: screenHeight*(167/640),
      color: Colors.white,
      child: Column(
        children: [
          heightPadding(screenHeight,22),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "임대 기간",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                  ),
                ),
              ],
            ),
          ),
          heightPadding(screenHeight,26),
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
                        maxTime: tFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(tFilterRentDone).year, DateFormat('y.MM.d').parse(tFilterRentDone).month,DateFormat('y.MM.d').parse(tFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          tFilterRentStart = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        tFilterRentStart == "" ? "입주" : tFilterRentStart,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: tFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
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
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: tFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(tFilterRentStart).year, DateFormat('y.MM.d').parse(tFilterRentStart).month,DateFormat('y.MM.d').parse(tFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          tFilterRentDone = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        tFilterRentDone == "" ? "퇴실" : tFilterRentDone,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: tFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Row(
            children: [
              widthPadding(screenWidth,12),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              Expanded(child: SizedBox()),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              widthPadding(screenWidth,12),
            ],
          ),
          heightPadding(screenHeight,28),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: tFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if(tFilterRentStart == "" || tFilterRentDone ==""){
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      tFilterList[2].flag = false;
                      tFilterList[2].title = "임대 기간";
                      tFilterList[2].selected = false;
                      tCloseFilter();
                      OKDialog(context, "임대 기간을 입력해주세요!", "입주나 퇴실 기간을 선택해주세요", "확인",okFunc);
                    }else {
                      tFilterList[2].title = tFilterRentStart + "-"+tFilterRentDone;
                      tFilterList[2].selected = true;

                      int subFlag2 = -1;
                      for(int i = 0; i < tListContractType.length; i++) {
                        if(tListContractType[i].flag){
                          subFlag2 = i+1;
                          break;
                        }
                      }

                      bool subFlag = true;
                      for(int i = 0; i <tListOption.length; i++) {
                        if(tListOption[i].selected) {
                          subFlag = false;
                          break;
                        }
                      }

                      globalRoomSalesInfoListFiltered
                          .clear();
                      var list = await ApiProvider().post("/RoomSalesInfo/ListTransferFilter", jsonEncode(
                          {
                            "types" : tSubList.length == 0 ? null : tSubList,
                            "jeonse": subFlag2 == -1 ? null : subFlag2,
                            "depositmin" : tDepositLowRange,
                            "depositmax" : tDepositHighRange == 30000 ? 9999999999 : tDepositHighRange,
                            "monthlyfeemin" : tMonthlyFeeLowRange,
                            "monthlyfeemax" : tMonthlyFeeHighRange == 30000 ? 9999999999 : tDepositHighRange,
                            "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                            "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                            "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                            "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                            "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                          }
                      ));

                      // var Llist = await ApiProvider()
                      //     .post(
                      //     '/RoomSalesInfo/Select/Like',
                      //     jsonEncode(
                      //         {
                      //           "userID": GlobalProfile
                      //               .loggedInUser
                      //               .userID,
                      //         }
                      //     ));

                      if (list != null && list != false) {
                        for (int i = 0; i <
                            list.length; ++i) {
                          RoomSalesInfo item = RoomSalesInfo
                              .fromJson(list[i]);

                          // for (int j = 0; j <
                          //     Llist.length; j++) {
                          //   Map<String,
                          //       dynamic> data = Llist[j];
                          //   ModelRoomLikes Litem = ModelRoomLikes
                          //       .fromJson(data);
                          //
                          //   if (item.id ==
                          //       Litem.RoomSaleID) {
                          //     item.Likes = true;
                          //     setState(() {});
                          //     break;
                          //   }
                          // }

                          globalRoomSalesInfoListFiltered
                              .add(item);
                        }
                        FlagForFilter = true;
                      }
                      else {
                        Function okFunc = () async{
                          Navigator.pop(context);

                        };
                        resetTransferRent();
                        OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                      }


                      tCloseFilter();


                      setState(() {

                      });

                    }

                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    tCurFilter == 3 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "추가 옵션",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:tListOption.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        tListOption[index].flag = !tListOption[index].flag;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${tListOption[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: tListOption[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: tListOption[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: tFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    tFilterList[3].title = "";
                    for(int i =0; i < tListOption.length; i++){
                      if(tListOption[i].flag) {
                        tFilterList[3].title += tListOption[i].title + "/";
                      }
                    }
                    String s = tFilterList[3].title;
                    int l = tFilterList[3].title.length;

                    if(l==0) {//아무것도 선택 안한 경우
                      tFilterList[3].flag = false;
                      tFilterList[3].title = "추가 옵션";
                      tFilterList[3].selected = false;
                    }else {
                      tFilterList[3].selected = true;
                      tFilterList[3].title = s.substring(0,l-1);
                      sCloseFilter();
                    }

                    int subFlag2 = -1;
                    for(int i = 0; i < tListContractType.length; i++) {
                      if(tListContractType[i].flag){
                        subFlag2 = i+1;
                        break;
                      }
                    }

                    bool subFlag = true;
                    for(int i = 0; i <tListOption.length; i++) {
                      if(tListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    globalRoomSalesInfoListFiltered
                        .clear();
                    var list = await ApiProvider().post("/RoomSalesInfo/ListTransferFilter", jsonEncode(
                        {
                          "types" : tSubList.length == 0 ? null : tSubList,
                          "jeonse": subFlag2 == -1 ? null : subFlag2,
                          "depositmin" : tDepositLowRange,
                          "depositmax" : tDepositHighRange == 30000 ? 9999999999 : tDepositHighRange,
                          "monthlyfeemin" : tMonthlyFeeLowRange,
                          "monthlyfeemax" : tMonthlyFeeHighRange == 30000 ? 9999999999 : tDepositHighRange,
                          "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                          "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                          "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                        }
                    ));

                    // var Llist = await ApiProvider()
                    //     .post(
                    //     '/RoomSalesInfo/Select/Like',
                    //     jsonEncode(
                    //         {
                    //           "userID": GlobalProfile
                    //               .loggedInUser
                    //               .userID,
                    //         }
                    //     ));

                    if (list != null && list != false) {
                      for (int i = 0; i <
                          list.length; ++i) {
                        RoomSalesInfo item = RoomSalesInfo
                            .fromJson(list[i]);

                        // for (int j = 0; j <
                        //     Llist.length; j++) {
                        //   Map<String,
                        //       dynamic> data = Llist[j];
                        //   ModelRoomLikes Litem = ModelRoomLikes
                        //       .fromJson(data);
                        //
                        //   if (item.id ==
                        //       Litem.RoomSaleID) {
                        //     item.Likes = true;
                        //     setState(() {});
                        //     break;
                        //   }
                        // }

                        globalRoomSalesInfoListFiltered
                            .add(item);
                      }
                      FlagForFilter = true;
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetTransferOption();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }

                    tCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) : Container();
  }

  InkWell sFilterCancelWidget(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: (){
        sCloseFilter();
        for(int i =0; i < sFilterList.length; i++) {
          if(sFilterList[i].selected)
            continue;
          else
            sFilterList[i].flag = false;
        }
        setState(() {

        });
      },
      child: Container(
        height: screenHeight*(40/640),
        child: Center(
          child: Text(
            '취소하기',
            style: TextStyle(
                fontSize: screenWidth*(12/360),
                fontWeight: FontWeight.bold,
                color: hexToColor('#CCCCCC')
            ),
          ),
        ),
      ),
    );
  }
  InkWell tFilterCancelWidget(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: (){
        tCloseFilter();
        for(int i =0; i < tFilterList.length; i++) {
          if(tFilterList[i].selected)
            continue;
          else
            tFilterList[i].flag = false;
        }
        setState(() {

        });
      },
      child: Container(
        height: screenHeight*(40/640),
        child: Center(
          child: Text(
            '취소하기',
            style: TextStyle(
                fontSize: screenWidth*(12/360),
                fontWeight: FontWeight.bold,
                color: hexToColor('#CCCCCC')
            ),
          ),
        ),
      ),
    );
  }

  void resetTransferAll() {
    resetTransferType();
    resetTransferRent();
    resetTransferPrice();
    resetTransferOption();
  }

  void resetRoomAll() {
    resetRoomType();
    resetRoomPrice();
    resetRoomRent();
    resetRoomOption();
  }

  void resetTransferOption() {
    tFilterList[3].flag = false;
    tFilterList[3].title = "추가 옵션";
    tFilterList[3].selected = false;
    for(int i = 0; i < tListOption.length; i++) {
      tListOption[i].flag = false;
      tListOption[i].selected = false;
    }
  }

  void resetTransferRent() {
    tFilterList[2].flag = false;
    tFilterList[2].title = "임대 기간";
    tFilterList[2].selected = false;
    tFilterRentStart = "";
    tFilterRentDone = "";
  }

  void resetTransferPrice() {
    tFilterList[1].flag = false;
    tFilterList[1].title = "가격";
    tFilterList[1].selected = false;

    tCurContractType = -1;
    for(int i = 0; i < tListContractType.length; i++) {
      tListContractType[i].flag  = false;
      tListContractType[i].selected  = false;
    }

    tDepositLowRange = 0;
    tDepositHighRange = 30000;
    tDepositValues = RangeValues(0, 30000);

    tMonthlyFeeLowRange = 0;
    tMonthlyFeeHighRange = 30000;
    tMonthlyFeeValues = RangeValues(0, 30000);

  }

  void resetTransferType() {
    tFilterList[0].flag = false;
    tFilterList[0].title = "방 종류";
    tFilterList[0].selected = false;

    for(int i = 0; i < tListRoomType.length; i++){
      tListRoomType[i].flag = false;
      tListRoomType[i].selected = false;
    }
    tCurRoomType = -1;

  }

  void resetRoomOption() {
    sFilterList[3].flag = false;
    sFilterList[3].title = "추가 옵션";
    sFilterList[3].selected = false;
    for(int i = 0; i < sListOption.length; i++) {
      sListOption[i].flag = false;
      sListOption[i].selected = false;
    }
  }

  void resetRoomRent() {
    sFilterList[2].flag = false;
    sFilterList[2].title = "임대 기간";
    sFilterList[2].selected = false;
    sFilterRentStart = "";
    sFilterRentDone = "";
  }

  void resetRoomPrice() {
    sFilterList[1].flag = false;
    sFilterList[1].title = "가격";
    sFilterList[1].selected = false;
    sPriceLowRange = 0;
    sPriceHighRange = 0;
  }

  void resetRoomType() {
    sFilterList[0].flag = false;
    sFilterList[0].title = "방 종류";
    sFilterList[0].selected = false;

    for(int i = 0; i < sListRoomType.length; i++){
      sListRoomType[i].flag = false;
      sListRoomType[i].selected = false;
    }
    sCurRoomType = -1;
  }
}

class Triangle extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(size.width,size.height);
    path.lineTo(size.width,0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}

