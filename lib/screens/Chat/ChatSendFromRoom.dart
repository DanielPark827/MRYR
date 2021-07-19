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
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/widget/Public/floatButtonWithListIcon.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:mryr/userData/User.dart';
import 'package:transition/transition.dart';

import 'ChatDetailScreen.dart';

final PurpleMenuIcon = 'assets/images/Map/PurpleMenuIcon.svg';
final MessageIcon = 'assets/images/Chat/message.svg';
final CloseIcon = 'assets/images/Chat/Close.svg';

class ChatSendFromRoomScreen extends StatefulWidget {
  int roomID;
  int oppoID;
  ChatSendFromRoomScreen({Key key, this.roomID,this.oppoID}) : super(key:key);
  @override
  _ChatSendFromRoomScreenState createState() => _ChatSendFromRoomScreenState();
}

SharedPreferences localStorage;

class _ChatSendFromRoomScreenState extends State<ChatSendFromRoomScreen>with SingleTickerProviderStateMixin  {
  final DescriptionController = TextEditingController();

  final _scrollController = ScrollController();
  void initState() {

    super.initState();

    (() async {

    })();
  }

  @override
  void dispose(){
    super.dispose();
    DescriptionController.dispose();
  }


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
          child: SingleChildScrollView(
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
                              icon:SvgPicture.asset(
                                CloseIcon,

                                height: screenWidth * (14 / 360),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],),),
                      Spacer(),
                      Text('쪽지 보내기',
                        style: TextStyle(
                          color: hexToColor("#222222"),
                          fontSize:screenWidth*( 16/360),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: screenWidth*(85/360),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {

                                if(mulCheck == false) {
                                  mulCheck = true;
                                  if (DescriptionController.text == "" ||
                                      DescriptionController.text == null) {
                                    Navigator.pop(context);
                                  }
                                  else {
                                    Function okFunc = () async {
                                      EasyLoading.show(
                                          status: "",
                                          maskType:
                                          EasyLoadingMaskType
                                              .black);
                                      var result = await ApiProvider().post(
                                          '/Note/Send', jsonEncode(
                                          {
                                            "userID": GlobalProfile.loggedInUser
                                                .userID,
                                            "receiverID": widget.oppoID,
                                            "roomID": widget.roomID,
                                            "contents": DescriptionController
                                                .text,
                                          }
                                      ));
                                      if (result == false) {
                                        Navigator.pop(context);
                                        CustomOKDialog(context, "쪽지가 전송되지 않았습니다",
                                            "다시 전송해주세요!");
                                      }
                                      else {
                                        chatSum = 0;
                                        //쪽지함 리스트
                                        chatInfoList.clear();
                                        var ye = await ApiProvider().post(
                                            '/Note/MessageRoomListTest',
                                            jsonEncode({
                                              "userID": GlobalProfile
                                                  .loggedInUser.userID
                                            }));

                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                      EasyLoading.dismiss();
                                    };
                                    Function cancelFunc = () {
                                      Navigator.pop(context);
                                    };
                                    OKCancelDialog(
                                        context,
                                        "쪽지를 보내시겠습니까?",
                                        "확인을 누르면 쪽지가 전송됩니다!",
                                        "확인",
                                        "취소",
                                        okFunc,
                                        cancelFunc);
                                  }
                                  mulCheck = false;
                                }
                                mulCheck = false;
                              },
                              child: Container(

                                height: screenHeight * (22 / 640),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Padding(

                                  padding: EdgeInsets.only(left: 16.0,right: 16.0),
                                  child: Center(
                                    child: Text(
                                      "전송",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * (12/ 360),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width:screenWidth*(12/360)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  color: Color(0xffeeeeee),
                  height: screenHeight *(2/640),
                ),

                Column(
                  children: [
                    TextField(
                      controller: DescriptionController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines:32,//filesList.length != 0?17 :25,
                      minLines: 5,

                      decoration: InputDecoration(
                        isDense: true,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "내용을 입력하세요.",
                        hintStyle: TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                      ),
                      onChanged: (text){
                        setState(() {

                        });
                      },
                    ),
                  ],
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