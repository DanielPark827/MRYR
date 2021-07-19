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

import 'ChatDetailScreen.dart';

final PurpleMenuIcon = 'assets/images/Map/PurpleMenuIcon.svg';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

SharedPreferences localStorage;



class _ChatScreenState extends State<ChatScreen>with SingleTickerProviderStateMixin  {
  AnimationController extendedController;
  double animatedHeight1 = 0.0;
  double animatedHeight2 = 0.0;
  double animatedHeight3 = 0.0;

  bool res = false;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _scrollController = ScrollController();
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

    (() async {


    })();
  }

  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }



  final Start = TextEditingController();
  final End = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    final SearchController = TextEditingController();
    RoomListScreenProvider data = Provider.of<RoomListScreenProvider>(context);


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


              chatSum =0;
              //쪽지함 리스트
              chatInfoList.clear();
              var ye = await ApiProvider().post('/Note/MessageRoomListTest', jsonEncode({
                "userID" : GlobalProfile.loggedInUser.userID

              }));

              var tt = ye['result'];
              if (ye != null && ye  != false) {
                for (int i = 0; i < ye['result'].length; ++i) {
                  chatInfoList.add(Chat.fromJson(ye['result'][i],ye['Contents'][i]));
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
                      Spacer(),
                      Text('쪽지함',
                        style: TextStyle(
                          color: hexToColor("#222222"),
                          fontSize:screenWidth*( 16/360),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xffeeeeee),
                  height: screenHeight *(4/640),
                ),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: chatInfoList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if(chatInfoList.length == 0){
                          return Container(
                            color: Color(0xffe5e5e5),
                            width: screenWidth,height: screenHeight,
                            child: Column(

                              children: [
                                Container(height: screenHeight*(200/640),),
                                SvgPicture.asset(
                                  'assets/images/Chat/snail.svg',
                                  width: screenWidth * (112 / 360),
                                  height: screenWidth * (110/ 640),
                                ),
                                Container(height: screenWidth*(20/360),),
                                Text("주고 받은 쪽지가 아직 없어요!", style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),)
                              ],),);
                        }
                        else
                        return Column(
                          children: [
                            InkWell(

                              onTap: () async {
                                if(doubleCheck == false) {
                                  doubleCheck = true;

                                  chatRoomDetail = null;
                                  var ye = await ApiProvider().post(
                                      '/Note/MessageList/RoomInfo', jsonEncode({
                                    "roomID": chatInfoList[index].roomID,

                                  }));
                                  if (ye != null && ye != false) {
                                    chatRoomDetail =
                                    (RoomSalesInfo.fromJson(ye));
                                  }
                                  eachChatList.clear();
                                  var ye2 = await ApiProvider().post(
                                      '/Note/MessageList', jsonEncode({
                                    "roomID": chatInfoList[index].roomID,
                                    //chatInfoList[index].roomID,
                                    "senderID": chatInfoList[index].senderID,
                                    //chatInfoList[index].senderID,
                                    "receiverID": chatInfoList[index].receiverID
                                    //chatInfoList[index].receiverID,
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


                                  chatSum -= chatInfoList[index].notYetView;
                                  chatInfoList[index].notYetView = 0;


                                  Navigator.push(
                                      context, // 기본 파라미터, SecondRoute로 전달
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChatDetailScreen(
                                                  chatInfo: chatInfoList[index])) // SecondRoute를 생성하여 적재
                                  );
                                  setState(() {

                                  });
                                }
                              },
                              child: Container(
                                width: screenWidth,
                                height: screenHeight * (70/640),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * (12/360),
                                    //  right: screenWidth * 0.033333,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenHeight * (36 / 640),
                                        height: screenHeight * (36/ 640),
                                        child:
                                        ClipRRect(
                                            borderRadius: new BorderRadius.circular(4.0),
                                            child:
                                            (chatInfoList[index].senderID == GlobalProfile.loggedInUser.userID?chatInfoList[index].receiverImg:chatInfoList[index].senderImg)=="BasicImage"
                                                ||(chatInfoList[index].senderID == GlobalProfile.loggedInUser.userID?chatInfoList[index].receiverImg:chatInfoList[index].senderImg)==null
                                                ?
                                            SvgPicture.asset(
                                              ProfileIconInMoreScreen,
                                              width: screenHeight * (36 / 640),
                                              height: screenHeight * (36 / 640),
                                            )
                                                :
                                            FittedBox(
                                              fit: BoxFit.cover,
                                              child: getExtendedImage(get_resize_image_name(chatInfoList[index].senderID == GlobalProfile.loggedInUser.userID?chatInfoList[index].receiverImg:chatInfoList[index].senderImg,120), 0,extendedController),
                                            )

                                        ),
                                      ),
                                      SizedBox(width: screenWidth*(4/360),),
                                      Container(
                                        width: chatInfoList[index].notYetView!=0? screenWidth*(208/360) : screenWidth*(236/360),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment : MainAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              Container(
                                                constraints: BoxConstraints( maxWidth: 140),
                                                child: Text(chatInfoList[index].senderID == GlobalProfile.loggedInUser.userID?chatInfoList[index].receiverNickName:chatInfoList[index].senderNickName,
                                                  maxLines:1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(14/360)),),
                                              ),

                                              SizedBox(width: screenWidth*(4/360),),



                                              SizedBox(width: screenWidth*(10/360),),
                                              Text(timeCheckForChat(chatInfoList[index].updatedAt),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),)
                                            ],),
                                            SizedBox(height: screenHeight*(3/640),),
                                            Container(
                                              width: screenWidth*(228/360),
                                              child:
                                              Text(chatInfoList[index].contents.contains("NotePhotos/")?"Photo":chatInfoList[index].contents,
                                                maxLines:1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),)
                                          ],),
                                      ),
                                      chatInfoList[index].notYetView!=0? Container(
                                        width: screenWidth*(28/360),
                                        child: Row(

                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: screenHeight*(20/640),
                                              decoration: BoxDecoration(
                                                color: Color(0xfff9423a),
                                                borderRadius: BorderRadius.circular(100),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 5,right: 5,top: 1,bottom: 1),
                                                  child: Text(
                                                    //"444",
                                                    chatInfoList[index].notYetView.toString(),
                                                    style: TextStyle(
                                                      //fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: screenWidth * (10 / 360),
                                                      // fontSize: screenHeight * (10 / 640)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ):Container(),

                                      Container(width: screenWidth*(6/360),),
                                      Container(
                                        width: screenWidth * (56/360),
                                        height: screenHeight * (46/640),
                                        child: ClipRRect(
                                            borderRadius: new BorderRadius.circular(4.0),
                                            child:    chatInfoList[index].roomImgUrl=="BasicImage"
                                                ?
                                            SvgPicture.asset(
                                              mryrInReviewScreen,
                                              width:
                                              screenHeight *
                                                  (56 /
                                                      640),
                                              height:
                                              screenHeight *
                                                  (46 /
                                                      640),
                                            )
                                                :  FittedBox(
                                              fit: BoxFit.cover,
                                              child:    getExtendedImage(get_resize_image_name(chatInfoList[index].roomImgUrl,360), 0,extendedController),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
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


String timeCheckForChat(String tmp) {
  if(tmp == null || tmp == '' || tmp.contains('.') == true) return '';

  if(tmp.length == 12){
    tmp = tmp.substring(0, 11) + '0' + tmp[12];
  }else if(tmp.length == 11){
    tmp = tmp.substring(0, 10) + '0' + tmp[11] + '0' + tmp[12];
  }

  int year = int.parse(tmp[0] + tmp[1] + tmp[2] + tmp[3]);
  int month = int.parse(tmp[4] + tmp[5]);
  int day = int.parse(tmp[6] + tmp[7]);
  int hour = int.parse(tmp[8] + tmp[9]);

  int minute = int.parse(tmp[10] + tmp[11]);
  int second = int.parse(tmp[12] + tmp[13]);
  return (month.toString().length==1?"0"+month.toString():month.toString())+"/"+(day.toString().length==1?"0"+day.toString():day.toString())+" "+(hour.toString().length==1?"0"+hour.toString():hour.toString())+":"+(minute.toString().length==1?"0"+minute.toString():minute.toString());
}
