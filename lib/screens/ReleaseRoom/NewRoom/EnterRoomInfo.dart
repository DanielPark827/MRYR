import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

import 'ProposeTerm.dart';
import 'StudentIdentification.dart';

class EnterRoomInfo extends StatefulWidget {
  @override
  _EnterRoomInfoState createState() => _EnterRoomInfoState();
}

class _EnterRoomInfoState extends State<EnterRoomInfo> {
  List<String> RoomInfoList = ['방 종류','방 위치','기본 정보','보증금월세','임대 기간','기타 제안','옵션 선택','상세 정보','방 사진'];
  List<String> RouteList = ['/SelectItemCategory','/ItemLocation','/PutItemInfo','/ProposePrice','/ProposeTerm','/OtherSuggestion','/SelectOption','/ItemDescription','/ItemImg'];

  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DummyUser data2 = Provider.of<DummyUser>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        Function okFunc = () async {
          data.ResetEnterRoomInfoProvider();
          data2.ResetDummyUser();
          f= null;
          FlagForInitialDate = false;
          FlagForLastDate = false;
          setState(() {
          });
          Navigator.pushReplacement(
              context, // 기본 파라미터, SecondRoute로 전달
              MaterialPageRoute(
                  builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
          );
        };

        Function cancelFunc = () {
          Navigator.pop(context);
        };

        OKCancelDialog(context, "처음으로 돌아가시겠습니까?","입력된 매물의 정보가\n모두 삭제됩니다. 계속하시겠습니까?", "확인", "취소", okFunc, cancelFunc);
        return;
      },
      child: MediaQuery(
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
                  Function okFunc = () async {
                    data.ResetEnterRoomInfoProvider();
                    data2.ResetDummyUser();
                    f= null;
                    FlagForInitialDate = false;
                    FlagForLastDate = false;
                    setState(() {
                    });
                    Navigator.pushReplacement(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
                    );
                  };

                  Function cancelFunc = () {
                    Navigator.pop(context);
                  };

                  OKCancelDialog(context, "처음으로 돌아가시겠습니까?","입력된 매물의 정보가\n모두 삭제됩니다. 계속하시겠습니까?", "확인", "취소", okFunc, cancelFunc);
                }),
            title: GestureDetector(
              onTap: (){
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
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
                            width: screenWidth * (290/360),
                            height: screenHeight * (400/640),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: screenHeight*(28/640),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: screenWidth*(28/360),),
                                        SvgPicture.asset(
                                          'assets/images/releaseRoomScreen/imgText1.svg',
                                          height: screenHeight*(28/640),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*(4/640),),
                                    Row(
                                      children: [
                                        SizedBox(width: screenWidth*(28/360),),
                                        SvgPicture.asset(
                                          'assets/images/releaseRoomScreen/imgText2.svg',
                                          height: screenHeight*(84/640),
                                          width: screenWidth*(100/360),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom:screenHeight*(64/640),
                                  child:
                                  Row(
                                    children: [
                                      SizedBox(width: screenWidth*(22/360),),
                                      SvgPicture.asset(
                                        'assets/images/releaseRoomScreen/imgImg1.svg',
                                        width:screenWidth*(256/360),
                                        // height: screenHeight*(257/640),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom:0,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                        Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: screenWidth * (290/360),
                                          height: screenHeight * (60/640),
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8.0),bottomRight: Radius.circular(8.0))
                                          ),

                                          child: Center(
                                            child: Text(
                                                '내놓은 매물 보러가기',
                                                style: TextStyle(
                                                  fontSize: screenWidth*(18/360),
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                )
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                    }
                );
              },
              child: SvgPicture.asset(
                MryrLogoInReleaseRoomTutorialScreen,
                width: screenHeight * (110 / 640),
                height: screenHeight * (27 / 640),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.059375,),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.033333),
                  child: Text(
                    '방 정보 입력',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*(24/360),
                    ),
                  ),
                ),
                heightPadding(screenHeight,8),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.033333),
                  child: Text(
                    '방에 대한 정확한 정보를 입력해주세요',
                    style: TextStyle(
                      fontSize: screenWidth*0.033333,
                      color: hexToColor("#888888"),
                    ),
                  ),
                ),
                heightPadding(screenHeight,8),
                Padding(
                  padding: EdgeInsets.only(right: screenWidth*(8/360)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                        data.curStep.toString() + "/9",
                        style: TextStyle(
                          fontSize: screenWidth*(14/360),
                          color: kPrimaryColor
                        ),
                    ),
                  ),
                ),
                heightPadding(screenHeight,4),
                Row(
                  children: [
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 1 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 2 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 3 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 4 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 5 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 6 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 7 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 8 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: data.curStep >= 9 ? kPrimaryColor : hexToColor('#EEEEEE'),
                    ),
                  ],
                ),
                SizedBox(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Container(
                      color: hexToColor("#F8F8F8"),
                      height: screenHeight * 0.0015625,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: RoomInfoList.length,
                    itemBuilder: (BuildContext context, int index) => RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      onPressed: (){
                        data.transferType;
                        if(index <= data.CompleteCheck) {
                          Navigator.pushNamed(context, '${RouteList[index]}');
                        }
                        // Navigator.pushNamed(context, '${RouteList[index]}');
                      },
                      child: Container(
                        height: screenHeight*0.0671875,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth*0.03333,
                            ),

                            Container(
                              width: screenWidth*(150/360),
                              child: Text(
                                index ==3 &&  data.transferType != 0 ? "전세금제안" : '${RoomInfoList[index]}' ,
                                style: TextStyle(
                                    fontSize: screenWidth*0.03888,
                                    color: index <= data.CompleteCheck ? Colors.black : hexToColor('#928E8E')
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            index <= data.CompleteCheck-1 ? Container(
                              height: screenHeight*0.0296875,
                              width: screenWidth*0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: kPrimaryColor),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '입력 완료',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: screenWidth*0.0277777
                                  ),
                                ),
                              ),
                            ) : SizedBox(),
                            widthPadding(screenWidth,20),
                            index <= data.CompleteCheck ? SvgPicture.asset(
                              GreyNextIcon,
                              height: screenHeight*0.025,
                              width: screenHeight*0.025,
                            ) : SizedBox(),
                            SizedBox(
                              width: screenWidth*0.03333,
                            ),
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
