import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/MoreScreen/model/ModelRoomRecommend.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/ReleaseRoom/model/ModelRecommendedRoom.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/screens/DetailRoomWannaLive.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/Public/floatButtonWithListIcon.dart';
import 'package:provider/provider.dart';
import 'package:mryr/screens/NeedRoomSalesInfo/model/NeedRoomSalesInfoLikes.dart';
import 'package:mryr/screens/TransferRoom/WarningBeforeTransfer.dart';
import 'package:mryr/userData/Room.dart';

import 'ProposalRoomInfo.dart';
import 'StudentIdentification.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/EnterRoomInfo.dart';

class MyRoomList extends StatefulWidget {
  //final int state;

  MyRoomList({
    Key key,
   // this.state,
  }) : super(key: key);

  @override
  _MyRoomListState createState() => _MyRoomListState();
}

class _MyRoomListState extends State<MyRoomList>
    with SingleTickerProviderStateMixin {
  AnimationController extendedController;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _scrollController = ScrollController();

  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent - 100) {
        // _getMoreData();
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
  void dispose() {
    super.dispose();
    extendedController.dispose();
  }

/*
  _getMoreData() async{
    Timer(Duration(milliseconds: 500), ()async{

      var tmp = await ApiProvider().post('/NeedRoomSalesInfo/RecommendUserList/Offset', jsonEncode(
          {
            "userID":GlobalProfile.loggedInUser.userID,
            "index" : GlobalProfile.listForMe2.length.toString(),
          }
      ));
      if(tmp != null){
        for(int i =0;i<tmp.length;i++){
          NeedRoomInfo _NeedRoomInfo= NeedRoomInfo.fromJson(tmp[i]);
          GlobalProfile.listF2.add(_NeedRoomInfo);
        }
      }
      else
        print("error&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    });
  }*/

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    return WillPopScope(
      onWillPop: () {

        navigationNumProvider.setNum(navigationNumProvider.getPastNum());

        return;
      },
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          //자기 매물 정보
          var list5 = await ApiProvider().post('/RoomSalesInfo/myroomInfo',
              jsonEncode({"userID": GlobalProfile.loggedInUser.userID}));

          GlobalProfile.roomSalesInfoList.clear();
          if (list5 != null && list5  != false) {
            for (int i = 0; i < list5.length; ++i) {
              GlobalProfile.roomSalesInfoList
                  .add(RoomSalesInfo.fromJson(list5[i]));
            }
          }
          setState(() {});
        },
        child: Scaffold(
          backgroundColor: Color(0xfff8f8f8),
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                //  navigationNumProvider.setNum(3 /* socket: socket*/);
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
                        "내가 내놓은 방 정보",
                        style: TextStyle(
                            fontSize: screenWidth * (16 / 360),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: screenWidth * (4 / 360),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: screenHeight * (12 / 640),
                ),
                GlobalProfile.roomSalesInfoList.length == 0
                    ? Padding(
                      padding: EdgeInsets.only(top:screenHeight*(118/640)),
                      child: emptySnail(screenHeight, screenWidth, "내놓은 방이 아직 없어요!"),
                    )
                    : Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: GlobalProfile.roomSalesInfoList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Column(
                                    children: [
                                      index == 0
                                          ? Container(
                                              color: Colors.white,
                                              height: screenHeight * (16 / 640),
                                            )
                                          : Container(
                                              color: Colors.white,
                                              height: screenHeight * (12 / 640),
                                            ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context, // 기본 파라미터, SecondRoute로 전달
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailedRoomInformation(
                                                        roomSalesInfo: GlobalProfile
                                                                .roomSalesInfoList[
                                                            index],
                                                        nbnb: false,
                                                      ))).then((value) {
                                            setState(() {});
                                          }); // SecondRoute를 생성하여 적재
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          width: screenWidth,
                                          height: screenHeight * (108 / 640),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * (12 / 360),
                                              ),
                                              Container(
                                                width:
                                                    screenHeight * (108 / 640),
                                                height:
                                                    screenHeight * (108 / 640),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                    child: GlobalProfile
                                                                .roomSalesInfoList[
                                                                    index]
                                                                .imageUrl1 ==
                                                            "BasicImage"
                                                        ? SvgPicture.asset(
                                                            mryrInReviewScreen,
                                                            width:
                                                                screenHeight *
                                                                    (60 / 640),
                                                            height:
                                                                screenHeight *
                                                                    (60 / 640),
                                                          )
                                                        : FittedBox(
                                                            fit: BoxFit.cover,
                                                            child: getExtendedImage(
                                                                get_resize_image_name(
                                                                    GlobalProfile
                                                                        .roomSalesInfoList[
                                                                            index]
                                                                        .imageUrl1,
                                                                    360),
                                                                0,
                                                                extendedController),
                                                          )),
                                              ),
                                              SizedBox(
                                                width: screenWidth * (12 / 360),
                                              ),
                                              Container(
                                                width:
                                                    screenWidth * (170 / 360),
                                                height:
                                                    screenHeight * (120 / 640),
                                                //color: Colors.red,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: screenWidth *
                                                              (53 / 360),
                                                          height: screenHeight *
                                                              (22 / 640),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffeeeeee),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    screenHeight *
                                                                        (4 /
                                                                            640)),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                                GlobalProfile.roomSalesInfoList[index].Condition == 1 ? "신축 건물" : "구축 건물",

                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize:
                                                                    screenWidth *
                                                                        TagFontSize),
                                                          )),
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (4 / 360),
                                                        ),
                                                        Container(
                                                          width: screenWidth *
                                                              (53 / 360),
                                                          height: screenHeight *
                                                              (22 / 640),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffeeeeee),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    screenHeight *
                                                                        (4 /
                                                                            640)),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            GlobalProfile
                                                                        .roomSalesInfoList[
                                                                            index]
                                                                        .Floor == 1 ? "반지하" : GlobalProfile
                                                                .roomSalesInfoList[
                                                            index]
                                                                .Floor == 2 ? "1층" : "2층 이상",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize:
                                                                    screenWidth *
                                                                        TagFontSize),
                                                          )),
                                                        ),
                                                        Spacer(),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: screenHeight *
                                                          (4 / 640),
                                                    ),
                                                    Row(
                                                      children: [

                                                        Text(
                                                          GlobalProfile.roomSalesInfoList[index].jeonse == true?       GlobalProfile.roomSalesInfoList[index].depositFeesOffer.toString()+"만원 / 전세" :       GlobalProfile.roomSalesInfoList[index].monthlyRentFeesOffer.toString()+"만원 / 월세",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  screenWidth *
                                                                      (16 /
                                                                          360)),
                                                        ),

                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: screenHeight *
                                                          (4 / 640),
                                                    ),
                                                    Text(
                                                      GlobalProfile
                                                              .roomSalesInfoList[
                                                                  index]
                                                              .termOfLeaseMin +
                                                          '~' +
                                                          GlobalProfile
                                                              .roomSalesInfoList[
                                                                  index]
                                                              .termOfLeaseMax,
                                                      style: TextStyle(
                                                        fontSize: screenWidth*(12/360),
                                                        color:hexToColor("#44444444"),),
                                                    ),
                                                    Container(
                                                      width: screenWidth *
                                                          (250 / 360),
                                                      child: Text(
                                                        GlobalProfile
                                                            .roomSalesInfoList[
                                                                index]
                                                            .information,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            color: hexToColor(
                                                                "#888888")),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xff888888),
                                                size: screenWidth * (20 / 360),
                                              ),
                                              SizedBox(
                                                  width:
                                                      screenWidth * (12 / 360)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight * (12 / 640),
                                        width: screenWidth,
                                        color: Color(0xffffffff),
                                      ),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Color(0xffeeeeee),
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                            },
                                            child: Container(
                                              width:
                                                  screenWidth * (179.5 / 360),
                                              height: screenHeight * (40 / 640),
                                              color: Color(0xffffffff),
                                              child: Center(
                                                child: Text(
                                                  "양도중으로 변경",
                                                  style: TextStyle(
                                                      fontSize: (12 / 360) *
                                                          screenWidth,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: hexToColor('#CCCCCC')),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: screenWidth * (1 / 360),
                                              height: screenHeight * (40 / 640),
                                              color: Color(0xffeeeeee)),
                                          InkWell(
                                            onTap: () async {

                                              Function okFunc = () async {
                                                //자기 매물 정보
                                                await ApiProvider().post(
                                                    '/RoomSalesInfo/Update/TradingState',
                                                    jsonEncode({
                                                      "roomID": GlobalProfile
                                                          .roomSalesInfoList[
                                                      index]
                                                          .id,
                                                      "tstate": 1,
                                                    }));
                                                var list5 = await ApiProvider()
                                                    .post(
                                                    '/RoomSalesInfo/myroomInfo',
                                                    jsonEncode({
                                                      "userID":
                                                      GlobalProfile
                                                          .loggedInUser
                                                          .userID
                                                    }));

                                                GlobalProfile.roomSalesInfoList
                                                    .clear();
                                                if (list5 != null) {
                                                  for (int i = 0;
                                                  i < list5.length;
                                                  ++i) {
                                                    GlobalProfile
                                                        .roomSalesInfoList
                                                        .add(RoomSalesInfo
                                                        .fromJson(
                                                        list5[i]));
                                                  }
                                                }



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

                                                  // if(null != Llist) {
                                                  //   RoomLikesList.clear();
                                                  //   RoomLikesIdList.clear();
                                                  //   for(int i = 0; i < Llist.length; ++i){
                                                  //     Map<String, dynamic> data = Llist[i];
                                                  //
                                                  //     ModelRoomLikes item = ModelRoomLikes.fromJson(data);
                                                  //     RoomLikesIdList.add(item.RoomSaleID);
                                                  //     RoomLikesList.add(item);
                                                  //     //await NotiDBHelper().createData(noti);
                                                  //   }
                                                  //   for(int i= 0; i < globalRoomSalesInfoList.length; i++) {
                                                  //     if(RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
                                                  //       globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
                                                  //     }
                                                  //   }
                                                  //
                                                  // }

                                                }
                                                var list3 = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
                                                    {
                                                      "userID" : GlobalProfile.loggedInUser.userID,
                                                    }
                                                ));

                                                // if(null != list3) {
                                                //   RoomLikesList.clear();
                                                //   RoomLikesIdList.clear();
                                                //   for(int i = 0; i < list3.length; ++i){
                                                //     Map<String, dynamic> data = list3[i];
                                                //
                                                //     ModelRoomLikes item = ModelRoomLikes.fromJson(data);
                                                //     RoomLikesIdList.add(item.RoomSaleID);
                                                //     RoomLikesList.add(item);
                                                //     //await NotiDBHelper().createData(noti);
                                                //   }
                                                //   for(int i= 0; i < globalRoomSalesInfoList.length; i++) {
                                                //     if(RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
                                                //       globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
                                                //     }
                                                //   }
                                                //
                                                //
                                                // }


                                                //메인 단기매물 리스트
                                                mainShortList.clear();
                                                var tmp= await ApiProvider().get('/RoomSalesInfo/ShortRooms');
                                                if(null != tmp){
                                                  for(int i = 0;i<tmp.length;i++){
                                                    mainShortList.add(RoomSalesInfo.fromJson(tmp[i]));
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

                                                setState(() {});

                                                Navigator.pop(context);

                                                setState(() {});
                                              };

                                              Function cancelFunc = () {
                                                Navigator.pop(context);

                                                setState(() {});
                                              };

                                              OKCancelDialog(
                                                  context,
                                                  "변경하시겠습니까?",
                                                  "거래완료로 변경하시면\n 방 구하기 목록에서 내 방이 내려갑니다",
                                                  "확인",
                                                  "취소",
                                                  okFunc,
                                                  cancelFunc);

                                            },
                                            child: Container(
                                              width:
                                                  screenWidth * (179.5 / 360),
                                              height: screenHeight * (40 / 640),
                                              color: Color(0xffffffff),
                                              child: Center(
                                                child: Text(
                                                  GlobalProfile
                                                              .roomSalesInfoList[
                                                                  index]
                                                              .tradingState ==
                                                          2
                                                      ? "거래완료로 변경"
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: (12 / 360) *
                                                          screenWidth,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 1,
                                        width: screenWidth,
                                        color: Color(0xffeeeeee),
                                      ),
                                      Container(
                                        height: screenHeight * (12 / 640),
                                        width: screenWidth,
                                      ),
                                    ],
                                  ),
                                  GlobalProfile.roomSalesInfoList[index]
                                              .tradingState ==
                                          2
                                      ? Container()
                                      : Container(
                                          width: screenWidth,
                                          height: screenHeight * (175 / 640),
                                          color: Colors.white.withOpacity(0.8),
                                          child: Column(
                                            children: [
                                              Container(
                                                height:
                                                    screenHeight * (12 / 640),
                                              ),
                                              Container(
                                                width: screenWidth,
                                                height:
                                                    screenHeight * (108 / 640),
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth *
                                                          (12 / 360),
                                                    ),
                                                    Container(
                                                      width: screenHeight *
                                                          (108 / 640),
                                                      height: screenHeight *
                                                          (108 / 640),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth *
                                                          (12 / 360),
                                                    ),
                                                    Container(
                                                      width: screenWidth *
                                                          (170 / 360),
                                                      height: screenHeight *
                                                          (120 / 640),
                                                      //color: Colors.red,
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.transparent,
                                                      size: screenWidth *
                                                          (20 / 360),
                                                    ),
                                                    SizedBox(
                                                        width: screenWidth *
                                                            (12 / 360)),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height:
                                                      screenHeight * (12 / 640),
                                                  width: screenWidth),
                                              Container(
                                                  height: 1,
                                                  width: screenWidth),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {


                                                      Function okFunc = () async {
                                                        //자기 매물 정보
                                                        await ApiProvider().post(
                                                            '/RoomSalesInfo/Update/TradingState',
                                                            jsonEncode({
                                                              "roomID": GlobalProfile
                                                                  .roomSalesInfoList[
                                                              index]
                                                                  .id,
                                                              "tstate": 2,
                                                            }));
                                                        var list5 = await ApiProvider()
                                                            .post(
                                                            '/RoomSalesInfo/myroomInfo',
                                                            jsonEncode({
                                                              "userID":
                                                              GlobalProfile
                                                                  .loggedInUser
                                                                  .userID
                                                            }));

                                                        GlobalProfile.roomSalesInfoList
                                                            .clear();
                                                        if (list5 != null) {
                                                          for (int i = 0;
                                                          i < list5.length;
                                                          ++i) {
                                                            GlobalProfile
                                                                .roomSalesInfoList
                                                                .add(RoomSalesInfo
                                                                .fromJson(
                                                                list5[i]));
                                                          }
                                                        }




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

                                                          // if(null != Llist) {
                                                          //   RoomLikesList.clear();
                                                          //   RoomLikesIdList.clear();
                                                          //   for(int i = 0; i < Llist.length; ++i){
                                                          //     Map<String, dynamic> data = Llist[i];
                                                          //
                                                          //     ModelRoomLikes item = ModelRoomLikes.fromJson(data);
                                                          //     RoomLikesIdList.add(item.RoomSaleID);
                                                          //     RoomLikesList.add(item);
                                                          //     //await NotiDBHelper().createData(noti);
                                                          //   }
                                                          //   for(int i= 0; i < globalRoomSalesInfoList.length; i++) {
                                                          //     if(RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
                                                          //       globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
                                                          //     }
                                                          //   }
                                                          //
                                                          // }

                                                        }
                                                        var list3 = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
                                                            {
                                                              "userID" : GlobalProfile.loggedInUser.userID,
                                                            }
                                                        ));

                                                        // if(null != list3) {
                                                        //   RoomLikesList.clear();
                                                        //   RoomLikesIdList.clear();
                                                        //   for(int i = 0; i < list3.length; ++i){
                                                        //     Map<String, dynamic> data = list3[i];
                                                        //
                                                        //     ModelRoomLikes item = ModelRoomLikes.fromJson(data);
                                                        //     RoomLikesIdList.add(item.RoomSaleID);
                                                        //     RoomLikesList.add(item);
                                                        //     //await NotiDBHelper().createData(noti);
                                                        //   }
                                                        //   for(int i= 0; i < globalRoomSalesInfoList.length; i++) {
                                                        //     if(RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
                                                        //       globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
                                                        //     }
                                                        //   }
                                                        //
                                                        //
                                                        // }



                                                        //메인 단기매물 리스트
                                                        mainShortList.clear();
                                                        var tmp= await ApiProvider().get('/RoomSalesInfo/ShortRooms');
                                                        if(null != tmp){
                                                          for(int i = 0;i<tmp.length;i++){
                                                            mainShortList.add(RoomSalesInfo.fromJson(tmp[i]));
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

                                                        setState(() {});

                                                        Navigator.pop(context);

                                                        setState(() {});
                                                      };

                                                      Function cancelFunc = () {
                                                        Navigator.pop(context);

                                                        setState(() {});
                                                      };

                                                      OKCancelDialog(
                                                          context,
                                                          "변경하시겠습니까?",
                                                          "판매중으로 변경하시면 방 구하기 목록에\n 다시 내 방이 올라갑니다",

                                                          "확인",
                                                          "취소",
                                                          okFunc,
                                                          cancelFunc);

                                                    },
                                                    child: Container(
                                                      width: screenWidth *
                                                          (179.5 / 360),
                                                      height: screenHeight *
                                                          (40 / 640),
                                                      color: Color(0xffffffff),
                                                      child: Center(
                                                        child: Text(
                                                          GlobalProfile
                                                              .roomSalesInfoList[
                                                          index]
                                                              .tradingState ==
                                                              1
                                                              ? "양도중으로 변경"
                                                              : "",
                                                          style: TextStyle(
                                                              fontSize: (12 /
                                                                  360) *
                                                                  screenWidth,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color:
                                                              Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: screenWidth *
                                                          (1 / 360),
                                                      height: screenHeight *
                                                          (40 / 640)),
                                                  Container(
                                                    width: screenWidth *
                                                        (179.5 / 360),
                                                    height: screenHeight *
                                                        (40 / 640),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                  height: 1,
                                                  width: screenWidth),
                                            ],
                                          ),
                                        ),
                                ],
                              );
                            }),
                      ),
                SizedBox(
                  height: screenHeight * (12 / 640),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
