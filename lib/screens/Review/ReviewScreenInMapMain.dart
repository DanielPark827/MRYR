import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/Review/ReviewScreenInMapDetail.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:provider/provider.dart';
import 'package:mryr/widget/Public/floatButtonWithListIcon.dart';

import 'ReviewScreenInMap.dart';
import 'package:mryr/model/google_map_place.dart';
import 'package:mryr/screens/Review/addressComplteForReview.dart';

import 'ReviewScreenInMap2.dart';

final PurpleMenuIcon = 'assets/images/Map/PurpleMenuIcon.svg';

class ReviewScreenInMapMain extends StatefulWidget {
  @override
  _ReviewScreenInMapMainState createState() => _ReviewScreenInMapMainState();
}

class _ReviewScreenInMapMainState extends State<ReviewScreenInMapMain>
    with SingleTickerProviderStateMixin {
  AnimationController extendedController;
  double animatedHeight1 = 0.0;
  double animatedHeight2 = 0.0;
  double animatedHeight3 = 0.0;
  bool res = false;
  GlobalKey<RefreshIndicatorState> refreshKey;
  ScrollController _scrollController;

  void initState() {
    refreshKey = GlobalKey<RefreshIndicatorState>();

    _scrollController = ScrollController();

    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    extendedController.dispose();
  }

  final Start = TextEditingController();
  final End = TextEditingController();

  bool getM = false;

  Future _getMoreData() async {
    Timer(Duration(milliseconds: 200), () async {
      var tmp;
      if(filter ==false) {
        tmp = await ApiProvider().post(
            '/Review/SelectListLonlat/Offset', jsonEncode(
            {
              "option": false,
              "index": GlobalProfile.reviewList.length.toString()
            }
        ));
        if(tmp != null){
          for(int i =0;i<tmp.length;i++){
            GlobalProfile.reviewList.add(Review.fromJson(tmp[i]));
          }
        }
      }
      else{
        tmp = await ApiProvider().post(
            '/Review/SelectListLonlat/Offset', jsonEncode(
            {
              "option": true,
              "index": GlobalProfile.reviewListStar.length.toString()
            }
        ));
        if(tmp != null){
          for(int i =0;i<tmp.length;i++){
            GlobalProfile.reviewListStar.add(Review.fromJson(tmp[i]));
          }
        }
      }

      setState(() {

      });
    });

  }

  bool FlagForFilter = false;

  int starrating = -1;
  var starColor = Color(0xffeeeeee);

  bool filter = false;
  String location ="주소 검색";
  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final SearchController = TextEditingController();

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: RefreshIndicator(
              key: refreshKey,
              onRefresh: () async {
                if ( filter ==false) {
                  GlobalProfile.reviewList.clear();

                  var reviewList = await ApiProvider().post('/Review/SelectListLonlat', jsonEncode({
                    "option" : false
                  }));

                  if(reviewList != null){
                    for(int i = 0 ; i < reviewList.length; ++i){
                      GlobalProfile.reviewList.add(Review.fromJson(reviewList[i]));
                    }
                  }

                } else {
                  GlobalProfile.reviewListStar.clear();

                  var reviewListRecent = await ApiProvider()
                      .post('/Review/SelectListLonlat',
                      jsonEncode({"option": true}));

                  if (reviewListRecent != null) {
                    for (int i = 0;
                    i < reviewListRecent.length;
                    ++i) {
                      GlobalProfile.reviewListStar.add(
                          Review.fromJson(
                              reviewListRecent[i]));
                    }
                  }

                }
                setState(() {});
              },
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * (18 / 640),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //    SizedBox(width: screenWidth*(12/360),),
                          ButtonTheme(
                            minWidth: screenHeight * 0.05,
                            height: screenHeight * 0.05,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            buttonColor: Colors.white,
                            child: RaisedButton(
                              elevation: 0,
                              onPressed: () {
                               Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                backArrow,
                                width: screenHeight * 0.03125,
                                height: screenHeight * 0.03125,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async{
                              PlaceDetail item = await Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => addressComplteForReview(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                              location = item.name;


                              GlobalProfile.filteredReview.clear();

                              var filteredReview = await ApiProvider().post('/Review/SelectMarkerLonlat', jsonEncode({
                                "longitude": item.lng,
                                "latitude": item.lat,
                              }));
                              if(filteredReview != null) {
                                GlobalProfile.filteredReview.add(
                                    Review.fromJson(filteredReview));
                              }
                              else{
                                filteredReview = await ApiProvider().post('/Review/SelectMarker', jsonEncode({
                                  "location": location,
                                }));
                                GlobalProfile.filteredReview.add(
                                    Review.fromJson(filteredReview));
                              }

                              setState(() {

                              });
                            },
                            child: Container(
                              width: screenWidth * (299 / 360),
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(8.0),
                                color: hexToColor("#EEEEEE"),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.0222222,
                                  ),
                                  SvgPicture.asset(
                                    GreyMagnifyingGlass,
                                    width: screenHeight * 0.025,
                                    height: screenHeight * 0.025,
                                  ),
                                  SizedBox(
                                    width: screenWidth * (10 / 360),
                                  ),
                                  Text(
                                    '$location',
                                    style: TextStyle(
                                        fontSize: screenWidth * (12 / 360),
                                        color: location == "주소 검색"
                                            ? Color(0xff928E8E)
                                            : Colors.black),),
                                  Spacer(),
                                  IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        location ="주소 검색";
                                        setState(() {
                                          FlagForFilter = false;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        color: Color(0xFFCCCCCC),
                                        size: screenWidth * 0.0333333333333333,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (12 / 640),
                      ),
                      FlagForFilter ==true?
                      Container():
                      Container(
                        width: screenWidth,
                        decoration: BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
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
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async{
                                      _scrollController.animateTo(
                                        0.0,
                                        curve: Curves.easeOut,
                                        duration: const Duration(milliseconds: 300),
                                      );
                                      filter = false;
                                      GlobalProfile.reviewList.clear();

                                      var reviewList = await ApiProvider().post('/Review/SelectListLonlat', jsonEncode({
                                        "option" : false
                                      }));

                                      if(reviewList != null){
                                        for(int i = 0 ; i < reviewList.length; ++i){
                                          GlobalProfile.reviewList.add(Review.fromJson(reviewList[i]));
                                        }
                                      }

                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: filter == false
                                                ? kPrimaryColor
                                                : Color(0xff888888)),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomLeft: Radius.circular(8)),
                                      ),
                                      width: screenWidth * (50 / 360),
                                      height: screenHeight * (32 / 640),
                                      child: Center(
                                        child: Text(
                                          "최신순",
                                          style: TextStyle(
                                              fontSize:
                                                  screenWidth * (12 / 360),
                                              color: filter == false
                                                  ? kPrimaryColor
                                                  : Color(0xff888888)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      _scrollController.animateTo(
                                        0.0,
                                        curve: Curves.easeOut,
                                        duration: const Duration(milliseconds: 300),
                                      );
                                      filter = true;

                                      GlobalProfile.reviewListStar.clear();

                                      var reviewListRecent = await ApiProvider()
                                          .post('/Review/SelectListLonlat',
                                              jsonEncode({"option": true}));

                                      if (reviewListRecent != null) {
                                        for (int i = 0;
                                            i < reviewListRecent.length;
                                            ++i) {
                                          GlobalProfile.reviewListStar.add(
                                              Review.fromJson(
                                                  reviewListRecent[i]));
                                        }
                                      }

                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: filter == true
                                                ? kPrimaryColor
                                                : Color(0xff888888)),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8)),
                                      ),
                                      width: screenWidth * (50 / 360),
                                      height: screenHeight * (32 / 640),
                                      child: Center(
                                        child: Text(
                                          "별점순",
                                          style: TextStyle(
                                              fontSize:
                                                  screenWidth * (12 / 360),
                                              color: filter == true
                                                  ? kPrimaryColor
                                                  : Color(0xff888888)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * (12 / 360),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (20 / 640),
                      ),
                      Container(
                        width: screenWidth,
                        child: Center(
                          child: Container(
                            width: screenWidth * (20 / 360),
                            height: screenHeight * (2 / 640),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(8.0),
                              color: Color(0xffc4c4c4),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (10 / 640),
                      ),
                      FlagForFilter == true?

                      GlobalProfile.filteredReview ==null||GlobalProfile.filteredReview.length==0?
                      Container(

                      ):
                      GestureDetector(
                        onTap: () async {


                          GlobalProfile.detailReviewList.clear();

                          double finalLat;
                          double finalLng;
                          if(null == GlobalProfile
                              .filteredReview[0].lng || null == GlobalProfile
                              .filteredReview[0].lat) {
                            var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(GlobalProfile
                                .filteredReview[0].Location);
                            var first = addresses.first;

                            finalLat = first.coordinates.latitude;
                            finalLng = first.coordinates.longitude;
                          } else {
                            finalLat =GlobalProfile
                                .filteredReview[0].lat;
                            finalLng = GlobalProfile
                                .filteredReview[0].lng;
                          }
                          var detailReviewList= await ApiProvider()
                              .post('/Review/ReviewListLngLat', jsonEncode({
                            "longitude":finalLng,
                            "latitude":finalLat,
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

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      ReviewScreenInMapMainDetail( review : GlobalProfile
                                          .filteredReview[0])));
                        },
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.19375,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.033333,
                              //  right: screenWidth * 0.033333,
                            ),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                        height: screenHeight *
                                            0.01875),
                                    Container(
                                      width:
                                      screenWidth * 0.3333333,
                                      height:
                                      screenHeight * 0.15625,
                                      child: ClipRRect(
                                          borderRadius:
                                          new BorderRadius
                                              .circular(4.0),
                                          child: GlobalProfile
                                              .filteredReview[0]
                                              .ImageUrl ==
                                              "BasicImage"
                                              ? SvgPicture.asset(
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
                                              : FittedBox(
                                            fit: BoxFit
                                                .cover,
                                            child: getExtendedImage(
                                                get_resize_image_name(
                                                    GlobalProfile
                                                        .filteredReview[0]
                                                        .ImageUrl,
                                                    360),
                                                0,
                                                extendedController),
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: screenWidth * 0.033333,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          children: [
                                            SizedBox(
                                                height:
                                                screenHeight *
                                                    0.01875),
                                            SizedBox(
                                              width: screenWidth *
                                                  (185 / 360),
                                              child: Row(
                                                children: [
                                                  SvgPicture
                                                      .asset(
                                                    star,
                                                    width: screenWidth *
                                                        (19 /
                                                            360),
                                                    height:
                                                    screenWidth *
                                                        (19 /
                                                            360),
                                                    color: GlobalProfile
                                                        .filteredReview[0]
                                                        .StarAvg >=
                                                        1
                                                        ? kPrimaryColor
                                                        : starColor,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth *
                                                        (5 / 360),
                                                  ),
                                                  SvgPicture
                                                      .asset(
                                                    star,
                                                    width: screenWidth *
                                                        (19 /
                                                            360),
                                                    height:
                                                    screenWidth *
                                                        (19 /
                                                            360),
                                                    color: GlobalProfile
                                                        .filteredReview[0]
                                                        .StarAvg >=
                                                        2
                                                        ? kPrimaryColor
                                                        : starColor,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth *
                                                        (5 / 360),
                                                  ),
                                                  SvgPicture
                                                      .asset(
                                                    star,
                                                    width: screenWidth *
                                                        (19 /
                                                            360),
                                                    height:
                                                    screenWidth *
                                                        (19 /
                                                            360),
                                                    color: GlobalProfile
                                                        .filteredReview[0]
                                                        .StarAvg >=
                                                        3
                                                        ? kPrimaryColor
                                                        : starColor,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth *
                                                        (5 / 360),
                                                  ),
                                                  SvgPicture
                                                      .asset(
                                                    star,
                                                    width: screenWidth *
                                                        (19 /
                                                            360),
                                                    height:
                                                    screenWidth *
                                                        (19 /
                                                            360),
                                                    color: GlobalProfile
                                                        .filteredReview[0]
                                                        .StarAvg >=
                                                        4
                                                        ? kPrimaryColor
                                                        : starColor,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth *
                                                        (5 / 360),
                                                  ),
                                                  SvgPicture
                                                      .asset(
                                                    star,
                                                    width: screenWidth *
                                                        (19 /
                                                            360),
                                                    height:
                                                    screenWidth *
                                                        (19 /
                                                            360),
                                                    color: GlobalProfile
                                                        .filteredReview[0]
                                                        .StarAvg >=
                                                        5
                                                        ? kPrimaryColor
                                                        : starColor,
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth *
                                                        (5 / 360),
                                                  ),
                                                  Text(
                                                    GlobalProfile
                                                        .filteredReview[0]
                                                        .StarAvg.toString() +"점",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: screenWidth *
                                                            (10 /
                                                                360),
                                                        color: kPrimaryColor
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight *
                                          (9 / 640),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "매물 종류",
                                          style: TextStyle(
                                              fontSize:
                                              screenWidth *
                                                  (12 / 360),
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                        SizedBox(
                                          width: screenWidth *
                                              (8 / 360),
                                        ),
                                        Text(
                                          GlobalProfile.filteredReview[0].Type==0?"원룸": GlobalProfile.filteredReview[0].Type==1?"투룸 이상":GlobalProfile.filteredReview[0].Type==2?"오피스텔":"아파트",
                                          style: TextStyle(
                                            fontSize:
                                            screenWidth *
                                                (12 / 360),),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: screenHeight *
                                          (41 / 640),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "매물 위치",
                                            style: TextStyle(
                                                fontSize:
                                                screenWidth *
                                                    (12 /
                                                        360),
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          SizedBox(
                                            width: screenWidth *
                                                (8 / 360),
                                          ),
                                          Container(
                                            width: screenWidth *
                                                (148 / 360),
                                            height: screenHeight *
                                                (41 / 640),
                                            child:  Text(
                                              GlobalProfile.filteredReview[0].Location+GlobalProfile.filteredReview[0].LocationDetail,
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

                                    Container(
                                      width: screenWidth *
                                          (205 / 360),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text(
                                            timeCheck(
                                                GlobalProfile.filteredReview[0].createdAt
                                                    .toString()),
                                            style: TextStyle(
                                                fontSize:
                                                screenWidth *
                                                    (10 /
                                                        360),
                                                color: Color(
                                                    0xff888888)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          :filter == false?(GlobalProfile.reviewList == null)
                          ? Container()
                          : Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (ScrollNotification scrollInfo) {

                                  if (scrollInfo.metrics.pixels+200 >=
                                      scrollInfo.metrics.maxScrollExtent &&getM == false) {
                                    getM = true;
                                    _getMoreData();
                                    // start loading data

                                 setState(() {

                                 });

                                  }
                                  getM = false;
                                  return;
                                },
                                child: ListView.builder(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(
                                        parent: AlwaysScrollableScrollPhysics()),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: GlobalProfile.reviewList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () async {

                                          if(doubleCheck == false) {
                                            doubleCheck = true;
                                            GlobalProfile.detailReviewList
                                                .clear();

                                            double finalLat;
                                            double finalLng;
                                            if (null == GlobalProfile
                                                .reviewList[index].lng ||
                                                null == GlobalProfile
                                                    .reviewList[index].lat) {
                                              var addresses = await Geocoder
                                                  .google(
                                                  'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                                  .findAddressesFromQuery(
                                                  GlobalProfile
                                                      .reviewList[index]
                                                      .Location);
                                              var first = addresses.first;

                                              finalLat =
                                                  first.coordinates.latitude;
                                              finalLng =
                                                  first.coordinates.longitude;
                                            } else {
                                              finalLat = GlobalProfile
                                                  .reviewList[index].lat;
                                              finalLng = GlobalProfile
                                                  .reviewList[index].lng;
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
                                                                .reviewList[index])));
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              width: screenWidth,
                                              height:
                                              screenHeight * 0.15625,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: screenWidth * 0.033333,
                                                  //  right: screenWidth * 0.033333,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              screenWidth * 0.3333333,
                                                          height:
                                                              screenHeight * 0.15625,

                                                          decoration: BoxDecoration(        color: Color(0xffcccccc),  borderRadius: BorderRadius.circular(8),),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  new BorderRadius
                                                                      .circular(4.0),
                                                              child: GlobalProfile
                                                                          .reviewList[index]
                                                                          .ImageUrl ==
                                                                      "BasicImage"
                                                                  ? SvgPicture.asset(
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
                                                                  : FittedBox(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      child: getExtendedImage(
                                                                          get_resize_image_name(GlobalProfile.reviewList[index].ImageUrl,
                                                                              360),
                                                                          0,
                                                                          extendedController),
                                                                    )),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.033333,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [

                                                                SizedBox(
                                                                  width: screenWidth *
                                                                      (185 / 360),
                                                                  child: Row(
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        star,
                                                                        width: screenWidth *
                                                                            (19 /
                                                                                360),
                                                                        height:
                                                                            screenWidth *
                                                                                (19 /
                                                                                    360),
                                                                        color: GlobalProfile
                                                                                    .reviewList[index]
                                                                                    .StarAvg >=
                                                                                1
                                                                            ? kPrimaryColor
                                                                            : starColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: screenWidth *
                                                                            (5 / 360),
                                                                      ),
                                                                      SvgPicture
                                                                          .asset(
                                                                        star,
                                                                        width: screenWidth *
                                                                            (19 /
                                                                                360),
                                                                        height:
                                                                            screenWidth *
                                                                                (19 /
                                                                                    360),
                                                                        color: GlobalProfile
                                                                                    .reviewList[index]
                                                                                    .StarAvg >=
                                                                                2
                                                                            ? kPrimaryColor
                                                                            : starColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: screenWidth *
                                                                            (5 / 360),
                                                                      ),
                                                                      SvgPicture
                                                                          .asset(
                                                                        star,
                                                                        width: screenWidth *
                                                                            (19 /
                                                                                360),
                                                                        height:
                                                                            screenWidth *
                                                                                (19 /
                                                                                    360),
                                                                        color: GlobalProfile
                                                                                    .reviewList[index]
                                                                                    .StarAvg >=
                                                                                3
                                                                            ? kPrimaryColor
                                                                            : starColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: screenWidth *
                                                                            (5 / 360),
                                                                      ),
                                                                      SvgPicture
                                                                          .asset(
                                                                        star,
                                                                        width: screenWidth *
                                                                            (19 /
                                                                                360),
                                                                        height:
                                                                            screenWidth *
                                                                                (19 /
                                                                                    360),
                                                                        color: GlobalProfile
                                                                                    .reviewList[index]
                                                                                    .StarAvg >=
                                                                                4
                                                                            ? kPrimaryColor
                                                                            : starColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: screenWidth *
                                                                            (5 / 360),
                                                                      ),
                                                                      SvgPicture
                                                                          .asset(
                                                                        star,
                                                                        width: screenWidth *
                                                                            (19 /
                                                                                360),
                                                                        height:
                                                                            screenWidth *
                                                                                (19 /
                                                                                    360),
                                                                        color: GlobalProfile
                                                                                    .reviewList[index]
                                                                                    .StarAvg >=
                                                                                5
                                                                            ? kPrimaryColor
                                                                            : starColor,
                                                                      ),
                                                                      SizedBox(
                                                                        width: screenWidth *
                                                                            (5 / 360),
                                                                      ),
                                                                      Text(
                                                                        GlobalProfile
                                                                                    .reviewList[index]
                                                                                    .StarAvg.toStringAsFixed(1) +"점",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .bold,
                                                                            fontSize: screenWidth *
                                                                                (10 /
                                                                                    360),
                                                                            color: kPrimaryColor
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: screenHeight *
                                                              (9 / 640),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "매물 종류",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth *
                                                                          (12 / 360),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              width: screenWidth *
                                                                  (8 / 360),
                                                            ),
                                                            Text(
                                                              GlobalProfile.reviewList[index].Type==0?"원룸": GlobalProfile.reviewList[index].Type==1?"투룸 이상":GlobalProfile.reviewList[index].Type==2?"오피스텔":"아파트",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  screenWidth *
                                                                      (12 / 360),),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          height: screenHeight *
                                                              (41 / 640),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "매물 위치",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenWidth *
                                                                            (12 /
                                                                                360),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                width: screenWidth *
                                                                    (8 / 360),
                                                              ),
                                                              Container(
                                                                width: screenWidth *
                                                                    (148 / 360),
                                                                height: screenHeight *
                                                                    (41 / 640),
                                                                child:  Text(
                                                                  GlobalProfile.reviewList[index].Location+" "+GlobalProfile.reviewList[index].LocationDetail,
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

                                                        Container(
                                                          width: screenWidth *
                                                              (205 / 360),
                                                          child: Row(
                                                            children: [
                                                              Spacer(),
                                                              Text(
                                                                timeCheck(
                                                                    GlobalProfile.reviewList[index].createdAt
                                                                        .toString()),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        screenWidth *
                                                                            (10 /
                                                                                360),
                                                                    color: Color(
                                                                        0xff888888)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(height:screenHeight*(10/640))
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ):
                      (GlobalProfile.reviewListStar == null)
                          ? Container()
                          : Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels+200 >=
                                scrollInfo.metrics.maxScrollExtent &&getM == false) {
                              getM = true;
                              _getMoreData();
                              // start loading data

                              setState(() {

                              });

                            }
                            getM = false;
                            return;
                          },
                          child: ListView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: GlobalProfile.reviewListStar.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {

                                        if(doubleCheck == false) {
                                          doubleCheck = true;


                                          GlobalProfile.detailReviewList
                                              .clear();

                                          double finalLat;
                                          double finalLng;
                                          if (null == GlobalProfile
                                              .reviewListStar[index].lng ||
                                              null == GlobalProfile
                                                  .reviewListStar[index].lat) {
                                            var addresses = await Geocoder
                                                .google(
                                                'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                                .findAddressesFromQuery(
                                                GlobalProfile
                                                    .reviewListStar[index]
                                                    .Location);
                                            var first = addresses.first;

                                            finalLat =
                                                first.coordinates.latitude;
                                            finalLng =
                                                first.coordinates.longitude;
                                          } else {
                                            finalLat = GlobalProfile
                                                .reviewListStar[index].lat;
                                            finalLng = GlobalProfile
                                                .reviewListStar[index].lng;
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
                                                              .reviewListStar[index])));
                                        }
                                      },
                                      child: Container(
                                        width: screenWidth,
                                        height: screenHeight * 0.19375,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: screenWidth * 0.033333,
                                            //  right: screenWidth * 0.033333,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  SizedBox(
                                                      height: screenHeight *
                                                          0.01875),
                                                  Container(
                                                    width:
                                                    screenWidth * 0.3333333,
                                                    height:
                                                    screenHeight * 0.15625,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                        new BorderRadius
                                                            .circular(4.0),
                                                        child: GlobalProfile
                                                            .reviewListStar[index]
                                                            .ImageUrl ==
                                                            "BasicImage"
                                                            ? SvgPicture.asset(
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
                                                            : FittedBox(
                                                          fit: BoxFit
                                                              .cover,
                                                            child: getExtendedImage(
                                                                          get_resize_image_name(
                                                                              GlobalProfile
                                                                                  .reviewListStar[index]
                                                                                  .ImageUrl,
                                                                              360),
                                                                          0,
                                                                          extendedController),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.033333,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                              height:
                                                              screenHeight *
                                                                  0.01875),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                (185 / 360),
                                                            child: Row(
                                                              children: [
                                                                SvgPicture
                                                                    .asset(
                                                                  star,
                                                                  width: screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  height:
                                                                  screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  color: GlobalProfile
                                                                      .reviewListStar[index]
                                                                      .StarAvg >=
                                                                      1
                                                                      ? kPrimaryColor
                                                                      : starColor,
                                                                ),
                                                                SizedBox(
                                                                  width: screenWidth *
                                                                      (5 / 360),
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  star,
                                                                  width: screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  height:
                                                                  screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  color: GlobalProfile
                                                                      .reviewListStar[index]
                                                                      .StarAvg >=
                                                                      2
                                                                      ? kPrimaryColor
                                                                      : starColor,
                                                                ),
                                                                SizedBox(
                                                                  width: screenWidth *
                                                                      (5 / 360),
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  star,
                                                                  width: screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  height:
                                                                  screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  color: GlobalProfile
                                                                      .reviewListStar[index]
                                                                      .StarAvg >=
                                                                      3
                                                                      ? kPrimaryColor
                                                                      : starColor,
                                                                ),
                                                                SizedBox(
                                                                  width: screenWidth *
                                                                      (5 / 360),
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  star,
                                                                  width: screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  height:
                                                                  screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  color: GlobalProfile
                                                                      .reviewListStar[index]
                                                                      .StarAvg >=
                                                                      4
                                                                      ? kPrimaryColor
                                                                      : starColor,
                                                                ),
                                                                SizedBox(
                                                                  width: screenWidth *
                                                                      (5 / 360),
                                                                ),
                                                                SvgPicture
                                                                    .asset(
                                                                  star,
                                                                  width: screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  height:
                                                                  screenWidth *
                                                                      (19 /
                                                                          360),
                                                                  color: GlobalProfile
                                                                      .reviewListStar[index]
                                                                      .StarAvg >=
                                                                      5
                                                                      ? kPrimaryColor
                                                                      : starColor,
                                                                ),
                                                                SizedBox(
                                                                  width: screenWidth *
                                                                      (5 / 360),
                                                                ),
                                                                Text(
                                                                  GlobalProfile
                                                                      .reviewListStar[index]
                                                                      .StarAvg.toStringAsFixed(1) +"점",

                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                      fontSize: screenWidth *
                                                                          (10 /
                                                                              360),
                                                                      color: kPrimaryColor
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: screenHeight *
                                                        (9 / 640),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "매물 종류",
                                                        style: TextStyle(
                                                            fontSize:
                                                            screenWidth *
                                                                (12 / 360),
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      SizedBox(
                                                        width: screenWidth *
                                                            (8 / 360),
                                                      ),
                                                      Text(
                                                        GlobalProfile
                                                            .reviewListStar[index].Type==0?"원룸": GlobalProfile.reviewListStar[index].Type==1?"투룸 이상":GlobalProfile.reviewListStar[index].Type==2?"오피스텔":"아파트",
                                                        style: TextStyle(
                                                          fontSize:
                                                          screenWidth *
                                                              (12 / 360),),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    height: screenHeight *
                                                        (40 / 640),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "매물 위치",
                                                          style: TextStyle(
                                                              fontSize:
                                                              screenWidth *
                                                                  (12 /
                                                                      360),
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        SizedBox(
                                                          width: screenWidth *
                                                              (8 / 360),
                                                        ),
                                                        Container(
                                                          width: screenWidth *
                                                              (148 / 360),
                                                          height: screenHeight *
                                                              (40 / 640),
                                                          child:  Text(
                                                            GlobalProfile.reviewListStar[index].Location+" "+GlobalProfile.reviewListStar[index].LocationDetail,
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
                                                  SizedBox(
                                                    height: screenHeight *
                                                        (1 / 640),
                                                  ),
                                                  Container(
                                                    width: screenWidth *
                                                        (205 / 360),
                                                    child: Row(
                                                      children: [
                                                        Spacer(),
                                                        Text(
                                                          timeCheck(
                                                              GlobalProfile.reviewListStar[index].createdAt
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontSize:
                                                              screenWidth *
                                                                  (10 /
                                                                      360),
                                                              color: Color(
                                                                  0xff888888)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton:         GestureDetector(
            onTap: () async {
              Navigator.push(
                  context, // 기본 파라미터, SecondRoute로 전달
                  MaterialPageRoute(
                      builder: (context) =>
                          ReviewScreenInMap()) // SecondRoute를 생성하여 적재
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 52,
                  width:130,
                  decoration:BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
                Container(
                    height: 52,
                    width:140,
                    child: Row(
                      children: <Widget>[
                        Container(width:13),

                        Container(child:Text("후기남기기",style: TextStyle(color:Color(0xFF222222)),)),
                        Container(width:4),

                        FloatingActionButton(heroTag: "btn2",child:Icon(Icons.add,size: 30))],mainAxisAlignment: MainAxisAlignment.end,)
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
