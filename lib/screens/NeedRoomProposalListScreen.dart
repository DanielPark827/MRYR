import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';

class NeedRoomProposalListScreen extends StatefulWidget {
  @override
  _NeedRoomProposalListScreenState createState() => _NeedRoomProposalListScreenState();
}

class _NeedRoomProposalListScreenState extends State<NeedRoomProposalListScreen>with SingleTickerProviderStateMixin {


  AnimationController extendedController;
  @override
  void initState() {
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;


    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenWidth * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                height: screenHeight*(20/640),),
              Container(
                padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                width: screenWidth,
                color: Colors.white,
                child: Text(
                  "나에게 온 제안 목록",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
              ),
              Container(
                color: Colors.white,
                height: screenHeight*(12/640),),
              GlobalProfile.roomList.length == 0 ?
               Container(
                 height: screenHeight * (420/640),
                 child: Center(
                   child: SvgPicture.asset('assets/images/releaseRoomScreen/BasicProposalmage.svg'),
                 ),
               )
              :
              ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: GlobalProfile.roomList.length ,
                itemBuilder: (BuildContext context, int index) =>
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            //await AddRecent(index);
                            Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailedRoomInformation(
                                          roomSalesInfo: GlobalProfile.roomList[index],
                                        )) // SecondRoute를 생성하여 적재
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            width: screenWidth,
                            height: screenHeight * 0.19375,
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
                                      child:
                                      GlobalProfile.roomList[index].imageUrl1=="BasicImage"
                                          ?
                                      SvgPicture.asset(
                                        ProfileIconInMoreScreen,
                                        width: screenHeight * (60 / 640),
                                        height: screenHeight * (60 / 640),
                                      )
                                          :
                                      FittedBox(
                                          fit: BoxFit.cover,
                                          child: getExtendedImage( get_resize_image_name(GlobalProfile.roomList[index].imageUrl1,360), 0,extendedController),


                                      )


                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.033333,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: screenWidth * 0.011111,
                                        children: List<Widget>.generate(
                                            DummyRoomList[0].RoomTags.length, (int i) {
                                          return Container(
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
                                                  "${DummyRoomList[0].RoomTags[i % 3]}",
                                                  style: TextStyle(
                                                      fontSize: screenHeight * 0.015625,
                                                      color: kPrimaryColor,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              new BorderRadius.circular(4.0),
                                              color: hexToColor("#E5E5E5"),
                                            ),
                                          );
                                        }),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.00625,
                                      ),
                                      Text(
                                        GlobalProfile.roomList[index].monthlyRentFees.toString() +
                                            '만원 / 월',
                                        style: TextStyle(
                                            fontSize: screenHeight * 0.025,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.00625,
                                      ),
                                      Text(
                                        GlobalProfile.roomList[index].information,
                                        style: TextStyle(

                                            color: hexToColor("#888888")),
                                      )
                                    ],
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                      onTap: () async {
                                        getRoomSalesInfoByID(GlobalProfile.roomList[index].id).ChangeLikesWithValue(!getRoomSalesInfoByID(GlobalProfile.roomList[index].id).Likes);
                                        setState(() {
                                        });
                                      },
                                      child:  SvgPicture.asset(
                                        getRoomSalesInfoByID(GlobalProfile.roomList[index].id).Likes == false ?GreyEmptyHeartIcon : PurpleFilledHeartIcon,
                                        width: screenHeight * 0.0375,
                                        height: screenHeight * 0.0375,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * (4/640),),
                      ],
                    ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
