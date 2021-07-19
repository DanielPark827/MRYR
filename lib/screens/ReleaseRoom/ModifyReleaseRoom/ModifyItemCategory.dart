import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

class ModifyItemCategory extends StatefulWidget {


  @override
  _ModifyItemCategoryState createState() => _ModifyItemCategoryState();
}

class _ModifyItemCategoryState extends State<ModifyItemCategory> {

  int Dtype;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
//        leading: IconButton(
//            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//            onPressed: () {
//              Navigator.pop(context);
//            }),
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
            SizedBox(height: screenHeight*0.059375,),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*0.033333),
              child: Text(
                '방 종류 선택',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth*(24/360),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.0125,),
            Padding(
              padding: EdgeInsets.only(left: screenWidth*0.033333),
              child: Text(
                '구하실 방의 종류를 선택해주세요',
                style: TextStyle(
                  fontSize: screenWidth*0.033333,
                  color: hexToColor("#888888"),
                ),
              ),
            ),
            SizedBox(height: screenHeight*0.05625,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    data.ChangeItemCategory(0);
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
                        color: data.ItemCategory == 0 ? kPrimaryColor : Colors.white,
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
                            OneRoomInReleaseRoomScreen,
                            color: data.ItemCategory == 0 ? kPrimaryColor : Colors.black,
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
                                color: data.ItemCategory == 0
                                    ? kPrimaryColor
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
                    data.ChangeItemCategory(1);
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
                        color: data.ItemCategory == 1? kPrimaryColor : Colors.white,
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
                            TwoRoomInReleaseRoomScreen,
                            color: data.ItemCategory == 1 ? kPrimaryColor : Colors.black,
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
                                color: data.ItemCategory == 1
                                    ? kPrimaryColor
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
                    data.ChangeItemCategory(2);
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
                        color: data.ItemCategory == 2? kPrimaryColor : Colors.white,
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
                            OpInReleaseRoomScreen,
                            color: data.ItemCategory == 2 ? kPrimaryColor : Colors.black,
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
                                color:
                                data.ItemCategory == 2  ? kPrimaryColor : Color(0xff222222)),
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
                    data.ChangeItemCategory(3);
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
                        color: data.ItemCategory == 3 ? kPrimaryColor : Colors.white,
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
                            AptInReleaseRoomScreen,
                            color: data.ItemCategory == 3 ? kPrimaryColor : Colors.black,
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
                                color: data.ItemCategory == 3
                                    ? kPrimaryColor
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
        bottomNavigationBar: GestureDetector(
          onTap: (){
            if(!data.FlagEnterRoomInfo[0]) {
              if(data.ItemCategory != null) {
                data.ChangeFlagEnterRoomInfo(0, true);
                data.ChangeCompleteCheck(++data.CompleteCheck);
                Navigator.pop(context);
              }
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            height: screenHeight*0.09375,
            width: screenWidth,
            decoration: BoxDecoration(
                color: data.ItemCategory != null ? kPrimaryColor : hexToColor("#CCCCCC")
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
}
