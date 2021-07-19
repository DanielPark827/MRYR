import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/model/RoomListScreenProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/DetailRoomWannaLive.dart';
import 'package:mryr/screens/NeedRoomSalesInfo/model/NeedRoomSalesInfoLikes.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class NeedRoomSalesInfoListScreen extends StatefulWidget {
  @override
  _NeedRoomSalesInfoListScreenState createState() => _NeedRoomSalesInfoListScreenState();
}

class _NeedRoomSalesInfoListScreenState extends State<NeedRoomSalesInfoListScreen> {
  double animatedHeight1 = 0.0;
  double animatedHeight2 = 0.0;
  double animatedHeight3 = 0.0;
  GlobalKey<RefreshIndicatorState> refreshKey;
  final _scrollController = ScrollController();
  final Start = TextEditingController();
  final End = TextEditingController();

  bool FlagForFilter = false;

  List<NeedRoomSalesInfoLikes> LikesList = [];
  List<int> LikesidList = [];
  _getMoreData() async{
    Timer(Duration(milliseconds: 500), ()async{
      var tmp = await ApiProvider().post('/NeedRoomSalesInfo/SelectList/Offset', jsonEncode(
          {
            "index":needRoomSalesInfoList.length,
          }
      ));
      if(tmp != null){
        for(int i =0;i<tmp.length;i++){
          NeedRoomInfo needRoom=NeedRoomInfo.fromJson(tmp[i]);
          needRoomSalesInfoList.add(needRoom);
        }
      }
      else
        print("error&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    });
  }

  @override
  void initState() {

    refreshKey = GlobalKey<RefreshIndicatorState>();

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent-100){
        _getMoreData();
      }
      setState(() {

      });
    });
    // TODO: implement initState
    super.initState();
    (() async {
      var list = await ApiProvider().post('/NeedRoomSalesInfo/SelectLike', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));

      if(null != list) {
        LikesList.clear();
        LikesidList.clear();
        for(int i = 0; i < list.length; ++i){
          Map<String, dynamic> data = list[i];

          NeedRoomSalesInfoLikes item = NeedRoomSalesInfoLikes.fromJson(data);
          LikesList.add(item);
          LikesidList.add(item.NeedRoomSaleID);
        }
        int len = needRoomSalesInfoList.length;
        for(int i= 0; i < len; i++) {
          if(LikesidList.contains(needRoomSalesInfoList[i].id)) {
            needRoomSalesInfoList[i].ChangeLikes(true);
            needRoomSalesInfoList[i].Likes;
          } else {

          }
        }

        print('sdfs2');
        return true;
      } else {
        print('no');
        return false;
      }
    })();
  }

  @override
  Widget build(BuildContext context) {

    RoomListScreenProvider data = Provider.of<RoomListScreenProvider>(context);


    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
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
          body: RefreshIndicator(
            key: refreshKey,
            onRefresh: ()async{
              if( FlagForFilter == false) {
                var needRoomList = await ApiProvider().get(
                    '/NeedRoomSalesInfo/Select/List');

                if (needRoomSalesInfoList != null)
                  needRoomSalesInfoList.clear();
                if (null != needRoomList) {
                  for (int i = 0; i < needRoomList.length; ++i) {
                    needRoomSalesInfoList.add(
                        NeedRoomInfo.fromJson(needRoomList[i]));
                  }

                  var list = await ApiProvider().post('/NeedRoomSalesInfo/SelectLike', jsonEncode(
                      {
                        "userID" : GlobalProfile.loggedInUser.userID,
                      }
                  ));

                  if(null != list) {
                    LikesList.clear();
                    LikesidList.clear();
                    for(int i = 0; i < list.length; ++i){
                      Map<String, dynamic> data = list[i];

                      NeedRoomSalesInfoLikes item = NeedRoomSalesInfoLikes.fromJson(data);
                      LikesList.add(item);
                      LikesidList.add(item.NeedRoomSaleID);
                    }
                    int len = needRoomSalesInfoList.length;
                    for(int i= 0; i < len; i++) {
                      if(LikesidList.contains(needRoomSalesInfoList[i].id)) {
                        needRoomSalesInfoList[i].ChangeLikes(true);
                        needRoomSalesInfoList[i].Likes;
                      } else {

                      }
                    }

                    print('sdfs2');
                    return true;
                  }
                }
              }
              else{

              }
            },
            child: Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: screenHeight*(20/640),),
                  Container(
                    color: Colors.white,
                    child: Row(children: [
                      SizedBox(width: screenWidth *(12/360),),
                      Text("역제안 리스트",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
                      SizedBox(width: screenWidth*(4/360),),
                      GestureDetector(
                        onTap: (){

                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context)
                                .modalBarrierDismissLabel,
                            barrierColor: Colors.black12.withOpacity(0.6),
                            transitionDuration: Duration(milliseconds: 150),
                            pageBuilder: (BuildContext context, Animation first,
                                Animation second) {
                              return Center(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.all(
                                        new Radius.circular(8.0)),
                                  ),
                                  width:
                                  MediaQuery.of(context).size.width * (248 / 360),
                                  height: MediaQuery.of(context).size.height *
                                      (186 / 640),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            (16 / 640),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (12 / 360),
                                          ),
                                          Material(
                                              child: Text(
                                                "역제안 리스트란?",
                                                style: TextStyle(
                                                    fontSize: screenWidth * (16 / 360),
                                                    fontWeight: FontWeight.bold),
                                              ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: screenHeight * (8 / 640),
                                      ),
                                      Container(
                                        height: screenHeight * (96 / 640),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: screenWidth * (12 / 360),
                                            ),
                                            Container(
                                              width: screenWidth * (226 / 360),
                                              child: RichText(
                                                text: TextSpan(
                                                    style: TextStyle(
                                                        fontSize:
                                                        screenWidth * (12 / 360),
                                                        color: Color(0xff888888)),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                          "사람들이 구하고 싶어하는 방의 리스트입니다.\n"),
                                                      TextSpan(
                                                          text: "방을 내놓을 때",
                                                          style: TextStyle(
                                                              color: kPrimaryColor)),
                                                      TextSpan(
                                                          text:
                                                          ", 사람들이 원하는 조건을 미리 알아보고 빨리 매물을 내놓을 수 있고\n"),
                                                      TextSpan(
                                                          text: "방을 구할 때",
                                                          style: TextStyle(
                                                              color: kPrimaryColor)),
                                                      TextSpan(
                                                          text:
                                                          ", 자신이 원하는 조건을 제시할 수 있습니다"),
                                                    ]),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Material(
                                          child: Container(
                                            width: screenWidth * (240 / 360),
                                            height: screenHeight * (40 / 640),
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  "확인",
                                                  style: TextStyle(
                                                      fontSize: screenWidth * (14 / 360),
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white),
                                                )),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          question_circle_filled,
                          height: screenHeight * (16 / 640),
                        ),
                      )
                    ],),
                  ),
                  Container(height: screenHeight*(8/640),color: Colors.white,),
                  Container(
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: screenWidth*0.033333,),
                        Container(
                          height: screenHeight * 0.05,
                          width: screenWidth *0.175,
                          child: Padding(
                            padding: EdgeInsets.all(screenHeight * 0.009375),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  GreyFilterIcon,
                                  width: screenHeight * 0.03125,
                                  height: screenHeight * 0.03125,
                                ),
                                Spacer(),
                                Text(
                                  '월세',
                                  style: TextStyle(
                                    fontSize: screenWidth*SearchCaseFontSize,
                                    color: hexToColor('#888888'),
                                  ),
                                )
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(4.0),
                            border: Border.all(
                              width: 1,
                              color: hexToColor("#EEEEEE"),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth*0.01111,),
                        Container(
                          child: Row(
                            children: [
                              !FlagForFilter ? Row(
                                children: [
                                  Container(
                                    width: screenWidth*0.26388,
                                    height: screenHeight*0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(4.0),
                                      border: Border.all(
                                        width: 1,
                                        color: hexToColor("#EEEEEE"),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            // width: screenWidth*0.05555,
                                            //height: screenHeight*(90/640),
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              textInputAction: TextInputAction.done,
                                              controller: Start,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                              ], // Only numbers can be entered
                                              style: TextStyle(
                                                fontSize: screenWidth * (12 / 360),
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(vertical: screenHeight*0.0130625),
                                                errorBorder: InputBorder.none,
                                                hintText: '0',
                                                hintStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * (12 / 360),
                                                  color: hexToColor("#cccccc"),
                                                ),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                isDense: true,
                                              ),
                                              onChanged: (text){
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom :screenHeight*(2.5/640)),
                                          child: Text(
                                            ' 만원',
                                            style: TextStyle(
                                              color: hexToColor('#888888'),
                                              fontSize: screenWidth*SearchCaseFontSize,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth*(2/360),),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    ' ~ ',
                                    style: TextStyle(
                                      fontSize: screenWidth*0.055555,
                                      color: hexToColor('#979797'),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth*0.26388,
                                    height: screenHeight*0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.circular(4.0),
                                      border: Border.all(
                                        width: 1,
                                        color: hexToColor("#EEEEEE"),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            // width: screenWidth*0.05555,
                                            child: TextField(
                                              textAlign: TextAlign.right,
                                              textInputAction: TextInputAction.done,
                                              controller: End,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                              ], // Only numbers can be entered
                                              style: TextStyle(
                                                fontSize: screenWidth * (12 / 360),
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(vertical: screenHeight*0.0130625),
                                                errorBorder: InputBorder.none,
                                                hintText: '0',
                                                hintStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * (12 / 360),
                                                  color: hexToColor("#cccccc"),
                                                ),
                                                border: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                isDense: true,
                                              ),
                                              onChanged: (text){
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom :screenHeight*(2.5/640)),
                                          child: Text(
                                            ' 만원',
                                            style: TextStyle(
                                              color: hexToColor('#888888'),
                                              fontSize: screenWidth*SearchCaseFontSize,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth*(2/360),),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth*0.01111,),
                                  InkWell(
                                    onTap: ()async{
                                      EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                                      Start.text = int.parse(Start.text) == 0? "0" : Start.text;
                                      if(Start.text != "" && End.text != "") {
                                        if(int.parse(Start.text)>int.parse(End.text)){
                                          var tmp = Start.text;
                                          Start.text = End.text;
                                          End.text = tmp;
                                        }
                                        needRoomSalesInfoListFiltered.clear();
                                        var list = await ApiProvider().post('/NeedRoomSalesInfo/OfferFilter',jsonEncode({
                                          "rentmin" : Start.text,
                                          "rentmax": End.text,
                                          "index" : "0",
                                        }));

                                        var Llist = await ApiProvider().post('/NeedRoomSalesInfo/SelectLike', jsonEncode(
                                            {
                                              "userID" : GlobalProfile.loggedInUser.userID,
                                            }
                                        ));

                                        if(list != null){
                                          for(int i =0;i<list.length;i++){
                                            NeedRoomInfo item = NeedRoomInfo.fromJson(list[i]);

                                            for(int j =0; j < Llist.length; j++) {
                                              Map<String, dynamic> data = Llist[j];
                                              NeedRoomSalesInfoLikes Litem = NeedRoomSalesInfoLikes.fromJson(data);

                                              if(item.id == Litem.NeedRoomSaleID) {
                                                item.Likes = true;
                                                setState(() {
                                                });
                                                break;
                                              }
                                            }
                                            needRoomSalesInfoListFiltered.add(item);
                                          }
                                        }
                                        FlagForFilter = true;
                                      }
                                      setState(() {

                                      });
                                      EasyLoading.dismiss();
                                    },
                                    child: Container(
                                      width: screenWidth*0.1305555,
                                      height: screenHeight*0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(4.0),
                                        border: Border.all(
                                          width: 1,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '입력',
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: screenWidth*SearchCaseFontSize,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ) :
                              InkWell(
                                onTap: ()async{
                                  var list = await ApiProvider().post('/NeedRoomSalesInfo/SelectLike', jsonEncode(
                                      {
                                        "userID" : GlobalProfile.loggedInUser.userID,
                                      }
                                  ));

                                  if(null != list) {
                                    LikesList.clear();
                                    LikesidList.clear();
                                    for(int i = 0; i < list.length; ++i){
                                      Map<String, dynamic> data = list[i];

                                      NeedRoomSalesInfoLikes item = NeedRoomSalesInfoLikes.fromJson(data);
                                      LikesList.add(item);
                                      LikesidList.add(item.NeedRoomSaleID);
                                    }
                                    int len = needRoomSalesInfoList.length;
                                    for(int i= 0; i < len; i++) {
                                      if(LikesidList.contains(needRoomSalesInfoList[i].id)) {
                                        needRoomSalesInfoList[i].ChangeLikes(true);
                                      } else {
                                        needRoomSalesInfoList[i].ChangeLikes(false);
                                      }
                                    }
                                  }
                                  setState(() {
                                    FlagForFilter = false;
                                  });
                                },
                                child: Container(
                                  height: screenHeight*0.05,
                                  // width: screenWidth*0.7,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.circular(4.0),
                                    border: Border.all(
                                      width: 1,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        SizedBox(width: screenWidth*(10/360),),
                                        Text(
                                          '${Start.text}' +'만원 ~ '+'${End.text}'+'만원',
                                          style: TextStyle(
                                              color: kPrimaryColor
                                          ),
                                        ),
                                        SizedBox(width: screenWidth*(10/360),),

                                        Text(
                                          'x',
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth*(8/360),),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: screenHeight*(20/640),color: Colors.white,),
                  FlagForFilter == false?
                  needRoomSalesInfoList == null?Container():
                  Expanded(child:
                  ListView.builder(
                      controller: _scrollController,
                      itemCount: needRoomSalesInfoList.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

                      itemBuilder:(BuildContext context, int index) {

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context, // 기본 파라미터, SecondRoute로 전달
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailRoomWannaLive( needRoomInfo : needRoomSalesInfoList[index],Likes: needRoomSalesInfoList[index].Likes,)) // SecondRoute를 생성하여 적재
                                ).then((value) {
                                  needRoomSalesInfoList[index].ChangeLikes(value);
                                  setState(() {

                                  });
                                });

                              },
                              child: Container(
                                height: screenHeight * (135/640),
                                color: Colors.white,
                                child: Row(

                                  children: [
                                    SizedBox(width: screenWidth *(12/360),),
                                    Column(
                                      children: [
                                        SizedBox(height: screenHeight*(12/640),),
                                        SvgPicture.asset(
                                          PersonalProfileImage,
                                          width: screenWidth * (100/360),
                                          height: screenHeight * (100/640),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        child: SizedBox(width: screenWidth * (12/360),)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: screenHeight * (12/640),),
                                          Row(children: [
                                            Container(
                                              width: screenWidth*(53/360),
                                              height: screenHeight*(22/640),
                                              decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                              child: Center(child: Text(
                                                needRoomSalesInfoList[index].PreferTerm == 2 ? "하루가능" :
                                                needRoomSalesInfoList[index].PreferTerm == 1 ? "1개월이상" : "기관무관",
                                                style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                            ),
                                            SizedBox(width: screenWidth*(4/360),),
                                            Container(
                                              width: screenWidth*(53/360),
                                              height: screenHeight*(22/640),
                                              decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                              child: Center(child: Text( needRoomSalesInfoList[index].SmokingPossible == 0?"흡연가능":needRoomSalesInfoList[index].SmokingPossible == 1?"흡연불가": "흡연 무관"
                                                ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                            ),
                                            SizedBox(width: screenWidth*(4/360),),
                                            Container(
                                              width: screenWidth*(53/360),
                                              height: screenHeight*(22/640),
                                              decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                              child: Center(child: Text(needRoomSalesInfoList[index].PreferSex== 0?"남자 선호":needRoomSalesInfoList[index].PreferSex == 1?"여자 선호": "성별 무관",
                                                style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                            ),
                                            Expanded(child: SizedBox()),
                                            GestureDetector(
                                                onTap: () async {
                                                  var res = await ApiProvider().post('/NeedRoomSalesInfo/InsertLike', jsonEncode(
                                                      {
                                                        "userID" : GlobalProfile.loggedInUser.userID,
                                                        "needRoomSaleID": needRoomSalesInfoList[index].id,
                                                      }
                                                  ));

                                                  needRoomSalesInfoList[index].ChangeLikes(!needRoomSalesInfoList[index].Likes);
                                                  setState(() {
                                                  });
                                                },
                                                child:  needRoomSalesInfoList[index].Likes ?
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
                                            SizedBox(width: screenWidth*0.03333,),
                                          ],),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(children: [
                                            Text(needRoomSalesInfoList[index].MonthlyFeesMin.toString()+"만원 ~ "+needRoomSalesInfoList[index].MonthlyFeesMax.toString()+"만원 / 월",
                                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                          ],),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(
                                            children: [
                                              Container(
                                                  width: screenWidth*(84/360),
                                                  child: Text("임대희망기간",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize),)),
                                              needRoomSalesInfoList[index].TermOfLeaseMin ==null? Text(" - ",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),)
                                                  : Row(children: [
                                                Text(getMonthAndDay(needRoomSalesInfoList[index].TermOfLeaseMin)+" ~ "+getMonthAndDay(needRoomSalesInfoList[index].TermOfLeaseMax)
                                                  ,style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),),
                                              ],),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(
                                            children: [
                                              Container(
                                                  width: screenWidth*(84/360),
                                                  child: Text("희망보증금",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize),)),
                                              Row(children: [
                                                Text(needRoomSalesInfoList[index].DepositeFeesMin.toString(),style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),),
                                                Text("만원",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),),
                                                Text(" ~ ",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),),
                                                Text(needRoomSalesInfoList[index].DepositeFeesMax.toString(),style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),),
                                                Text("만원",style: TextStyle(fontSize: screenWidth*OptionFontSize,color: Color(0xff888888)),),
                                              ],),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(children: [
                                            Spacer(),
                                            Text(timeCheck( needRoomSalesInfoList[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),
                                            SizedBox(width: screenWidth*(12/360),)
                                          ],)

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * (8/640),),
                          ],
                        );
                      }
                  )
                  ):
                  needRoomSalesInfoListFiltered == null?Container(): Expanded(child:
                  ListView.builder(
                      itemCount: needRoomSalesInfoListFiltered.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder:(BuildContext context, int index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context, // 기본 파라미터, SecondRoute로 전달
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailRoomWannaLive( needRoomInfo : needRoomSalesInfoListFiltered[index],Likes: needRoomSalesInfoListFiltered[index].Likes,)) // SecondRoute를 생성하여 적재
                                ).then((value) {
                                  needRoomSalesInfoListFiltered[index].ChangeLikes(value);
                                  setState(() {

                                  });
                                });

                              },
                              child: Container(
                                height: screenHeight * (135/640),
                                color: Colors.white,
                                child: Row(

                                  children: [
                                    SizedBox(width: screenWidth *(12/360),),
                                    Column(
                                      children: [
                                        SizedBox(height: screenHeight*(12/640),),
                                        SvgPicture.asset(
                                          PersonalProfileImage,
                                          width: screenWidth * (100/360),
                                          height: screenHeight * (100/640),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        child: SizedBox(width: screenWidth * (12/360),)),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: screenHeight * (12/640),),
                                          Row(children: [
                                            Container(
                                              width: screenWidth*(53/360),
                                              height: screenHeight*(22/640),
                                              decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                              child: Center(child: Text(
                                                needRoomSalesInfoListFiltered[index].Type == null?"error":needRoomSalesInfoListFiltered[index].Type == 0?"원룸": needRoomSalesInfoListFiltered[index].Type == 1?"투룸이상": needRoomSalesInfoListFiltered[index].Type == 2?"오피스텔":"아파트"
                                                ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                            ),
                                            SizedBox(width: screenWidth*(4/360),),
                                            Container(
                                              width: screenWidth*(53/360),
                                              height: screenHeight*(22/640),
                                              decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                              child: Center(child: Text( needRoomSalesInfoListFiltered[index].SmokingPossible == 0?"흡연 O":needRoomSalesInfoListFiltered[index].SmokingPossible == 1?"흡연 X": "흡연 무관"
                                                ,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                            ),
                                            SizedBox(width: screenWidth*(4/360),),
                                            Container(
                                              width: screenWidth*(53/360),
                                              height: screenHeight*(22/640),
                                              decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(screenHeight*(4/640)),),
                                              child: Center(child: Text(needRoomSalesInfoListFiltered[index].PreferSex== 0?"남자 선호":needRoomSalesInfoListFiltered[index].PreferSex == 1?"여자 선호": "성별 무관",
                                                style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: screenWidth*TagFontSize),)),
                                            ),
                                            Expanded(child: SizedBox()),
                                            GestureDetector(
                                                onTap: () async {
                                                  var res = await ApiProvider().post('/NeedRoomSalesInfo/InsertLike', jsonEncode(
                                                      {
                                                        "userID" : GlobalProfile.loggedInUser.userID,
                                                        "needRoomSaleID": needRoomSalesInfoListFiltered[index].id,
                                                      }
                                                  ));

                                                  needRoomSalesInfoListFiltered[index].ChangeLikes(!needRoomSalesInfoListFiltered[index].Likes);
                                                  setState(() {
                                                  });
                                                },
                                                child:  needRoomSalesInfoListFiltered[index].Likes ?
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
                                            SizedBox(width: screenWidth*0.03333,),
                                          ],),
                                          SizedBox(height: screenHeight * (4/640),),
                                          Row(children: [
                                            Text(needRoomSalesInfoListFiltered[index].MonthlyFeesMin.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                            Text("만원",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                            Text(" ~ ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                            Text(needRoomSalesInfoListFiltered[index].MonthlyFeesMax.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                            Text("만원 / 월",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360)),),
                                          ],),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(
                                            children: [
                                              Container(
                                                  width: screenWidth*(75/360),
                                                  child: Text("임대희망기간",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*OptionFontSize),)),
                                              needRoomSalesInfoListFiltered[index].TermOfLeaseMin ==null? Text(" - ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),)
                                                  : Row(children: [
                                                Text(getMonthAndDay(needRoomSalesInfoListFiltered[index].TermOfLeaseMin),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                Text(" ~ ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                Text(getMonthAndDay(needRoomSalesInfoListFiltered[index].TermOfLeaseMax),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                              ],),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(
                                            children: [
                                              Container(
                                                  width: screenWidth*(75/360),
                                                  child: Text("희망보증금",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*ListContentsFontSize),)),
                                              Row(children: [
                                                Text(needRoomSalesInfoListFiltered[index].DepositeFeesMin.toString(),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                Text("만원",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                Text(" ~ ",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                Text(needRoomSalesInfoListFiltered[index].DepositeFeesMax.toString(),style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                                Text("만원",style: TextStyle(fontSize: screenWidth*ListContentsFontSize,color: Color(0xff888888)),),
                                              ],),
                                            ],
                                          ),
                                          SizedBox(height: screenHeight*(4/640),),
                                          Row(children: [
                                            Spacer(),
                                            Text(timeCheck( needRoomSalesInfoListFiltered[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),
                                            SizedBox(width: screenWidth*(12/360),)
                                          ],)

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * (8/640),),
                          ],
                        );
                      }
                  )
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



