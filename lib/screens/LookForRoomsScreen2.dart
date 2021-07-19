import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/screens/DashBoardScreen.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class LookForRoomsScreen2 extends StatefulWidget {
  int currentPage;

  LookForRoomsScreen2({Key key, this.currentPage}) : super(key: key);

  @override
  _LookForRoomsScreen2State createState() => _LookForRoomsScreen2State();
}

class _LookForRoomsScreen2State extends State<LookForRoomsScreen2> {
  bool one = false;
  bool two = false;
  bool op = false;
  bool apt = false;
  RangeValues DepositValues = RangeValues(1, 1000);
  RangeValues RentValues = RangeValues(1, 100);
  double Deposit_lowValue = 1;
  double Deposit_highValue = 1000;
  double Rent_lowValue = 1;
  double Rent_highValue = 100;

  int type = 0;
  int rent = 1;
  int term = 2;
  int suggestion = 3;
  int location = 4;

  bool depositCheckBox = false;

  bool longTerm = false;
  bool shortTerm = false;
  bool anytime = false;

  bool man = false;
  bool woman = false;
  bool everyone = false;

  bool smokeOk = false;
  bool smokeNotOk = false;
  bool smokeDontCare = false;
  String adressValue = "주소를 검색해주세요";
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
                Navigator.of(context).pop();
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * (500 / 640),
                width: screenWidth,
                color: Colors.white,
                child: Row(
                  children: [
                    widget.currentPage == type
                        ? typeBody(screenHeight, screenWidth)
                        : widget.currentPage == rent
                            ? rentBody(screenHeight, screenWidth)
                            : widget.currentPage == term
                                ? termBody(screenHeight, screenWidth)
                                : widget.currentPage == suggestion
                                    ? suggestionBody(screenHeight, screenWidth)
                                    : widget.currentPage == location
                                        ? locationBody(screenHeight, screenWidth)
                                        : Container(
                                            child: CircularProgressIndicator())
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: screenWidth,
            height: screenHeight * (60 / 640),
            color: kPrimaryColor,
            child: Center(
              child: Text(
                "다음",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * (16 / 360),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row typeBody(double screenHeight, double screenWidth) {
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
                    setState(() {
                      one == true ? one = false : one = true;
                      two = false;
                      op = false;
                      apt = false;
                    });
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: buildColorBoxDecoration(
                        one == true ? kPrimaryColor : Color(0xffffffff)),
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            OneRoomInReleaseRoomScreen,
                            color: one == true ? Colors.white : Colors.black,
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
                                color: one == true
                                    ? Colors.white
                                    : Color(0xff222222)),
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
                    setState(() {
                      one = false;
                      two == true ? two = false : two = true;
                      op = false;
                      apt = false;
                    });
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: buildColorBoxDecoration(
                        two == true ? kPrimaryColor : Color(0xffffffff)),
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            TwoRoomInReleaseRoomScreen,
                            color: two == true ? Colors.white : Colors.black,
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
                                color: two == true
                                    ? Colors.white
                                    : Color(0xff222222)),
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
                    setState(() {
                      one = false;
                      two = false;
                      op == true ? op = false : op = true;
                      apt = false;
                    });
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: buildColorBoxDecoration(
                        op == true ? kPrimaryColor : Color(0xffffffff)),
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            OpInReleaseRoomScreen,
                            color: op == true ? Colors.white : Colors.black,
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
                                color: op == true
                                    ? Colors.white
                                    : Color(0xff222222)),
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
                    setState(() {
                      one = false;
                      two = false;
                      op = false;
                      apt == true ? apt = false : apt = true;
                    });
                  },
                  child: Container(
                    width: screenWidth * (164 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: buildColorBoxDecoration(
                        apt == true ? kPrimaryColor : Color(0xffffffff)),
                    child: Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * (8 / 360),
                          ),
                          SvgPicture.asset(
                            AptInReleaseRoomScreen,
                            color: apt == true ? Colors.white : Colors.black,
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
                                color: apt == true
                                    ? Colors.white
                                    : Color(0xff222222)),
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

  Row rentBody(double screenHeight, double screenWidth) {
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
                          (Deposit_lowValue.floor()).toString(),
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
                          Deposit_highValue.floor().toString(),
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
                      labels: RangeLabels(Deposit_lowValue.floor().toString(),
                          Deposit_highValue.floor().toString()),
                      values: DepositValues,
                      //RangeValues(_lowValue,_highValue),
                      onChanged: (_range) {
                        setState(() {
                          DepositValues = _range;
                          Deposit_lowValue = _range.start;
                          Deposit_highValue = _range.end;
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
                  (Rent_lowValue.floor()).toString(),
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
                  Rent_highValue.floor().toString(),
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
                labels: RangeLabels(Rent_lowValue.floor().toString(),
                    Rent_highValue.floor().toString()),
                values: RentValues,
                //RangeValues(_lowValue,_highValue),
                onChanged: (_range) {
                  setState(() {
                    RentValues = _range;
                    Rent_lowValue = _range.start;
                    Rent_highValue = _range.end;
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

  Row termBody(double screenHeight, double screenWidth) {
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
                            _dateInLookForRoomsScreenProvider.getTimeState() ==
                                    false
                                ? "입주"
                                : _dateInLookForRoomsScreenProvider
                                    .getStringInitialDate(),
                            style: TextStyle(
                                fontSize: screenWidth * (20 / 360),
                                fontWeight: FontWeight.bold,
                                color: _dateInLookForRoomsScreenProvider
                                            .getTimeState() ==
                                        false
                                    ? Color(0xffcccccc)
                                    : Colors.black),
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
                            _dateInLookForRoomsScreenProvider.getTimeState() ==
                                    false
                                ? "퇴실"
                                : _dateInLookForRoomsScreenProvider
                                    .getStringLastDate(),
                            style: TextStyle(
                                fontSize: screenWidth * (20 / 360),
                                fontWeight: FontWeight.bold,
                                color: _dateInLookForRoomsScreenProvider
                                            .getTimeState() ==
                                        false
                                    ? Color(0xffcccccc)
                                    : Colors.black),
                          ))),
                      Spacer(),
                    ],
                  ),
                ),
                Positioned(
                  child: FlatButton(
                      color: Colors.transparent,
                      onPressed: () async {
                        List<DateTime> picked =
                            await DateRagePicker.showDatePicker(
                                context: context,
                                initialFirstDate:
                                    _dateInLookForRoomsScreenProvider
                                                .getDate()
                                                .length ==
                                            2
                                        ? _dateInLookForRoomsScreenProvider
                                            .getInitialDate()
                                        : _dateInLookForRoomsScreenProvider
                                                    .getDate()
                                                    .length ==
                                                1
                                            ? _dateInLookForRoomsScreenProvider
                                                .getInitialDate()
                                            : DateTime.now(),
                                initialLastDate:
                                    _dateInLookForRoomsScreenProvider
                                                .getDate()
                                                .length ==
                                            2
                                        ? _dateInLookForRoomsScreenProvider
                                            .getLastDate()
                                        : _dateInLookForRoomsScreenProvider
                                                    .getDate()
                                                    .length ==
                                                1
                                            ? _dateInLookForRoomsScreenProvider
                                                .getInitialDate()
                                            : (DateTime.now())
                                                .add(Duration(days: 1)),
                                firstDate: DateTime(DateTime.now().year),
                                lastDate: DateTime(DateTime.now().year + 1));
                        if (picked.length == 1) {
                          picked.add(picked[0]);
                        }
                        _dateInLookForRoomsScreenProvider.setDate(picked);
                        _dateInLookForRoomsScreenProvider.setTimeState();
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

  Row suggestionBody(double screenHeight, double screenWidth) {
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
                      if (shortTerm == false) {
                        shortTerm = true;
                        longTerm = false;
                        anytime = false;
                      } else {
                        shortTerm = false;
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
                        color: shortTerm == true ? kPrimaryColor : Colors.white,
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
                            color: shortTerm == true
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
                      if (longTerm == false) {
                        shortTerm = false;
                        longTerm = true;
                        anytime = false;
                      } else {
                        longTerm = false;
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
                        color: longTerm == true ? kPrimaryColor : Colors.white,
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
                            color: longTerm == true
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
                      if (anytime == false) {
                        shortTerm = false;
                        longTerm = false;
                        anytime = true;
                      } else {
                        anytime = false;
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
                        color: anytime == true ? kPrimaryColor : Colors.white,
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
                            color: anytime == true
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
                      if (man == false) {
                        man = true;
                        woman = false;
                        everyone = false;
                      } else {
                        man = false;
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
                        color: man == true ? kPrimaryColor : Colors.white,
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
                            color: man == true
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
                      if (woman == false) {
                        man = false;
                        woman = true;
                        everyone = false;
                      } else {
                        woman = false;
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
                        color: woman == true ? kPrimaryColor : Colors.white,
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
                            color: woman == true
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
                      if (everyone == false) {
                        man = false;
                        woman = false;
                        everyone = true;
                      } else {
                        everyone = false;
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
                        color: everyone == true ? kPrimaryColor : Colors.white,
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
                            color: everyone == true
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
                      if (smokeOk == false) {
                        smokeOk = true;
                        smokeNotOk = false;
                        smokeDontCare = false;
                      } else {
                        smokeOk = false;
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
                        color: smokeOk == true ? kPrimaryColor : Colors.white,
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
                            color: smokeOk == true
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
                      if (smokeNotOk == false) {
                        smokeOk = false;
                        smokeNotOk = true;
                        smokeDontCare = false;
                      } else {
                        smokeNotOk = false;
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
                            smokeNotOk == true ? kPrimaryColor : Colors.white,
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
                            color: smokeNotOk == true
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
                      if (smokeDontCare == false) {
                        smokeOk = false;
                        smokeNotOk = false;
                        smokeDontCare = true;
                      } else {
                        smokeDontCare = false;
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
                        color: smokeDontCare == true
                            ? kPrimaryColor
                            : Colors.white,
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
                            color: smokeDontCare == true
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

  SingleChildScrollView locationBody(double screenHeight, double screenWidth) {
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
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
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
}
