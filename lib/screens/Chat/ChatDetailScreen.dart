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
import 'package:mryr/screens/Chat/ChatScreen.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/RoomWannaLive.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/Chat.dart';
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

import 'ChatSend.dart';
import 'ImagePage.dart';
final MessageIcon = 'assets/images/Chat/message.svg';
final PurpleMenuIcon = 'assets/images/Map/PurpleMenuIcon.svg';
final MoreIcon = 'assets/images/Chat/More.svg';

class ChatDetailScreen extends StatefulWidget {
  Chat chatInfo;
  ChatDetailScreen({Key key, this.chatInfo}) : super(key:key);
  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

SharedPreferences localStorage;

class _ChatDetailScreenState extends State<ChatDetailScreen>with SingleTickerProviderStateMixin  {
  AnimationController extendedController;
  double animatedHeight1 = 0.0;
  double animatedHeight2 = 0.0;
  double animatedHeight3 = 0.0;

  bool res = false;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _scrollController = ScrollController();
  final _scrollController2 = ScrollController();
  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _getMoreData();
      }
    });
    super.initState();

    for(int i =0;i<nbnbRoomListId.length;i++){
      if(nbnbRoomListId[i] ==  chatRoomDetail.id)
        nbnbC = true;
    }

    doubleCheck = false;
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

    (() async {

    })();
  }

  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  bool nbnbC = false;



  final Start = TextEditingController();
  final End = TextEditingController();
  _getMoreData() async{
    Timer(Duration(milliseconds: 500), ()async{
      eachChatList.clear();
      var ye2 = await ApiProvider().post('/Note/MessageList/Offset',jsonEncode({
        "roomID":widget.chatInfo.roomID,//chatInfoList[index].roomID,
        "senderID":widget.chatInfo.senderID,//chatInfoList[index].senderID,
        "receiverID":widget.chatInfo.receiverID,//chatInfoList[index].receiverID,
        "index" : chatNum,
      }));
      chatNum = chatNum + ye2.length;
      if (ye2 != null && ye2 != false) {
        for (int i = 0; i < ye2.length; ++i) {
          var tmp =  EachChat.fromJson(ye2[i]);

          if(i ==0){
            eachChatList.add(tmp);
          }
          else{
            if(eachChatList[eachChatList.length-1].img != true || tmp.img != true){
              eachChatList.add(tmp);
            }
            else{
              if(
              replaceDateToDatetime(eachChatList[eachChatList.length-1].createdAt).difference( replaceDateToDatetime(tmp.createdAt)).inSeconds <1
              ){
                eachChatList[eachChatList.length-1].contents.add(tmp.contents[0]);
              }
              else{
                eachChatList.add(tmp);

              }
            }
          }
        }
      }
      setState(() {

      });
    });
  }

  bool FlagForFilter = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: RefreshIndicator(
            key: refreshKey,
            onRefresh: ()async{

              eachChatList.clear();
              var ye2 = await ApiProvider().post('/Note/MessageList',jsonEncode({
                "roomID":widget.chatInfo.roomID,//chatInfoList[index].roomID,
                "senderID":widget.chatInfo.senderID,//chatInfoList[index].senderID,
                "receiverID":widget.chatInfo.receiverID//chatInfoList[index].receiverID,
              }));

              chatNum = ye2.length;
              if (ye2 != null && ye2 != false) {
                for (int i = 0; i < ye2.length; ++i) {
                  var tmp =  EachChat.fromJson(ye2[i]);

                  if(i ==0){
                    eachChatList.add(tmp);
                  }
                  else{
                    if(eachChatList[eachChatList.length-1].img != true || tmp.img != true){
                      eachChatList.add(tmp);
                    }
                    else{
                      if(
                      replaceDateToDatetime(eachChatList[eachChatList.length-1].createdAt).difference( replaceDateToDatetime(tmp.createdAt)).inSeconds <1
                      ){
                        eachChatList[eachChatList.length-1].contents.add(tmp.contents[0]);
                      }
                      else{
                        eachChatList.add(tmp);
                      }
                    }
                  }
                }
              }
              setState(() {

              });


            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  height: screenHeight*(60/640),
                  child: Row(
                    children: [

                      Container(width: screenWidth*(85/360),
                        child: Row(children: [
                          SizedBox(width: screenWidth*(8/360),),
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                              onPressed: () async{

                                if(doubleCheck == false) {
                                  doubleCheck = true;

                                  var ye3 = await ApiProvider().post(
                                      '/Note/ViewCheck', jsonEncode({
                                    "userID": GlobalProfile.loggedInUser.userID,
                                    "roomID": widget.chatInfo.roomID,
                                    //chatInfoList[index].roomID,
                                    "messroomID": widget.chatInfo.messRoomID,
                                    //chatInfoList[index].senderID,
                                    "messageID": eachChatList[0].id
                                    //chatInfoList[index].receiverID,
                                  }));
                                  chatSum = 0;
                                  //쪽지함 리스트
                                  chatInfoList.clear();
                                  var ye = await ApiProvider().post(
                                      '/Note/MessageRoomListTest', jsonEncode({
                                    "userID": GlobalProfile.loggedInUser.userID
                                  }));
                                  var tt = ye['result'];
                                  if (ye != null && ye != false) {
                                    for (int i = 0; i <
                                        ye['result'].length; ++i) {
                                      chatInfoList.add(Chat.fromJson(
                                          ye['result'][i], ye['Contents'][i]));
                                    }
                                  }
                                  Navigator.pop(context);
                                  navigationNumProvider.setNum(2);
                                  setState(() {

                                  });
                                  doubleCheck = false;
                                }
                              }),
                        ],),),
                      Spacer(),
                      Text(widget.chatInfo.senderID == GlobalProfile.loggedInUser.userID?widget.chatInfo.receiverNickName:widget.chatInfo.senderNickName,
                        style: TextStyle(
                          color: hexToColor("#222222"),
                          fontSize:16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(width: screenWidth*(85/360),
                        child:
                        Row(children: [
                          IconButton(
                              icon:SvgPicture.asset(
                                MessageIcon,
                                width: screenHeight * (110 / 640),
                                height: screenHeight * (27 / 640),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context, // 기본 파라미터, SecondRoute로 전달
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChatSendScreen(chatInfo : widget.chatInfo,isChatList: true,)) // SecondRoute를 생성하여 적재
                                ).then((value)async{
                                  setState(() {});});
                              }),

                          IconButton(
                              icon:SvgPicture.asset(
                                MoreIcon,
                                width: screenHeight * (110 / 640),
                                height: screenHeight * (27 / 640),
                              ),
                              onPressed: () {
                                setState(() {
                                  BottomSheetForDetailedRoomInformation(context,screenWidth,screenHeight, chatRoomDetail);
                                  /* Future.microtask(() async {
                                AllNotification = await getNotiByStatus();
                              });*/
                                });
                                //Navigator.pop(context);
                              }),

                        ],),)
                    ],
                  ),
                ),
                InkWell(
                  onTap: ()async{
                    if(mulCheck == false) {
                      mulCheck = true;
                      GlobalProfile.detailReviewList.clear();
                      double finalLat;
                      double finalLng;
                      if (null == chatRoomDetail.lng ||
                          null == chatRoomDetail.lat) {
                        var addresses = await Geocoder.google(
                            'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                            .findAddressesFromQuery(chatRoomDetail.location);
                        var first = addresses.first;
                        finalLat = first.coordinates.latitude;
                        finalLng = first.coordinates.longitude;
                      } else {
                        finalLat = chatRoomDetail.lat;
                        finalLng = chatRoomDetail.lng;
                      }
                      var detailReviewList = await ApiProvider()
                          .post('/Review/ReviewListLngLat', jsonEncode({
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
                      res = await Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailedRoomInformation(
                                    roomSalesInfo: chatRoomDetail,
                                    chat: true,
                                    nbnb: nbnbC,
                                  )) // SecondRoute를 생성하여 적재
                      );
                      mulCheck = false;
                    }
                    mulCheck = false;
                  },
                  child: Container(
                    width: screenWidth,
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
                              SizedBox(height: screenHeight * (6/640)),
                              Container(
                                width: screenWidth * (76/360),
                                height: screenHeight * (64/640),
                                child: ClipRRect(
                                    borderRadius: new BorderRadius.circular(4.0),
                                    child:     (widget.chatInfo.roomImgUrl=="BasicImage" ||  widget.chatInfo.roomImgUrl ==null)
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
                                        :  FittedBox(
                                      fit: BoxFit.cover,
                                      child:    getExtendedImage(get_resize_image_name(widget.chatInfo.roomImgUrl,360), 0,extendedController),
                                    )
                                ),
                              ),

                              SizedBox(height: screenHeight * (6/640)),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 0.033333,
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: screenHeight * (6/640)),
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
                                                          chatRoomDetail.preferenceTerm == 2 ? "하루가능" : chatRoomDetail.preferenceTerm == 1 ? "1개월이상" : "기관무관",
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
                                                          chatRoomDetail.preferenceSmoking == 2 ? "흡연가능" :chatRoomDetail.preferenceSmoking == 1 ? "흡연불가" : "흡연무관",
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
                                                          chatRoomDetail.preferenceSex == 2 ? "남자선호" : chatRoomDetail.preferenceSex == 1 ? "여자선호" : "성별무관",
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
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.00625,
                                ),
                                Text(

                                  chatRoomDetail.monthlyRentFeesOffer.toString() +
                                      (nbnbC == true? '원 / 일':'만원 / 월'),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.00625,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screenWidth*(60/360),
                                      child: Text(
                                        "매물 위치",
                                        style: TextStyle(
                                            fontSize:12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        width: screenWidth*(190/360),
                                        child: Text(chatRoomDetail.location,style: TextStyle(fontSize: 12,),))
                                  ],
                                ),

                                SizedBox(height: screenHeight * (6/640)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Color(0xffeeeeee),
                  height: screenHeight *(6/640),
                ),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: eachChatList.length,
                      itemBuilder: (BuildContext context, int index) {

                        return Column(
                          children: [

                            Container(
                              color: Color(0xffeeeeee),
                              height: screenHeight *(1/640),
                            ),
                            GestureDetector(
                              onTap: () async {

                              },
                              child: Container(
                                width: screenWidth,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * (12/360),
                                    //  right: screenWidth * 0.033333,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment : MainAxisAlignment.center,
                                    children: [

                                      SizedBox(height: screenHeight*(10/640),),
                                      Row(children: [
                                        Container(
                                          child: Text(eachChatList[index].senderID == GlobalProfile.loggedInUser.userID? "보낸 쪽지" : "받은 쪽지",
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(14/360),color: eachChatList[index].senderID == GlobalProfile.loggedInUser.userID? Color(0xffEB9C25): Color(0xff6F22D2)),),
                                        ),

                                        Spacer(),
                                        Text(timeCheckForChat(replaceLocalDate(eachChatList[index].createdAt)),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),
                                        SizedBox(width: screenWidth*(16/360),),
                                      ],),
                                      SizedBox(height: screenHeight*(9/640),),
                                      Container(
                                        width: screenWidth*(336/360),
                                        child:
                                        eachChatList[index].img == false?
                                        SelectableText(eachChatList[index].contents[0],

                                          style: TextStyle(fontSize: 12,color: Color(0xff888888)),):
                                        Row(
                                          mainAxisAlignment : MainAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                Navigator.push(
                                                    context, // 기본 파라미터, SecondRoute로 전달
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImagePage(imageUrl : eachChatList[index].contents[0])) // SecondRoute를 생성하여 적재
                                                );
                                              },
                                              child: Container(
                                                width: screenHeight * (60 / 640),
                                                height: screenHeight * (60 / 640),
                                                child:

                                                ClipRRect(
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    child:
                                                    eachChatList[index].contents[0]=="BasicImage"||eachChatList[index].contents==null
                                                        ?
                                                    SvgPicture.asset(
                                                      ProfileIconInMoreScreen,
                                                      width: screenHeight * (60 / 640),
                                                      height: screenHeight * (60 / 640),
                                                    )
                                                        :
                                                    FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: getExtendedImage(get_resize_image_name(eachChatList[index].contents[0],60), 0,extendedController),
                                                    )
                                                ),

                                              ),
                                            ),
                                            Container(width: screenWidth*(4/360),),
                                            eachChatList[index].contents.length>1?
                                            InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                    context, // 기본 파라미터, SecondRoute로 전달
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImagePage(imageUrl : eachChatList[index].contents[1])) // SecondRoute를 생성하여 적재
                                                );
                                              },
                                              child: Container(
                                                width: screenHeight * (60 / 640),
                                                height: screenHeight * (60 / 640),
                                                child:

                                                ClipRRect(
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    child:
                                                    eachChatList[index].contents[1]=="BasicImage"||eachChatList[index].contents==null
                                                        ?
                                                    SvgPicture.asset(
                                                      ProfileIconInMoreScreen,
                                                      width: screenHeight * (60 / 640),
                                                      height: screenHeight * (60 / 640),
                                                    )
                                                        :
                                                    FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: getExtendedImage(get_resize_image_name(eachChatList[index].contents[1],60), 0,extendedController),
                                                    )
                                                ),
                                              ),
                                            ) : Container(),

                                            Container(width: screenWidth*(4/360),),
                                            eachChatList[index].contents.length>2?
                                            InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                    context, // 기본 파라미터, SecondRoute로 전달
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImagePage(imageUrl : eachChatList[index].contents[2])) // SecondRoute를 생성하여 적재
                                                );
                                              },
                                              child: Container(
                                                width: screenHeight * (60 / 640),
                                                height: screenHeight * (60 / 640),
                                                child:

                                                ClipRRect(
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    child:
                                                    eachChatList[index].contents[2]=="BasicImage"||eachChatList[index].contents==null
                                                        ?
                                                    SvgPicture.asset(
                                                      ProfileIconInMoreScreen,
                                                      width: screenHeight * (60 / 640),
                                                      height: screenHeight * (60 / 640),
                                                    )
                                                        :
                                                    FittedBox(
                                                      fit: BoxFit.cover,
                                                      child: getExtendedImage(get_resize_image_name(eachChatList[index].contents[2],60), 0,extendedController),
                                                    )
                                                ),

                                              ),
                                            ) : Container(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: screenHeight*(12/640),),
                                    ],),
                                ),
                              ),
                            ),
                          ],
                        );
                      }


                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
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