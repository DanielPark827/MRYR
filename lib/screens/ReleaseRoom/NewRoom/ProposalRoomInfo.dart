import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/MoreScreen/model/ModelRoomRecommend.dart';
import 'package:mryr/screens/ReleaseRoom/model/ModelRecommendedRoom.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/screens/DetailRoomWannaLive.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/screens/NeedRoomSalesInfo/model/NeedRoomSalesInfoLikes.dart';

class ProposalRoomInfo extends StatefulWidget {

  final int idx;

  ProposalRoomInfo({Key key, this.idx }) : super(key : key);
  @override
  _ProposalRoomInfoState createState() => _ProposalRoomInfoState();
}

class _ProposalRoomInfoState extends State<ProposalRoomInfo> with SingleTickerProviderStateMixin {
  AnimationController extendedController;
  final GreyQustionIcon= 'assets/images/public/GreyQustionIcon.svg';
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
  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  _getMoreData() async{
    Timer(Duration(milliseconds: 500), ()async{

      var tmp = await ApiProvider().post('/NeedRoomSalesInfo/RecommendUserList/Offset', jsonEncode(
          {
            "userID":GlobalProfile.loggedInUser.userID,
            "index" : GlobalProfile.listForMe2.length.toString(),
          }
      ));
      if(tmp != null){
        for(int i =0;i<tmp.length;i++){
          NeedRoomInfo _NeedRoomInfo= NeedRoomInfo.fromJson(tmp[i]);
          GlobalProfile.listForMe2.add(_NeedRoomInfo);
        }
      }
      else
        print("error&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    });
  }

  List<NeedRoomSalesInfoLikes> NLikesList = [];
  List<int> LikesidList = [];
  Future<bool> initReverse(BuildContext context) async {
    var list = await ApiProvider().post('/NeedRoomSalesInfo/SelectLike', jsonEncode(
        {
          "userID" : GlobalProfile.loggedInUser.userID,
        }
    ));

    if(null != list) {
      NLikesList.clear();
      LikesidList.clear();
      for(int i = 0; i < list.length; ++i){
        Map<String, dynamic> data = list[i];

        NeedRoomSalesInfoLikes item = NeedRoomSalesInfoLikes.fromJson(data);
        NLikesList.add(item);
        LikesidList.add(item.NeedRoomSaleID);
      }
      int len = GlobalProfile.listForMe2.length;
      for(int i= 0; i < len; i++) {
        if(LikesidList.contains(GlobalProfile.listForMe2[i].id)) {
          GlobalProfile.listForMe2[i].ChangeLikes(true);
        }
      }

      return true;
    } else {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return;
      },
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: ()async{
          GlobalProfile.listForMe2.clear();
          var list3 = await ApiProvider().post('/NeedRoomSalesInfo/RecommendUserPerRoom', jsonEncode(
              {
                "roomID" :GlobalProfile.roomSalesInfoList[widget.idx].id
              }
          ));
          if(list3 != null){
            for(int i = 0;i<list3.length;i++){
              GlobalProfile.listForMe2.add(NeedRoomInfo.fromJson(list3[i]));
            }
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xfff8f8f8),
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black,),
                onPressed: () {
                  Navigator.pop(context);
                  return;
                }),
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  ( GlobalProfile.listForMe2 == null||GlobalProfile.listForMe2.length == 0)?
                  Column(children: [
                    Container(
                      color: Colors.white,
                      height: screenHeight * (20 / 640),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          InkWell(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    var screenWidth = MediaQuery.of(context).size.width;
                                    var screenHeight = MediaQuery.of(context).size.height;

                                    return
                                      new AlertDialog(
                                        contentPadding: EdgeInsets.all(0.0),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8)),
                                        content: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              new BoxShadow(
                                                color: Colors.grey.withOpacity(0.25),
                                                spreadRadius: 0,
                                                blurRadius: 4,
                                                offset: Offset(1.5, 1.5),
                                              ),
                                            ],
                                          ),
                                          width: screenWidth * (300/360),
                                          height: screenHeight * (420/640),
                                          child: Column(
                                            children: [
                                              SizedBox(height: screenHeight*(28/640),),
                                              SvgPicture.asset(
                                                'assets/images/public/CompleteReleaseRoom.svg',
                                                width:screenWidth*(256/360),
                                              ),
                                              SizedBox(height: screenHeight*(14/640),),
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                                child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    width: screenWidth * (300/360),
                                                    height: screenHeight * (65/640),
                                                    decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(8.0))
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                          '내놓은 매물 보러가기',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                  }
                              );
                            },
                            child: Text(
                              "내가 내놓은 방 정보",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * (4 / 360),
                          ),


                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: screenHeight * (28 / 640),
                    ),
                    GlobalProfile.roomSalesInfoList[widget.idx] == null ?
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.209375,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '아직 등록한 방이 없습니다',
                          style: TextStyle(
                              color: hexToColor('#222222'),
                              fontSize: screenWidth*0.044444,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                        :GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context, // 기본 파라미터, SecondRoute로 전달
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailedRoomInformation(
                                      roomSalesInfo:  GlobalProfile.roomSalesInfoList[widget.idx],
                                    ))).then((value) {
                          setState(() {

                          });
                        }); // SecondRoute를 생성하여 적재
                      },
                      child: Container(
                        color: Colors.white,
                        width: screenWidth,
                        height: screenHeight * (104 / 640),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * (12 / 360),
                            ),
                            Container(
                              width: screenHeight * (104 / 640),
                              height: screenHeight * (104 / 640),
                              child: ClipRRect(
                                  borderRadius: new BorderRadius.circular(4.0),
                                  child:
                                  GlobalProfile.roomSalesInfoList[widget.idx].imageUrl1=="BasicImage"
                                      ?
                                  SvgPicture.asset(
                                    ProfileIconInMoreScreen,
                                    width: screenHeight * (60 / 640),
                                    height: screenHeight * (60 / 640),
                                  )
                                      :

                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child:   getExtendedImage(get_resize_image_name(GlobalProfile.roomSalesInfoList[widget.idx].imageUrl1,360), 0,extendedController),

                                  )

                              ),
                            ),
                            SizedBox(
                              width: screenWidth * (12 / 360),
                            ),
                            Container(
                              width: screenWidth * (200 / 360),
                              height: screenHeight * (120 / 640),
                              //color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: screenWidth * (53 / 360),
                                        height: screenHeight * (22 / 640),
                                        decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius: BorderRadius.circular(
                                              screenHeight * (4 / 640)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              GlobalProfile.roomSalesInfoList[widget.idx].preferenceTerm == 2 ? "하루가능" :
                                              GlobalProfile.roomSalesInfoList[widget.idx].preferenceTerm == 1 ? "1개월이상" : "기관무관",

                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kPrimaryColor,
                                                  fontSize: screenWidth * TagFontSize),
                                            )),
                                      ),
                                      SizedBox(
                                        width: screenWidth * (4 / 360),
                                      ),
                                      Container(
                                        width: screenWidth * (53 / 360),
                                        height: screenHeight * (22 / 640),
                                        decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius: BorderRadius.circular(
                                              screenHeight * (4 / 640)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              GlobalProfile.roomSalesInfoList[widget.idx].preferenceSmoking == 2 ? "흡연가능" : GlobalProfile.roomSalesInfoList[widget.idx].preferenceSmoking == 1 ? "흡연불가" : "흡연무관",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kPrimaryColor,
                                                  fontSize: screenWidth * TagFontSize),
                                            )),
                                      ),
                                      SizedBox(
                                        width: screenWidth * (4 / 360),
                                      ),
                                      Container(
                                        width: screenWidth * (53 / 360),
                                        height: screenHeight * (22 / 640),
                                        decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius: BorderRadius.circular(
                                              screenHeight * (4 / 640)),
                                        ),
                                        child: Center(
                                            child: Text(
                                              GlobalProfile.roomSalesInfoList[widget.idx].preferenceSex == 2 ? "남자선호" : GlobalProfile.roomSalesInfoList[widget.idx].preferenceSmoking == 1 ? "여자선호" : "성별무관",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kPrimaryColor,
                                                  fontSize: screenWidth * TagFontSize),
                                            )),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * (8 / 640),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        GlobalProfile.roomSalesInfoList[widget.idx].monthlyRentFeesOffer.toString() ,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * (16 / 360)),
                                      ),
                                      Text(
                                        "만원",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * (16 / 360)),
                                      ),
                                      Text(
                                        " / 월",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * (16 / 360)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * (8 / 640),
                                  ),
                                  Text(
                                    GlobalProfile.roomSalesInfoList[widget.idx].termOfLeaseMin +
                                        '~' +
                                        GlobalProfile.roomSalesInfoList[widget.idx].termOfLeaseMax,
                                    style: TextStyle(color: hexToColor("#888888")),
                                  ),
                                  SizedBox(
                                    height: screenHeight * (4 / 640),
                                  ),
                                  Container(
                                    width: screenWidth*0.45,
                                    child: Text(
                                      GlobalProfile.roomSalesInfoList[widget.idx].information,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(

                                          color: hexToColor("#888888")),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: screenHeight * (16 / 640),
                    ),
                    SizedBox(height: screenHeight*(12/640),),
                    Container(color: Colors.white,height: screenHeight*(54/640),width: screenWidth,
                      child: Column(children: [
                        SizedBox(height: screenHeight*(20/640),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: screenWidth*(12/360),),
                            Text('내 방이 필요한 사람들', style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                            SizedBox(width: screenWidth*0.025,),
                            GestureDetector(
                              onTap: (){
                                showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel:
                                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                  barrierColor: Colors.black12.withOpacity(0.6),
                                  transitionDuration: Duration(milliseconds: 200),
                                  pageBuilder:
                                      (BuildContext context, Animation first, Animation second) {
                                    return Center(
                                        child: Container(
                                          height: screenHeight*0.289375,
                                          width: screenWidth*0.688888,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: Colors.white
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: screenHeight*0.025,),
                                              Padding(
                                                padding: EdgeInsets.only(left: screenWidth*0.03333),
                                                child: Text(
                                                  '내 방이 필요한 사람들?',
                                                  style: TextStyle(
                                                    decoration: TextDecoration.none,
                                                    color: Colors.black,
                                                    fontSize: screenWidth*0.04444,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: screenHeight*0.0125,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(color: Colors.black, fontSize: screenHeight*0.025),
                                                    children: <TextSpan>[
                                                      TextSpan(text: '내가 내놓은 방과', style: TextStyle(fontSize: screenWidth*0.033333, color: hexToColor('#888888'))),
                                                      TextSpan(text: ' 비슷한 조건의 방', style: TextStyle(
                                                          color: kPrimaryColor, fontSize: screenWidth*0.033333
                                                      ),
                                                      ),
                                                      TextSpan(text: '을 찾는\n사람들의 리스트입니다.', style: TextStyle(fontSize: screenWidth*0.033333, color: hexToColor('#888888'))),
                                                      TextSpan(text: '\n나의 조건과 맞는 사람들에게 방을 제안해 ', style: TextStyle(
                                                          color:  hexToColor('#888888'), fontSize: screenWidth*0.033333
                                                      ),
                                                      ),
                                                      TextSpan(text: '빠르게', style: TextStyle(fontSize: screenWidth*0.033333, color:kPrimaryColor)),
                                                      TextSpan(text: ' 매물을 거래해보세요!', style: TextStyle(
                                                          color:  hexToColor('#888888'), fontSize: screenWidth*0.033333
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Align(
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: screenWidth*0.688888,
                                                    height: screenHeight*(44/640),
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8),bottomRight: Radius.circular(8)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '확인',
                                                        style: TextStyle(

                                                            decoration: TextDecoration.none,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: screenWidth*0.03888
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    );
                                  },
                                );
                              },
                              child: SvgPicture.asset(
                                GreyQustionIcon,
                                height: screenHeight*0.025,
                                width: screenHeight*0.025,
                              ),
                            ),
                          ],)
                      ],),
                    ),
                  ],):
                  FutureBuilder(
                      future: initReverse(context),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                        if (snapshot.hasData == false) {
                          return CircularProgressIndicator();
                        }
                        //error가 발생하게 될 경우 반환하게 되는 부분
                        else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }
                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                        else {
                          return Expanded(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                controller: _scrollController,
                                itemCount: GlobalProfile.listForMe2.length ,
                                itemBuilder: (BuildContext context, int index) {
                                  return  Column(
                                    children: [
                                      index == 0?
                                      Column(children: [
                                        Container(
                                          color: Colors.white,
                                          height: screenHeight * (20 / 640),
                                        ),
                                        Container(
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: screenWidth * (12 / 360),
                                              ),
                                              Text(
                                                "내가 내놓은 방 정보",
                                                style: TextStyle(
                                                    fontSize: screenWidth * (16 / 360),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: screenWidth * (4 / 360),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          color: Colors.white,
                                          height: screenHeight * (28 / 640),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context, // 기본 파라미터, SecondRoute로 전달
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailedRoomInformation(
                                                          roomSalesInfo: GlobalProfile.roomSalesInfoList[widget.idx],
                                                        ))).then((value) {
                                              setState(() {

                                              });
                                            }); // SecondRoute를 생성하여 적재
                                          },
                                          child: Container(
                                            color: Colors.white,
                                            width: screenWidth,
                                            height: screenHeight * (108 / 640),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: screenWidth * (12 / 360),
                                                ),
                                                Container(
                                                  width: screenHeight * (108 / 640),
                                                  height: screenHeight * (108 / 640),
                                                  child: ClipRRect(
                                                      borderRadius: new BorderRadius.circular(4.0),
                                                      child:
                                                      GlobalProfile.roomSalesInfoList[widget.idx].imageUrl1=="BasicImage"
                                                          ?
                                                      SvgPicture.asset(
                                                        mryrInReviewScreen,
                                                        width: screenHeight * (60 / 640),
                                                        height: screenHeight * (60 / 640),
                                                      )
                                                          :

                                                      FittedBox(
                                                        fit: BoxFit.cover,
                                                        child:   getExtendedImage(get_resize_image_name( GlobalProfile.roomSalesInfoList[widget.idx].imageUrl1,360), 0,extendedController),

                                                      )

                                                  ),
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (12 / 360),
                                                ),
                                                Container(
                                                  width: screenWidth * (170/ 360),
                                                  height: screenHeight * (120 / 640),
                                                  //color: Colors.red,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: screenWidth * (53 / 360),
                                                            height: screenHeight * (22 / 640),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xffeeeeee),
                                                              borderRadius: BorderRadius.circular(
                                                                  screenHeight * (4 / 640)),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  GlobalProfile.roomSalesInfoList[widget.idx].preferenceTerm == 2 ? "하루가능" :
                                                                  GlobalProfile.roomSalesInfoList[widget.idx].preferenceTerm == 1 ? "1개월이상" : "기관무관",

                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: kPrimaryColor,
                                                                      fontSize: screenWidth * TagFontSize),
                                                                )),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth * (4 / 360),
                                                          ),
                                                          Container(
                                                            width: screenWidth * (53 / 360),
                                                            height: screenHeight * (22 / 640),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xffeeeeee),
                                                              borderRadius: BorderRadius.circular(
                                                                  screenHeight * (4 / 640)),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  GlobalProfile.roomSalesInfoList[widget.idx].preferenceSmoking == 2 ? "흡연가능" : GlobalProfile.roomSalesInfoList[widget.idx].preferenceSmoking == 1 ? "흡연불가" : "흡연무관",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: kPrimaryColor,
                                                                      fontSize: screenWidth * TagFontSize),
                                                                )),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth * (4 / 360),
                                                          ),
                                                          Container(
                                                            width: screenWidth * (53 / 360),
                                                            height: screenHeight * (22 / 640),
                                                            decoration: BoxDecoration(
                                                              color: Color(0xffeeeeee),
                                                              borderRadius: BorderRadius.circular(
                                                                  screenHeight * (4 / 640)),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                                  GlobalProfile.roomSalesInfoList[widget.idx].preferenceSex == 2 ? "남자선호" :  GlobalProfile.roomSalesInfoList[widget.idx].preferenceSmoking == 1 ? "여자선호" : "성별무관",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: kPrimaryColor,
                                                                      fontSize: screenWidth * TagFontSize),
                                                                )),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: screenHeight * (4 / 640),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            GlobalProfile.roomSalesInfoList[widget.idx].monthlyRentFeesOffer.toString() ,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: screenWidth * (16 / 360)),
                                                          ),
                                                          Text(
                                                            "만원",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: screenWidth * (16 / 360)),
                                                          ),
                                                          Text(
                                                            " / 월",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: screenWidth * (16 / 360)),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: screenHeight * (4 / 640),
                                                      ),
                                                      Text(
                                                        GlobalProfile.roomSalesInfoList[widget.idx].termOfLeaseMin +
                                                            '~' +
                                                            GlobalProfile.roomSalesInfoList[widget.idx].termOfLeaseMax,
                                                        style: TextStyle(color: hexToColor("#888888")),
                                                      ),
                                                      Container(
                                                        width: screenWidth * (250 / 360),
                                                        child: Text(
                                                          GlobalProfile.roomSalesInfoList[widget.idx].information,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 3,
                                                          style: TextStyle(

                                                              color: hexToColor("#888888")),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xff888888),
                                                  size: screenWidth * (20 / 360),
                                                ),
                                                SizedBox(width:screenWidth*(12/360)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: Colors.white,
                                          height: screenHeight * (16 / 640),
                                        ),
                                        SizedBox(height: screenHeight*(12/640),),
                                        Container(color: Colors.white,height: screenHeight*(54/640),width: screenWidth,
                                          child: Column(children: [
                                            SizedBox(height: screenHeight*(20/640),),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: screenWidth*(12/360),),
                                                Text('내 방이 필요한 사람들', style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                                                SizedBox(width: screenWidth*0.025,),
                                                GestureDetector(
                                                  onTap: (){
                                                    showGeneralDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      barrierLabel:
                                                      MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                                      barrierColor: Colors.black12.withOpacity(0.6),
                                                      transitionDuration: Duration(milliseconds: 200),
                                                      pageBuilder:
                                                          (BuildContext context, Animation first, Animation second) {
                                                        return Center(
                                                            child: Container(
                                                              height: screenHeight*0.289375,
                                                              width: screenWidth*0.688888,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                  color: Colors.white
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(height: screenHeight*0.025,),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: screenWidth*0.03333),
                                                                    child: Text(
                                                                      '내 방이 필요한 사람들?',
                                                                      style: TextStyle(
                                                                        decoration: TextDecoration.none,
                                                                        color: Colors.black,
                                                                        fontSize: screenWidth*0.04444,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: screenHeight*0.0125,),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
                                                                    child: RichText(
                                                                      text: TextSpan(
                                                                        style: TextStyle(color: Colors.black, fontSize: screenHeight*0.025),
                                                                        children: <TextSpan>[
                                                                          TextSpan(text: '내가 내놓은 방과', style: TextStyle(fontSize: screenWidth*0.033333, color: hexToColor('#888888'))),
                                                                          TextSpan(text: ' 비슷한 조건의 방', style: TextStyle(
                                                                              color: kPrimaryColor, fontSize: screenWidth*0.033333
                                                                          ),
                                                                          ),
                                                                          TextSpan(text: '을 찾는\n사람들의 리스트입니다.', style: TextStyle(fontSize: screenWidth*0.033333, color: hexToColor('#888888'))),
                                                                          TextSpan(text: '\n나의 조건과 맞는 사람들에게 방을 제안해 ', style: TextStyle(
                                                                              color:  hexToColor('#888888'), fontSize: screenWidth*0.033333
                                                                          ),
                                                                          ),
                                                                          TextSpan(text: '빠르게', style: TextStyle(fontSize: screenWidth*0.033333, color:kPrimaryColor)),
                                                                          TextSpan(text: ' 매물을 거래해보세요!', style: TextStyle(
                                                                              color:  hexToColor('#888888'), fontSize: screenWidth*0.033333
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Align(
                                                                    alignment: Alignment.center,
                                                                    child: GestureDetector(
                                                                      onTap: (){
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Container(
                                                                        width: screenWidth*0.688888,
                                                                        height: screenHeight*(44/640),
                                                                        decoration: BoxDecoration(
                                                                          color: kPrimaryColor,
                                                                          borderRadius: new BorderRadius.only(bottomLeft:Radius.circular(8.0),bottomRight:Radius.circular(8.0)),
                                                                        ),
                                                                        child: Center(
                                                                          child: Text(
                                                                            '확인',
                                                                            style: TextStyle(

                                                                                decoration: TextDecoration.none,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: screenWidth*0.03888
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    GreyQustionIcon,
                                                    height: screenHeight*0.025,
                                                    width: screenHeight*0.025,
                                                  ),
                                                ),
                                              ],)
                                          ],),
                                        ),
                                      ],):
                                      Container(),
                                      GestureDetector(
                                        onTap: () async {
                                          NeedRoomInfo item;
                                          for(int i = 0; i < needRoomSalesInfoList.length; i++) {
                                            if(needRoomSalesInfoList[i].id == GlobalProfile.listForMe2[index].id) {
                                              item = needRoomSalesInfoList[i];
                                              break;
                                            }
                                          }
                                          Navigator.push(
                                              context, // 기본 파라미터, SecondRoute로 전달
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailRoomWannaLive( needRoomInfo : needRoomSalesInfoList[index],Likes:  GlobalProfile.listForMe2[index].Likes,)) // SecondRoute를 생성하여 적재
                                          ).then((value) {
                                            GlobalProfile.listForMe2[index].ChangeLikes(value);
                                            setState(() {

                                            });
                                          });

                                        },
                                        child:  Column(
                                          children: [
                                            Container(
                                              color: Colors.white,
                                              width: screenWidth,
                                              height: screenHeight * (132 / 640),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * (12 / 360),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(height: screenHeight*(12/640),),
                                                      SvgPicture.asset(
                                                        ProfileIconInMoreScreen,
                                                        width: screenWidth * (98 / 360),
                                                        height: screenWidth * (98 / 360),
                                                      ),
                                                      SizedBox(height: screenHeight*(12/640),),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: screenWidth * (12 / 360),
                                                  ),
                                                  Container(
                                                    width: screenWidth * (238/ 360),
                                                    height: screenHeight * (132 / 640),
                                                    //color: Colors.red,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(height: screenHeight*(12/640),),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              width: screenWidth * (53 / 360),
                                                              height: screenHeight * (22 / 640),
                                                              decoration: BoxDecoration(
                                                                color: Color(0xffeeeeee),
                                                                borderRadius: BorderRadius.circular(
                                                                    screenHeight * (4 / 640)),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                    GlobalProfile.listForMe2[index].PreferTerm == 2 ? "하루가능" :
                                                                    GlobalProfile.listForMe2[index].PreferTerm == 1 ? "1개월이상" : "기관무관",

                                                                     style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: kPrimaryColor,
                                                                        fontSize: screenWidth * TagFontSize),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: screenWidth * (4 / 360),
                                                            ),
                                                            Container(
                                                              width: screenWidth * (53 / 360),
                                                              height: screenHeight * (22 / 640),
                                                              decoration: BoxDecoration(
                                                                color: Color(0xffeeeeee),
                                                                borderRadius: BorderRadius.circular(
                                                                    screenHeight * (4 / 640)),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                    GlobalProfile.listForMe2[index]
                                                                        .SmokingPossible ==
                                                                        0
                                                                        ? "흡연가능"
                                                                        : GlobalProfile.listForMe2[index]
                                                                        .SmokingPossible ==
                                                                        1
                                                                        ? "흡연불가"
                                                                        : "흡연 무관",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: kPrimaryColor,
                                                                        fontSize: screenWidth * TagFontSize),
                                                                  )),
                                                            ),
                                                            SizedBox(
                                                              width: screenWidth * (4 / 360),
                                                            ),
                                                            Container(
                                                              width: screenWidth * (53 / 360),
                                                              height: screenHeight * (22 / 640),
                                                              decoration: BoxDecoration(
                                                                color: Color(0xffeeeeee),
                                                                borderRadius: BorderRadius.circular(
                                                                    screenHeight * (4 / 640)),
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                    GlobalProfile.listForMe2[index]
                                                                        .PreferSex ==
                                                                        0
                                                                        ? "남자 선호"
                                                                        :GlobalProfile.listForMe2[index]
                                                                        .PreferSex ==
                                                                        1
                                                                        ? "여자 선호"
                                                                        : "성별 무관",
                                                                    style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: kPrimaryColor,
                                                                        fontSize: screenWidth * TagFontSize),
                                                                  )),
                                                            ),
                                                            Spacer(),
                                                            GestureDetector(
                                                                onTap: () async {
                                                                  var res = await ApiProvider().post('/NeedRoomSalesInfo/InsertLike', jsonEncode(
                                                                      {
                                                                        "userID" : GlobalProfile.loggedInUser.userID,
                                                                        "needRoomSaleID": GlobalProfile.listForMe2[index].id,
                                                                      }
                                                                  ));

                                                                  GlobalProfile.listForMe2[index].ChangeLikes(!GlobalProfile.listForMe2[index].Likes);
                                                                  setState(() {
                                                                  });
                                                                },
                                                                child: GlobalProfile.listForMe2[index].Likes ?
                                                                SvgPicture.asset(
                                                                  PurpleFilledHeartIcon,
                                                                  width: screenHeight * 0.0375,
                                                                  height: screenHeight * 0.0375,
                                                                  color: kPrimaryColor,
                                                                )
                                                                    : SvgPicture.asset(
                                                                  GreyEmptyHeartIcon,
                                                                  width: screenHeight * 0.0375,
                                                                  height: screenHeight * 0.0375,
                                                                )),
                                                            SizedBox(width: screenWidth*(12/360),),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${GlobalProfile.listForMe2[index].MonthlyFeesMin}',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: screenWidth * (16 / 360)),
                                                            ),
                                                            Text(
                                                              "만원",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: screenWidth * (16 / 360)),
                                                            ),
                                                            Text(
                                                              " ~ ",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: screenWidth * (16 / 360)),
                                                            ),
                                                            Text(
                                                              '${GlobalProfile.listForMe2[index].MonthlyFeesMax}',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: screenWidth * (16 / 360)),
                                                            ),
                                                            Text(
                                                              "만원 / 월",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: screenWidth * (16 / 360)),
                                                            ),
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        Row(
                                                          children: [
                                                            Container(
                                                                width: screenWidth * (84 / 360),
                                                                child: Text(
                                                                  "임대희망기간",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: screenWidth * ListContentsFontSize),
                                                                )),
                                                            GlobalProfile.listForMe2[index].TermOfLeaseMin == null?Text(" - ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),):
                                                            Row(children: [
                                                              Text(getMonthAndDay(GlobalProfile.listForMe2[index].TermOfLeaseMin),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                              Text(" ~ ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                              Text(getMonthAndDay(GlobalProfile.listForMe2[index].TermOfLeaseMax),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                            ],)
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: screenHeight * (4 / 640),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                                width: screenWidth * (84 / 360),
                                                                child: Text(
                                                                  "희망보증금",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: screenWidth * ListContentsFontSize),
                                                                )),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  '${GlobalProfile.listForMe2[index].DepositeFeesMin}',
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth *ListContentsFontSize,
                                                                      color: Color(0xff888888)),
                                                                ),
                                                                Text(
                                                                  "만원",
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth * ListContentsFontSize,
                                                                      color: Color(0xff888888)),
                                                                ),
                                                                Text(
                                                                  " ~ ",
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth * ListContentsFontSize,
                                                                      color: Color(0xff888888)),
                                                                ),
                                                                Text(
                                                                  '${GlobalProfile.listForMe2[index].DepositeFeesMax}',
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth * ListContentsFontSize,
                                                                      color: Color(0xff888888)),
                                                                ),
                                                                Text(
                                                                  "만원",
                                                                  style: TextStyle(
                                                                      fontSize: screenWidth * ListContentsFontSize,
                                                                      color: Color(0xff888888)),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: screenHeight*(12/640),)
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(height: screenHeight*(8/640),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }


                            ),
                          );
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
