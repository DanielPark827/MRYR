import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter_easyloading/flutter_easyloading.dart';


class EditRoomWannaLive extends StatefulWidget {
  @override
  _EditRoomWannaLiveState createState() => _EditRoomWannaLiveState();
}


class _EditRoomWannaLiveState extends State<EditRoomWannaLive> {
  //현재페이지
  int currentPage = 0;

  //페이지 index
  int startPageNum = 0;
  int kindPageNum = 1;
  int rentPageNum = 2;
  int termPageNum = 3;
  int suggestionPageNum = 4;
  int locationPageNum = 5;
  int detailPageNum = 6;

  //kindPage변수

  int type = GlobalProfile.NeedRoomInfoOfloggedInUser.Type;

  //rentPage변수

  RangeValues DepositValues = RangeValues(1, 1000);
  RangeValues RentValues = RangeValues(1, 100);
  double depositeFeesMin = GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMin.toDouble()==0?1:GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMin.toDouble();
  double depositeFeesMax = GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMin.toDouble()==0?1:GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMax.toDouble();
  double monthlyFeesMin = GlobalProfile.NeedRoomInfoOfloggedInUser.MonthlyFeesMin.toDouble();
  double monthlyFeesMax = GlobalProfile.NeedRoomInfoOfloggedInUser.MonthlyFeesMax.toDouble();
  bool depositCheckBox = GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMin==0? true:false;

  //termPage변수

  List<DateTime> picked = [
    DateTime.now(),
    (DateTime.now()).add(Duration(days: 1))
  ];
  String termOfLeaseMin = GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMin;
  String termOfLeaseMax= GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMax;

  //suggestionPage변수

  int preferTerm = GlobalProfile.NeedRoomInfoOfloggedInUser.PreferTerm;
  int preferSex =  GlobalProfile.NeedRoomInfoOfloggedInUser.PreferSex;
  int smokingPossible =  GlobalProfile.NeedRoomInfoOfloggedInUser.SmokingPossible;

  //locatoinPage변수
  String Location;


  //detailPage변수
  bool detailPageState = false;
  String Description= GlobalProfile.NeedRoomInfoOfloggedInUser.Information;
  TextEditingController _description;
  @override
  void initState(){
    super.initState();
    _description = TextEditingController(text: Description);
  }


  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        if (currentPage == 0){
          Navigator.pop(context);
        }

        else {
          currentPage = 0;
          setState(() {});
        }
        return;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  if (currentPage == 0){
                    Navigator.pop(context);
                  }

                  else {
                    currentPage = 0;
                    setState(() {});
                  }

                }),
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: WillPopScope(
            onWillPop: (){
              if (currentPage == 0){
                Navigator.pop(context);
              }

              else {
                currentPage = 0;
                setState(() {});
              }
              return;
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: currentPage == startPageNum
                    ? startPage(screenWidth, screenHeight)
                    : currentPage == kindPageNum
                    ? kindPage(screenHeight, screenWidth)
                    : currentPage == rentPageNum
                    ? rentPage(screenHeight, screenWidth)
                    : currentPage == termPageNum
                    ? termPage(screenHeight, screenWidth)
                    : currentPage == suggestionPageNum
                    ? suggestionPage(screenHeight, screenWidth)
                    : currentPage == locationPageNum
                    ? locationPage(screenHeight, screenWidth)
                    : currentPage == detailPageNum
                    ? detailPage(screenHeight, screenWidth)
                    :
                Container(child: CircularProgressIndicator()),
              ),
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () async{

              if(GlobalProfile.booleanButton == true){}
              else {
                try {
                  GlobalProfile.booleanButton = true;




                  Function okFunc = () async {
                    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                    var result =  await ApiProvider().post("/NeedRoomSalesInfo/Update", jsonEncode(
                        {
                          "userID": GlobalProfile.loggedInUser.userID,
                          "type":type,
                          "depositeFeesMin":depositCheckBox==true?0:depositeFeesMin.floor().toString(),
                          "depositeFeesMax":depositCheckBox==true?0:depositeFeesMax.floor().toString(),
                          "monthlyFeesMin":monthlyFeesMin.floor().toString(),
                          "monthlyFeesMax":monthlyFeesMax.floor().toString(),
                          "termOfLeaseMin":termChange(termOfLeaseMin),
                          "termOfLeaseMax":termChange(termOfLeaseMax),
                          "preferTerm":preferTerm,
                          "preferSex":preferSex,
                          "smokingPossible":smokingPossible,
                          "location":"인하대학교",
                          "information" : _description.text,
                        }
                    ));
                    GlobalProfile.NeedRoomInfoOfloggedInUser.Type = type;
                    GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMin = depositCheckBox==true?0:depositeFeesMin.toInt();
                    GlobalProfile.NeedRoomInfoOfloggedInUser.DepositeFeesMax =depositCheckBox==true?0: depositeFeesMax.toInt();
                    GlobalProfile.NeedRoomInfoOfloggedInUser.MonthlyFeesMin = monthlyFeesMin.toInt();
                    GlobalProfile.NeedRoomInfoOfloggedInUser.MonthlyFeesMax =monthlyFeesMax.toInt();
                    GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMin = termOfLeaseMin;
                    GlobalProfile.NeedRoomInfoOfloggedInUser.TermOfLeaseMax = termOfLeaseMax;
                    GlobalProfile.NeedRoomInfoOfloggedInUser.PreferTerm = preferTerm;
                    GlobalProfile.NeedRoomInfoOfloggedInUser.PreferSex = preferSex;
                    GlobalProfile.NeedRoomInfoOfloggedInUser.SmokingPossible = smokingPossible;
                    GlobalProfile.NeedRoomInfoOfloggedInUser.Information = _description.text;


                    GlobalProfile.listForMe.clear();
                    var list2 = await ApiProvider().post('/RoomSalesInfo/Recommend', jsonEncode({
                      "userID" : GlobalProfile.loggedInUser.userID,
                    }));
                    if(list2 != null){
                      for(int i = 0;i<list2.length;i++){
                        GlobalProfile.listForMe.add(RoomSalesInfo.fromJson(list2[i]));
                      }
                    }



                    navigationNumProvider.setNum(ROOM_WANNA_LIVE);
                    Navigator.pushReplacement(
                        context, // 기본 파라미터, SecondRoufte로 전달
                        MaterialPageRoute(
                            builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
                    );

                  };
                  Function cancelFunc = () {
                    Navigator.pop(context);
                  };

                  if( currentPage == startPageNum){
                    OKCancelDialog(context, "수정을 완료하시겠습니까?","내가 살고싶은 방의 정보가 입력된 정보로\n수정됩니다. 계속하시겠습니까?", "확인", "취소", okFunc, cancelFunc);

                  }
                  else{
                    currentPage = startPageNum;
                    setState(() {

                    });
                  }


                  GlobalProfile.booleanButton = false;
                  setState(() {

                  });
                  EasyLoading.dismiss();
                }
                catch(e){
                  GlobalProfile.booleanButton = false;
                  print(e);
                }
              }

             },
            child: Container(
              width: screenWidth,
              height: screenHeight * (60 / 640),
              color: kPrimaryColor,
              //((one==true||two==true||op==true||apt==true))?kPrimaryColor:Color(0xffcccccc),
              child: Center(
                child: Text(
                  "수정하기",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * (16 / 640)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column startPage(double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: screenWidth,
          color: Colors.white,
          child: Row(
            children: [
              SizedBox(
                width: screenWidth * (12 / 360),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * (40 / 640),
                  ),
                  Text(
                    "방 정보 수정",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * (24 / 640),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (8 / 640),
                  ),
                  Text(
                    "내가 살고 싶은 방의 정보를 수정해주세요",
                    style: TextStyle(
                      color: Color(0xff888888),
                      fontSize: screenHeight * (12 / 640),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * (36 / 640),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
        menuInLookForRoomsScreen(
            "매물 종류", kindPageNum, screenHeight, screenWidth),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
        menuInLookForRoomsScreen(
            "보증금 월세", rentPageNum, screenHeight, screenWidth),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
        menuInLookForRoomsScreen(
            "임대 기간", termPageNum, screenHeight, screenWidth),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
        menuInLookForRoomsScreen(
            "기타 제안", suggestionPageNum, screenHeight, screenWidth),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
        menuInLookForRoomsScreen(
            "매물 위치", locationPageNum, screenHeight, screenWidth),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
        menuInLookForRoomsScreen(
            "상세설명", detailPageNum, screenHeight, screenWidth),
        Container(
          height: 1,
          color: Color(0xfff8f8f8),
        ),
      ],
    );
  }
  Row detailPage(double screenHeight, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * (12 / 360),
        ),
        Container(
          width: screenWidth*(336/360),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.0625,),
              Text(
                '매물 상세 설명',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth*(24/360),
                ),
              ),
              SizedBox(height: screenHeight*0.0125,),
              Text(
                '내놓을 매물의 상세 설명을 작성해주세요',
                style: TextStyle(
                  fontSize: screenWidth*0.033333,
                  color: hexToColor("#888888"),
                ),
              ),
              SizedBox(height: screenHeight*0.03125,),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                maxLength: 225,
                controller: _description,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: '매물에 대한 설명을 225자 이내로 작성해주세요',
                  hintStyle: TextStyle(
                    fontSize: screenWidth*0.0333333,
                    color: hexToColor("#D2D2D2"),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: hexToColor(("#CCCCCC"))),
                  ),
                ),
                onSubmitted: (text){
                  Description = text;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }


  Row kindPage(double screenHeight, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * (12 / 360),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * (40 / 640),
            ),
            Text(
              "매물 종류 선택",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenHeight * (24 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Text(
              "내놓을 매물의 종류를 선택해주세요",
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: screenHeight * (12 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (36 / 640),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (type == 0)
                      type = -1;
                    else
                      type = 0;

                    setState(() {});
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(
                              1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:type == 0
                            ? kPrimaryColor
                            : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),

                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            OneRoomInReleaseRoomScreen,
                            color: type == 0
                                ? kPrimaryColor
                                : Colors.black,
                            width: screenHeight * (24 / 640),
                            height: screenHeight * (24 / 640),
                          ),
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          Text(
                            "원룸",
                            style: TextStyle(
                              fontSize: screenHeight * (12 / 640),
                              color: type == 0? kPrimaryColor
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (8 / 360),
                ),
                InkWell(
                  onTap: () {
                    if (type == 1)
                      type = -1;
                    else
                      type = 1;
                    setState(() {});
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(
                              1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:type == 1
                            ? kPrimaryColor
                            : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),

                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            TwoRoomInReleaseRoomScreen,
                            color: type == 1
                                ? kPrimaryColor
                                : Colors.black,
                            width: screenHeight * (24 / 640),
                            height: screenHeight * (24 / 640),
                          ),
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          Text(
                            "투룸 이상",
                            style: TextStyle(
                              fontSize: screenHeight * (12 / 640),
                              color: type == 1
                                  ? kPrimaryColor
                                  : Colors.black,),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (type == 2)
                      type = -1;
                    else
                      type = 2;
                    setState(() {});
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(
                              1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:type == 2
                            ? kPrimaryColor
                            : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),

                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            OpInReleaseRoomScreen,
                            color: type == 2
                                ? kPrimaryColor
                                : Colors.black,
                            width: screenHeight * (24 / 640),
                            height: screenHeight * (24 / 640),
                          ),
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          Text(
                            "오피스텔",
                            style: TextStyle(
                              fontSize: screenHeight * (12 / 640),
                              color: type == 2
                                  ? kPrimaryColor
                                  : Colors.black,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (8 / 360),
                ),
                InkWell(
                  onTap: () {
                    if (type == 3)
                      type = -1;
                    else
                      type = 3;

                    setState(() {});
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(
                              1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:type == 3
                            ? kPrimaryColor
                            : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),

                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            AptInReleaseRoomScreen,
                            color:type == 3
                                ? kPrimaryColor
                                : Colors.black,
                            width: screenHeight * (24 / 640),
                            height: screenHeight * (24 / 640),
                          ),
                          SizedBox(
                            width: screenWidth * (12 / 360),
                          ),
                          Text(
                            "아파트",
                            style: TextStyle(
                              fontSize: screenHeight * (12 / 640),
                              color:type == 3
                                  ? kPrimaryColor
                                  : Colors.black,),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  Row rentPage(double screenHeight, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * (12 / 360),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * (40 / 640),
            ),
            Row(
              children: [
                Text(
                  "보증금 제안",
                  style: TextStyle(
                    color: depositCheckBox == false
                        ? Colors.black
                        : Color(0xffE9E8E6),
                    fontWeight: FontWeight.bold,
                    fontSize: screenHeight * (24 / 640),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (8 / 360),
                ),
                Container(
                  width: screenWidth * (20 / 360),
                  height: screenHeight * (30 / 640),
                  child: Checkbox(
                    checkColor: Colors.white,
                    activeColor: kPrimaryColor,
                    value: depositCheckBox,
                    onChanged: (bool value) {
                      setState(() {
                        depositCheckBox = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: screenWidth * (4 / 360),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * (1.5 / 640)),
                  child: Text(
                    "보증금 없음",
                    style: TextStyle(
                        fontSize: screenWidth * (12 / 360),
                        color: depositCheckBox == true
                            ? kPrimaryColor
                            : Color(0xff666666)),
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Text(
              "원하시는 보증금 범위를 정해주세요",
              style: TextStyle(
                color: depositCheckBox == false
                    ? Color(0xff888888)
                    : Color(0xffE9E8E6),
                fontSize: screenHeight * (12 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (20 / 640),
            ),
            depositCheckBox == false
                ? Container(
              child: Row(
                children: [
                  Text(
                    (depositeFeesMin.floor()).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (20 / 640),
                        color: kPrimaryColor),
                  ),
                  SizedBox(
                    width: screenWidth * (2 / 360),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(bottom: screenHeight * (4 / 640)),
                    child: Text(
                      "만원",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * (20 / 640),
                          color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * (2 / 360),
                  ),
                  Text(
                    "~",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (20 / 640),
                        color: kPrimaryColor),
                  ),
                  SizedBox(
                    width: screenWidth * (2 / 360),
                  ),
                  Text(
                    depositeFeesMax.floor().toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (20 / 640),
                        color: kPrimaryColor),
                  ),
                  SizedBox(
                    width: screenWidth * (2 / 360),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(bottom: screenHeight * (4 / 640)),
                    child: Text(
                      "만원",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * (20 / 640),
                          color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            )
                : Container(),
            SizedBox(
              height: screenHeight * (32 / 640),
            ),
            depositCheckBox == false
                ? Container(
              width: screenWidth * (336 / 360),
              child: RangeSlider(
                min: 1,
                max: 1000,
                divisions: 200,

                inactiveColor: Color(0xffcccccc),
                activeColor: kPrimaryColor,
                labels: RangeLabels(depositeFeesMin.floor().toString(),
                    depositeFeesMax.floor().toString()),
                values: DepositValues,
                //RangeValues(_lowValue,_highValue),
                onChanged: (_range) {
                  setState(() {
                    DepositValues = _range;
                    depositeFeesMin = _range.start;
                    depositeFeesMax = _range.end;
                  });
                },
              ),
            )
                : Container(),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            depositCheckBox == false
                ? Row(
              children: [
                Text(
                  "최소",
                  style: TextStyle(
                      fontSize: screenHeight * (10 / 640),
                      color: Color(0xff888888)),
                ),
                SizedBox(
                  width: screenWidth * (293 / 360),
                ),
                Text(
                  "최대",
                  style: TextStyle(
                      fontSize: screenHeight * (10 / 640),
                      color: Color(0xff888888)),
                ),
              ],
            )
                : Container(),
            SizedBox(
              height: screenHeight * (20 / 640),
            ),
            Text(
              "월세 제안",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenHeight * (24 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Text(
              "원하시는 월세 범위를 정해주세요",
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: screenHeight * (12 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (20 / 640),
            ),
            Row(
              children: [
                Text(
                  (monthlyFeesMin.floor()).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * (20 / 640),
                      color: kPrimaryColor),
                ),
                SizedBox(
                  width: screenWidth * (2 / 360),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * (4 / 640)),
                  child: Text(
                    "만원",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (20 / 640),
                        color: kPrimaryColor),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (2 / 360),
                ),
                Text(
                  "~",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * (20 / 640),
                      color: kPrimaryColor),
                ),
                SizedBox(
                  width: screenWidth * (2 / 360),
                ),
                Text(
                  monthlyFeesMax.floor().toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenHeight * (20 / 640),
                      color: kPrimaryColor),
                ),
                SizedBox(
                  width: screenWidth * (2 / 360),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * (4 / 640)),
                  child: Text(
                    "만원",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (20 / 640),
                        color: kPrimaryColor),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (32 / 640),
            ),
            Container(
              width: screenWidth * (336 / 360),
              child: RangeSlider(
                min: 1,
                max: 100,
                divisions: 100,

                inactiveColor: Color(0xffcccccc),
                activeColor: kPrimaryColor,
                labels: RangeLabels(monthlyFeesMin.floor().toString(),
                    monthlyFeesMax.floor().toString()),
                values: RentValues,
                //RangeValues(_lowValue,_highValue),
                onChanged: (_range) {
                  setState(() {
                    RentValues = _range;
                    monthlyFeesMin = _range.start;
                    monthlyFeesMax = _range.end;
                  });
                },
              ),
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Row(
              children: [
                Text(
                  "최소",
                  style: TextStyle(
                      fontSize: screenHeight * (10 / 640),
                      color: Color(0xff888888)),
                ),
                SizedBox(
                  width: screenWidth * (293 / 360),
                ),
                Text(
                  "최대",
                  style: TextStyle(
                      fontSize: screenHeight * (10 / 640),
                      color: Color(0xff888888)),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Row termPage(double screenHeight, double screenWidth) {
    DateInLookForRoomsScreenProvider _dateInLookForRoomsScreenProvider =
    Provider.of<DateInLookForRoomsScreenProvider>(context);
    return Row(
      children: [
        SizedBox(
          width: screenWidth * (12 / 360),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * (20 / 640),
            ),
            Text(
              "임대 기간 제안",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenHeight * (24 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Text(
              "월세 또는 총 기간의 임대료를 입력해주세요",
              style: TextStyle(
                color: Color(0xff888888),
                fontSize: screenHeight * (12 / 640),
              ),
            ),
            SizedBox(
              height: screenHeight * (58 / 640),
            ),
            Stack(
              children: [
                Container(
                  width: screenWidth * (336 / 360),
                  child: Row(
                    children: [
                      Spacer(),
                      // SizedBox(width: screenWidth*(20/360),),
                      Container(
                          width: screenWidth * (120 / 360),
                          child: Center(
                              child: Text(
                              termOfLeaseMin==null?"입주" :termOfLeaseMin.substring(0,10),
                                style: TextStyle(
                                    fontSize: screenWidth * (20 / 360),
                                    fontWeight: FontWeight.bold,
                                    color:  Colors.black),
                              ))),
                      SizedBox(
                        width: screenWidth * (55 / 640),
                      ),
                      Text(
                        "~",
                        style: TextStyle(
                            fontSize: screenWidth * (20 / 360),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: screenWidth * (55 / 640),
                      ),
                      Container(
                          width: screenWidth * (120 / 360),
                          child: Center(
                              child: Text(
                               termOfLeaseMax == null?"퇴실":termOfLeaseMax.substring(0,10),
                                style: TextStyle(
                                    fontSize: screenWidth * (20 / 360),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ))),
                      Spacer(),
                    ],
                  ),
                ),
                Positioned(
                  child: FlatButton(
                      color: Colors.transparent,
                      onPressed: () async {
                        List<DateTime> picked2 =
                        await DateRagePicker.showDatePicker(
                            context: context,
                            initialFirstDate: picked.length == 2
                                ? picked[0]
                                : picked.length == 1
                                ? picked[0]
                                : DateTime.now(),
                            initialLastDate: picked.length == 2
                                ? picked[1]
                                : picked.length == 1
                                ? picked[0]
                                : (DateTime.now())
                                .add(Duration(days: 1)),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year + 3));
                        if (picked2.length == 1) {
                          picked2.add(picked2[0]);
                        }
                        picked = picked2;
                        termOfLeaseMin = termChange( picked[0].toString());
                        termOfLeaseMax = termChange( picked[1].toString());
                        setState(() {});
                      },
                      child: Container(
                        height: screenHeight * (35 / 640),
                        width: screenWidth * (300 / 360),
                      )),
                ),
              ],
            ),
            Container(
              width: screenWidth * (336 / 360),
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    color: Color(0xffcccccc),
                    width: screenWidth * (148 / 360),
                    height: screenHeight * (1 / 640),
                  ),
                  SizedBox(
                    width: screenWidth * (40 / 360),
                  ),
                  Container(
                    color: Color(0xffcccccc),
                    width: screenWidth * (148 / 360),
                    height: screenHeight * (1 / 640),
                  ),
                  Spacer(),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Row suggestionPage(double screenHeight, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * (12 / 360),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * (40 / 640),
            ),
            //매물종류 선택
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "기타 제안",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * (24 / 360),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (8 / 640),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "해당되는 사항을 선택해주세요",
                  style: TextStyle(
                    color: Color(0xff888888),
                    fontSize: screenWidth * (12 / 360),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (36 / 640),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "선호 기간",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * (16 / 360),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (16 / 640),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (preferTerm == 0) {
                        preferTerm = -1;
                      } else {
                        preferTerm = 0;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: preferTerm == 0 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "하루가능",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: preferTerm == 0
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (6 / 360),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (preferTerm == 1) {
                        preferTerm = -1;
                      } else {
                        preferTerm = 1;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: preferTerm == 1 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "1개월이상",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: preferTerm == 1
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (6 / 360),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (preferTerm == 2) {
                        preferTerm = -1;
                      } else {
                        preferTerm = 2;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: preferTerm == 2 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "기간 무관",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: preferTerm == 2
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (36 / 640),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "선호 성별",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * (16 / 360),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (16 / 640),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (preferSex == 0) {
                        preferSex = -1;
                      } else {
                        preferSex = 0;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: preferSex == 0 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "남자선호",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: preferSex == 0
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (6 / 360),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (preferSex == 1) {
                        preferSex = -1;
                      } else {
                        preferSex = 1;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: preferSex == 1 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "여자선호",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: preferSex == 1
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (6 / 360),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (preferSex == 2) {
                        preferSex = -1;
                      } else {
                        preferSex = 2;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color: preferSex == 2 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "성별 무관",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: preferSex == 2
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (36 / 640),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  "흡연 가능 여부",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * (16 / 360),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (16 / 640),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (smokingPossible == 0) {
                        smokingPossible = -1;
                      } else {
                        smokingPossible = 0;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:
                        smokingPossible == 0 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "흡연 가능",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: smokingPossible == 0
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (6 / 360),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (smokingPossible == 1) {
                        smokingPossible = -1;
                      } else {
                        smokingPossible = 1;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:
                        smokingPossible == 1 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "흡연 불가",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: smokingPossible == 1
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (6 / 360),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (smokingPossible == 2) {
                        smokingPossible = -1;
                      } else {
                        smokingPossible = 2;
                      }
                    });
                  },
                  child: Container(
                    width: screenWidth * (108 / 360),
                    height: screenHeight * (40 / 640),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                      border: Border.all(
                        color:
                        smokingPossible == 2 ? kPrimaryColor : Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                      color: Color(0xffffffff),
                    ),
                    child: Center(
                      child: Text(
                        "흡연 무관 ",
                        style: TextStyle(
                            fontSize: screenWidth * (12 / 360),
                            color: smokingPossible == 2
                                ? kPrimaryColor
                                : Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  SingleChildScrollView locationPage(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * (280 / 640),
            width: screenWidth,
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * (40 / 640),
                    ),
                    Text(
                      "임대 위치 제안",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * (24 / 360),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Text(
                      "※현재 서비스는 인하대학교로만 제한됩니다※",
                      style: TextStyle(
                        color: hexToColor('#6F22D2'),
                        fontSize: screenWidth * (12 / 360),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (58 / 640),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * (336 / 360),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "인하대학교",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * (20 / 360),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Container(
                      width: screenWidth * (336 / 360),
                      height: 1,
                      color: Color(0xffcccccc),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: screenWidth,
                child: SvgPicture.asset(
                  'assets/images/Map/InhaMap.svg',
                  height: screenHeight * (310 / 640),
                ),
              ),
              Positioned(
                left: screenWidth * (11 / 360),
                top: screenHeight * (14 / 640),
                child: Container(
                  width: screenHeight * (22 / 640),
                  height: screenHeight * (22 / 640),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    new BorderRadius.all(new Radius.circular(8.0)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.gps_fixed,
                      color: Color(0xff888888),
                      size: screenHeight * (14 / 640),
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                height: screenHeight * (240 / 640),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    color: kPrimaryColor,
                    size: screenHeight * (22 / 640),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector menuInLookForRoomsScreen(
      String name, int nextPage, double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () {
        if (nextPage == kindPageNum) {
          currentPage = nextPage;
        } else if (nextPage == rentPageNum) {

            currentPage = nextPage;

        } else if (nextPage == termPageNum) {

            currentPage = nextPage;

        } else if (nextPage == suggestionPageNum) {

            currentPage = nextPage;

        } else if (nextPage == locationPageNum) {

            currentPage = nextPage;

        }
        else if (nextPage == detailPageNum) {

          currentPage = nextPage;

        }
        setState(() {});
      },
      child: Container(
        height: screenHeight * (43 / 640),
        color: Color(0xffffffff),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * (12 / 360),
            ),
            Container(
                width: screenWidth * (80 / 360),
                child: Text(
                  name,
                  style: TextStyle(fontSize: screenWidth * (14 / 360),color: Color(0xff222222),),
                )),
            submittedComplete(
                screenHeight, screenWidth),
            Spacer(),
            arrowIcon(screenHeight),
            SizedBox(
              width: screenWidth * (12 / 360),
            ),
          ],
        ),
      ),
    );
  }

  Icon arrowIcon(double screenHeight) {
    return Icon(
      Icons.arrow_forward_ios,
      color: Color(0xff888888),
      size: screenHeight * (13 / 640),
    );
  }

  Container notSubmittedComplete(double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * (20 / 640),
      width: screenWidth * (54 / 360),
    );
  }

  Container submittedComplete(double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * (20 / 640),
      width: screenWidth * (54 / 360),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        //   color:  kPrimaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
          child: Text(
            "입력 완료",
            style:
            TextStyle(fontSize: screenWidth * (10 / 360), color: kPrimaryColor),
          )),
    );
  }
}

String replaceUTCDate(String dateStr){
  DateTime date = new DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(dateStr, true);
  date = date.add(Duration(hours: 9));

  return date.toLocal().toString().replaceAll('-', '').replaceAll(':', '').replaceAll('.', '').replaceAll(' ', '');
}