import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

Future BottomSheetInShowChatList(BuildContext context, double screenWidth, double screenHeight,RoomSalesInfo roomSalesInfo, AnimationController extendedController){

  return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(8.0),
              topRight: const Radius.circular(8.0))
      ),
      builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * (20/640),),
                  Row(
                    children: [
                      Container(width: screenWidth * (12/360),),
                      Container(
                        child: Text("대화중인 채팅방", style: TextStyle(fontSize: screenWidth * (16/360), fontWeight: FontWeight.bold, color: hexToColor('#222222')),),
                      ),
                      SizedBox(width: screenWidth * (12/360),),
                      Container(
                        child: Text(roomSalesInfo.chatRoomUserList.length.toString(), style: TextStyle(fontSize: screenWidth * (16/360), fontWeight: FontWeight.normal, color: hexToColor('#6F22D2')),),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*(15/640),),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        //physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: roomSalesInfo.chatRoomUserList.length ,
                        itemBuilder: (BuildContext context, int index) =>
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, roomSalesInfo.chatRoomUserList[index]);
                              },
                              child: Container(
                                width: screenWidth,
                                //height: screenHeight * (48/640),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.033333,
                                      right: screenWidth * 0.033333,
                                     ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: screenHeight * (48/640),
                                            width:  screenHeight * (48/640),
                                            child: ClipRRect(
                                              borderRadius: new BorderRadius.circular(4.0),
                                              child: GlobalProfile.getUserByUserID(roomSalesInfo.chatRoomUserList[index].chatID).profileUrlList=="BasicImage"
                                                  ?
                                              SvgPicture.asset(
                                                ProfileIconInMoreScreen,
                                              )
                                                  :  FittedBox(
                                                          fit: BoxFit.cover,
                                                         child:  getExtendedImage(get_resize_image_name(GlobalProfile.getUserByUserID(roomSalesInfo.chatRoomUserList[index].chatID).profileUrlList,120), 0,extendedController),
                                              )
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenWidth * 0.033333,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(GlobalProfile.getUserByUserID(roomSalesInfo.chatRoomUserList[index].chatID).nickName),
                                               // child: Text("TEST"),
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.00625,
                                              ),
                                              Container(
                                                child: Text(ChatGlobal.roomInfoList[roomSalesInfo.chatRoomUserList[index].id].lastMessage),
                                              )
                                            ],
                                          ),
                                          Expanded(child: SizedBox()),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight*(20/640),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
      }
  );
}
