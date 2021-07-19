import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

class ModifyItemInfo extends StatefulWidget {
  @override
  _ModifyItemInfoState createState() => _ModifyItemInfoState();
}

class _ModifyItemInfoState extends State<ModifyItemInfo> {
  TextEditingController originalMonthlyRent ;
  TextEditingController originalDeposit;
  TextEditingController maintenanceCost;
  TextEditingController averageUtilityCharge;
  TextEditingController area;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  final FocusNode _nodeText4 = FocusNode();
  final FocusNode _nodeText5 = FocusNode();
  KeyboardActionsItem returnKeyboardActionItem(FocusNode item) {
    return KeyboardActionsItem(
      focusNode: item,
      onTapAction: () {
        FocusScope.of(context).unfocus();
      },
    );
  }
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.grey[200],
        nextFocus: true,
        actions: [
          returnKeyboardActionItem(_nodeText1),
          returnKeyboardActionItem(_nodeText2),
          returnKeyboardActionItem(_nodeText3),
          returnKeyboardActionItem(_nodeText4),
          returnKeyboardActionItem(_nodeText5),
        ]
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);

    if(data.ExistingMonthlyRent != null && data.ExistingMonthlyRent != 0) {
      originalMonthlyRent = TextEditingController(text:data.ExistingMonthlyRent.toString() );
    }
    if(data.ExistingDeposit != null && data.ExistingDeposit != 0) {
      originalDeposit = TextEditingController(text:data.ExistingDeposit.toString() );
    }
    if(data.AdministrativeExpenses != null && data.AdministrativeExpenses != 0) {
      maintenanceCost = TextEditingController(text:data.AdministrativeExpenses.toString() );
    }
    if(data.AverageUtilityBill != null && data.AverageUtilityBill != 0) {
      averageUtilityCharge = TextEditingController(text:data.AverageUtilityBill.toString() );
    }
    if(data.AreaSize != null && data.AreaSize != 0) {
      area = TextEditingController(text:data.AreaSize.toString() );
    }
    CheckForPutItemInfo(data);
  }

  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
          backgroundColor: Colors.white,
          appBar: AppBar(
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
          body: KeyboardActions(
            config: _buildConfig(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.059375,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '거래유형',
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
                  '방의 거래유형 정보를 입력해주세요',
                  style: TextStyle(
                    fontSize: screenWidth*0.033333,
                    color: hexToColor("#888888"),
                  ),
                ),
              ),
              heightPadding(screenHeight,36),
              Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: () {
                      data.changeTransferType(1);
                      CheckForPutItemInfo(data);
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
                          color: data.transferType == 1? kPrimaryColor : Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                        color: Color(0xffffffff),
                      ),
                      child: Center(
                        child: Text(
                          "월세",
                          style: TextStyle(
                              fontSize: screenHeight * (12 / 640),
                              color: data.transferType == 1
                                  ? kPrimaryColor
                                  : Color(0xff222222)),
                        ),
                      ),
                    ),
                  ),
                  widthPadding(screenWidth,8),
                  InkWell(
                    onTap: () {
                      data.changeTransferType(2);
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
                          color: data.transferType == 2? kPrimaryColor : Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                        color: Color(0xffffffff),
                      ),
                      child: Center(
                        child: Text(
                          "전세",
                          style: TextStyle(
                              fontSize: screenHeight * (12 / 640),
                              color: data.transferType == 2
                                  ? kPrimaryColor
                                  : Color(0xff222222)),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: screenHeight*(60/640),),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '기본 정보 (가격)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth*0.066666,
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.0125,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.033333),
                child: Text(
                  '방의 기본적인 정보를 입력해주세요',
                  style: TextStyle(
                    fontSize: screenWidth*0.033333,
                    color: hexToColor("#888888"),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.05625,),
              Container(
                height: 1,
                color: Color(0xfff8f8f8),
              ),
              Container(
                height: screenHeight * (230 / 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Container(
                            width: screenWidth * (124 / 360),
                            child: Text(
                              "기존 월세",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222)),
                            )),
                        Container(
                            width: screenWidth * (80 / 360),
                            child: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (14 / 360),
                                color: hexToColor("#222222"),
                              ),
                              textAlign: TextAlign.center,
                              inputFormatters: <TextInputFormatter> [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              focusNode: _nodeText1,
                              controller: originalMonthlyRent,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                hintText: '18',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (16 / 360),
                                  color: hexToColor("#cccccc"),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text){
                                if(text == "") {
                                  data.ChangeExistingMonthlyRent(-1);//-1이면 아무것도 안적힌 상태를 의미함
                                } else {
                                  data.ChangeExistingMonthlyRent(int.parse(text));
                                }
                                CheckForPutItemInfo(data);
                              },
                            )),
                        Text(
                          "만원",
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 1,
                      color: Color(0xfff8f8f8),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Container(
                            width: screenWidth * (124 / 360),
                            child: Text(
                              "기존 보증금",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222)),
                            )),
                        Container(
                            width: screenWidth * (80 / 360),
                            child: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (14 / 360),
                                color: hexToColor("#222222"),
                              ),
                              textAlign: TextAlign.center,
                              inputFormatters: <TextInputFormatter> [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              focusNode: _nodeText2,
                              controller: originalDeposit,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                hintText: '200',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (16 / 360),
                                  color: hexToColor("#cccccc"),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text){
                                if(text == "") {
                                  data.ChangeExistingDeposit(-1);
                                } else {
                                  data.ChangeExistingDeposit(int.parse(text));
                                }
                                CheckForPutItemInfo(data);
                              },
                            )),
                        Text(
                          "만원",
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 1,
                      color: Color(0xfff8f8f8),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Container(
                            width: screenWidth * (124 / 360),
                            child: Text(
                              "관리비",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222)),
                            )),
                        Container(
                            width: screenWidth * (80 / 360),
                            child: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (14 / 360),
                                color: hexToColor("#222222"),
                              ),
                              textAlign: TextAlign.center,
                              inputFormatters: <TextInputFormatter> [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              focusNode: _nodeText3,
                              controller: maintenanceCost,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                hintText: '5',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (16 / 360),
                                  color: hexToColor("#cccccc"),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text){
                                if(text == "") {
                                  data.ChangeAdministrativeExpenses(-1);
                                } else {
                                  data.ChangeAdministrativeExpenses(int.parse(text));
                                }
                                CheckForPutItemInfo(data);
                              },
                            )),
                        Text(
                          "만원",
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 1,
                      color: Color(0xfff8f8f8),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Container(
                            width: screenWidth * (124 / 360),
                            child: Text(
                              "평균 공과금",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222)),
                            )),
                        Container(
                            width: screenWidth * (80 / 360),
                            child: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (14 / 360),
                                color: hexToColor("#222222"),
                              ),
                              textAlign: TextAlign.center,
                              inputFormatters: <TextInputFormatter> [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              focusNode: _nodeText4,
                              controller: averageUtilityCharge,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                hintText: '4',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (16 / 360),
                                  color: hexToColor("#cccccc"),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text){
                                if(text == "") {
                                  data.ChangeAverageUtilityBill(-1);
                                } else {
                                  data.ChangeAverageUtilityBill(int.parse(text));
                                }
                                CheckForPutItemInfo(data);
                              },
                            )),
                        Text(
                          "만원",
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * (12 / 360),
                        ),
                        Container(
                            width: screenWidth * (124 / 360),
                            child: Text(
                              "면적",
                              style: TextStyle(
                                  fontSize: screenWidth * (16 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff222222)),
                            )),
                        Container(
                            width: screenWidth * (80 / 360),
                            child: TextField(
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (14 / 360),
                                color: hexToColor("#222222"),
                              ),
                              textAlign: TextAlign.center,
                              inputFormatters: <TextInputFormatter> [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              focusNode: _nodeText5,
                              controller: area,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 5),
                                hintText: '5',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * (16 / 360),
                                  color: hexToColor("#cccccc"),
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              onChanged: (text){
                                if(text == "") {
                                  data.ChangeAreaSize(-1);
                                } else {
                                  data.ChangeAreaSize(int.parse(text));
                                }
                                CheckForPutItemInfo(data);
                              },
                            )),
                        Text(
                          "평",
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
          bottomNavigationBar: GestureDetector(
            onTap: (){
              if(!data.FlagEnterRoomInfo[2]) {
                if(data.CheckCompleteFlag == true) {
                  data.ChangeFlagEnterRoomInfo(2, true);
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
      ),
    );
  }

  void CheckForPutItemInfo(EnterRoomInfoProvider data) {
    if(data.ExistingMonthlyRent != null && data.ExistingDeposit != null && data.AdministrativeExpenses != null && data.AverageUtilityBill != null&& data.AreaSize != null &&
        data.ExistingMonthlyRent != -1 && data.ExistingDeposit != -1 && data.AdministrativeExpenses != -1 && data.AverageUtilityBill != -1&& data.AreaSize != -1
        ) {

      data.ChangeCheckComplete(true);
    } else {
      data.ChangeCheckComplete(false);
    }
  }
}
