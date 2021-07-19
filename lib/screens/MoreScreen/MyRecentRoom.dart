import 'dart:convert';

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
import 'package:geocoder/geocoder.dart';

class MyRecentRoom extends StatefulWidget {
  final int current;

  MyRecentRoom({Key key, this.current,}) : super(key : key);

  @override
  _MyRecentRoomState createState() => _MyRecentRoomState();
}

SharedPreferences localStorage;
String KeyForLikes = 'RoomLikesList';
String KeyForRecent = 'RecentLIst';

class _MyRecentRoomState extends State<MyRecentRoom> with SingleTickerProviderStateMixin{

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
    selectedLeft = widget.current;
  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }
  List<ModelRoomLikes> RoomLikesList = [];
  List<int> RoomLikesIdList = [];
  Future<bool> initLikes(BuildContext context) async {
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
      for(int i= 0; i < globalRoomSalesInfoList.length; i++) {
        if(RoomLikesIdList.contains(globalRoomSalesInfoList[i].id)) {
          globalRoomSalesInfoList[i].ChangeLikesWithValue(true);
        }
      }

      print('sdfs5');
      setState(() {

      });
      return true;
    } else {
      print('no');
      return false;
    }
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

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,//hexToColor('#F8F8F8'),
      appBar: AppBar(
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
                Container(
                  height: screenHeight*0.0675,
                  width: screenWidth /3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight*0.0140625,
                      ),
                      Text(
                        '찜한 방',
                        style: TextStyle(
                            fontSize: screenWidth * (16 / 360),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight*0.0109375,),
                    ],
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: screenHeight*0.0125,),
          FutureBuilder(
              future: initLikes(context),
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
                  return RoomLikesList.length == 0 ? Padding(
                      padding: EdgeInsets.only(top:screenHeight*(118/640)),
                      child: emptySnail(screenHeight, screenWidth, "관심 목록이 아직 없어요!")) : Expanded(
                    child: ListView.separated(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) => Container(height: screenHeight*(4/640),color: hexToColor('#F8F8F8'),),
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

                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedRoomInformation(
                                            roomSalesInfo: tmpRoom,
                                          )) // SecondRoute를 생성하여 적재
                              );
                            },
                            child: Container(
                              width: screenWidth,
                              height: screenHeight * 0.19375,
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
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
                                                          getRoomSalesInfoByID(RoomLikesIdList[index]).preferenceTerm == 2 ? "하루가능" :getRoomSalesInfoByID(RoomLikesIdList[index]).preferenceTerm == 1 ? "1개월이상" : "기관무관",
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
                                                          getRoomSalesInfoByID(RoomLikesIdList[index]).preferenceSmoking == 2 ? "흡연가능" : getRoomSalesInfoByID(RoomLikesIdList[index]).preferenceSmoking == 1 ? "흡연불가" : "흡연무관",
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
                                                          getRoomSalesInfoByID(RoomLikesIdList[index]).preferenceSex == 1 ? "남자선호" : getRoomSalesInfoByID(RoomLikesIdList[index]).preferenceSmoking == 0 ? "여자선호" : "성별무관",
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

                                          // getRoomSalesInfoByID(RoomLikesIdList[index]).ChangeLikesWithValue(!getRoomSalesInfoByID(RoomLikesIdList[index]).Likes);
                                          RoomSalesInfo t = getRoomSalesInfoByID(RoomLikesIdList[index]);
                                          bool sub = !t.Likes;
                                          t.ChangeLikesWithValue(sub);
                                          getRoomSalesInfoByIDFromMainTransfer(t.id).ChangeLikesWithValue(sub);
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
                  );
                }
              })
        ],
      ),
    );
  }
}
