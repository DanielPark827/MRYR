import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/NeedRoomSalesInfoListScreen.dart';
import 'package:mryr/screens/Review/ReviewScreenInMapMain.dart';
import 'package:mryr/screens/TutorialScreen.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/NoticeInMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/dummyData/DummyUser.dart';

class ReviewScreenInMapMainDetail extends StatefulWidget {
  final RoomSalesInfo roomSalesInfo;
  final bool isRoom;
  final Review review;

  ReviewScreenInMapMainDetail({Key key, @required this.review,this.roomSalesInfo,this.isRoom}) : super(key: key);
  @override
  _ReviewScreenInMapMainDetailState createState() =>
      _ReviewScreenInMapMainDetailState();
}

class _ReviewScreenInMapMainDetailState
    extends State<ReviewScreenInMapMainDetail>with SingleTickerProviderStateMixin {
  Future<bool> init() async {
    if (null != GlobalProfile.roomSalesInfo) {
      return true;
    } else {
      print('no');
      return false;
    }
  }
  int reviewLen = GlobalProfile.detailReviewList.length;

  AnimationController extendedController;
  final _scrollController = ScrollController();
  int starrating = -1;
  var starColor = Color(0xffeeeeee);

  void initState() {
    super.initState();
    doubleCheck = false;
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    doubleCheck = false;
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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


    double starA = 0;
    for(int i =0;i< GlobalProfile.detailReviewList.length;i++){
      starA +=int.parse(GlobalProfile.detailReviewList[i].StarRating);
    }


    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DummyUser data2 = Provider.of<DummyUser>(context);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.pop(context);
            return;
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.19375,
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
                              SizedBox(height: screenHeight * 0.01875),
                              Container(
                                width: screenWidth * 0.3333333,
                                height: screenHeight * 0.15625,
                                child: ClipRRect(
                                    borderRadius:
                                    new BorderRadius.circular(4.0),
                                    child:widget.isRoom == true?
                                    widget.roomSalesInfo
                                        .imageUrl1==
                                        "BasicImage"
                                        ? SvgPicture.asset(
                                      mryrInReviewScreen,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                    )
                                        : Container(

                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: getExtendedImage(
                                            get_resize_image_name(widget.roomSalesInfo.imageUrl1,360),
                                            0,
                                            extendedController),
                                      ),
                                    )
                                        :
                                    widget.review
                                        .ImageUrl ==
                                        "BasicImage"
                                        ? SvgPicture.asset(
                                      mryrInReviewScreen,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                    )
                                        : Container(

                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: getExtendedImage(
                                            get_resize_image_name(widget.review.ImageUrl,360),
                                            0,
                                            extendedController),
                                      ),
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: screenWidth * 0.033333,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: screenHeight * 0.01875),
                                      SizedBox(
                                        width: screenWidth * (185 / 360),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              star,
                                              width: screenWidth * (19 / 360),
                                              height:
                                              screenWidth * (19 / 360),
                                              color:widget.isRoom == true?starA/GlobalProfile.detailReviewList.length >=1
                                                  ? kPrimaryColor
                                                  : starColor: widget.review
                                                  .StarAvg>= 1
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
                                              color: widget.isRoom == true?starA/GlobalProfile.detailReviewList.length >=2
                                                  ? kPrimaryColor
                                                  : starColor:  widget.review
                                                  .StarAvg>= 2
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
                                              color: widget.isRoom == true?starA/GlobalProfile.detailReviewList.length >=3
                                                  ? kPrimaryColor
                                                  : starColor: widget.review
                                                  .StarAvg>= 3
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
                                              color: widget.isRoom == true?starA/GlobalProfile.detailReviewList.length >=4
                                                  ? kPrimaryColor
                                                  : starColor:  widget.review
                                                  .StarAvg>= 4
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
                                              color:widget.isRoom == true?starA/GlobalProfile.detailReviewList.length >=5
                                                  ? kPrimaryColor
                                                  : starColor:   widget.review
                                                  .StarAvg>= 5
                                                  ? kPrimaryColor
                                                  : starColor,
                                            ),
                                            SizedBox(
                                              width: screenWidth * (5 / 360),
                                            ),
                                            Text(
                                              ( widget.isRoom == true? (starA/GlobalProfile.detailReviewList.length).toStringAsFixed(1):  widget.review
                                                  .StarAvg.toStringAsFixed(1) )+"점",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                  screenWidth * (10 / 360),
                                                  color:widget.isRoom == true? starA/GlobalProfile.detailReviewList.length >=1? kPrimaryColor
                                                      : Color(0xffeeeeee):  widget.review
                                                      .StarAvg!= -1
                                                      ? kPrimaryColor
                                                      : Color(0xffeeeeee)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * (9 / 640),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "매물 종류",
                                    style: TextStyle(
                                        fontSize: screenWidth * (12 / 360),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: screenWidth * (8 / 360),
                                  ),
                                  Text(
                                    widget.isRoom == true?widget.roomSalesInfo.type==null?" ":widget.roomSalesInfo.type==0?"원룸": widget.roomSalesInfo.type==1?"투룸 이상":widget.roomSalesInfo.type==2?"오피스텔":"아파트": widget.review.Type==0?"원룸": widget.review.Type==1?"투룸 이상":widget.review.Type==2?"오피스텔":"아파트",
                                    style: TextStyle(
                                      fontSize:
                                      screenWidth *
                                          (12 / 360),),
                                  )
                                ],
                              ),
                              Container(

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(

                                      "매물 위치",
                                      style: TextStyle(
                                          fontSize: screenWidth * (12 / 360),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: screenWidth * (8 / 360),
                                    ),
                                    Container(
                                      width: screenWidth *
                                          (148 / 360),

                                      child:  Text(
                                        widget.isRoom == true?widget.roomSalesInfo.location+"\n"+widget.roomSalesInfo.locationDetail:  widget.review.Location+"\n"+widget.review.LocationDetail,
                                        style: TextStyle(
                                          fontSize:
                                          screenWidth *
                                              (12 /
                                                  360),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  reviewLen == 0? Container(): Container(
                      width: screenWidth,
                      height: screenHeight * (8 / 640),
                      color: Color(0xffeeeeee)),
                  reviewLen == 0? Container(): Container(
                    width: screenWidth,
                    height: screenHeight * (111 / 640),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (12 / 640),
                            ),
                            Row(
                              children: [
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
                              children: [
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
                              children: [
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      width: screenWidth,
                      height: screenHeight * (8 / 640),
                      color: Color(0xffeeeeee)),
                  Column(
                    children: [
                      SizedBox(
                        height: screenHeight * (20 / 640),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          Text(
                            "상세후기(" + "$reviewLen" + ")",
                            style: TextStyle(
                                fontSize: screenWidth * (16 / 360),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (20 / 640),
                      ),
                      ListView.builder(
                          controller: _scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount:GlobalProfile.detailReviewList.length,
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
                                              Container(

                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      GlobalProfile.detailReviewList[index].user.Nickname,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
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
                                              ),
                                              Spacer(),
                                              GlobalProfile.detailReviewList[index].startdate != null && GlobalProfile.detailReviewList[index].enddate != null?Container(
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
                                            height: screenHeight * (20 / 640),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width:
                                                screenWidth * (158 / 360),
                                                child: Text(
                                                  "집 주변이 시끄러웠나요?",
                                                  style: TextStyle(
                                                      fontSize: screenWidth *
                                                          (12 / 360),
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                GlobalProfile.detailReviewList[index].HowNoise==0?"\"조용했어요\"":
                                                GlobalProfile.detailReviewList[index].HowNoise==1?"\"보통이었어요\"":
                                                GlobalProfile.detailReviewList[index].HowNoise==2?"\"시끄러웠어요\"":
                                                "",
                                                style: TextStyle(
                                                  fontSize:
                                                  screenWidth * (12 / 360),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * (8 / 640),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width:
                                                screenWidth * (158 / 360),
                                                child: Text(
                                                  "집에 벌레가 있었나요?",
                                                  style: TextStyle(
                                                      fontSize: screenWidth *
                                                          (12 / 360),
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                GlobalProfile.detailReviewList[index].HowBug==0?"\"벌레가 없었어요\"":
                                                GlobalProfile.detailReviewList[index].HowBug==1?"\"보통이었어요\"":
                                                GlobalProfile.detailReviewList[index].HowBug==2?"\"벌레가 많이 나왔어요\"":
                                                "",
                                                style: TextStyle(
                                                  fontSize:
                                                  screenWidth * (12 / 360),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * (8 / 640),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width:
                                                screenWidth * (158 / 360),
                                                child: Text(
                                                  "집주인이 친절했나요?",
                                                  style: TextStyle(
                                                      fontSize: screenWidth *
                                                          (12 / 360),
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              Text(
                                                GlobalProfile.detailReviewList[index].HowKind==0?"\"친절했어요\"":
                                                GlobalProfile.detailReviewList[index].HowKind==1?"\"보통이었어요\"":
                                                GlobalProfile.detailReviewList[index].HowKind==2?"\"불친절했어요\"":
                                                "",
                                                style: TextStyle(
                                                  fontSize:
                                                  screenWidth * (12 / 360),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: screenHeight * (16 / 640),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                index == GlobalProfile.detailReviewList.length-1 ?
                                Container(
                                    width: screenWidth,
                                    height: screenHeight * (8 / 640),
                                    color: Color(0xffeeeeee)): Divider(height: 3,color: OptionDivideLineColor,),
                              ],
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
