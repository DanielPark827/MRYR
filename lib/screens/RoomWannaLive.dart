import 'dart:async';
import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/DetailRoomWannaLive.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BorrowRoom/DetailedRoomInformation.dart';
import 'BorrowRoom/RoomForBorrowList.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';

class RoomWannaLive extends StatefulWidget {

  @override
  _RoomWannaLiveState createState() => _RoomWannaLiveState();
}

class _RoomWannaLiveState extends State<RoomWannaLive>with SingleTickerProviderStateMixin  {
  AnimationController extendedController;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _scrollController = ScrollController();

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  void initState() {

    refreshKey = GlobalKey<RefreshIndicatorState>();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent-10){
        _getMoreData();
      }
      setState(() {

      });
    });

    (() async {
      var list = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));

      if(null != list) {
        RoomLikesList.clear();
        RoomLikesIdList.clear();
        for(int i = 0; i < list.length; ++i){
          Map<String, dynamic> data = list[i];

          ModelRoomLikes item = ModelRoomLikes.fromJson(data);
          RoomLikesIdList.add(item.RoomSaleID);
          RoomLikesList.add(item);
          //await NotiDBHelper().createData(noti);
        }
        for(int i= 0; i < GlobalProfile.listForMe.length; i++) {
          if(RoomLikesIdList.contains(GlobalProfile.listForMe[i].id)) {
            GlobalProfile.listForMe[i].ChangeLikesWithValue(true);
          }
        }

      }
    })();


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
  _getMoreData() async{
    Timer(Duration(milliseconds: 500), ()async{
      var tmp = await ApiProvider().post('/RoomSalesInfo/Recommend/Offset', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
            "index": GlobalProfile.listForMe.length,
          }
      ));
      if(tmp != null){
        for(int i =0;i<tmp.length;i++){
          RoomSalesInfo _roomSalesInfo= RoomSalesInfo.fromJson(tmp[i]);
          GlobalProfile.listForMe.add(_roomSalesInfo);
        }
      }
    });
  }

  Future<List<String>> getRecentList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(KeyForRecent);
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
      return;
    }
    subList.add(index.toString());
    if(subList.length == 10) {
      subList.removeAt(0);
    }
    prefs.setStringList(KeyForRecent, subList);

    print("ddddddddddddddddd"+"${subList.length.toString()}"+"    ${subList}");
  }

  List<ModelRoomLikes> RoomLikesList = [];
  List<int> RoomLikesIdList = [];

  Future<bool> initLikes() async {
    var list = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
        {
          "userID" : GlobalProfile.loggedInUser.userID,
        }
    ));

    if(null != list) {
      RoomLikesList.clear();
      RoomLikesIdList.clear();
      for(int i = 0; i < list.length; ++i){
        Map<String, dynamic> data = list[i];

        ModelRoomLikes item = ModelRoomLikes.fromJson(data);
        RoomLikesIdList.add(item.RoomSaleID);
        RoomLikesList.add(item);
        //await NotiDBHelper().createData(noti);
      }
      for(int i= 0; i < GlobalProfile.listForMe.length; i++) {
        if(RoomLikesIdList.contains(GlobalProfile.listForMe[i].id)) {
          GlobalProfile.listForMe[i].ChangeLikesWithValue(true);
        }
      }

      print('sdfs');
      setState(() {

      });
      return true;
    } else {
      print('no');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    return WillPopScope(
      onWillPop: (){
        navigationNumProvider.setNum(navigationNumProvider.getPastNum());
        return;
      },
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: ()async{
          GlobalProfile.listForMe.clear();
          var list2 = await ApiProvider().post('/RoomSalesInfo/Recommend', jsonEncode({
            "userID" :GlobalProfile.loggedInUser.userID,
          }));
          if(list2 != null){
            for(int i = 0;i<list2.length;i++){
              GlobalProfile.listForMe.add(RoomSalesInfo.fromJson(list2[i]));
            }
          }

          setState(() {

          });

        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
          child: Scaffold(
            backgroundColor: Color(0xfff8f8f8),
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
                  onPressed: () {

                    if(navigationNumProvider.getPastNum()==4) {
                      navigationNumProvider.setPastNum(1);
                    }
                    setState(() {

                    });
                    navigationNumProvider.setNum(navigationNumProvider.getPastNum());
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
            body: SafeArea(
              child: Column(
                children: [

                  ( GlobalProfile.listForMe == null||GlobalProfile.listForMe.length == 0)?
                  Expanded(
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        separatorBuilder: (BuildContext context, int index) => Container(
                          height: screenHeight*(8/640),
                          decoration: BoxDecoration(
                            color: hexToColor('#F8F8F8'),
                          ),
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return  Column(
                            children: [
                              Column(children: [
                                Container(
                                  color: Colors.white,
                                  height: screenHeight * (20 / 640),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * (12 / 360),
                                      ),
                                      Text(
                                        "내가 살고 싶은 방 정보",
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: screenWidth * (4 / 360),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel: MaterialLocalizations.of(context)
                                                .modalBarrierDismissLabel,
                                            barrierColor: Colors.black12.withOpacity(0.6),
                                            transitionDuration: Duration(milliseconds: 150),
                                            pageBuilder: (BuildContext context, Animation first,
                                                Animation second) {
                                              return Center(
                                                child: Container(
                                                  decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.all(
                                                        new Radius.circular(8.0)),
                                                  ),
                                                  width:
                                                  MediaQuery.of(context).size.width * (248 / 360),
                                                  height: MediaQuery.of(context).size.height *
                                                      (186 / 640),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: MediaQuery.of(context).size.height *
                                                            (16 / 640),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: screenWidth * (12 / 360),
                                                          ),
                                                          Material(
                                                              child: Text(
                                                                "내가 살고 싶은 방이란?",
                                                                style: TextStyle(
                                                                    fontSize: screenWidth * (16 / 360),
                                                                    fontWeight: FontWeight.bold),
                                                              ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: screenHeight * (8 / 640),
                                                      ),
                                                      Container(
                                                        height: screenHeight * (96 / 640),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: screenWidth * (12 / 360),
                                                            ),
                                                            Container(
                                                              width: screenWidth * (226 / 360),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        screenWidth * (12 / 360),
                                                                        color: Color(0xff888888)),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                          "사람들이 구하고 싶어하는 방의 리스트입니다.\n"),
                                                                      TextSpan(
                                                                          text: "방을 내놓을 때",
                                                                          style: TextStyle(
                                                                              color: kPrimaryColor)),
                                                                      TextSpan(
                                                                          text:
                                                                          ", 사람들이 원하는 조건을 미리 알아보고 빨리 매물을 내놓을 수 있고\n"),
                                                                      TextSpan(
                                                                          text: "방을 구할 때",
                                                                          style: TextStyle(
                                                                              color: kPrimaryColor)),
                                                                      TextSpan(
                                                                          text:
                                                                          ", 자신이 원하는 조건을 제시할 수 있습니다"),
                                                                    ]),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Material(
                                                          child: Container(
                                                            width: screenWidth * (240 / 360),
                                                            height: screenHeight * (40 / 640),
                                                            decoration: BoxDecoration(
                                                              color: kPrimaryColor,
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  "확인",
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth * (14 / 360),
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white),
                                                                )),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          question_circle_filled,
                                          height: screenHeight * (16 / 640),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: screenHeight * (28 / 640),
                                ),
                                Container(
                                  color: Colors.white,
                                  width: screenWidth,
                                  height: screenHeight * (104 / 640),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: screenHeight * (16 / 640),
                                ),
                                SizedBox(height: screenHeight*(12/640),),
                                Container(color: Colors.white,height: screenHeight*(54/640),width: screenWidth,
                                  child: Column(children: [
                                    SizedBox(height: screenHeight*(20/640),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: screenWidth*(12/360),),
                                        Text("나에게 맞는 매물 추천", style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),)
                                      ],)
                                  ],),
                                ),
                              ],),
                            ],
                          );
                        }
                    ),
                  ):
                  Expanded(
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        separatorBuilder: (BuildContext context, int index) => Container(
                          height: screenHeight*(8/640),
                          decoration: BoxDecoration(
                            color: hexToColor('#F8F8F8'),
                          ),
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        itemCount: GlobalProfile.listForMe.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  Column(
                            children: [
                              index == 0? Column(children: [
                                Container(
                                  color: Colors.white,
                                  height: screenHeight * (20 / 640),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * (12 / 360),
                                      ),
                                      Text(
                                        "내가 살고 싶은 방 정보",
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: screenWidth * (4 / 360),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel: MaterialLocalizations.of(context)
                                                .modalBarrierDismissLabel,
                                            barrierColor: Colors.black12.withOpacity(0.6),
                                            transitionDuration: Duration(milliseconds: 150),
                                            pageBuilder: (BuildContext context, Animation first,
                                                Animation second) {
                                              return Center(
                                                child: Container(
                                                  decoration: new BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: new BorderRadius.all(
                                                        new Radius.circular(8.0)),
                                                  ),
                                                  width:
                                                  MediaQuery.of(context).size.width * (248 / 360),
                                                  height: MediaQuery.of(context).size.height *
                                                      (186 / 640),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: MediaQuery.of(context).size.height *
                                                            (16 / 640),
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: screenWidth * (12 / 360),
                                                          ),
                                                          Material(
                                                              child: Text(
                                                                "내가 살고 싶은 방이란?",
                                                                style: TextStyle(
                                                                    fontSize: screenWidth * (16 / 360),
                                                                    fontWeight: FontWeight.bold),
                                                              ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: screenHeight * (8 / 640),
                                                      ),
                                                      Container(
                                                        height: screenHeight * (96 / 640),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: screenWidth * (12 / 360),
                                                            ),
                                                            Container(
                                                              width: screenWidth * (226 / 360),
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        screenWidth * (12 / 360),
                                                                        color: Color(0xff888888)),
                                                                    children: <TextSpan>[
                                                                      TextSpan(
                                                                          text:
                                                                          "사람들이 구하고 싶어하는 방의 리스트입니다.\n"),
                                                                      TextSpan(
                                                                          text: "방을 내놓을 때",
                                                                          style: TextStyle(
                                                                              color: kPrimaryColor)),
                                                                      TextSpan(
                                                                          text:
                                                                          ", 사람들이 원하는 조건을 미리 알아보고 빨리 매물을 내놓을 수 있고\n"),
                                                                      TextSpan(
                                                                          text: "방을 구할 때",
                                                                          style: TextStyle(
                                                                              color: kPrimaryColor)),
                                                                      TextSpan(
                                                                          text:
                                                                          ", 자신이 원하는 조건을 제시할 수 있습니다"),
                                                                    ]),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Material(
                                                          child: Container(
                                                            width: screenWidth * (240 / 360),
                                                            height: screenHeight * (40 / 640),
                                                            decoration: BoxDecoration(
                                                              color: kPrimaryColor,
                                                              borderRadius: BorderRadius.circular(4),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  "확인",
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth * (14 / 360),
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white),
                                                                )),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          question_circle_filled,
                                          height: screenHeight * (16 / 640),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: screenHeight * (28 / 640),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context, // 기본 파라미터, SecondRoute로 전달
                                        MaterialPageRoute(
                                            builder: (context) => DetailRoomWannaLive(
                                                needRoomInfo: GlobalProfile
                                                    .NeedRoomInfoOfloggedInUser)) // SecondRoute를 생성하여 적재
                                    );
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    width: screenWidth,
                                    height: screenHeight * (104 / 640),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth * (12 / 360),
                                        ),
                                        SvgPicture.asset(
                                          ProfileIconInMoreScreen,
                                          width: screenWidth * (100 / 360),
                                          height: screenHeight * (104 / 640),
                                        ),
                                        SizedBox(
                                          width: screenWidth * (12 / 360),
                                        ),

                                        Container(
                                          height: screenHeight * (104 / 640),
                                          //color: Colors.red,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: screenWidth * (53 / 360),
                                                    height: screenHeight * (22 / 640),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffeeeeee),
                                                      borderRadius: BorderRadius.circular(
                                                          screenHeight * (4 / 640)),
                                                    ),
                                                    child: Center(
                                                        child: Text(

                                                          GlobalProfile.NeedRoomInfoOfloggedInUser.PreferTerm == 2 ? "하루가능" :
                                                          GlobalProfile.NeedRoomInfoOfloggedInUser.PreferTerm == 1 ? "1개월이상" : "기관무관",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kPrimaryColor,
                                                              fontSize: screenWidth * (10 / 360)),
                                                        )),
                                                  ),
                                                  SizedBox(width: screenWidth*(4/360),),
                                                  Container(
                                                    width: screenWidth * (53 / 360),
                                                    height: screenHeight * (22 / 640),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffeeeeee),
                                                      borderRadius: BorderRadius.circular(
                                                          screenHeight * (4 / 640)),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                          GlobalProfile.NeedRoomInfoOfloggedInUser
                                                              .SmokingPossible ==
                                                              0
                                                              ? "흡연가능"
                                                              : GlobalProfile.NeedRoomInfoOfloggedInUser
                                                              .SmokingPossible ==
                                                              1
                                                              ? "흡연불가"
                                                              : "흡연 무관",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kPrimaryColor,
                                                              fontSize: screenWidth * (10 / 360)),
                                                        )),
                                                  ),
                                                  SizedBox(width: screenWidth*(4/360),),
                                                  Container(
                                                    width: screenWidth * (53 / 360),
                                                    height: screenHeight * (22 / 640),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffeeeeee),
                                                      borderRadius: BorderRadius.circular(
                                                          screenHeight * (4 / 640)),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                          GlobalProfile.NeedRoomInfoOfloggedInUser
                                                              .PreferSex ==
                                                              0
                                                              ? "남자 선호"
                                                              : GlobalProfile.NeedRoomInfoOfloggedInUser
                                                              .PreferSex ==
                                                              1
                                                              ? "여자 선호"
                                                              : "성별 무관",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: kPrimaryColor,
                                                              fontSize: screenWidth * (10 / 360)),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * (4 / 640),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${GlobalProfile.NeedRoomInfoOfloggedInUser.MonthlyFeesMin}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: screenWidth * (16 / 360)),
                                                    ),
                                                    Text(
                                                      "만원",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: screenWidth * (16 / 360)),
                                                    ),
                                                    Text(
                                                      " ~ ",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: screenWidth * (16 / 360)),
                                                    ),
                                                    Text(
                                                      '${GlobalProfile.NeedRoomInfoOfloggedInUser.MonthlyFeesMax}',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: screenWidth * (16 / 360)),
                                                    ),
                                                    Text(
                                                      "만원 / 월",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: screenWidth * (16 / 360)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenHeight * (4 / 640),
                                              ),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMin == null?Text(" - ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),):
                                                    Text(getMonthAndDay(GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMin) + " ~ " + getMonthAndDay(GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMax)
                                                      ,style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width:screenWidth*(185/360),
                                                child: Text(
                                                  GlobalProfile.NeedRoomInfoOfloggedInUser.Information == null? "" :  GlobalProfile.NeedRoomInfoOfloggedInUser.Information,
                                                  maxLines:3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: screenWidth * ListContentsFontSize,
                                                      color: Color(0xff888888)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                       Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xff888888),
                                          size: screenWidth * (15 / 360),
                                        ),
                                        SizedBox(width:screenWidth*(8/360)),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  height: screenHeight * (16 / 640),
                                ),
                                SizedBox(height: screenHeight*(12/640),),
                                Container(color: Colors.white,height: screenHeight*(54/640),width: screenWidth,
                                  child: Column(children: [
                                    SizedBox(height: screenHeight*(20/640),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: screenWidth*(12/360),),
                                        Text("나에게 맞는 매물 추천", style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),)
                                      ],)
                                  ],),
                                ),
                              ],): Container(),
                              InkWell(
                                onTap: () async {
                                  await AddRecent(index);
                                  Navigator.push(
                                      context, // 기본 파라미터, SecondRoute로 전달
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailedRoomInformation(
                                                roomSalesInfo: GlobalProfile.listForMe[index],
                                              )) // SecondRoute를 생성하여 적재
                                  );
                                },
                                child: Container(
                                  width: screenWidth,
                                  height: screenHeight * 0.19375,
                                  decoration:BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width:screenWidth * 0.033333,),
                                      Column(
                                        children: [
                                          SizedBox(height: screenHeight * 0.01875),
                                          Container(
                                            width: screenWidth * 0.3333333,
                                            height: screenHeight * 0.15625,
                                            child: ClipRRect(
                                                borderRadius: new BorderRadius.circular(4.0),
                                                child:   GlobalProfile.listForMe[index].imageUrl1=="BasicImage"
                                                    ?
                                                SvgPicture.asset(
                                                  ProfileIconInMoreScreen,
                                                  width: screenHeight * (60 / 640),
                                                  height: screenHeight * (60 / 640),
                                                )
                                                    :  FittedBox(
                                                  fit: BoxFit.cover,
                                                  child:    getExtendedImage(get_resize_image_name(GlobalProfile.listForMe[index].imageUrl1,360), 0,extendedController),
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
                                                                    GlobalProfile.listForMe[index].preferenceTerm == 2 ? "하루가능" :
                                                                    GlobalProfile.listForMe[index].preferenceTerm == 1 ? "1개월이상" : "기관무관",

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
                                                                    GlobalProfile.listForMe[index].preferenceSmoking == 1 ? "흡연가능" : GlobalProfile.listForMe[index].preferenceSmoking == 0 ? "흡연불가" : "흡연무관",
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
                                                                    GlobalProfile.listForMe[index].preferenceSex == 1 ? "남자선호" : GlobalProfile.listForMe[index].preferenceSmoking == 0 ? "여자선호" : "성별무관",
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
                                                            )
                                                          ],
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  SizedBox(height: screenHeight * 0.014),
                                                  GestureDetector(

                                                      onTap: () async {
                                                        var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                            {
                                                              "userID" : GlobalProfile.loggedInUser.userID,
                                                              "roomSaleID": GlobalProfile.listForMe[index].id,
                                                            }
                                                        ));

                                                        GlobalProfile.listForMe[index].ChangeLikesWithValue(!GlobalProfile.listForMe[index].Likes);
                                                        setState(() {
                                                        });
                                                      },
                                                      child:  GlobalProfile.listForMe[index].Likes ?
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
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.00625,
                                          ),
                                          Text(

                                            GlobalProfile.listForMe[index].monthlyRentFeesOffer.toString() +
                                                '만원 / 월',
                                            style: TextStyle(
                                                fontSize: screenHeight * 0.025,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.00625,
                                          ),
                                          Text(
                                            GlobalProfile.listForMe[index].termOfLeaseMin +
                                                '~' +
                                                GlobalProfile.listForMe[index].termOfLeaseMax,
                                            style: TextStyle(color: hexToColor("#888888")),
                                          ),
                                          Container(
                                            width: screenWidth*0.45,
                                            height: screenHeight*(16/640),
                                            child: Text(
                                              GlobalProfile.listForMe[index].information,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(

                                                  color: hexToColor("#888888")),
                                            ),
                                          ),
                                          SizedBox(height: screenHeight*(3/640),),
                                          Container(
                                            width: screenWidth*(205/360),
                                            child: Row(
                                              children: [
                                                Spacer(),
                                                Text(timeCheck( GlobalProfile.listForMe[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          );
                        }
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
