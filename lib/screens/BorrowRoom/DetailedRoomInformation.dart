import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyProposeForBorrow.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/model/RoomListScreenProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/ReportScreen.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/Chat/ChatSendFromRoom.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyRoomItemInfo.dart';
import 'package:mryr/screens/Review/ReviewScreenInMapDetail.dart';
import 'package:mryr/screens/Review/SearchMapForReview.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/AppConfig.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mryr/constants/GlobalAbstractClass.dart';
import 'dart:io';
import 'package:location/location.dart';

class DetailedRoomInformation extends StatefulWidget {
  RoomSalesInfo roomSalesInfo;
  bool isParentChat;
  bool nbnb;

  bool chat;

  DetailedRoomInformation({Key key, this.roomSalesInfo, this.isParentChat, this.nbnb,this.chat}) : super(key : key);

  @override
  _DetailedRoomInformationState createState() => _DetailedRoomInformationState();
}

class _DetailedRoomInformationState extends State<DetailedRoomInformation> with SingleTickerProviderStateMixin{
  Completer<GoogleMapController> _controller = Completer();
  MapType _googleMapType = MapType.normal;
  Set<Marker> _markers = Set();
  BitmapDescriptor markerIcon;
  String addressJSON = '';

  CameraPosition _initialCameraPostion;

  final MicrowaveIcon= 'assets/images/Option/MicrowaveIcon.svg';
  final AirConditionerIcon= 'assets/images/Option/AirConditionerIcon.svg';
  final ElevatorIcon= 'assets/images/Option/ElevatorIcon.svg';
  final WasherIcon= 'assets/images/Option/WasherIcon.svg';
  final WifiIcon= 'assets/images/Option/WifiIcon.svg';
  final cctv = 'assets/images/releaseRoomScreen/cctv.svg';

  final BedIcon = 'assets/images/Option/BedIcon.svg';
  final DeskIcon = 'assets/images/Option/DeskIcon.svg';
  final ChairIcon = 'assets/images/Option/ChairIcon.svg';
  final ClosetIcon = 'assets/images/Option/ClosetIcon.svg';
  final InductionIcon = 'assets/images/Option/InductionIcon.svg';
  final RefrigeratorIcon = 'assets/images/Option/RefrigeratorIcon.svg';
  final DoorLockIcon = 'assets/images/Option/DoorLockIcon.svg';
  final TvIcon = 'assets/images/Option/TvIcon.svg';
  final GreyModify= 'assets/images/public/GreyModify.svg';


  MESSAGE_TYPE message_type;

  bool isMe = false;
  String proposalText = "쪽지 보내기";

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }


  int reviewLen = GlobalProfile.detailReviewList.length;
  AnimationController extendedController;
  @override

  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  String getSexString(int sex){
    String res = "상관 없음";
    if(sex == 0){
      res = "남자선호";
    }else if(sex == 1){
      res = "여자선호";
    }

    return res;
  }

  var starColor = Color(0xffeeeeee);
  String getSmokingString(int smoking){
    String res = "상관 없음";
    if(smoking == 0) {
      res = "X";
    }else if(smoking == 1){
      res = "O";
    }

    return res;
  }
  int currentPage = 0;

  var jan = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var feb = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var mar = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var apr = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var may = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var jun = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var jul = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var aug = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var sep = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var oct = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var nov = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];
  var dec = [
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","",
    "","","","","","","","","","","","",];

  var janReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var febReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var marReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var aprReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var mayReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var junReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var julReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var augReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var sepReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var octReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var novReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];
  var decReserve = [
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,];


  void initState() {

    super.initState();
    doubleCheck = false;
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

    (() async {
      if(widget.roomSalesInfo.userID == GlobalProfile.loggedInUser.userID){
        isMe = true;
      }

   /*   //가입되어있는 방 정보 가져옴
      widget.roomSalesInfo.chatRoomUserList.clear();
      var list = await ApiProvider().post("/ChatRoomUser/SelectByRoomSaleID", jsonEncode(
          {
            "roomSaleID" : widget.roomSalesInfo.id
          }
      ));*/

     /* for(int i = 0 ; i < list.length; ++i){
        widget.roomSalesInfo.chatRoomUserList.add(ChatRoomUser.fromJson(list[i]));
      }*/

   /*   //자기 자신이고 문의한 매물 정보가 있을
      if(isMe && widget.roomSalesInfo.chatRoomUserList.length != 0){
        setState(() {
          proposalText = proposalText + "(" + widget.roomSalesInfo.chatRoomUserList.length.toString() + ")";
        });
      }*/
    })();

    //달력만들기

    //예약된 날짜 받아오기
      for(int i =1 ;i<=12; i++){
        print(DateTime.now().month);
        int oneWeekDay;
        if(DateTime.now().month<=i) {
          oneWeekDay = DateTime(DateTime
              .now()
              .year, i, 1).weekday == 7 ? 0 : DateTime(DateTime
              .now()
              .year, i, 1).weekday;
        }
        else{
          oneWeekDay = DateTime(DateTime
              .now()
              .year+1, i, 1).weekday == 7 ? 0 : DateTime(DateTime
              .now()
              .year+1, i, 1).weekday;
        }
        int endDay;
        if(DateTime.now().month>=i) {
          endDay = DateTime(DateTime
              .now()
              .year, i + 1, 0).day;
        }
        else{
          endDay = DateTime(DateTime
              .now()
              .year+1, i + 1, 0).day;
        }
        switch(i){
          case 1:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              jan[j] = time.toString();
              ++time;
            }
            break;
          case 2:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              feb[j] = time.toString();
              ++time;
            }
            break;
          case 3:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              mar[j] = time.toString();
              ++time;
            }
            break;
          case 4:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              apr[j] = time.toString();
              ++time;
            }
            break;
          case 5:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              may[j] = time.toString();
              ++time;
            }
            break;
          case 6:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              jun[j] = time.toString();
              ++time;
            }
            break;
          case 7:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              jul[j] = time.toString();
              ++time;
            }
            break;
          case 8:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              aug[j] = time.toString();
              ++time;
            }
            break;
          case 9:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              sep[j] = time.toString();
              ++time;
            }
            break;
          case 10:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              oct[j] = time.toString();
              ++time;
            }
            break;
          case 11:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              nov[j] = time.toString();
              ++time;
            }
            break;
          case 12:
            int time = 1;
            for(int j = oneWeekDay; j <oneWeekDay + endDay; j++){
              dec[j] = time.toString();
              ++time;
            }
            break;

        }
      }



      for( int i =0 ;i <GlobalProfile.reserveDateList.length; i++){

        if(GlobalProfile.reserveDateList[i].month ==1){
          for(int j =0 ;j <42;j++){
            if(int.parse(jan[j]==""?"-1":jan[j]) == GlobalProfile.reserveDateList[i].day)
              ++janReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==2){
          for(int j =0 ;j <42;j++){
            if(int.parse(feb[j]==""?"-1":feb[j]) == GlobalProfile.reserveDateList[i].day)
              ++febReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==3){
          for(int j =0 ;j <42;j++){
            if(int.parse(mar[j]==""?"-1":mar[j]) == GlobalProfile.reserveDateList[i].day)
              ++marReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==4){
          for(int j =0 ;j <42;j++){
            if(int.parse(apr[j]==""?"-1":apr[j]) == GlobalProfile.reserveDateList[i].day)
              ++aprReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==5){
          for(int j =0 ;j <42;j++){
            if(int.parse(may[j]==""?"-1":may[j]) == GlobalProfile.reserveDateList[i].day)
              ++mayReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==6){
          for(int j =0 ;j <42;j++){
            if(int.parse(jun[j]==""?"-1":jun[j]) == GlobalProfile.reserveDateList[i].day)
              ++junReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==7){
          for(int j =0 ;j <42;j++){
            if(int.parse(jul[j]==""?"-1":jul[j]) == GlobalProfile.reserveDateList[i].day)
              ++julReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==8){
          for(int j =0 ;j <42;j++){
            if(int.parse(aug[j]==""?"-1":aug[j]) == GlobalProfile.reserveDateList[i].day)
              ++augReserve[j];

          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==9){
          for(int j =0 ;j <42;j++){
            if(int.parse(sep[j]==""?"-1":sep[j]) == GlobalProfile.reserveDateList[i].day)
              ++sepReserve[j];
          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==10){
          for(int j =0 ;j <42;j++){
            if(int.parse(oct[j]==""?"-1":oct[j]) == GlobalProfile.reserveDateList[i].day)
              ++octReserve[j];
          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==11){
          for(int j =0 ;j <42;j++){
            if(int.parse(nov[j]==""?"-1":nov[j]) == GlobalProfile.reserveDateList[i].day)
              ++novReserve[j];
          }
        }
        else if(GlobalProfile.reserveDateList[i].month ==12){
          for(int j =0 ;j<42;j++){
            if(int.parse(dec[j]==""?"-1":dec[j]) == GlobalProfile.reserveDateList[i].day)
              ++decReserve[j];
          }
        }
      }

    mayReserve;
      for(int i =0 ;i<mayReserve.length; i++){
        print(mayReserve[i]);
      }

  }

  PageController _PageController = PageController(
    initialPage: 0,
    viewportFraction: 0.9,
  );

/*

  InfinityPageController _PageController = InfinityPageController(
    initialPage: DateTime.now().month-1,
    viewportFraction: 0.9,
  );
*/
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14.0,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<int> noise =[0,0,0];
    int nm=-1;
    int nmidx = -1;
    List<int> bug =[0,0,0];
    int bm= -1;
    int bmidx = -1;
    List<int> kind =[0,0,0];
    int km = -1;
    int kmidx = -1;




    for(int i =0;i <GlobalProfile.detailReviewList.length;i++){
      ++noise[GlobalProfile.detailReviewList[i].HowNoise];
      ++bug[GlobalProfile.detailReviewList[i].HowBug];
      ++kind[GlobalProfile.detailReviewList[i].HowKind];
    }
    for(int i =0;i<3;i++){
      if(noise[i]>nm){
        nm = noise[i];
        nmidx = i;
      }
      if(bug[i]>bm){
        bm = bug[i];
        bmidx = i;
      }
      if(kind[i]>km){
        km = kind[i];
        kmidx = i;
      }
    }


    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);
    mayReserve;

    DummyProposeForBorrow data1 = Provider.of<DummyProposeForBorrow>(context);
    RoomListScreenProvider data = Provider.of<RoomListScreenProvider>(context);
    //   SocketProvider socket = Provider.of<SocketProvider>(context);

    print(DateTime(DateTime.now().year,1, 1).weekday.toString());

    List<String> ImgList = [];
    if(widget.roomSalesInfo.imageUrl1!="BasicImage") ImgList.add(widget.roomSalesInfo.imageUrl1);
    if(widget.roomSalesInfo.imageUrl2!="BasicImage") ImgList.add(widget.roomSalesInfo.imageUrl2);
    if(widget.roomSalesInfo.imageUrl3!="BasicImage") ImgList.add(widget.roomSalesInfo.imageUrl3);
    if(widget.roomSalesInfo.imageUrl4!="BasicImage") ImgList.add(widget.roomSalesInfo.imageUrl4);
    if(widget.roomSalesInfo.imageUrl5!="BasicImage") ImgList.add(widget.roomSalesInfo.imageUrl5);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    bool FlagForModify = (widget.roomSalesInfo == GlobalProfile.roomSalesInfo);


    _initialCameraPostion = CameraPosition(
      target: LatLng(widget.roomSalesInfo.lat, widget.roomSalesInfo.lng),
      zoom: 18,
    );



    double starA = 0;
    for(int i =0;i< GlobalProfile.detailReviewList.length;i++){
      starA +=int.parse(GlobalProfile.detailReviewList[i].StarRating);
    }



    return WillPopScope(
      onWillPop: (){
        if(widget.isParentChat == true){
          // socket.setRoomStatus(ROOM_STATUS_CHAT);
        }
        Navigator.pop(context,widget.roomSalesInfo.Likes);
        return;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: hexToColor("#FFFFFF"),
            elevation: 0.0,
            leading:
            IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  if(widget.isParentChat == true){
                    // socket.setRoomStatus(ROOM_STATUS_CHAT);
                  }
                  Navigator.pop(context,widget.roomSalesInfo.Likes);
                }),

            /* title: Text('인하대학교',  //검색어 필터
              style: TextStyle(
                color: hexToColor("#222222"),
                fontSize: screenWidth*( 16/360),
                fontWeight: FontWeight.bold,
              ),
            ),*/
            actions: <Widget>[
              GlobalProfile.roomSalesInfoList ==null? SizedBox():
              myRoomCheck(widget.roomSalesInfo.id)?
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                ModifyRoomItemInfo(
                                  roomSalesInfo: widget.roomSalesInfo,
                                )) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: SvgPicture.asset(GreyModify)) : SizedBox(),
              FlagForModify ?SizedBox () : SizedBox(width: screenWidth*0.0333333,),
              widget.roomSalesInfo.Likes == null ? SizedBox():GestureDetector(

                  onTap: () async {
                    var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                        {
                          "userID" : GlobalProfile.loggedInUser.userID,
                          "roomSaleID": widget.roomSalesInfo.id,
                        }
                    ));

                    widget.roomSalesInfo.ChangeLikesWithValue(!widget.roomSalesInfo.Likes);
                    // getRoomSalesInfoByID(mainTransferList[index].id).ChangeLikes();
                    setState(() {

                    });
                  },
                  child:  widget.roomSalesInfo.Likes ?
                  SvgPicture.asset(
                    PurpleFilledHeartDetailedIcon,
                    width: screenHeight * 0.0375,
                    height: screenHeight * 0.0375,
                    color: kPrimaryColor,
                  )
                      : SvgPicture.asset(
                    GreyEmptyHeartDetailedIcon,
                    width: screenHeight * 0.0375,
                    height: screenHeight * 0.0375,
                  )),
              SizedBox(width: screenWidth*0.0333333,),
              GestureDetector(
                onTap: (){
                  BottomSheetForDetailedRoomInformation(context,screenWidth,screenHeight, widget.roomSalesInfo);
                },
                child: SvgPicture.asset(
                  GreyDots,
                  height: screenHeight*0.0375,
                  width: screenHeight*0.0375,
                ),
              ),
              SizedBox(width: screenWidth*0.0277777,)
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight*(300/640),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount:ImgList.length, //추후 이미지 여러개 부분 수정 필요
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Container(
                              width: screenWidth,
                              height: screenHeight,
                              decoration: BoxDecoration(
                                color: hexToColor('#F8F8F8'),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Color.fromRGBO(116, 125, 130, 0.2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child:  ImgList[index]=="BasicImage"
                                  ?
                              SvgPicture.asset(
                                ProfileIconInMoreScreen,
                                width: screenHeight * (60 / 640),
                                height: screenHeight * (60 / 640),
                              )
                                  :

                              FittedBox(
                                fit: BoxFit.cover,
                                child: ClipRRect(
                                    child:    getExtendedImage(ImgList[index], 0,extendedController)
                                ),
                              ),


                            ),
                            Center(
                              child: SvgPicture.asset(
                                RoomWaterMark,
                              ),
                            ),

                          ],
                        ),
                      ),

                      Positioned(
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
                                Text("${ImgList.length}",style: TextStyle(fontSize: screenWidth*(12/360),color: Colors.white),),
                              ],),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.03125,),
                Text(
                  widget.nbnb ==true? widget.roomSalesInfo.DailyRentFeesOffer.toString() + '만원 / 일' :

                  widget.roomSalesInfo.jeonse == true?    widget.roomSalesInfo.depositFeesOffer.toString()+"만원 / 전세" :   widget.roomSalesInfo.monthlyRentFeesOffer.toString()+"만원 / 월세",

                  style: TextStyle(
                    fontSize:screenWidth*( 20/360),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight*(4/640),),
                widget.nbnb ==true?  RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: screenWidth*( 12/360),),
                    children: <TextSpan>[
                      TextSpan(text: '임대가능기간   ', style: TextStyle(fontWeight: FontWeight.bold,)),
                      TextSpan(text: widget.roomSalesInfo.termOfLeaseMin + ' ~ ' + widget.roomSalesInfo.termOfLeaseMax, style: TextStyle(
                        color: hexToColor("#666666"),
                      ),),
                    ],
                  ),
                )  :    Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth*(12/360)),
                  child: Container(
                    width: screenWidth*(330/360),
                    child: Text(
                      widget.roomSalesInfo.information==null?"":widget.roomSalesInfo.information,
                      maxLines: 8,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth*OptionFontSize,
                        color: hexToColor("#888888"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*(16/640),),
                widget.nbnb ?  Row(
                  children: [
                    Spacer(),
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
                            color: hexToColor("#E5E5E5"),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ) : Row(
                  children: [
                    Spacer(),
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
                                  widget.roomSalesInfo.Condition == 1 ? "신축 건물" : "구축 건물",
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

                                widget.roomSalesInfo.Floor == 1 ? "반지하" : widget.roomSalesInfo.Floor == 2 ? "1층" : "2층 이상",
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
                    Spacer(),
                  ],
                ),
                SizedBox(height: screenHeight*0.03125,),
                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),
                ExpansionTile(
                    title: new Text('방 정보',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth*(16 /360),
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.10,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('주소',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Container(
                                height: screenHeight*0.10,
                                width: screenWidth*0.6,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(widget.roomSalesInfo.location + widget.roomSalesInfo.locationDetail,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize:screenWidth*OptionFontSize,
                                    ),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('면적(전용)',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.square.toString()+'평',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text(' 종류',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.type == 0 ? '원룸' : widget.roomSalesInfo.type == 1 ? '투룸 이상' : widget.roomSalesInfo.type == 2 ? '오피스텔' : '아파트',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                      widget.nbnb ==true?Container():Divider(height: 3,color: OptionDivideLineColor,),
                      widget.nbnb ==true?Container(): Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('임대기간',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize:screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text( widget.roomSalesInfo.termOfLeaseMin + ' ~ ' + widget.roomSalesInfo.termOfLeaseMax, style: TextStyle(
                                color: Colors.black,
                                fontSize:screenWidth*OptionFontSize,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),


                widget.nbnb ==true?  Column(children: [

                  Container(
                    color: hexToColor("#F8F8F8"),
                    height: screenHeight*0.0125,
                  ),
                  Container(width:screenWidth, height : screenHeight*(35/640),
                      child: Center(child: Row(children: [SizedBox(width: screenWidth*(12/360),),Text('예약 가능한 날짜',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*(16 /360),
                            color: Colors.black
                        ),
                      ),],),)
                  ),
                  Container(
                    color: hexToColor("#F8F8F8"),
                    height: 3,
                  ),
                  SizedBox(
                    height: screenHeight*(270/640),
                    child: Stack(
                      children: [
                        PageView.builder(
                          pageSnapping: true,
                          controller: _PageController,

                          itemCount: 12,
                          itemBuilder: (context, index) {
                            index = index + DateTime.now().month-1;
                            index = index % 12;
                            return Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.circular(8.0),
                                boxShadow: [
                                  new BoxShadow(
                                    color: Color.fromRGBO(166, 125, 130, 0.5),
                                    blurRadius: 4,
                                  ),],
                              ),
                              child:  ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  child:   Container(
                                    width: screenWidth,
                                    height: screenHeight*(270/640),
                                    child: Column(children: [
                                      SizedBox(height:10),
                                      Container(width: screenWidth,height: screenHeight*(40/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width: screenWidth*(10/360),),
                                          // Icon(Icons.arrow_back_ios, color: Colors.black),
                                          Spacer(),
                                          Text(((DateTime.now().month-1<=index)?DateTime.now().year.toString():(DateTime.now().year+1).toString() )+ "년 " + (index+1).toString()+"월",style: TextStyle(fontSize: screenWidth*(14/360),fontWeight: FontWeight.w500),),
                                          //SizedBox(width: screenWidth*(20/360),),
                                          Spacer(),
                                          // Icon(Icons.arrow_forward_ios, color: Colors.black),
                                          SizedBox(width: screenWidth*(10/360),),
                                        ],
                                      )),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("일",style: TextStyle(color: kPrimaryColor),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("월",))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("화",))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("수",))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("목",))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("금",))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text("토",style: TextStyle(color: kPrimaryColor),))),

                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),
                                      Container(height: 1,width: screenWidth,color:Color(0xfff8f8f8)),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[0]:index == 1?feb[0]:index == 2?mar[0]:index == 3?apr[0]:index == 4?may[0]:index == 5?jun[0]:index == 6?jul[0]:index == 7?aug[0]:index == 8?sep[0]:index == 9?oct[0]:index == 10?nov[0]:index == 11?dec[0]: "error",style:
                                          TextStyle(
                                              color: index == 0?janReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[0] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor
                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[1]:index == 1?feb[1]:index == 2?mar[1]:index == 3?apr[1]:index == 4?may[1]:index == 5?jun[1]:index == 6?jul[1]:index == 7?aug[1]:index == 8?sep[1]:index == 9?oct[1]:index == 10?nov[1]:index == 11?dec[1]: "error",style:
                                          TextStyle(
                                            color: index == 0?janReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[1] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[1] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[1] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[1] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[1] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[1] == 0? Colors.black:Color(0xffeeeeee): Colors.black,
                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[2]:index == 1?feb[2]:index == 2?mar[2]:index == 3?apr[2]:index == 4?may[2]:index == 5?jun[2]:index == 6?jul[2]:index == 7?aug[2]:index == 8?sep[2]:index == 9?oct[2]:index == 10?nov[2]:index == 11?dec[2]: "error",style: TextStyle(
                                            color: index == 0?janReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 2?marReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 6?julReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[2] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[2] == 0? Colors.black:Color(0xffeeeeee):index == 10?novReserve[2] == 0?Colors.black:Color(0xffeeeeee):index == 11?decReserve[2] == 0? Colors.black:Color(0xffeeeeee): Colors.black,),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[3]:index == 1?feb[3]:index == 2?mar[3]:index == 3?apr[3]:index == 4?may[3]:index == 5?jun[3]:index == 6?jul[3]:index == 7?aug[3]:index == 8?sep[3]:index == 9?oct[3]:index == 10?nov[3]:index == 11?dec[3]: "error",style: TextStyle(
                                            color: index == 0?janReserve[3] == 0?Colors.black:Color(0xffeeeeee):index == 1?febReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 2?marReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 6?julReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 8?sepReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 10?novReserve[3] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[3] == 0?Colors.black:Color(0xffeeeeee):Colors.black,),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[4]:index == 1?feb[4]:index == 2?mar[4]:index == 3?apr[4]:index == 4?may[4]:index == 5?jun[4]:index == 6?jul[4]:index == 7?aug[4]:index == 8?sep[4]:index == 9?oct[4]:index == 10?nov[4]:index == 11?dec[4]: "error",style: TextStyle(
                                              color: index == 0?janReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[4] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[4] == 0?Colors.black:Color(0xffeeeeee):index == 4?mayReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 6?julReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 8?sepReserve[4] == 0?Colors.black:Color(0xffeeeeee):index == 9?octReserve[4] == 0? Colors.black:Color(0xffeeeeee):index == 10?novReserve[4] == 0?Colors.black:Color(0xffeeeeee):index == 11?decReserve[4] == 0? Colors.black:Color(0xffeeeeee):Colors.black),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[5]:index == 1?feb[5]:index == 2?mar[5]:index == 3?apr[5]:index == 4?may[5]:index == 5?jun[5]:index == 6?jul[5]:index == 7?aug[5]:index == 8?sep[5]:index == 9?oct[5]:index == 10?nov[5]:index == 11?dec[5]: "error",style: TextStyle(
                                            color: index == 0?janReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[5] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[5] == 0?Colors.black:Color(0xffeeeeee):index == 5?junReserve[5] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[5] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 10?novReserve[5] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[5] == 0? Colors.black:Color(0xffeeeeee): Colors.black,),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[6]:index == 1?feb[6]:index == 2?mar[6]:index == 3?apr[6]:index == 4?may[6]:index == 5?jun[6]:index == 6?jul[6]:index == 7?aug[6]:index == 8?sep[6]:index == 9?oct[6]:index == 10?nov[6]:index == 11?dec[6]: "error",style: TextStyle(
                                            color: index == 0?janReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[6] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[6] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor,),))),
                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),
                                      Container(height: 1,width: screenWidth,color:Color(0xfff8f8f8)),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[7]:index == 1?feb[7]:index == 2?mar[7]:index == 3?apr[7]:index == 4?may[7]:index == 5?jun[7]:index == 6?jul[7]:index == 7?aug[7]:index == 8?sep[7]:index == 9?oct[7]:index == 10?nov[7]:index == 11?dec[7]: "error",style:
                                          TextStyle(
                                              color: index == 0?janReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[7] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor
                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[8]:index == 1?feb[8]:index == 2?mar[8]:index == 3?apr[8]:index == 4?may[8]:index == 5?jun[8]:index == 6?jul[8]:index == 7?aug[8]:index == 8?sep[8]:index == 9?oct[8]:index == 10?nov[8]:index == 11?dec[8]: "error",style:
                                          TextStyle(
                                            color: index == 0?janReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[8] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[8] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[8] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[8] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[8] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[8] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[9]:index == 1?feb[9]:index == 2?mar[9]:index == 3?apr[9]:index == 4?may[9]:index == 5?jun[9]:index == 6?jul[9]:index == 7?aug[9]:index == 8?sep[9]:index == 9?oct[9]:index == 10?nov[9]:index == 11?dec[9]: "error",style: TextStyle(

                                            color: index == 0?janReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[9] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[9] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[9] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[9] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[9] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[9] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[10]:index == 1?feb[10]:index == 2?mar[10]:index == 3?apr[10]:index == 4?may[10]:index == 5?jun[10]:index == 6?jul[10]:index == 7?aug[10]:index == 8?sep[10]:index == 9?oct[10]:index == 10?nov[10]:index == 11?dec[10]: "error",style: TextStyle(
                                            color: index == 0?janReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[10] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[10] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[10] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[10] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[10] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[10] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[11]:index == 1?feb[11]:index == 2?mar[11]:index == 3?apr[11]:index == 4?may[11]:index == 5?jun[11]:index == 6?jul[11]:index == 7?aug[11]:index == 8?sep[11]:index == 9?oct[11]:index == 10?nov[11]:index == 11?dec[11]: "error",style: TextStyle(
                                            color: index == 0?janReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[11] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[11] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[11] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[11] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[11] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[11] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[12]:index == 1?feb[12]:index == 2?mar[12]:index == 3?apr[12]:index == 4?may[12]:index == 5?jun[12]:index == 6?jul[12]:index == 7?aug[12]:index == 8?sep[12]:index == 9?oct[12]:index == 10?nov[12]:index == 11?dec[12]: "error",style: TextStyle(
                                            color: index == 0?janReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[12] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[12] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[12] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[12] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[12] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[12] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[13]:index == 1?feb[13]:index == 2?mar[13]:index == 3?apr[13]:index == 4?may[13]:index == 5?jun[13]:index == 6?jul[13]:index == 7?aug[13]:index == 8?sep[13]:index == 9?oct[13]:index == 10?nov[13]:index == 11?dec[13]: "error",style: TextStyle(
                                              color: index == 0?janReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[13] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),

                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),
                                      Container(height: 1,width: screenWidth,color:Color(0xfff8f8f8)),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[14]:index == 1?feb[14]:index == 2?mar[14]:index == 3?apr[14]:index == 4?may[14]:index == 5?jun[14]:index == 6?jul[14]:index == 7?aug[14]:index == 8?sep[14]:index == 9?oct[14]:index == 10?nov[14]:index == 11?dec[14]: "error",style: TextStyle(
                                              color: index == 0?janReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[14] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[15]:index == 1?feb[15]:index == 2?mar[15]:index == 3?apr[15]:index == 4?may[15]:index == 5?jun[15]:index == 6?jul[15]:index == 7?aug[15]:index == 8?sep[15]:index == 9?oct[15]:index == 10?nov[15]:index == 11?dec[15]: "error",style: TextStyle(
                                            color: index == 0?janReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[15] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[15] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[15] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[15] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[15] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[15] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[16]:index == 1?feb[16]:index == 2?mar[16]:index == 3?apr[16]:index == 4?may[16]:index == 5?jun[16]:index == 6?jul[16]:index == 7?aug[16]:index == 8?sep[16]:index == 9?oct[16]:index == 10?nov[16]:index == 11?dec[16]: "error",style: TextStyle(
                                            color: index == 0?janReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[16] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[16] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[16] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[16] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[16] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[16] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[17]:index == 1?feb[17]:index == 2?mar[17]:index == 3?apr[17]:index == 4?may[17]:index == 5?jun[17]:index == 6?jul[17]:index == 7?aug[17]:index == 8?sep[17]:index == 9?oct[17]:index == 10?nov[17]:index == 11?dec[17]: "error",style: TextStyle(
                                            color: index == 0?janReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[17] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[17] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[17] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[17] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[17] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[17] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[18]:index == 1?feb[18]:index == 2?mar[18]:index == 3?apr[18]:index == 4?may[18]:index == 5?jun[18]:index == 6?jul[18]:index == 7?aug[18]:index == 8?sep[18]:index == 9?oct[18]:index == 10?nov[18]:index == 11?dec[18]: "error",style: TextStyle(
                                            color: index == 0?janReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[18] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[18] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[18] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[18] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[18] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[18] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[19]:index == 1?feb[19]:index == 2?mar[19]:index == 3?apr[19]:index == 4?may[19]:index == 5?jun[19]:index == 6?jul[19]:index == 7?aug[19]:index == 8?sep[19]:index == 9?oct[19]:index == 10?nov[19]:index == 11?dec[19]: "error",style: TextStyle(
                                            color: index == 0?janReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[19] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[19] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[19] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[19] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[19] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[19] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[20]:index == 1?feb[20]:index == 2?mar[20]:index == 3?apr[20]:index == 4?may[20]:index == 5?jun[20]:index == 6?jul[20]:index == 7?aug[20]:index == 8?sep[20]:index == 9?oct[20]:index == 10?nov[20]:index == 11?dec[20]: "error",style: TextStyle(
                                              color: index == 0?janReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[20] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),

                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),
                                      Container(height: 1,width: screenWidth,color:Color(0xfff8f8f8)),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[21]:index == 1?feb[21]:index == 2?mar[21]:index == 3?apr[21]:index == 4?may[21]:index == 5?jun[21]:index == 6?jul[21]:index == 7?aug[21]:index == 8?sep[21]:index == 9?oct[21]:index == 10?nov[21]:index == 11?dec[21]: "error",style: TextStyle(
                                              color: index == 0?janReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[21] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[22]:index == 1?feb[22]:index == 2?mar[22]:index == 3?apr[22]:index == 4?may[22]:index == 5?jun[22]:index == 6?jul[22]:index == 7?aug[22]:index == 8?sep[22]:index == 9?oct[22]:index == 10?nov[22]:index == 11?dec[22]: "error",style: TextStyle(
                                            color: index == 0?janReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[22] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[22] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[22] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[22] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[22] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[22] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[23]:index == 1?feb[23]:index == 2?mar[23]:index == 3?apr[23]:index == 4?may[23]:index == 5?jun[23]:index == 6?jul[23]:index == 7?aug[23]:index == 8?sep[23]:index == 9?oct[23]:index == 10?nov[23]:index == 11?dec[23]: "error",style: TextStyle(
                                            color: index == 0?janReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[23] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[23] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[23] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[23] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[23] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[23] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[24]:index == 1?feb[24]:index == 2?mar[24]:index == 3?apr[24]:index == 4?may[24]:index == 5?jun[24]:index == 6?jul[24]:index == 7?aug[24]:index == 8?sep[24]:index == 9?oct[24]:index == 10?nov[24]:index == 11?dec[24]: "error",style: TextStyle(
                                            color: index == 0?janReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[24] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[24] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[24] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[24] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[24] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[24] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[25]:index == 1?feb[25]:index == 2?mar[25]:index == 3?apr[25]:index == 4?may[25]:index == 5?jun[25]:index == 6?jul[25]:index == 7?aug[25]:index == 8?sep[25]:index == 9?oct[25]:index == 10?nov[25]:index == 11?dec[25]: "error",style: TextStyle(
                                            color: index == 0?janReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[25] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[25] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[25] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[25] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[25] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[25] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[26]:index == 1?feb[26]:index == 2?mar[26]:index == 3?apr[26]:index == 4?may[26]:index == 5?jun[26]:index == 6?jul[26]:index == 7?aug[26]:index == 8?sep[26]:index == 9?oct[26]:index == 10?nov[26]:index == 11?dec[26]: "error",style: TextStyle(
                                            color: index == 0?janReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[26] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[26] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[26] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[26] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[26] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[26] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[27]:index == 1?feb[27]:index == 2?mar[27]:index == 3?apr[27]:index == 4?may[27]:index == 5?jun[27]:index == 6?jul[27]:index == 7?aug[27]:index == 8?sep[27]:index == 9?oct[27]:index == 10?nov[27]:index == 11?dec[27]: "error",style: TextStyle(
                                              color: index == 0?janReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[27] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),

                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),
                                      Container(height: 1,width: screenWidth,color:Color(0xfff8f8f8)),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[28]:index == 1?feb[28]:index == 2?mar[28]:index == 3?apr[28]:index == 4?may[28]:index == 5?jun[28]:index == 6?jul[28]:index == 7?aug[28]:index == 8?sep[28]:index == 9?oct[28]:index == 10?nov[28]:index == 11?dec[28]: "error",style: TextStyle(
                                              color: index == 0?janReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[28] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[29]:index == 1?feb[29]:index == 2?mar[29]:index == 3?apr[29]:index == 4?may[29]:index == 5?jun[29]:index == 6?jul[29]:index == 7?aug[29]:index == 8?sep[29]:index == 9?oct[29]:index == 10?nov[29]:index == 11?dec[29]: "error",style: TextStyle(
                                            color: index == 0?janReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[29] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[29] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[29] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[29] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[29] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[29] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[30]:index == 1?feb[30]:index == 2?mar[30]:index == 3?apr[30]:index == 4?may[30]:index == 5?jun[30]:index == 6?jul[30]:index == 7?aug[30]:index == 8?sep[30]:index == 9?oct[30]:index == 10?nov[30]:index == 11?dec[30]: "error",style: TextStyle(
                                            color: index == 0?janReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[30] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[30] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[30] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[30] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[30] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[30] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[31]:index == 1?feb[31]:index == 2?mar[31]:index == 3?apr[31]:index == 4?may[31]:index == 5?jun[31]:index == 6?jul[31]:index == 7?aug[31]:index == 8?sep[31]:index == 9?oct[31]:index == 10?nov[31]:index == 11?dec[31]: "error",style: TextStyle(
                                            color: index == 0?janReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[31] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[31] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[31] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[31] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[31] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[31] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[32]:index == 1?feb[32]:index == 2?mar[32]:index == 3?apr[32]:index == 4?may[32]:index == 5?jun[32]:index == 6?jul[32]:index == 7?aug[32]:index == 8?sep[32]:index == 9?oct[32]:index == 10?nov[32]:index == 11?dec[32]: "error",style: TextStyle(
                                            color: index == 0?janReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[32] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[32] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[32] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[32] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[32] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[32] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[33]:index == 1?feb[33]:index == 2?mar[33]:index == 3?apr[33]:index == 4?may[33]:index == 5?jun[33]:index == 6?jul[33]:index == 7?aug[33]:index == 8?sep[33]:index == 9?oct[33]:index == 10?nov[33]:index == 11?dec[33]: "error",style: TextStyle(
                                            color: index == 0?janReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[33] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[33] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[33] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[33] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[33] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[33] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[34]:index == 1?feb[34]:index == 2?mar[34]:index == 3?apr[34]:index == 4?may[34]:index == 5?jun[34]:index == 6?jul[34]:index == 7?aug[34]:index == 8?sep[34]:index == 9?oct[34]:index == 10?nov[34]:index == 11?dec[34]: "error",style: TextStyle(
                                              color: index == 0?janReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[34] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),

                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),
                                      Container(height: 1,width: screenWidth,color:Color(0xfff8f8f8)),
                                      Container(width: screenWidth,height: screenHeight*(30/640),child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          SizedBox(width:screenWidth*(10/360)),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[35]:index == 1?feb[35]:index == 2?mar[35]:index == 3?apr[35]:index == 4?may[35]:index == 5?jun[35]:index == 6?jul[35]:index == 7?aug[35]:index == 8?sep[35]:index == 9?oct[35]:index == 10?nov[35]:index == 11?dec[35]: "error",style: TextStyle(
                                              color: index == 0?janReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[35] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[36]:index == 1?feb[36]:index == 2?mar[36]:index == 3?apr[36]:index == 4?may[36]:index == 5?jun[36]:index == 6?jul[36]:index == 7?aug[36]:index == 8?sep[36]:index == 9?oct[36]:index == 10?nov[36]:index == 11?dec[36]: "error",style: TextStyle(
                                            color: index == 0?janReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[36] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[36] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[36] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[36] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[36] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[36] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[37]:index == 1?feb[37]:index == 2?mar[37]:index == 3?apr[37]:index == 4?may[37]:index == 5?jun[37]:index == 6?jul[37]:index == 7?aug[37]:index == 8?sep[37]:index == 9?oct[37]:index == 10?nov[37]:index == 11?dec[37]: "error",style: TextStyle(
                                            color: index == 0?janReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[37] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[37] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[37] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[37] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[37] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[37] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[38]:index == 1?feb[38]:index == 2?mar[38]:index == 3?apr[38]:index == 4?may[38]:index == 5?jun[38]:index == 6?jul[38]:index == 7?aug[38]:index == 8?sep[38]:index == 9?oct[38]:index == 10?nov[38]:index == 11?dec[38]: "error",style: TextStyle(
                                            color: index == 0?janReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[38] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[38] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[38] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[38] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[38] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[38] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[39]:index == 1?feb[39]:index == 2?mar[39]:index == 3?apr[39]:index == 4?may[39]:index == 5?jun[39]:index == 6?jul[39]:index == 7?aug[39]:index == 8?sep[39]:index == 9?oct[39]:index == 10?nov[39]:index == 11?dec[39]: "error",style: TextStyle(
                                            color: index == 0?janReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[39] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[39] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[39] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[39] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[39] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[39] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[40]:index == 1?feb[40]:index == 2?mar[40]:index == 3?apr[40]:index == 4?may[40]:index == 5?jun[40]:index == 6?jul[40]:index == 7?aug[40]:index == 8?sep[40]:index == 9?oct[40]:index == 10?nov[40]:index == 11?dec[40]: "error",style: TextStyle(
                                            color: index == 0?janReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 1?febReserve[40] == 0?Colors.black:Color(0xffeeeeee):index == 2?marReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 3?aprReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 4?mayReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 5?junReserve[40] == 0?Colors.black:Color(0xffeeeeee):index == 6?julReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 7?augReserve[40] == 0?Colors.black:Color(0xffeeeeee):index == 8?sepReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 9?octReserve[40] == 0?Colors.black:Color(0xffeeeeee):index == 10?novReserve[40] == 0? Colors.black:Color(0xffeeeeee):index == 11?decReserve[40] == 0? Colors.black:Color(0xffeeeeee): Colors.black,

                                          ),))),
                                          Spacer(),
                                          Container(width:screenWidth*(18/360), child: Center(child: Text(index == 0?jan[41]:index == 1?feb[41]:index == 2?mar[41]:index == 3?apr[41]:index == 4?may[41]:index == 5?jun[41]:index == 6?jul[41]:index == 7?aug[41]:index == 8?sep[41]:index == 9?oct[41]:index == 10?nov[41]:index == 11?dec[41]: "error",style: TextStyle(
                                              color: index == 0?janReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 1?febReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 2?marReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 3?aprReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 4?mayReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 5?junReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 6?julReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 7?augReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 8?sepReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 9?octReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 10?novReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee):index == 11?decReserve[41] == 0? kPrimaryColor:Color(0xffeeeeee): kPrimaryColor

                                          ),))),

                                          SizedBox(width:screenWidth*(10/360)),
                                        ],
                                      )),

                                    ],),
                                  )

                              ),);
                          },
                        ),
                      ],
                    ),
                  ),

                ],) :
               Container(),

                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),
                widget.nbnb ==true?Container(): ExpansionTile(
                    title: new Text('기본 정보',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth*(16 /360),
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: OptionDivideLineColor,),
                      widget.roomSalesInfo.jeonse == true?Container(): Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('기존 월세',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.monthlyRentFees.toString()+'만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                      widget.roomSalesInfo.jeonse == true?Container(): Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text(
                                  widget.roomSalesInfo.jeonse == false?"기존 보증금": '기존 전세',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.depositFees.toString()+'만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('평균 공과금',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.utilityFees.toString()+'만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
                widget.nbnb ==true?Container():Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),

                widget.nbnb ==true?Container():ExpansionTile(
                    title: new Text('양도 가격 정보',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:screenWidth*( 16/360),
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: OptionDivideLineColor,),
                      widget.roomSalesInfo.jeonse == false?  Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('월세',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.monthlyRentFeesOffer.toString() + '만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ):Container(),
                      widget.roomSalesInfo.jeonse == false? Divider(height: 3,color: OptionDivideLineColor,) : Container(),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text(  widget.roomSalesInfo.jeonse == false?'보증금' : "전세",
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth * OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.depositFeesOffer.toString() + '만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ]
                ),
                widget.nbnb ==true? ExpansionTile(
                    title: new Text('가격 정보',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:screenWidth*( 16/360),
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('일 단위',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.DailyRentFeesOffer.toString() + '만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('주 단위',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth * OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.WeeklyRentFeesOffer.toString() + '만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth*OptionFontSize,
                                ),),
                              Text(" (청소비 별도)",
                                style: TextStyle(
                                  color: hexToColor('#888888'),
                                  fontSize: screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        height: screenHeight*0.05,
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0444444),
                          child: Row(
                            children: [
                              SizedBox(
                                width: screenWidth*0.24444,
                                child: Text('월 단위',
                                  style: TextStyle(
                                    color: hexToColor("#888888"),
                                    fontSize: screenWidth*OptionFontSize,
                                  ),),
                              ),
                              Text(widget.roomSalesInfo.monthlyRentFeesOffer.toString() + '만원',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: screenWidth*OptionFontSize,
                                ),),
                              Text(" (청소비 별도)",
                                style: TextStyle(
                                  color: hexToColor('#888888'),
                                  fontSize: screenWidth*OptionFontSize,
                                ),),
                            ],
                          ),
                        ),
                      ),
                    ]
                ):Container(),
                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),
                ExpansionTile(
                    title: new Text('옵션 정보',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight*0.025,
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: hexToColor("#F8F8F8"),),
                      SizedBox(
                        height: screenHeight*(326/640),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*(24/360)),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    BedIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.bed ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '침대',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.bed ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    WifiIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.wifi ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '와이파이',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.wifi ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    MicrowaveIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.microwave ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '전자레인지',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.microwave ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),

                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    DeskIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.desk ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '책상',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.desk ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    InductionIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.induction ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '인덕션',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.induction ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    WasherIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.washingMachine ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '세탁기',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.washingMachine ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    ChairIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.chair ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '의자',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.chair ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    RefrigeratorIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.refrigerator ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '냉장고',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.refrigerator ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    cctv,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.hallwayCCTV ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '복도 CCTV',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.hallwayCCTV ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),

                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    ClosetIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.closet ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '옷장',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.closet ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    DoorLockIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.doorLock ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '도어락',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.doorLock ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    ParkingIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.parking ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '주차 가능',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.parking ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  SvgPicture.asset(
                                    AirConditionerIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.aircon ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    '에어컨',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.aircon ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.046875,),
                                  SvgPicture.asset(
                                    TvIcon,
                                    height: screenWidth*(48/360),
                                    width: screenWidth*(48/360),
                                    color: widget.roomSalesInfo.tv ? kPrimaryColor : AllOptionIconColor,
                                  ),
                                  heightPadding(screenHeight, 6),
                                  Text(
                                    'TV',
                                    style: TextStyle(
                                      fontSize: screenWidth*OptionIconFontSize,
                                      color: widget.roomSalesInfo.tv ? kPrimaryColor : AllOptionIconColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ]
                ),
                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),
                ExpansionTile(
                    title: new Text('방 상세 설명',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight*0.025,
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Container(
                        width: screenWidth,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0333333, vertical: screenHeight*0.0125),
                          child: Text(
                            widget.roomSalesInfo.information,
                            style: TextStyle(
                                fontSize: screenHeight*0.01875,
                                color: Colors.black
                            ),
                          ),
                        ),
                      )
                    ]
                ),
                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),
                ExpansionTile(
                    title: new Text('방 위치',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight*0.025,
                          color: Colors.black
                      ),
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      Divider(height: 3,color: OptionDivideLineColor,),
                      Column(
                        children: [
                          Container(
                            width: screenWidth,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.0333333, vertical: screenHeight*0.0125),
                              child: Text(
                                widget.roomSalesInfo.location,
                                style: TextStyle(
                                    fontSize: screenHeight*0.01875,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: screenHeight*(200/640),
                            width: screenWidth,
                            child: GoogleMap(
                              mapType: _googleMapType,
                              initialCameraPosition: _initialCameraPostion,
                              onMapCreated: (GoogleMapController controller) async {
                                _controller.complete(controller);
                                //(Platform.isIOS)
                                markerIcon = (Platform.isIOS) ?
                                await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 50,
                                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                                    'assets/images/logo/currentMarker.png') :
                                await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 50,
                                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                                    'assets/images/logo/AndcurrentMarker.png');

                                setState(() {
                                  _markers.add(
                                    Marker(
                                        markerId: MarkerId('currentPosition'),
                                        position: LatLng(widget.roomSalesInfo.lat, widget.roomSalesInfo.lng),
                                        // infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?'),
                                        icon: markerIcon,
                                        onTap: () async {

                                        }
                                    ),
                                  );
                                });

                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              markers: _markers,
                            ),
                          )
                        ],
                      )
                    ]
                ),
                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight*0.0125,
                ),
                ExpansionTile(
                    title: Row(
                      children: [
                        new Text("이용 후기(" + "$reviewLen" + ")",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenHeight*0.025,
                              color: Colors.black
                          ),
                        ),
                        GlobalProfile.detailReviewList.length>=1?
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * (185 / 360),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * (8 / 360),
                                  ),
                                  SvgPicture.asset(
                                    star,
                                    width: screenWidth * (19 / 360),
                                    height:
                                    screenWidth * (19 / 360),
                                    color:starA/GlobalProfile.detailReviewList.length >=1
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
                                    color: starA/GlobalProfile.detailReviewList.length >=2
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
                                    color: starA/GlobalProfile.detailReviewList.length >=3
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
                                    color:starA/GlobalProfile.detailReviewList.length >=4
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
                                    color:starA/GlobalProfile.detailReviewList.length >=5
                                        ? kPrimaryColor
                                        : starColor,
                                  ),
                                  SizedBox(
                                    width: screenWidth * (5 / 360),
                                  ),
                                  Text(
                                    (  (starA/GlobalProfile.detailReviewList.length).toStringAsFixed(1))+"점",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                        screenWidth * (10 / 360),
                                        color: starA/GlobalProfile.detailReviewList.length >=1? kPrimaryColor
                                            : Color(0xffeeeeee)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ):Container(),
                      ],
                    ),
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    children: <Widget>[
                      GlobalProfile.detailReviewList.length>=1?Column(children: [    Divider(height: 3,color: OptionDivideLineColor,),

                        SizedBox(
                          height: screenHeight * (12 / 640),
                        ),
                        Row(
                          children: [
                            SizedBox(width: screenWidth * (16 / 360),),
                            Container(
                                height: screenHeight * (21 / 640),
                                width: screenWidth * (159 / 360),
                                child: Text(
                                  "집 주변이 시끄러웠나요?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                height: screenHeight * (21 / 640),
                                width:  screenWidth*(124/360),
                                child: Text(
                                  nmidx ==0 ? "조용했어요":nmidx==1?"보통이었어요":"시끄러웠어요",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360)),
                                )),
                            Container(
                              height: screenHeight * (21 / 640),
                              width: screenWidth * (60/ 360),
                              child: Padding(
                                padding: const EdgeInsets.only(top : 3.0),
                                child: Text(
                                  nm/GlobalProfile.detailReviewList.length*100 == 100? "100%": (nm/GlobalProfile.detailReviewList.length*100).toStringAsFixed(1) + "%",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * (12 / 640),
                        ),
                        Row(
                          children: [ SizedBox(width: screenWidth * (16 / 360),),
                            Container(
                                height: screenHeight * (21 / 640),
                                width: screenWidth * (159 / 360),
                                child: Text(
                                  "집에 벌레가 있었나요?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                height: screenHeight * (21 / 640),
                                width:  screenWidth*(124/360),
                                child: Text(
                                  bmidx ==0 ? "벌레가 없었어요":bmidx==1?"보통이었어요":"벌레가 많이 나왔어요",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360)),
                                )),
                            Container(
                              height: screenHeight * (21 / 640),
                              width: screenWidth * (60/ 360),
                              child: Padding(
                                padding: const EdgeInsets.only(top : 3.0),
                                child: Text(
                                  bm/GlobalProfile.detailReviewList.length*100 == 100? "100%":(bm/GlobalProfile.detailReviewList.length*100).toStringAsFixed(1) + "%",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * (12 / 640),
                        ),
                        Row(
                          children: [ SizedBox(width: screenWidth * (16 / 360),),
                            Container(
                                height: screenHeight * (21 / 640),
                                width: screenWidth * (159 / 360),
                                child: Text(
                                  "집주인이 친절했나요?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                height: screenHeight * (21 / 640),
                                width:  screenWidth*(124/360),
                                child: Text(
                                  kmidx ==0 ? "친절했어요":kmidx==1?"보통이었어요":"불친절했어요",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360)),
                                )),
                            Container(
                              height: screenHeight * (21 / 640),
                              width: screenWidth * (60/ 360),
                              child: Padding(
                                padding: const EdgeInsets.only(top : 3.0),
                                child: Text(
                                  km/GlobalProfile.detailReviewList.length*100 == 100? "100%":(km/GlobalProfile.detailReviewList.length*100).toStringAsFixed(1) + "%",

                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontSize: screenWidth * (14 / 360),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),

                        SizedBox(
                          height: screenHeight * (12 / 640),
                        ),
                        Divider(height: 3,color: OptionDivideLineColor,),
                        ListView.builder(
                          // controller: _scrollController,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount:GlobalProfile.detailReviewList.length >3?3:GlobalProfile.detailReviewList.length ,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * (12 / 360),
                                      ),
                                      Container(
                                        width: screenWidth * (336 / 360),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: screenHeight*(12/640)),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GlobalProfile.detailReviewList[index].user.ImgUrl ==
                                                    "BasicImage"
                                                    ? SvgPicture.asset(
                                                  ProfileIconInMoreScreen,
                                                  width: screenHeight * (36 / 640),
                                                  height: screenHeight * (36 / 640),
                                                )
                                                    : Container(

                                                  width: screenHeight * (36 / 640),
                                                  height: screenHeight * (36 / 640),
                                                  child: FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: getExtendedImage(
                                                        get_resize_image_name(
                                                            GlobalProfile.detailReviewList[index].user.ImgUrl ,
                                                            120),
                                                        0,
                                                        extendedController),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (4 / 360),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      GlobalProfile.detailReviewList[index].user.Nickname,
                                                      style: TextStyle(
                                                          fontSize: screenWidth *
                                                              (14 / 360),
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: screenHeight *
                                                          (1 / 360),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      children: [
                                                        SvgPicture.asset(
                                                          star,
                                                          width: screenWidth *
                                                              (12 / 360),
                                                          height: screenWidth *
                                                              (12 / 360),
                                                          color:  int.parse(GlobalProfile.detailReviewList[index].StarRating) >=1
                                                              ? kPrimaryColor
                                                              : starColor,
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (5 / 360),
                                                        ),
                                                        SvgPicture.asset(
                                                          star,
                                                          width: screenWidth *
                                                              (12 / 360),
                                                          height: screenWidth *
                                                              (12 / 360),
                                                          color:  int.parse(GlobalProfile.detailReviewList[index].StarRating) >=2
                                                              ? kPrimaryColor
                                                              : starColor,
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (5 / 360),
                                                        ),
                                                        SvgPicture.asset(
                                                          star,
                                                          width: screenWidth *
                                                              (12 / 360),
                                                          height: screenWidth *
                                                              (12 / 360),
                                                          color:  int.parse(GlobalProfile.detailReviewList[index].StarRating) >=3
                                                              ? kPrimaryColor
                                                              : starColor,
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (5 / 360),
                                                        ),
                                                        SvgPicture.asset(
                                                          star,
                                                          width: screenWidth *
                                                              (12 / 360),
                                                          height: screenWidth *
                                                              (12 / 360),
                                                          color:  int.parse(GlobalProfile.detailReviewList[index].StarRating) >=4
                                                              ? kPrimaryColor
                                                              : starColor,
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (5 / 360),
                                                        ),
                                                        SvgPicture.asset(
                                                          star,
                                                          width: screenWidth *
                                                              (12 / 360),
                                                          height: screenWidth *
                                                              (12 / 360),
                                                          color:  int.parse(GlobalProfile.detailReviewList[index].StarRating) >=5
                                                              ? kPrimaryColor
                                                              : starColor,
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (5 / 360),
                                                        ),
                                                        Text(
                                                          timeCheck(GlobalProfile.detailReviewList[index].updatedAt),
                                                          style: TextStyle(
                                                              fontSize:
                                                              screenWidth *
                                                                  (10 / 360),
                                                              color: Color(
                                                                  0xff888888)),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Spacer(),
                                                GlobalProfile.detailReviewList[index].startdate != null && GlobalProfile.detailReviewList[index].enddate != null? Container(
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
                                                        GlobalProfile.detailReviewList[index].startdate+" ~ "+ GlobalProfile.detailReviewList[index].enddate + " 이용",
                                                        style: TextStyle(
                                                            fontSize:
                                                            screenWidth*(10/360),
                                                            color: kPrimaryColor,
                                                            fontWeight: FontWeight.w500
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    new BorderRadius.circular(4.0),
                                                    color: hexToColor("#E5E5E5"),
                                                  ),
                                                ):Container(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: screenHeight * (12 / 640),
                                            ),
                                            (GlobalProfile.detailReviewList[index].ImageUrl1 ==null ||  GlobalProfile.detailReviewList[index].ImageUrl1 =="" ||GlobalProfile.detailReviewList[index].ImageUrl1 =="BasicImage")? Container(): SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width:
                                                    screenWidth * (100 / 360),
                                                    height:
                                                    screenWidth * (83 / 360),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                        child:  GlobalProfile.detailReviewList[index].ImageUrl1 ==
                                                            "BasicImage"
                                                            ? Container()
                                                            : FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: getExtendedImage(
                                                              get_resize_image_name(GlobalProfile.detailReviewList[index].ImageUrl1,360),
                                                              0,
                                                              extendedController),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    screenWidth * (4 / 360),
                                                  ),
                                                  Container(
                                                    width:
                                                    screenWidth * (100 / 360),
                                                    height:
                                                    screenWidth * (83 / 360),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                        child:  GlobalProfile.detailReviewList[index].ImageUrl2 ==
                                                            "BasicImage"
                                                            ? Container()
                                                            : FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: getExtendedImage(
                                                              get_resize_image_name(
                                                                  GlobalProfile.detailReviewList[index].ImageUrl2,
                                                                  360),
                                                              0,
                                                              extendedController),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    screenWidth * (4 / 360),
                                                  ),
                                                  Container(
                                                    width:
                                                    screenWidth * (100 / 360),
                                                    height:
                                                    screenWidth * (83 / 360),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                        child:  GlobalProfile.detailReviewList[index].ImageUrl3 ==
                                                            "BasicImage"
                                                            ? Container()
                                                            : FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: getExtendedImage(
                                                              get_resize_image_name(
                                                                  GlobalProfile.detailReviewList[index].ImageUrl3,
                                                                  360),
                                                              0,
                                                              extendedController),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    screenWidth * (4 / 360),
                                                  ),
                                                  Container(
                                                    width:
                                                    screenWidth * (100 / 360),
                                                    height:
                                                    screenWidth * (83 / 360),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                        child:  GlobalProfile.detailReviewList[index].ImageUrl4 ==
                                                            "BasicImage"
                                                            ? Container()
                                                            : FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: getExtendedImage(
                                                              get_resize_image_name(
                                                                  GlobalProfile.detailReviewList[index].ImageUrl4,
                                                                  360),
                                                              0,
                                                              extendedController),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    screenWidth * (4 / 360),

                                                  ),
                                                  Container(
                                                    width:
                                                    screenWidth * (100 / 360),
                                                    height:
                                                    screenWidth * (83 / 360),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                        child:  GlobalProfile.detailReviewList[index].ImageUrl5 ==
                                                            "BasicImage"
                                                            ? Container()
                                                            : FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: getExtendedImage(
                                                              get_resize_image_name(
                                                                  GlobalProfile.detailReviewList[index].ImageUrl5,
                                                                  360),
                                                              0,
                                                              extendedController),
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                    screenWidth * (4 / 360),

                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight * (12 / 640),
                                            ),
                                            Container(
                                              width: screenWidth * (334 / 360),
                                              child: Text(
                                                GlobalProfile.detailReviewList[index].InformationDetail,
                                                style: TextStyle(
                                                    fontSize:
                                                    screenWidth * (12 / 360)),
                                              ),
                                            ),

                                            SizedBox(
                                              height: screenHeight * (16 / 640),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  (GlobalProfile.detailReviewList.length >3  ?3== index+1:GlobalProfile.detailReviewList.length == index+1  ) ?
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * (8 / 640),
                                      ),
                                      GestureDetector(
                                        onTap:(){

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      ReviewScreenInMapMainDetail(
                                                        roomSalesInfo:  widget.roomSalesInfo,isRoom:true,)));
                                        },
                                        child: Container(
                                          width:screenWidth*(225/360),
                                          height:screenWidth*(40/360),
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.circular(4.5),

                                            border: Border.all(color: Colors.grey,width: 1),
                                          ),
                                          child: Center(child:
                                          Text("더 많은 후기 보러가기", style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360)),),),
                                        ),
                                      ),

                                      SizedBox(
                                        height: screenHeight * (20 / 640),
                                      ),
                                      Container(
                                          width: screenWidth,
                                          height: screenHeight * (8 / 640),
                                          color: Color(0xffeeeeee)),
                                    ],
                                  ):Divider(height: 3,color: OptionDivideLineColor,),

                                ],
                              );
                            }),],):Container(),

                    ]
                ),

              ],
            ),
          ),
          bottomNavigationBar: widget.chat == true? null:Container(
            height: screenHeight*0.09375,
            width: screenWidth,
            child: Row(
              children: [
                GestureDetector(
                  onTap: ()async{
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatSendFromRoomScreen(roomID : widget.roomSalesInfo.id, oppoID: widget.roomSalesInfo.userID,)) // SecondRoute를 생성하여 적재
                    ).then((value)async{
                      setState(() {});});

                  },
                  child: Container(
                    width: screenWidth*0.5,
                    height: screenHeight*0.09375,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        proposalText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight*0.025,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth*0.5,
                  height: screenHeight*0.09375,
                  decoration: BoxDecoration(
                    color: OptionDivideLineColor,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '이용 후기 보기',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight*0.025,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}

Future BottomSheetForDetailedRoomInformation(BuildContext context, double screenWidth,
    double screenHeight,  RoomSalesInfo _roomSalesInfo) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.transparent,
          width: screenWidth,
          height: screenHeight * (130 / 640),
          child: Column(
            children: [
              Container(
                width: screenWidth * (336 / 360),
                height: screenHeight * (49 / 640),
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
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(
                            context, // 기본 파라미터, SecondRoute로 전달
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReportScreen(roomSalesInfo : _roomSalesInfo)) // SecondRoute를 생성하여 적재
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight * (22 / 640),
                            child: Center(
                              child: Text(
                                "신고하기",
                                style: TextStyle(
                                    fontSize: screenHeight * (16 / 640),
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                        ],
                      ),
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
                          fontSize: screenHeight * (16 / 640),
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



bool myRoomCheck(int id){
  bool result = false;
  for(int i =0;i<GlobalProfile.roomSalesInfoList.length;i++){
    if(GlobalProfile.roomSalesInfoList[i].id == id)
      result = true;
  }
  return result;
}