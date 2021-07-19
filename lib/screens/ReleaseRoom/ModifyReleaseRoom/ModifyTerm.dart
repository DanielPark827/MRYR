import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ModifyTerm extends StatefulWidget {
  @override
  _ModifyTermState createState() => _ModifyTermState();
}

class _ModifyTermState extends State<ModifyTerm> {
  bool FlagForInitialDate = false;
  bool FlagForLastDate = false;

  DateTime dStart;
  DateTime dDone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider =
    Provider.of<DateInReleaseRoomsScreenProvider>(context,listen: false);
    FlagForInitialDate = true;
    FlagForLastDate = true;

    CheckForProposeTerm(data);
  }


  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider = Provider.of<DateInReleaseRoomsScreenProvider>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    dStart = DateFormat('y.MM.d').parse(data.rentStart);
    dDone =DateFormat('y.MM.d').parse(data.rentDone);

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
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * (242 / 640),
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
                        "양도 기간 제안",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth*(24/360),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
                      Text(
                        "원하시는 임대 기간을 입력해주세요",
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
                                GestureDetector(
                                  onTap: (){
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                                        maxTime: data.rentDone != null ? DateTime(DateFormat('y.MM.d').parse(data.rentDone).year, DateFormat('y.MM.d').parse(data.rentDone).month,DateFormat('y.MM.d').parse(data.rentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                        theme: DatePickerTheme(
                                            headerColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            itemStyle: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                        onChanged: (date) {
                                          data.changeRentStart(DateFormat('y.MM.d').format(date));
                                        },
                                        currentTime: dStart, locale: LocaleType.ko);
                                    CheckForProposeTerm(data);
                                  },
                                  child: Container(
                                    width: screenWidth * (120 / 360),
                                    child: Center(
                                      child: Text(
                                        data.rentStart == null ? "입주" : data.rentStart,
                                        style: TextStyle(
                                          fontSize: screenWidth * (20 / 360),
                                          fontWeight: FontWeight.bold,
                                          color: data.rentStart == null ? hexToColor('#CCCCCC') : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                                GestureDetector(
                                  onTap: (){
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: data.rentStart != null ? DateTime(DateFormat('y.MM.d').parse(data.rentStart).year, DateFormat('y.MM.d').parse(data.rentStart).month,DateFormat('y.MM.d').parse(data.rentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                        theme: DatePickerTheme(
                                            headerColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            itemStyle: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                        onChanged: (date) {
                                          data.changeRentDone(DateFormat('y.MM.d').format(date));
                                        },
                                        currentTime: dDone, locale: LocaleType.ko);
                                    CheckForProposeTerm(data);
                                  },
                                  child: Container(
                                    width: screenWidth * (120 / 360),
                                    child: Center(
                                      child: Text(
                                        data.rentDone == null ? "퇴실" : data.rentDone,
                                        style: TextStyle(
                                          fontSize: screenWidth * (20 / 360),
                                          fontWeight: FontWeight.bold,
                                          color: data.rentDone == null ? hexToColor('#CCCCCC') : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
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
              ),
            ),
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            if(!data.FlagEnterRoomInfo[4]) {
              if(CheckForProposeTerm(data)) {
                data.ChangeFlagEnterRoomInfo(4, true);
                data.ChangeCheckComplete(false);
                data.ChangeCompleteCheck(++data.CompleteCheck);
                Navigator.pop(context);
              }
            } else {
              data.ChangeCheckComplete(false);
              Navigator.pop(context);
            }
          },

          child: Container(
            height: screenHeight*0.09375,
            width: screenWidth,
            decoration: BoxDecoration(
                color: CheckForProposeTerm(data) ? kPrimaryColor : hexToColor("#CCCCCC")
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '완료',
                style: TextStyle(
                    fontSize: screenWidth*0.0444444,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool CheckForProposeTerm(EnterRoomInfoProvider data) {
    if(data.rentStart != null && data.rentDone != null) {
      return true;
    }
    else {
      return false;
    }

  }
}
