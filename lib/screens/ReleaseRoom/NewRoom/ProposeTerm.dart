import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

class ProposeTerm extends StatefulWidget {
  @override
  _ProposeTermState createState() => _ProposeTermState();
}

bool FlagForInitialDate = false;
bool FlagForLastDate = false;

class _ProposeTermState extends State<ProposeTerm> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);

    CheckForProposeTerm(data);
  }


  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider = Provider.of<DateInReleaseRoomsScreenProvider>(context);

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
                                        //시작 날짜가 끝 날짜를 넘지 못하도록
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
                                        currentTime: DateTime.now(), locale: LocaleType.ko);
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
                                    if(data.rentStart == null) {
                                      Function okFunc = () {
                                        Navigator.pop(context);
                                      };
                                      OKDialog(context, "입주 날짜부터 입력해주세요!", "", "알겠어요!",okFunc);
                                    }
                                    else {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          //끝날짜가 시작날짜를 넘지 않도록
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
                                          currentTime: DateTime.now(), locale: LocaleType.ko);
                                      CheckForProposeTerm(data);
                                    }
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
                data.changeCurStep(++data.curStep);
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
