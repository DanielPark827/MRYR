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
import 'package:mryr/screens/TutorialForShort.dart';
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
import '../main.dart';
import 'BorrowRoom/model/ModelRoomLikes.dart';
import 'Registration/RegistrationPage.dart';
import 'Review/ReviewScreenInMap5_phone.dart';
import 'Review/ReviewScreenInMapDetail.dart';
import 'Review/ReviewScreenInMapMain.dart';
import 'Review/model/TutorialForReview.dart';
import 'Setting/tutorial/TutorialScreenInSetting.dart';
import 'TransferRoom/WarningBeforeTransfer.dart';
import 'TutorialForLong.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>with SingleTickerProviderStateMixin  {

  PageController _PageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  int currentPage = 0;
  double PaddingForTopCard;
  bool FlagForBookMark = false;
  bool showNotificationBadge = true;
  int tmp = 0;

  int MAX_PERSONAL_PROFILE_VIEW = 10;
  int MAX_TEAM_PROFILE_VIEW = 10;

  List<bool> personalVisibleList;
  List<bool> teamVisibleList;

  LocalNotification _localNotification;
  //SocketProvider _socket;

  String KeyForRecent = 'RecentLIst';

  List<String> RecentList = [];

  int RecentListIndex = 0;

  void DeleteRecentAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(KeyForRecent, []);
    RecentList = await prefs.getStringList(KeyForRecent);
    print("RecentList : "+"    ${RecentList}");

  }

  Future<bool> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    RecentList = await prefs.getStringList(KeyForRecent);
    if(RecentList != null)
      RecentListIndex = await RecentList.length;

    return true;
  }
  AnimationController extendedController;
  @override
  void initState() {
    super.initState();


    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    personalVisibleList =
        List<bool>.filled(MAX_PERSONAL_PROFILE_VIEW, false, growable: true);
    teamVisibleList =
        List<bool>.filled(MAX_PERSONAL_PROFILE_VIEW, false, growable: true);
    setState(() {
      Future.microtask(() async {
        await permissionRequest();
        AllNotification = await getNotiByStatus();
      });
    });

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if(currentPage == null) currentPage = 0;
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      if(_PageController.hasClients) {
        _PageController.animateToPage(
          currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    new FirebaseNotifications().setUpFirebase(context);
  }

  @override
  void dispose() {
    _PageController.dispose();
    extendedController.dispose();
    super.dispose();
  }
  void showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text("hi"),
        ));
  }



  void AddRecent(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subList = await prefs.getStringList(KeyForRecent);
    if(subList == null) {
      subList = [];
      prefs.setStringList(KeyForRecent, subList);
    }
    subList;
    if(subList.contains(index.toString())) {
      subList.remove(index.toString());
    }
    subList;
    subList.insert(0,index.toString());
    if(subList.length == 10) {
      subList.removeAt(9);
    }
    prefs.setStringList(KeyForRecent, subList);
    subList;
  }



  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration.zero, () => showAlert(context));
    DashBoardAdPagesProvider dashBoardAdPages = Provider.of<DashBoardAdPagesProvider>(context);


    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

  // SocketProvider socket = Provider.of<SocketProvider>(context);


    NavigationNumProvider navigationNum =
        Provider.of<NavigationNumProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    if(null == _localNotification) _localNotification = Provider.of<LocalNotiProvider>(context).localNotification;

    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
        //  backgroundColor: Color(0xfff8f8f8),
          appBar: AppBar(
            backgroundColor: Color(0xffffffff),
            elevation: 0.0,
            actions: <Widget>[
              SizedBox(
                width: screenWidth * (12 / 360),
              ),
              GestureDetector(
                onTap: (){

                },
                child: SvgPicture.asset(
                  MryrLogoInDashBoardScreen,
                  width: screenWidth * (110 / 640),
                  height: screenHeight * (27 / 640),
                ),
              ),
              Spacer(),
              DashBoardNotificationButton(screenHeight, screenWidth, showNotificationBadge, navigationNum),
              SizedBox(
                width: screenWidth * 0.0333333333333333,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: screenWidth*(140/360),
                      child: PageView.builder(
                        pageSnapping: true,
                        controller: _PageController,
                        itemCount: bannerPNG.length,
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              if(index == 0){   Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewScreenInMap(),

                                  ) // SecondRoute를 생성하여 적재
                              );}
                              else if(index == 1){

                              }
                              else if(index == 2){
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
                              }
                              else{}
                            },
                            child: Container(
                              child: Image.asset(
                                  bannerPNG[index],
                                  width: screenWidth,
                                  height: screenWidth * (140/360),
                                  fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),

                  Positioned(
                    bottom : 7,
                      child: Container(
                        width: screenWidth,
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),

                              borderRadius: BorderRadius.circular(15),

                            ),

                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                              child: Text((currentPage+1).toString() + " / " + bannerPNG.length.toString(),style: TextStyle(color:Colors.white),),
                            ),
                          ),
                        ),
                      ))
                  /*  Positioned(
                      left: screenWidth*(159/360),
                      bottom: screenHeight * (12/640),
                      child: Container(
                        width: screenWidth*(42/360),
                        height: screenHeight*(24/640),
                        decoration: new BoxDecoration(
                            color:Color(0x000000).withOpacity(0.6),

                            borderRadius:
                            BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${currentPage+1}",style: TextStyle(fontSize: screenWidth*(12/360),color: Colors.white),),
                              Text("/",style: TextStyle(fontSize: screenWidth*(12/360),color: Colors.white),),
                              Text("${bannerPNG.length}",style: TextStyle(fontSize: screenWidth*(12/360),color: Colors.white),),
                            ],),
                        ),
                      ),
                    ),*/
                  ],
                ),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth,

                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Container(width: screenWidth*(16/360),),
                            Text("잠깐만 살고 싶다면?",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                            Spacer(),
                            FlatButton(
                                onPressed: ()async{

                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  bool flag = prefs.getBool(forShort);
                                  isShortForRoomList = true;
                                  setState(() {

                                  });
                                  if(flag == null){
                                    Navigator.push(
                                        context, // 기본 파라미터, SecondRoute로 전달
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TutorialForShort()) // SecondRoute를 생성하여 적재
                                    );
                                  }
                                  else {
                                    Navigator.push(
                                        context, // 기본 파라미터, SecondRoute로 전달
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchMapForBorrowRoom(flagForShort: true,)) // SecondRoute를 생성하여 적재
                                    );
                                  }

                                },
                                child: Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff6F22D2)),)),
                          ],),
                          SizedBox(
                            height: 4,
                          ),

                          Row(
                            children: [
                              Container(width: screenWidth*(16/360),),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: screenWidth * 0.011111,
                                children: [
                                  Container(
                                    height: screenHeight * (24/640),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225,
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(

                                          "내방니방 직영",
                                           style: TextStyle(
                                              fontSize:
                                              screenWidth*(12/360),
                                              color: kPrimaryColor,
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
                                    height: screenHeight * (24/640),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225,
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "하루도 가능",
                                          style: TextStyle(
                                              fontSize:
                                              screenWidth*(12/360),
                                              color: kPrimaryColor,
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
                                    height: screenHeight * (24/640),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225,
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "한달도 가능",
                                        style: TextStyle(
                                              fontSize:
                                              screenWidth*(12/360),
                                              color: kPrimaryColor,
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
                          SizedBox(
                            height: 12,
                          ),

                          Container(
                            height: screenWidth*(150/360),
                            child: Row(
                              children: [
                                Container(
                                  width: screenWidth*(12/360),
                                ),
                                Container(
                                  width:screenWidth*(348/360),
                                  height: screenWidth*(150/360),
                                  color: Colors.transparent,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    primary: true,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mainShortList == null?0 : mainShortList.length,
                                    itemBuilder: (BuildContext context, int index) => Padding(
                                      padding: index == 0? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 6),
                                      child: InkWell(
                                        onTap: () async {
                                          if(doubleCheck == false) {
                                            doubleCheck = true;

                                            //내방니방 직영 예약 날짜 받아오기
                                            var tmp9 = await ApiProvider()
                                                .post(
                                                '/RoomSalesInfo/NbnbRoomDateSelect',
                                                jsonEncode(
                                                    {"roomID": mainShortList[index]
                                                        .id.toString()}));
                                            GlobalProfile.reserveDateList
                                                .clear();
                                            if (tmp9 != null && tmp9.length !=0) {
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

                                            // await AddRecent(
                                            //     mainShortList[index].id);
                                            GlobalProfile.detailReviewList
                                                .clear();

                                            var detailReviewList = await ApiProvider()
                                                .post('/Review/SelectRoom',
                                                jsonEncode({
                                                  "location": mainShortList[index]
                                                      .location
                                                }));
                                            await AddRecent(
                                                mainShortList[index].id);

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
                                            await AddRecent(
                                                mainShortList[index].id);

                                            var tmp = await ApiProvider()
                                                .post('/RoomSalesInfo/RoomSelectWithLike',
                                                jsonEncode({
                                                  "roomID": mainShortList[index].id,
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
                                                          nbnb: tmpRoom.ShortTerm,
                                                        )) // SecondRoute를 생성하여 적재
                                            ).then((value) {
                                              if(null == value) {
                                                return;
                                              }
                                              if (value == false) {
                                                mainShortList[index]
                                                    .ChangeLikesWithValue(false);
                                                return;
                                              }
                                              mainShortList[index]
                                                  .ChangeLikesWithValue(value);
                                              setState(() {

                                              });
                                              return;
                                            });;
                                            extendedController.reset();
                                            setState(() {

                                            });
                                          }

                                        },
                                        child: Container(
                                          width: screenWidth*(140/360),
                                          height: screenWidth*(140/360),


                                          child:
                                          Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                      boxShadow: [
                                                        new BoxShadow(
                                                          color: Colors.grey.withOpacity(0.5),
                                                          spreadRadius: 0,
                                                          blurRadius: 1,
                                                          offset: Offset(1.5, 1.5),
                                                        ),
                                                      ],
                                                    ),
                                                    width: screenWidth*(140/360),
                                                    height: screenWidth*(88/360),
                                                    child: (mainShortList[index].imageUrl1=="BasicImage"||mainShortList[index].imageUrl1==null)
                                                        ?
                                                    ClipRRect(
                                                        borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                        child: Container(color:Color(0xffE7E7E7))
                                                    )
                                                        :

                                                    ClipRRect(
                                                      borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: getExtendedImage(get_resize_image_name(mainShortList[index].imageUrl1,360), 0,extendedController),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(

                                                    top: screenWidth*(4/360),
                                                    right:screenWidth*(4/360),
                                                    child:    GestureDetector(

                                                        onTap: () async {
                                                          var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                              {
                                                                "userID" : GlobalProfile.loggedInUser.userID,
                                                                "roomSaleID": mainShortList[index].id,
                                                              }
                                                          ));
                                                          bool sub = !mainShortList[index].Likes;
                                                          mainShortList[index].ChangeLikesWithValue(sub);
                                                          getRoomSalesInfoByID(mainShortList[index].id).ChangeLikesWithValue(sub);
                                                          setState(() {

                                                          });
                                                        },//( mainTransferList[index].Likes == null || !mainTransferList[index].Likes)
                                                        child:  mainShortList[index].Likes ?
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
                                                        )),)
                                                ],
                                              ),

                                              Container(
                                                width: screenWidth*(140/360),
                                                height:screenWidth*(52/360),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.only(bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(4.0)),
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 0,
                                                      blurRadius: 1,
                                                      offset: Offset(1.5, 1.5),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(width:screenWidth*(8/360)),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                      Container(height:screenWidth*(8/360)),
                                                      Text(mainShortList[index].DailyRentFeesOffer.toString()+"만원 / 일",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360)),),

                                                      Container(height:screenWidth*(2/360)),
                                                      Text(mainShortList[index].WeeklyRentFeesOffer.toString()+"만원 / 주",style: TextStyle(color:Color(0xff888888),fontSize: screenWidth*(10/360)),),

                                                    ],)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(children: [
                            Container(width: screenWidth*(16/360),),
                            Text("양도 받고 싶다면?",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                            Spacer(),
                            FlatButton(
                                onPressed: ()async{
                                  isShortForRoomList = false;
                                  setState(() {

                                  });
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  bool flag = prefs.getBool(forLong);
                                  if(flag == null){
                                    Navigator.push(
                                        context, // 기본 파라미터, SecondRoute로 전달
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TutorialForLong()) // SecondRoute를 생성하여 적재
                                    );
                                  }
                                  else {
                                    Navigator.push(
                                        context, // 기본 파라미터, SecondRoute로 전달
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SearchMapForBorrowRoom(flagForShort: false,)) // SecondRoute를 생성하여 적재
                                    );
                                  }


                                },
                                child: Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff6F22D2)),)),

                          ],),
                          SizedBox(
                            height: 4
                          ),

                          Row(
                            children: [
                              Container(width: screenWidth*(16/360),),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: screenWidth * 0.011111,
                                children: [
                                  Container(
                                    height: screenHeight * (24/640),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225,
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(

                                          "직접 양도",
                                          style: TextStyle(
                                            fontSize:
                                            screenWidth*(12/360),
                                            color: kPrimaryColor,
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
                                    height: screenHeight * (24/640),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225,
                                          screenWidth * 0.022222,
                                          screenHeight * 0.000225),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "1개월 이상",
                                          style: TextStyle(
                                            fontSize:
                                            screenWidth*(12/360),
                                            color: kPrimaryColor,
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
                          SizedBox(
                            height: 12,
                          ),

                          Container(
                            height: screenWidth*(150/360),
                            child: Row(
                              children: [
                                Container(
                                  width: screenWidth*(12/360),
                                ),
                                Container(
                                  width:screenWidth*(348/360),
                                  height: screenWidth*(150/360),
                                  color: Colors.transparent,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                    primary: true,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:mainTransferList == null?0 :  mainTransferList.length,
                                    itemBuilder: (BuildContext context, int index) => Padding(
                                      padding: index == 0? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 6),
                                      child: InkWell(
                                        onTap: () async {
                                          if(doubleCheck  ==false) {
                                            doubleCheck = true;

                                            var tmp = await ApiProvider().post('/RoomSalesInfo/RoomSelectWithLike', jsonEncode(
                                                {
                                                  "roomID" : mainTransferList[index].id,
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
                                              tmpRoom.lat = finalLat;
                                              tmpRoom.lng = finalLng;
                                            } else {
                                              finalLat =
                                                  tmpRoom.lat;
                                              finalLng =
                                                  tmpRoom.lng;
                                            }
                                            mainTransferList[index].lat = finalLat;
                                            mainTransferList[index].lng = finalLng;

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
                                              if(null == value) {
                                                return;
                                              }
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
                                          }
                                        },
                                        child: Container(
                                          width: screenWidth*(140/360),
                                          height: screenWidth*(140/360),


                                          child:
                                          Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                      boxShadow: [
                                                        new BoxShadow(
                                                          color: Colors.grey.withOpacity(0.5),
                                                          spreadRadius: 0,
                                                          blurRadius: 1,
                                                          offset: Offset(1.5, 1.5),
                                                        ),
                                                      ],
                                                    ),
                                                    width: screenWidth*(140/360),
                                                    height: screenWidth*(88/360),
                                                    child: (mainTransferList[index].imageUrl1=="BasicImage"||mainTransferList[index].imageUrl1==null)
                                                        ?
                                                    ClipRRect(
                                                        borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                        child: Container(color:Color(0xffE7E7E7))
                                                    )
                                                        :

                                                    ClipRRect(
                                                      borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                      child: FittedBox(
                                                        fit: BoxFit.cover,
                                                        child: getExtendedImage(get_resize_image_name(mainTransferList[index].imageUrl1,360), 0,extendedController),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(

                                                    top: screenWidth*(4/360),
                                                    right:screenWidth*(4/360),
                                                    child:    GestureDetector(

                                                      onTap: () async {
                                                        var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                            {
                                                              "userID" : GlobalProfile.loggedInUser.userID,
                                                              "roomSaleID": mainTransferList[index].id,
                                                            }
                                                        ));
                                                        bool sub = !mainTransferList[index].Likes;
                                                        mainTransferList[index].ChangeLikesWithValue(sub);
                                                        getRoomSalesInfoByID(mainTransferList[index].id).ChangeLikesWithValue(sub);
                                                        setState(() {

                                                        });
                                                      },//( mainTransferList[index].Likes == null || !mainTransferList[index].Likes)
                                                      child:  mainTransferList[index].Likes ?
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
                                                      )),)
                                                ],
                                              ),

                                              Container(
                                                width: screenWidth*(140/360),
                                                height:screenWidth*(52/360),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: new BorderRadius.only(bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(4.0)),
                                                  boxShadow: [
                                                    new BoxShadow(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      spreadRadius: 0,
                                                      blurRadius: 1,
                                                      offset: Offset(1.5, 1.5),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(width:screenWidth*(8/360)),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(height:screenWidth*(8/360)),

                                                        Text( mainTransferList[index].jeonse == true? mainTransferList[index].depositFeesOffer.toString()+"만원 / 전세" :  mainTransferList[index].monthlyRentFeesOffer.toString()+"만원 / 월세",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360)),),

                                                        Container(height:screenWidth*(2/360)),
                                                        Text((mainTransferList[index].Condition == 1 ? "신축 건물" : "구축 건물") + " / "+ (mainTransferList[index].Floor == 1 ? "반지하" : mainTransferList[index].Floor == 2 ? "1층" : "2층 이상"),
                                                          style: TextStyle(color:Color(0xff888888),fontSize: screenWidth*(10/360)),),

                                                      ],)
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (22 / 640),
                          ),
                        ],
                      ),
                    ),

                    GestureDetector(
                      onTap: ()async{
                        monthlyNewFst.clear();
                        var tmptt= await ApiProvider().get('/RoomSalesInfo/MonthlyNewFst');
                        if(null != tmptt && false != tmptt){
                            monthlyNewFst .add(ThisMonthNewRoomList.fromJson(tmptt));
                        }

                        monthlyNewScd.clear();
                        var tmptt2= await ApiProvider().get('/RoomSalesInfo/MonthlyNewScd');
                        if(null != tmptt2&& false != tmptt2){
                          monthlyNewScd.add(ThisMonthNewRoomList.fromJson(tmptt2));
                        }

                        monthlyNewTrd.clear();
                        var tmptt3= await ApiProvider().get('/RoomSalesInfo/MonthlyNewTrd');
                        if(null != tmptt3 && false != tmptt3){
                          monthlyNewTrd .add(ThisMonthNewRoomList.fromJson(tmptt3));
                        }

                        Navigator.push(
                            context, // 기본 파라미터, SecondRoute로 전달
                            MaterialPageRoute(
                              builder: (context) =>
                                  newRoomScreen(),
                            ) // SecondRoute를 생성하여 적재
                        );
                        doubleCheck = false;

                      },

                      child:GlobalProfile.banner == null? Container(): Container(width:screenWidth,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: getExtendedImage(GlobalProfile.banner , 0,extendedController),
                          ),),
                    ),
                    SizedBox(
                      height:8,
                    ),

                    Container(
                     color: Colors.white,
                     child: Column(children: [

                       Row(children: [
                         Container(width: screenWidth*(16/360),),
                         Text("솔직한 자취방 후기",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                         Spacer(),
                         FlatButton(
                             onPressed: ()async{
                               final SharedPreferences prefs = await SharedPreferences.getInstance();
                               bool flag = prefs.getBool(forReview);
                               if(flag == null){
                                 Navigator.push(
                                     context, // 기본 파라미터, SecondRoute로 전달
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             TutorialForReview()) // SecondRoute를 생성하여 적재
                                 );
                               }
                               else {
                                 Navigator.push(
                                     context, // 기본 파라미터, SecondRoute로 전달
                                     MaterialPageRoute(
                                         builder: (context) =>
                                             SearchMapForReview()) // SecondRoute를 생성하여 적재
                                 );
                               }

                             },
                             child: Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff6F22D2)),)),


                       ],),
                       SizedBox(
                         height: 4,
                       ),
                       Container(
                         height: screenWidth*(145/360),
                         child: Row(
                           children: [
                             Container(
                               width: screenWidth*(12/360),
                             ),
                             Container(
                               width:screenWidth*(348/360),
                               height: screenWidth*(145/360),
                               color: Colors.transparent,
                               child: ListView.builder(
                                 physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                 primary: true,
                                 shrinkWrap: true,
                                 scrollDirection: Axis.horizontal,
                                 itemCount: GlobalProfile.reviewForMain == null?0 : GlobalProfile.reviewForMain.length,
                                 itemBuilder: (BuildContext context, int index) =>Padding(
                                   padding: index == 0? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 6),
                                   child: InkWell(
                                     onTap: () async {
                                       if(doubleCheck == false) {
                                         doubleCheck = true;
                                         GlobalProfile.detailReviewList
                                             .clear();

                                         double finalLat;
                                         double finalLng;
                                         if (null == GlobalProfile
                                             .reviewForMain[index].lng ||
                                             null == GlobalProfile
                                                 .reviewForMain[index].lat) {
                                           var addresses = await Geocoder
                                               .google(
                                               'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                               .findAddressesFromQuery(
                                               GlobalProfile
                                                   .reviewForMain[index]
                                                   .Location);
                                           var first = addresses.first;

                                           finalLat =
                                               first.coordinates.latitude;
                                           finalLng =
                                               first.coordinates.longitude;
                                         } else {
                                           finalLat = GlobalProfile
                                               .reviewForMain[index].lat;
                                           finalLng = GlobalProfile
                                               .reviewForMain[index].lng;
                                         }
                                         var detailReviewList = await ApiProvider()
                                             .post(
                                             '/Review/ReviewListLngLat',
                                             jsonEncode({
                                               "longitude": finalLng,
                                               "latitude": finalLat,
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


                                         Navigator.push(
                                             context,
                                             MaterialPageRoute(
                                                 builder: (_) =>
                                                     ReviewScreenInMapMainDetail(
                                                         review: GlobalProfile
                                                             .reviewForMain[index])));
                                       }
//                                  await AddRecent(index);
                                       /*  Navigator.push(
                                        context, // 기본 파라미터, SecondRoute로 전달
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailedRoomInformation(
                                                  roomSalesInfo: getRoomSalesInfoByID(int.parse(RecentList[index])),
                                                )) // SecondRoute를 생성하여 적재
                                    );*/
                                     },
                                     child: Container(
                                       width: screenWidth*(175/360),
                                       height: screenWidth*(135/360),


                                       child:
                                       Column(
                                         children: [
                                           Container(
                                             decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                               boxShadow: [
                                                 new BoxShadow(
                                                   color: Colors.grey.withOpacity(0.5),
                                                   spreadRadius: 0,
                                                   blurRadius: 1,
                                                   offset: Offset(1.5, 1.5),
                                                 ),
                                               ],
                                             ),
                                       width: screenWidth*(175/360),
                                         height: screenWidth*(52/360),
                                           child: (GlobalProfile.reviewForMain[index].ImageUrl=="BasicImage"||GlobalProfile.reviewForMain[index].ImageUrl==null)
                                           ?
                                           ClipRRect(
                                             borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                             child: Container(color:Color(0xffE7E7E7))
                                           )
                                           :

                                       ClipRRect(
                                         borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                         child: FittedBox(
                                           fit: BoxFit.cover,
                                           child: getExtendedImage(get_resize_image_name(GlobalProfile.reviewForMain[index].ImageUrl,360), 0,extendedController),
                                         ),
                                       ),
                                       ),

                                           Container(
                                             width: screenWidth*(175/360),
                                             height:  screenWidth*(88/360),
                                             decoration: BoxDecoration(
                                               color: Colors.white,
                                               borderRadius: new BorderRadius.only(bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(4.0)),
                                               boxShadow: [
                                                 new BoxShadow(
                                                   color: Colors.grey.withOpacity(0.5),
                                                   spreadRadius: 0,
                                                   blurRadius: 1,
                                                   offset: Offset(1.5, 1.5),
                                                 ),
                                               ],
                                             ),
                                             child: Row(
                                               children: [
                                                 Container(width:screenWidth*(8/360)),
                                                 Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Container(height:screenWidth*(8/360)),
                                                     SizedBox(

                                                       child: Row(
                                                         children: [
                                                           SvgPicture.asset(
                                                             star,
                                                             width: screenWidth * (19 / 360),
                                                             height:
                                                             screenWidth * (19 / 360),
                                                             color:
                                                            GlobalProfile.reviewForMain[index].StarAvg>= 1
                                                                 ? kPrimaryColor
                                                                 : starColor,
                                                           ),
                                                           SizedBox(
                                                             width: screenWidth * (5 / 360),
                                                           ),
                                                           SvgPicture.asset(
                                                             star,
                                                             width: screenWidth * (19 / 360),
                                                             height:
                                                             screenWidth * (19 / 360),
                                                             color:
                                                                  GlobalProfile.reviewForMain[index].StarAvg>= 2
                                                                 ? kPrimaryColor
                                                                 : starColor,
                                                           ),
                                                           SizedBox(
                                                             width: screenWidth * (5 / 360),
                                                           ),
                                                           SvgPicture.asset(
                                                             star,
                                                             width: screenWidth * (19 / 360),
                                                             height:
                                                             screenWidth * (19 / 360),
                                                             color:
                                                             GlobalProfile.reviewForMain[index].StarAvg>= 3
                                                                 ? kPrimaryColor
                                                                 : starColor,
                                                           ),
                                                           SizedBox(
                                                             width: screenWidth * (5 / 360),
                                                           ),
                                                           SvgPicture.asset(
                                                             star,
                                                             width: screenWidth * (19 / 360),
                                                             height:
                                                             screenWidth * (19 / 360),
                                                             color:
                                                             GlobalProfile.reviewForMain[index].StarAvg>= 4
                                                                 ? kPrimaryColor
                                                                 : starColor,
                                                           ),
                                                           SizedBox(
                                                             width: screenWidth * (5 / 360),
                                                           ),
                                                           SvgPicture.asset(
                                                             star,
                                                             width: screenWidth * (19 / 360),
                                                             height:
                                                             screenWidth * (19 / 360),
                                                             color:
                                                                GlobalProfile.reviewForMain[index].StarAvg>= 5
                                                                 ? kPrimaryColor
                                                                 : starColor,
                                                           ),
                                                           SizedBox(
                                                             width: screenWidth * (5 / 360),
                                                           ),
                                                           Text(
                                                             GlobalProfile.reviewForMain[index].StarAvg.toStringAsFixed(1),
                                                             style: TextStyle(
                                                                 fontSize:
                                                                 screenWidth * (12 / 360),
                                                                 color: kPrimaryColor
                                                                     ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                     Container(height:screenWidth*(2/360)),
                                                     Row(
                                                       children: [
                                                         Text("매물 종류",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(10/360)),),
                                                         Container(width:screenWidth*(12/360)),
                                                         Text(GlobalProfile.reviewForMain[index].Type == 0?"원룸": GlobalProfile.reviewForMain[index].Type == 1?"투룸이상": GlobalProfile.reviewForMain[index].Type == 2?"오피스텔":"아파트",style: TextStyle(color:Color(0xff888888),fontSize: screenWidth*(10/360)),),
                                                       ],
                                                     ),

                                                     Container(height:screenWidth*(2/360)),
                                                     Row(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text("매물 위치",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(10/360)),),
                                                         Container(width:screenWidth*(12/360)),
                                                         Container(
                                                             width:screenWidth*(103/360),
                                                             child: Text(GlobalProfile.reviewForMain[index].Location,
                                                               maxLines: 2,
                                                               overflow: TextOverflow.ellipsis,
                                                               style: TextStyle(color:Color(0xff888888),fontSize: screenWidth*(10/360)),)),
                                                       ],
                                                     ),
                                                     Container(height:screenWidth*(12/360)),
                                                   ],)
                                               ],
                                             ),
                                           )
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                       SizedBox(
                         height: 22,
                       ),
                     ],),
                   ),
                    Container(
                      color: Colors.white,
                      child: Column(children: [

                        Row(children: [
                          Container(width: screenWidth*(16/360),),
                          Text("최근 조회한 매물",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                          Spacer(),
                          // Text("더보기 >",style: TextStyle(fontSize: screenWidth*(12/360),color:Color(0xff6F22D2)),),
                          Container(width: screenWidth*(14/360),),
                        ],),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: screenWidth*(150/360),
                          child: Row(
                            children: [
                              Container(
                                width: screenWidth*(12/360),
                              ),
                              FutureBuilder(
                                  future: init(),
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
                                    else if(RecentListIndex == 0) {
                                      return Container(
                                        height: screenHeight*0.21875,
                                        width: screenWidth*(336/360),
                                        child: Center(
                                          child: Text(
                                            '조회한 매물이 없습니다.',
                                            style: TextStyle(
                                                fontSize: screenHeight*0.025,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                    else {
                                      return Container(
                                        width:screenWidth*(348/360),
                                        height: screenWidth*(150/360),
                                        color: Colors.transparent,
                                        child: ListView.builder(
                                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                          primary: true,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: RecentList == null?0 : RecentList.length,
                                          itemBuilder: (BuildContext context, int index) => getRoomSalesInfoByID(int.parse(RecentList[index])) == null ? SizedBox() :Padding(
                                            padding: index == 0? EdgeInsets.only(left: 0) : EdgeInsets.only(left: 6),
                                            child: getRoomSalesInfoByID(int.parse(RecentList[index])).ShortTerm ? InkWell(
                                              onTap: () async {
                                                await AddRecent(index);
                                                var t = await ApiProvider().post('/RoomSalesInfo/RoomSelectWithLike', jsonEncode(
                                                    {
                                                      "roomID" : getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                                      "userID" : GlobalProfile.loggedInUser.userID
                                                    }
                                                ));

                                                RoomSalesInfo tmp = RoomSalesInfo.fromJson(t);

                                                GlobalProfile.detailReviewList.clear();
                                                if (null ==
                                                    tmp.lng ||
                                                    null == tmp
                                                        .lat) {
                                                  var addresses = await Geocoder.google(
                                                      'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                                      .findAddressesFromQuery(
                                                      tmp
                                                          .location);
                                                  var first = addresses.first;
                                                  tmp.lat = first.coordinates.latitude;
                                                  tmp.lng = first.coordinates.longitude;
                                                }
                                                var detailReviewList = await ApiProvider()
                                                    .post('/Review/ReviewListLngLat',
                                                    jsonEncode({
                                                      "longitude": tmp.lng,
                                                      "latitude": tmp.lat,
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
                                                    tmp.id);
                                                var res = await Navigator.push(
                                                    context, // 기본 파라미터, SecondRoute로 전달
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailedRoomInformation(
                                                              roomSalesInfo: tmp,
                                                              nbnb: tmp.ShortTerm,
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
                                                });
                                              },
                                              child: Container(
                                                width: screenWidth*(140/360),
                                                height: screenWidth*(140/360),


                                                child:
                                                Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                            boxShadow: [
                                                              new BoxShadow(
                                                                color: Colors.grey.withOpacity(0.5),
                                                                spreadRadius: 0,
                                                                blurRadius: 1,
                                                                offset: Offset(1.5, 1.5),
                                                              ),
                                                            ],
                                                          ),
                                                          width: screenWidth*(140/360),
                                                          height: screenWidth*(88/360),
                                                          child: (getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1=="BasicImage"||getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1==null)
                                                              ?
                                                          ClipRRect(
                                                              borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                              child: Container(color:Color(0xffE7E7E7))
                                                          )
                                                              :

                                                          ClipRRect(
                                                            borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: getExtendedImage(get_resize_image_name(getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1,360), 0,extendedController),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(

                                                          top: screenWidth*(4/360),
                                                          right:screenWidth*(4/360),
                                                          child:    GestureDetector(

                                                              onTap: () async {
                                                                var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                                    {
                                                                      "userID" : GlobalProfile.loggedInUser.userID,
                                                                      "roomSaleID":  getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                                                    }
                                                                ));
                                                                bool sub = ! getRoomSalesInfoByID(int.parse(RecentList[index])).Likes;
                                                                getRoomSalesInfoByID(int.parse(RecentList[index])).ChangeLikesWithValue(sub);
                                                                getRoomSalesInfoByID( getRoomSalesInfoByID(int.parse(RecentList[index])).id).ChangeLikesWithValue(sub);
                                                                setState(() {

                                                                });
                                                              },//( mainTransferList[index].Likes == null || !mainTransferList[index].Likes)
                                                              child:   getRoomSalesInfoByID(int.parse(RecentList[index])).Likes ?
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
                                                              )),)
                                                      ],
                                                    ),

                                                    Container(
                                                      width: screenWidth*(140/360),
                                                      height:screenWidth*(52/360),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: new BorderRadius.only(bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(4.0)),
                                                        boxShadow: [
                                                          new BoxShadow(
                                                            color: Colors.grey.withOpacity(0.5),
                                                            spreadRadius: 0,
                                                            blurRadius: 1,
                                                            offset: Offset(1.5, 1.5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(width:screenWidth*(8/360)),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(height:screenWidth*(8/360)),
                                                              Text(getRoomSalesInfoByID(int.parse(RecentList[index])).DailyRentFeesOffer.toString()+"만원 / 일",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360)),),

                                                              Container(height:screenWidth*(2/360)),
                                                              Text((getRoomSalesInfoByID(int.parse(RecentList[index])).tradingState == 1 ? "구축 건물" : "신축 건물") + " / "+ (getRoomSalesInfoByID(int.parse(RecentList[index])).Floor == 1 ? "반지하" : getRoomSalesInfoByID(int.parse(RecentList[index])).Floor == 2 ? "1층" : "2층 이상"),
                                                                style: TextStyle(color:Color(0xff888888),fontSize: screenWidth*(10/360)),),

                                                            ],)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ) :
                                            InkWell(
                                              onTap: () async {
                                                if(doubleCheck  ==false) {
                                                  doubleCheck = true;

                                                  var tmp = await ApiProvider().post('/RoomSalesInfo/RoomSelectWithLike', jsonEncode(
                                                      {
                                                        "roomID" :  getRoomSalesInfoByID(int.parse(RecentList[index])).id,
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
                                                    tmpRoom.lat = finalLat;
                                                    tmpRoom.lng = finalLng;
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
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: screenWidth*(140/360),
                                                height: screenWidth*(140/360),


                                                child:
                                                Column(
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                            boxShadow: [
                                                              new BoxShadow(
                                                                color: Colors.grey.withOpacity(0.5),
                                                                spreadRadius: 0,
                                                                blurRadius: 1,
                                                                offset: Offset(1.5, 1.5),
                                                              ),
                                                            ],
                                                          ),
                                                          width: screenWidth*(140/360),
                                                          height: screenWidth*(88/360),
                                                          child: ( getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1=="BasicImage"|| getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1==null)
                                                              ?
                                                          ClipRRect(
                                                              borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                              child: Container(color:Color(0xffE7E7E7))
                                                          )
                                                              :

                                                          ClipRRect(
                                                            borderRadius: new BorderRadius.only(topRight: Radius.circular(4.0),topLeft: Radius.circular(4.0)),
                                                            child: FittedBox(
                                                              fit: BoxFit.cover,
                                                              child: getExtendedImage(get_resize_image_name( getRoomSalesInfoByID(int.parse(RecentList[index])).imageUrl1,360), 0,extendedController),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(

                                                          top: screenWidth*(4/360),
                                                          right:screenWidth*(4/360),
                                                          child:    GestureDetector(

                                                              onTap: () async {
                                                                var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                                    {
                                                                      "userID" : GlobalProfile.loggedInUser.userID,
                                                                      "roomSaleID":  getRoomSalesInfoByID(int.parse(RecentList[index])).id,
                                                                    }
                                                                ));
                                                                bool sub = ! getRoomSalesInfoByID(int.parse(RecentList[index])).Likes;
                                                                getRoomSalesInfoByID(int.parse(RecentList[index])).ChangeLikesWithValue(sub);
                                                                getRoomSalesInfoByID( getRoomSalesInfoByID(int.parse(RecentList[index])).id).ChangeLikesWithValue(sub);
                                                                setState(() {

                                                                });
                                                              },//( mainTransferList[index].Likes == null || !mainTransferList[index].Likes)
                                                              child:   getRoomSalesInfoByID(int.parse(RecentList[index])).Likes ?
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
                                                              )),)
                                                      ],
                                                    ),

                                                    Container(
                                                      width: screenWidth*(140/360),
                                                      height:screenWidth*(52/360),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: new BorderRadius.only(bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(4.0)),
                                                        boxShadow: [
                                                          new BoxShadow(
                                                            color: Colors.grey.withOpacity(0.5),
                                                            spreadRadius: 0,
                                                            blurRadius: 1,
                                                            offset: Offset(1.5, 1.5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(width:screenWidth*(8/360)),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(height:screenWidth*(8/360)),

                                                              Text(  getRoomSalesInfoByID(int.parse(RecentList[index])).jeonse == true?  getRoomSalesInfoByID(int.parse(RecentList[index])).depositFeesOffer.toString()+"만원 / 전세" :   getRoomSalesInfoByID(int.parse(RecentList[index])).monthlyRentFeesOffer.toString()+"만원 / 월세",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360)),),

                                                              Container(height:screenWidth*(2/360)),
                                                              Text(( getRoomSalesInfoByID(int.parse(RecentList[index])).Condition == 1 ? "신축 건물" : "구축 건물") + " / "+ ( getRoomSalesInfoByID(int.parse(RecentList[index])).Floor == 1 ? "반지하" :  getRoomSalesInfoByID(int.parse(RecentList[index])).Floor == 2 ? "1층" : "2층 이상"),
                                                                style: TextStyle(color:Color(0xff888888),fontSize: screenWidth*(10/360)),),

                                                            ],)
                                                        ],
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
                                  }),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 22,
                        ),
                      ],),
                    ),
                    SizedBox(
                      height: 8,
                    ),

                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

}
