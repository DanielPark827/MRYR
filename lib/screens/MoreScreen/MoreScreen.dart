import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/MoreScreen/TradingState.dart';
import 'package:mryr/screens/MyPage.dart';
import 'package:mryr/screens/NeedRoomProposalListScreen.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/MyRoomList.dart';
import 'package:mryr/screens/Setting/CertificationList.dart';
import 'package:mryr/screens/Setting/PersonalInfoRule.dart';
import 'package:mryr/screens/Setting/Setting.dart';
import 'package:mryr/screens/Setting/UsingRule.dart';
import 'package:mryr/userData/CertificationPicture.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/utils/StatusBar.dart';
import 'package:mryr/widget/MoreScreen/BodyOfMoreScreen.dart';
import 'package:mryr/widget/MoreScreen/MyProfileLine.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AskScreen.dart';
import 'MyRecentRoom.dart';
import 'Notice.dart';
import 'model/NoticeModel.dart';
import 'package:mryr/screens/MoreScreen/MyRoomLikes.dart';
import 'package:mryr/screens/Payment/Payment.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>with SingleTickerProviderStateMixin {
  void _launchUrl(String Url)async{
    if(await canLaunch(Url)){
      await launch(Url);
    }
    else{
      throw 'Could not open Url';
    }
  }
  AnimationController extendedController;
  bool adminCheck = false;
  @override
  void initState() {
    super.initState();
        () async {
      var res = await ApiProvider().post('/Information/AdminCheck', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));
      adminCheck= res;
      setState(() {
        // Update your UI with the desired changes.
      });
    } ();

    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

    setState(() {
      Future.microtask(() async {
        AllNotification = await getNotiByStatus();
      });
    });
  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: (){
            navigationNumProvider.setNum(0);
            return;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth,
                  decoration: buildBoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight*(18/640),),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: screenWidth*(24/360),),
                          Container(
                            width: screenWidth * (60 / 360),
                            height: screenWidth * (60 / 360),
                            child:
                            ClipRRect(
                                borderRadius: new BorderRadius.circular(4.0),
                                child:
                                GlobalProfile.loggedInUser.profileUrlList=="BasicImage"||GlobalProfile.loggedInUser.profileUrlList==null
                                    ?
                                SvgPicture.asset(
                                  ProfileIconInMoreScreen,
                                  width: screenHeight * (60 / 640),
                                  height: screenHeight * (60 / 640),
                                )
                                    :
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: getExtendedImage(get_resize_image_name(GlobalProfile.loggedInUser.profileUrlList,120), 0,extendedController),
                                )

                            ),
                          ),
                          SizedBox(width: screenWidth*(12/360),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenHeight * (9/ 640),
                              ),
                              Container(
                                width: screenWidth*((360-96)/360),
                                child: Row(
                                  children: [
                                    Text(
                                      GlobalProfile.loggedInUser.name==null?"null":GlobalProfile.loggedInUser.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          //fontSize: screenHeight * (16 / 640),
                                          fontSize: screenWidth * (16 / 360),
                                          color: Color(0xff222222)),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context, // 기본 파라미터, SecondRoute로 전달
                                            MaterialPageRoute(
                                              builder: (context) => MyPage(),
                                            ) // SecondRoute를 생성하여 적재
                                        );
                                      },
                                      child: Container(
                                        width: screenWidth * (80 / 360),
                                        height: screenHeight * (22 / 640),
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "마이페이지",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * (10 / 360),
                                              // fontSize: screenHeight * (10 / 640)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth*(12/360),),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * (4 / 640),
                              ),
                              Text(
                                GlobalProfile.loggedInUser.id,
                                style: TextStyle(
                                  // fontSize: screenHeight * (12 / 640),
                                    fontSize: screenWidth * (12 / 360),
                                    color: Color(0xff888888)),
                              ),
                            ],),

                        ],
                      ),

                      SizedBox(
                        height: screenHeight * (16 / 640),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyRoomList()) // SecondRoute를 생성하여 적재
                              );

                            },
                            child: Container(
                              width: screenWidth * (119.5 / 360),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    RoomPictureInMoreScreen,
                                    width: screenWidth * (32 / 360),//screenHeight * (24 / 640),
                                    height: screenWidth * (32 / 360),
                                  ),
                                  SizedBox(height: screenHeight*(4/640),),
                                  Text("내가 내놓은 방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * (1 / 360),
                            height: screenHeight * (37 / 640),
                            color: Color(0xffBEBEBE),
                          ),
                          InkWell(
                            onTap: () {/*
                              GlobalProfile.tradingList.clear();
                              for(int i =0;i<chatRoomUserList.length;i++){
                                var tmp = getRoomSalesInfoByID(chatRoomUserList[i].roomSaleID);
                                GlobalProfile.tradingList.add(tmp);
                              }

                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TradingState(flag: true,)) // SecondRoute를 생성하여 적재
                              );*/
                            },
                            child: Container(
                              width: screenWidth * (119 / 360),
                              child:  Column(
                                children: [
                                  SvgPicture.asset(
                                    ReservePictureInMoreScreen,
                                    width: screenWidth * (32 / 360),//screenHeight * (24 / 640),
                                    height: screenWidth * (32 / 360),

                                  ),
                                  SizedBox(height: screenHeight*(4/640),),
                                  Text("예약 내역",style: TextStyle(fontSize: screenWidth*(12/360),color: Colors.grey),)
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * (1 / 360),
                            height: screenHeight * (37 / 640),
                            color: Color(0xffBEBEBE),
                          ),
                          InkWell(
                            onTap: ()async {
                              EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);

                              var ss = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
                                  {
                                    "userID" : GlobalProfile.loggedInUser.userID,
                                  }
                              ));
                              RoomLikesList.clear();
                              if(ss != null){
                                for(int i = 0 ; i < ss.length; ++i){
                                  Map<String, dynamic> t = ss[i]["RoomSalesInfo"];
                                  RoomSalesInfo sub = RoomSalesInfo.fromJsonLittle(t);
                                  sub.Likes=true;
                                  RoomLikesList.add(sub);
                                }
                              }
                              EasyLoading.dismiss();
                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyRoomLikes()) // SecondRoute를 생성하여 적재
                              );


                            },
                            child: Container(
                              width: screenWidth * (119.5 / 360),
                              child:  Column(
                                children: [
                                  SvgPicture.asset(
                                    HeartPictureInMoreScreen,
                                    width: screenWidth * (32 / 360),//screenHeight * (24 / 640),
                                    height: screenWidth * (32 / 360),
                                  ),
                                  SizedBox(height: screenHeight*(4/640),),
                                  Text("관심 목록",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                ReleaseRoomAndReverseListInMoreScreen(context,screenWidth, screenHeight),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                RegistedRoomListAndMyCommentInChatListScreen(context,screenWidth, screenHeight),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),


                Image.asset(
                  MoreBannerInMoreScreen,
                  width: screenWidth ,
                  //  color: Colors.black,
                ),
                //광고

                SizedBox(
                  height: screenHeight * (8 / 640),
                ),


                GestureDetector(
                  onTap: ()async{
                    var res = await ApiProvider().get("/NoticeWrite/NoticeGet");

                    if (null != res) {
                      GlobalProfile.ListNoticeModel.clear();
                      for (int i = 0; i < res.length; i++) {
                        var obj = NoticeModel.fromJson(res[i]);
                        GlobalProfile.ListNoticeModel.add(obj);
                      }
                      Navigator.push(
                          context, // 기본 파라미터, SecondRoute로 전달
                          MaterialPageRoute(
                            builder: (context) => Notice(),
                          ) // SecondRoute를 생성하여 적재
                      );
                    }

                  },
                  child: Container(width: screenWidth,height: screenWidth*(40/360),color: Colors.white,
                    child:
                    Row(children: [
                      SizedBox(width: screenWidth*(24/360),),
                      Text("공지사항",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),),
                    ],),
                  ),
                ),
                Container(height: 1,width: screenWidth,color: Color(0xfff8f8f8),),

                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                AskScreen()) // SecondRoute를 생성하여 적재
                    );


                  },
                  child: Container(width: screenWidth,height: screenWidth*(40/360),color: Colors.white, child:
                  Row(children: [
                    SizedBox(width: screenWidth*(24/360),),
                    Text("앱에 문의하기",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),),
                  ],),),
                ),
                Container(height: 1,width: screenWidth,color: Color(0xfff8f8f8),),

                /*  GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                AskScreen()) // SecondRoute를 생성하여 적재
                    );


                  },
                  child: Container(width: screenWidth,height: screenWidth*(40/360),color: Colors.white, child:
                  Row(children: [
                    SizedBox(width: screenWidth*(24/360),),
                    Text("신고하기",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),),
                  ],),),
                ),
                Container(height: 1,width: screenWidth,color: Color(0xfff8f8f8),),
*/
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                Setting()) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Container(width: screenWidth,height: screenWidth*(40/360),color: Colors.white, child:
                  Row(children: [
                    SizedBox(width: screenWidth*(24/360),),
                    Text("설정",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),),
                  ],),),
                ),
                // Container(height: 1,width: screenWidth,color: Color(0xfff8f8f8),),
                // GestureDetector(
                //   onTap: (){
                //     Navigator.push(
                //         context, // 기본 파라미터, SecondRoute로 전달
                //         MaterialPageRoute(
                //             builder: (context) =>
                //                 Payment()) // SecondRoute를 생성하여 적재
                //     );
                //   },
                //   child: Container(width: screenWidth,height: screenWidth*(40/360),color: Colors.white, child:
                //   Row(children: [
                //     SizedBox(width: screenWidth*(24/360),),
                //     Text("결제 테스트",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),),
                //   ],),),
                // ),
                Container(height: 1,width: screenWidth,color: Color(0xfff8f8f8),),
                adminCheck == true? GestureDetector(
                  onTap: ()async{
                    var tmp = await ApiProvider().get('/Manage/RenterIdList');
                    if(null != tmp){
                      for(int i =0;i<tmp.length;i++){
                        GlobalProfile.certificationPicture.add(CertificationPicture.fromJson(tmp[i]));
                      }
                    }

                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                CertificationList()) // SecondRoute를 생성하여 적재
                    );
                  },
                  child: Container(width: screenWidth,height: screenWidth*(40/360),color: Colors.white, child:
                  Row(children: [
                    SizedBox(width: screenWidth*(24/360),),
                    Text("신분증리스트",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff222222)),),
                  ],),),
                ):Container(),
                adminCheck == true? Container(height: 1,width: screenWidth,color: Color(0xfff8f8f8),):Container(),
                SizedBox(
                  height:30,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        onPressed: (){
                          _launchUrl('https://www.instagram.com/nbnb_app/');
                        },
                        child: Image.asset('assets/images/moreScreen/instagram.png',width: 25,)),
                    Container(width: 24,),
                    FlatButton(
                        onPressed: (){
                          _launchUrl('https://www.facebook.com/nbnbapp/');
                        },
                        child: Image.asset('assets/images/moreScreen/facebook.png',width: 25,)),
                  ],),

                Container(
                    width: screenWidth * (336 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: (){
                            Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UsingRule()) // SecondRoute를 생성하여 적재
                            );
                          },
                          child: Text(
                            "이용약관",
                            style: TextStyle(
                                fontSize: screenHeight * (10 / 640),
                                color: Color(0xff888888)),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(
                              fontSize: screenHeight * (10 / 640),
                              color: Color(0xff888888)),
                        ),
                        FlatButton(
                          onPressed: (){
                            Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PersonalInfoRule()) // SecondRoute를 생성하여 적재
                            );
                          },
                          child: Text(
                            "개인정보 처리방침",
                            style: TextStyle(
                                fontSize: screenHeight * (10 / 640),
                                color: Color(0xff888888)),
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(
                              fontSize: screenHeight * (10 / 640),
                              color: Color(0xff888888)),
                        ),
                        FlatButton(
                          onPressed: (){
                            _launchUrl('http://nbnbapp.com/');
                          },
                          child: Text(
                            "회사소개",
                            style: TextStyle(
                                fontSize: screenHeight * (10 / 640),
                                color: Color(0xff888888)),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                    height: 4
                ),
                Container(
                    width: screenWidth * (336 / 360),
                    child: Center(
                      child: Text(
                        "© Copyright 2020, 내방니방(MRYR)",
                        style: TextStyle(
                            fontSize: screenHeight * (10 / 640),
                            color: Color(0xff888888)),
                      ),
                    )),
                SizedBox(
                  height: screenHeight * (44 / 640),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
