import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradingState extends StatefulWidget {
  bool flag;

  TradingState({Key key, this.flag,}) : super(key : key);

  @override
  _TradingStateState createState() => _TradingStateState();
}

class _TradingStateState extends State<TradingState>with SingleTickerProviderStateMixin {

  bool selectedLeft ;

  List<RoomSalesInfo> ongoingList = [];
 // List<RoomSalesInfo> completedList = [];
  AnimationController extendedController;
  @override
  void initState() {

    selectedLeft = widget.flag;

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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedLeft = true;
                      });

                    },
                    child: Container(
                      height: screenHeight*0.0675,
                      width: screenWidth /2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight*0.0140625,
                          ),
                          Text(
                            '거래 진행중',
                            style: TextStyle(
                              fontSize: screenWidth*0.044444,
                              color: selectedLeft ? kPrimaryColor : hexToColor('#888888'),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.0109375,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedLeft = false;
                      });
                    },
                    child: Container(
                      height: screenHeight*0.0675,
                      width: screenWidth /2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight*0.0140625,
                          ),
                          Text(
                            '거래완료',
                            style: TextStyle(
                              fontSize: screenWidth*0.044444,
                              color: selectedLeft ? hexToColor('#888888') : kPrimaryColor,
                            ),
                          ),
                          SizedBox(height: screenHeight*0.0109375,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 200),
                alignment: selectedLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  height: screenHeight*0.003125,
                  width: screenWidth /2,
                  decoration: BoxDecoration(
                      color: kPrimaryColor
                  ),
                )
            ),
            SizedBox(height: screenHeight*0.0125,),
            selectedLeft == true ?
            GlobalProfile.tradingList == null? Container():  Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: GlobalProfile.tradingList.length ,
                itemBuilder: (BuildContext context, int index) =>
                    Column(
                      children: [
                        Container(
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
                                    GlobalProfile.tradingList[index].imageUrl1=="BasicImage"
                                        ?
                                    SvgPicture.asset(
                                      ProfileIconInMoreScreen,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                    )
                                        :  FittedBox(
                                        fit: BoxFit.cover,
                                        child: getExtendedImage( get_resize_image_name(GlobalProfile.tradingList[index].imageUrl1,360), 0,extendedController),
                                    )
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.033333,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenWidth*0.503888,//가로 사이즈에 따라 다이나믹하게 가로에 배치되게 처리하자~!
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
                                                     GlobalProfile.tradingList[index].preferenceTerm == 2 ? "하루가능" :GlobalProfile.tradingList[index].preferenceTerm == 1 ? "1개월이상" : "기관무관",
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
                                                      GlobalProfile.tradingList[index].preferenceSmoking == 2 ? "흡연가능" : GlobalProfile.tradingList[index].preferenceSmoking == 1 ? "흡연불가" : "흡연무관",
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
                                                      GlobalProfile.tradingList[index].preferenceSex == 2 ? "남자선호" : GlobalProfile.tradingList[index].preferenceSmoking == 1 ? "여자선호" : "성별무관",
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
                                    SizedBox(
                                      height: screenHeight * 0.00625,
                                    ),
                                    Text(
                                    GlobalProfile.tradingList[index].monthlyRentFeesOffer.toString() +
                                        '만원 / 월',
                                    style: TextStyle(
                                        fontSize: screenHeight * 0.025,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.00625,
                                  ),

                                    Text(
                                      GlobalProfile.tradingList[index].information,
                                      maxLines : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(

                                          color: hexToColor("#888888")),
                                    )
                                  ],
                                ),



                              ],
                            ),
                          ),
                        ),
                        Row(children: [
                          SizedBox(width: screenWidth*(12/360),),
                          Container(
                            width: screenWidth*(164/360),
                            height: screenHeight*(32/640),
                            decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffcccccc)),//Border.all(color:  kPrimaryColor),
                            color: Color(0xffcccccc),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(child:  Text("거래 완료하기",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360),color: Colors.white),),),

                          ),
                          SizedBox(width: screenWidth*(8/360),),
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailedRoomInformation(
                                            roomSalesInfo:  GlobalProfile.tradingList[index],
                                          )) // SecondRoute를 생성하여 적재
                              );
                            },
                            child: Container(
                              width: screenWidth*(164/360),
                              height: screenHeight*(32/640),
                              decoration: BoxDecoration(
                                border: Border.all(color:  kPrimaryColor),
                                color:Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(child:  Text("상세페이지",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(12/360),color: kPrimaryColor),),),

                            ),
                          )
                        ],),
                        SizedBox(height: screenHeight*(20/640),)
                      ],
                    ),
              ),
            )
                :
                Container(),
          ],
        ),
      ),
    );
  }
}
