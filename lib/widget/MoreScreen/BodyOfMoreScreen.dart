import 'dart:async';
import 'dart:convert';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/MyRoomList.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/ProposalRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/MoreScreen/AskScreen.dart';
import 'package:mryr/screens/MoreScreen/MyRecentRoom.dart';
import 'package:mryr/screens/MoreScreen/MyRoomLikes.dart';
import 'package:mryr/screens/BorrowRoom/ReportScreen.dart';
import 'package:mryr/screens/MoreScreen/Notice.dart';
import 'package:mryr/screens/MoreScreen/model/NoticeModel.dart';
import 'package:mryr/screens/NeedRoomSalesInfoListScreen.dart';
import 'package:mryr/screens/ReleaseRoom/MainReleaseRoomScreen.dart';
import 'package:mryr/screens/RoomWannaLive.dart';
import 'package:mryr/screens/Setting/Setting.dart';
import 'package:mryr/screens/Setting/tutorial/TutorialMainScreenInSetting.dart';
import 'package:mryr/screens/Setting/tutorial/TutorialScreenInSetting.dart';
import 'package:mryr/screens/TutorialScreen.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/screens/ReleaseRoom/ReleaseRoomTutorialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/TransferRoom/WarningBeforeTransfer.dart';



Row RegistedRoomListAndMyCommentInChatListScreen(BuildContext context,double screenWidth, double screenHeight) {
  final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: ()async {

            Navigator.push(
                context, // 기본 파라미터, SecondRoute로 전달
                MaterialPageRoute(
                    builder: (context) =>
                        TutorialScreenInSetting()) // SecondRoute를 생성하여 적재
            );

        },
        child: Container(
          width: screenWidth * (164 / 360),
          height:screenWidth * (48 / 360),
          decoration: buildBoxDecoration(),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * (8 / 360),
                ),
                SvgPicture.asset(
                  GuideIconInMoreScreen,
                  width: screenHeight * (24 / 640),
                  height: screenHeight * (24 / 640),
                ),
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "앱 사용 가이드",
                  style: TextStyle(
                      fontSize: screenWidth * (12 / 360),
                      //fontSize: screenHeight * (12 / 640),
                      color: Color(0xff222222)),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        width: screenWidth * (8 / 360),
      ),
      Container(
        width: screenWidth * (164 / 360),
        height:screenWidth * (48 / 360),
        decoration: buildBoxDecoration(),
        child: Center(
          child: Row(
            children: [
              SizedBox(
                width: screenWidth * (8 / 360),
              ),
              SvgPicture.asset(
                PencilIconInMoreScreen,
                color: Color(0xffBEBEBE),
                width: screenHeight * (24 / 640),
                height: screenHeight * (24 / 640),
              ),
              SizedBox(
                width: screenWidth * (12 / 360),
              ),
              Text(
                "내가 등록한 후기",
                style: TextStyle(
                    fontSize: screenWidth * (12 / 360),
                    // fontSize: screenHeight * (12 / 640),
                    color: Color(0xffBEBEBE)),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Row ReleaseRoomAndReverseListInMoreScreen(BuildContext context,double screenWidth, double screenHeight) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      GestureDetector(
        onTap: ()async {
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
        child: Container(
          width: screenWidth * (164 / 360),
          height:screenWidth * (48 / 360),
          decoration: buildBoxDecoration(),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * (8 / 360),
                ),
                SvgPicture.asset(
                  RoomIconInMoreScreen,
                  width: screenWidth * (24 / 360),//screenHeight * (24 / 640),
                  height: screenHeight * (24 / 640),
                ),
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "양도하기",
                  style: TextStyle(
                      fontSize: screenWidth * (12 / 360),
                      //fontSize: screenHeight * (12 / 640),
                      color: Color(0xff222222)),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        width: screenWidth * (8 / 360),
      ),
      GestureDetector(
        onTap: (){

        },
        child: Container(
          width: screenWidth * (164 / 360),
          height:screenWidth * (48 / 360),
          decoration: buildBoxDecoration(),
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * (8 / 360),
                ),
                SvgPicture.asset(
                  ListIconInMoreScreen,
                  width: screenWidth * (24 / 360),// screenHeight * (24 / 640),
                  height: screenHeight * (24 / 640),
                    color: Color(0xffBEBEBE)
                ),
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "내방니방 마켓",
                  style: TextStyle(
                      fontSize: screenWidth * (12 / 360),
                      //fontSize: screenHeight * (12 / 640),
                      color: Color(0xffBEBEBE)),
                ),
              ],
            ),
          ),
        ),
      )
    ],
  );
}

Container ChatListInMoreScreen(double screenWidth, double screenHeight) {
  return Container(
    width: screenWidth * (336 / 360),
    height: screenHeight * (60 / 640),
    decoration: buildBoxDecoration(),
    child: Center(
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * (8 / 360),
          ),
          SvgPicture.asset(
            ChatIconInMoreScreen,
            width: screenWidth * (24 / 360),
            height: screenHeight * (24 / 640), //screenHeight * (24 / 640),
          ),
          SizedBox(
            width: screenWidth * (12 / 360),
          ),
          Text(
              "쪽지함",
              style: TextStyle(
                fontSize: screenWidth * (16 / 360),
              )
          ),
          SizedBox(
            width: screenWidth * (8 / 360),
          ),

        ],
      ),
    ),
  );
}

Container DirectToMarketInMoreScreen(double screenWidth, double screenHeight) {
  return Container(
    width: screenWidth * (336 / 360),
    height: screenHeight * (60 / 640),
    decoration: buildBoxDecoration(),
    child: Center(
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * (8 / 360),
          ),
          SvgPicture.asset(
            MarketIconInMoreScreen,
            width: screenWidth * (24 / 360),
            height: screenHeight * (24 / 640),
            color: Color(0xffBEBEBE),
          ),
          SizedBox(
            width: screenWidth * (12 / 360),
          ),
          Text(
            "내방니방 마켓 바로가기",
            style: TextStyle(
                fontSize: screenWidth * (16 / 360),                color: Color(0xffBEBEBE)),
          )
        ],
      ),
    ),
  );
}
