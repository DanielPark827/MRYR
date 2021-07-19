import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

class ModifySuggestion extends StatefulWidget {
  @override
  _ModifySuggestionState createState() => _ModifySuggestionState();
}

class _ModifySuggestionState extends State<ModifySuggestion> {
  List<String> TermList = ['하루가능','1개월이상','기간 무관'];
  List<String> SexList = ["남자선호","여자선호",'성별 무관'];
  List<String> SmokeList = ["흡연 가능","흡연 불가",'흡연 무관'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);
    if(data.condition != null && data.floor != null) {
      data.ChangeCheckComplete(true);
    } else {
      data.ChangeCheckComplete(false);
    }
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333333),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.059375,),
                Text(
                  '기타 제안',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth*(24/360),
                  ),
                ),
                SizedBox(height: screenHeight*0.0125,),
                Text(
                  '해당되는 사항을 선택해주세요',
                  style: TextStyle(
                    fontSize: screenWidth*0.033333,
                    color: hexToColor("#888888"),
                  ),
                ),
                SizedBox(height: screenHeight*0.05625,),
                Text(
                  '건물 상태',
                  style: TextStyle(
                      fontSize: screenWidth*0.04444444,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: screenHeight*0.025,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        data.ChangeCondition(1);
                        if(data.condition != null && data.floor != null) {
                          data.ChangeCheckComplete(true);
                        } else {
                          data.ChangeCheckComplete(false);
                        }
                      },
                      child: Container(
                        width: screenWidth*0.3,
                        height: screenHeight*0.0625,
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
                            color: data.condition == 1 ? kPrimaryColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                          color: Color(0xffffffff),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '신축 건물',
                            style: TextStyle(
                              fontSize: screenWidth*0.033333,
                              color: data.condition == 1 ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    widthPadding(screenWidth,6),
                    GestureDetector(
                      onTap: (){
                        data.ChangeCondition(2);
                        if(data.condition != null && data.floor != null) {
                          data.ChangeCheckComplete(true);
                        } else {
                          data.ChangeCheckComplete(false);
                        }
                      },
                      child: Container(
                        width: screenWidth*0.3,
                        height: screenHeight*0.0625,
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
                            color: data.condition == 2 ? kPrimaryColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                          color: Color(0xffffffff),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '구축 건물',
                            style: TextStyle(
                              fontSize: screenWidth*0.033333,
                              color: data.condition == 2 ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.05625,),
                Text(
                  '방 층수',
                  style: TextStyle(
                      fontSize: screenWidth*0.04444444,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: screenHeight*0.025,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        data.ChangePrefferedSex(1);
                        if(data.condition != null && data.floor != null) {
                          data.ChangeCheckComplete(true);
                        } else {
                          data.ChangeCheckComplete(false);
                        }
                      },
                      child: Container(
                        width: screenWidth*0.3,
                        height: screenHeight*0.0625,
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
                            color: data.floor == 1 ? kPrimaryColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                          color: Color(0xffffffff),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "반지하",
                            style: TextStyle(
                              fontSize: screenWidth*0.033333,
                              color: data.floor == 1 ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        data.ChangePrefferedSex(2);
                        if(data.condition != null && data.floor != null) {
                          data.ChangeCheckComplete(true);
                        } else {
                          data.ChangeCheckComplete(false);
                        }
                      },
                      child: Container(
                        width: screenWidth*0.3,
                        height: screenHeight*0.0625,
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
                            color: data.floor == 2 ? kPrimaryColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                          color: Color(0xffffffff),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "1층",
                            style: TextStyle(
                              fontSize: screenWidth*0.033333,
                              color: data.floor == 2 ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){
                        data.ChangePrefferedSex(3);
                        if(data.condition != null && data.floor != null) {
                          data.ChangeCheckComplete(true);
                        } else {
                          data.ChangeCheckComplete(false);
                        }
                      },
                      child: Container(
                        width: screenWidth*0.3,
                        height: screenHeight*0.0625,
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
                            color: data.floor == 3 ? kPrimaryColor : Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //                 <--- border radius here
                          ),
                          color: Color(0xffffffff),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '2층 이상',
                            style: TextStyle(
                              fontSize: screenWidth*0.033333,
                              color: data.floor == 3 ? kPrimaryColor : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight*0.05625,),
              ],
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            if(!data.FlagEnterRoomInfo[5]) {
              if(data.CheckCompleteFlag == true) {
                data.ChangeFlagEnterRoomInfo(5, true);
                data.ChangeCheckComplete(false);
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
                color: data.CheckCompleteFlag == true ? kPrimaryColor : hexToColor("#CCCCCC")
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
