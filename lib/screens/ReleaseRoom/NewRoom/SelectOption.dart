import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

class SelectOption extends StatefulWidget {
  @override
  _SelectOptionState createState() => _SelectOptionState();
}

class _SelectOptionState extends State<SelectOption> {

  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);

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
                Navigator.pop(context);
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.059375,),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*(12/360)),
                  child: Text(
                    '옵션 선택',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*(24/360),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.0125,),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*(12/360)),
                  child: Text(
                    '방에 포함된 옵션을 선택해주세요',
                    style: TextStyle(
                      fontSize: screenWidth*0.033333,
                      color: hexToColor("#888888"),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.05625,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 0,BedIcon, '침대'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 1,DeskIcon, '책상'),
                  ],
                ),
                SizedBox(height: screenHeight*0.0125,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 2,ChairIcon, '의자'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 3,ClosetIcon, '옷장'),
                  ],
                ),
                SizedBox(height: screenHeight*0.0125,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 4,AirConditionerIcon, '에어컨'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 5,InductionIcon, '인덕션'),
                  ],
                ),
                SizedBox(height: screenHeight*0.0125,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 6,RefrigeratorIcon, '냉장고'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 7,tvInReleaseRoomScreen, 'TV'),
                  ],
                ),
                SizedBox(height: screenHeight*0.0125,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 8,DoorLockIcon, '도어락'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 9,MicrowaveIcon, '전자레인지'),
                  ],
                ),
                SizedBox(height: screenHeight*0.0125,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 10,WasherIcon, '세탁기'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 11,CCTVIcon, '복도 CCTV'),
                  ],
                ),
                SizedBox(height: screenHeight*0.0125,),
                Row(
                  children: [
                    buildOptionComponent(screenWidth, screenHeight, data, 12,WifiIcon, '와이파이'),
                    SizedBox(width: screenWidth*0.02222222,),
                    buildOptionComponent(screenWidth, screenHeight, data, 13, ParkingIcon, '주차 가능'),
                  ],
                ),
              ],
            ),

          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            if(!data.FlagEnterRoomInfo[6]) {
              data.ChangeFlagEnterRoomInfo(6, true);
              data.ChangeCompleteCheck(++data.CompleteCheck);
              data.changeCurStep(++data.curStep);
              Navigator.pop(context);
            } else {
              data.ChangeCheckComplete(false);
              Navigator.pop(context);
            }
          },
          child: Container(
            height: screenHeight*0.09375,
            width: screenWidth,
            decoration: BoxDecoration(
                color: kPrimaryColor
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

  GestureDetector buildOptionComponent(double screenWidth, double screenHeight, EnterRoomInfoProvider data, int index, String Img, String Title) {
    return GestureDetector(
      onTap: (){
        data.ChangeOptionListComponent(index, !data.OptionList[index]);
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
                    offset: Offset(1, 1), // changes position of shadow
                  ),
                ],
                border: Border.all(
                  color: data.OptionList[index] == true ? kPrimaryColor : Colors.white,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(Radius.circular(
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
                      Img,
                      color: data.OptionList[index] == true ? kPrimaryColor : Colors.black,
                      width: screenHeight * (24 / 640),
                      height: screenHeight * (24 / 640),
                    ),
                    SizedBox(
                      width: screenWidth * (12 / 360),
                    ),
                    Text(
                      Title,
                      style: TextStyle(
                          fontSize: screenHeight * (12 / 640),
                          color: data.OptionList[index] == true ? kPrimaryColor : Colors.black
                    ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
