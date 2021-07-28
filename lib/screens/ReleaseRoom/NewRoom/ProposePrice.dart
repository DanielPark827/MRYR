import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import  'package:keyboard_actions/keyboard_actions.dart';

class ProposePrice extends StatefulWidget {
  @override
  _ProposePriceState createState() => _ProposePriceState();
}

class _ProposePriceState extends State<ProposePrice> {
  bool one = false;
  bool two = false;
  bool op = false;
  bool apt = false;

  bool depositCheckBox = false;
  bool monthlyRentCheckBox = false;

  TextEditingController suggestDeposit;
  TextEditingController suggestMonthlyRent;

  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
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
        ]
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context, listen: false);

    if(data.depositCheckBox) {
      depositCheckBox = true;
      if(data.ProposedMonthlyRent != null && data.ProposedMonthlyRent != -1) {
        suggestMonthlyRent = TextEditingController(text: data.ProposedMonthlyRent.toString());
      }
    } else {
      depositCheckBox = false;
      if(data.ProposedDeposit != null && data.ProposedDeposit != -1) {
        suggestDeposit = TextEditingController(text: data.ProposedDeposit.toString());
      }
    }
    if(data.monthlyCheckBox) {
      monthlyRentCheckBox = true;
      if(data.ProposedMonthlyRent != null && data.ProposedMonthlyRent != -1) {
        suggestMonthlyRent = TextEditingController(text: data.ProposedMonthlyRent.toString());
      }
    } else {
      monthlyRentCheckBox = false;
      if(data.ProposedMonthlyRent != null && data.ProposedMonthlyRent != -1) {
        suggestMonthlyRent = TextEditingController(text: data.ProposedMonthlyRent.toString());
      }
    }
    CheckForProposePrice(data);
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
          body: KeyboardActions(
            config: _buildConfig(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: screenHeight * (40 / 640),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * (12 / 360),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * (2.5 / 640)),
                        child: Text(
                          data.transferType != 0 ?"전세금 제안": "보증금 제안",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*(24/360),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * (8 / 360),
                      ),
                      data.transferType != 0 ?Container():    Container(
                        width: screenWidth * (20 / 360),
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: kPrimaryColor,
                          value: depositCheckBox,
                          onChanged: (bool value) {
                            data.ChangedepositCheckBox(value);
                            if(value) {
                              data.ChangeProposedDeposit(-1);
                            }
                            setState(() {
                              depositCheckBox = value;
                            });
                            CheckForProposePrice(data);
                          },
                        ),
                      ),
                      data.transferType != 0 ?Container():  SizedBox(
                        width: screenWidth * (4 / 360),
                      ),
                      data.transferType != 0 ?Container():  Padding(
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
                  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * (12 / 360),
                      ),
                      Text(
                        data.transferType != 0 ?"원하시는 전세금을 입력해주세요": "원하시는 보증금을 입력해주세요",
                        style: TextStyle(
                          color: depositCheckBox == true
                              ? Color(0xffE9E8E6)
                              : Color(0xff888888),
                          fontSize: screenHeight * (12 / 640),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * (36 / 640),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      depositCheckBox == true
                          ? Container(
                        width: screenWidth * (80 / 360),
                        height: screenHeight * (30 / 640),
                        child: Center(
                          child: Text(
                            "0",
                            style: TextStyle(
                                fontSize: screenWidth * (20 / 360),
                                fontWeight: FontWeight.bold,
                                color: Color(0xffE9E8E6)),
                          ),
                        ),
                      )
                          : Container(
                          width: screenWidth * (100 / 360),
                          height: screenHeight * (30 / 640),
                          child: TextField(
                            textAlign: TextAlign.center,
                            inputFormatters: <TextInputFormatter> [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            focusNode: _nodeText1,
                            controller: suggestDeposit,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * (20 / 360),
                              color: Color(0xff222222),
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              errorBorder: InputBorder.none,
                              hintText: '180',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (20 / 360),
                                color: hexToColor("#cccccc"),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (text){
                              if(text == "") {
                                data.ChangeProposedDeposit(-1);
                              } else {
                                data.ChangeProposedDeposit(int.parse(text));
                              }
                              CheckForProposePrice(data);
                            },
                          )),
                      SizedBox(
                        width: screenWidth * (8 / 360),
                      ),
                      Container(
                          height: screenHeight * (30 / 640),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "만원",
                              style: TextStyle(
                                  fontSize: screenWidth * (20 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: depositCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff222222)),
                            ),
                          )),

                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * (4 / 640),
                  ),
                  Divider(thickness: 1, color: hexToColor("#CCCCCC"), indent: screenWidth*0.03333, endIndent: screenWidth*0.03333,),
                  SizedBox(
                    height: screenHeight * (40 / 640),
                  ),
                  data.transferType != 0 ?Container():  Row(
                    children: [
                      SizedBox(
                        width: screenWidth * (12 / 360),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * (2.5 / 640)),
                        child: Text(
                          "월세 제안",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth*(24/360),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * (8 / 360),
                      ),
                      Container(
                        width: screenWidth * (20 / 360),
                        child: Checkbox(
                          checkColor: Colors.white,
                          activeColor: kPrimaryColor,
                          value: monthlyRentCheckBox,
                          onChanged: (bool value) {
                            data.ChangemonthlyCheckBox(value);
                            if(value) {
                              data.ChangeProposedMonthlyRent(-1);
                            }
                            setState(() {
                              monthlyRentCheckBox = value;
                            });
                            CheckForProposePrice(data);
                          },
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * (4 / 360),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * (1.5 / 640)),
                        child: Text(
                          "월세 없음",
                          style: TextStyle(
                              fontSize: screenWidth * (12 / 360),
                              color: depositCheckBox == true
                                  ? kPrimaryColor
                                  : Color(0xff666666)),
                        ),
                      )
                    ],
                  ),
                  data.transferType != 0 ?Container(): SizedBox(
                    height: screenHeight * (8 / 640),
                  ),
                  data.transferType != 0 ?Container(): Row(
                    children: [
                      SizedBox(
                        width: screenWidth * (12 / 360),
                      ),
                      Text(
                        "전세는 \‘월세없음\’을 선택해주세요",
                        style: TextStyle(
                          color: monthlyRentCheckBox == true
                              ? Color(0xffE9E8E6)
                              : kPrimaryColor,
                          fontSize: screenHeight * (12 / 640),
                        ),
                      ),
                    ],
                  ),
                  data.transferType != 0 ?Container(): SizedBox(
                    height: screenHeight * (36 / 640),
                  ),
                  data.transferType != 0 ?Container(): Row(
                    children: [
                      Spacer(),
                      monthlyRentCheckBox == true
                          ? Container(
                        width: screenWidth * (80 / 360),
                        height: screenHeight * (30 / 640),
                        child: Center(
                          child: Text(
                            "0",
                            style: TextStyle(
                                fontSize: screenWidth * (20 / 360),
                                fontWeight: FontWeight.bold,
                                color: Color(0xffE9E8E6)),
                          ),
                        ),
                      )
                          : Container(
                          width: screenWidth * (100 / 360),
                          height: screenHeight * (30 / 640),
                          child: TextField(
                            textAlign: TextAlign.center,
                            inputFormatters: <TextInputFormatter> [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            focusNode: _nodeText2,
                            controller: suggestMonthlyRent,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * (20 / 360),
                              color: Color(0xff222222),
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              errorBorder: InputBorder.none,
                              hintText: '18',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * (20 / 360),
                                color: hexToColor("#cccccc"),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (text){
                              if(text == "") {
                                data.ChangeProposedMonthlyRent(-1);
                              } else {
                                data.ChangeProposedMonthlyRent(int.parse(text));
                              }
                              CheckForProposePrice(data);
                            },
                          )),
                      SizedBox(
                        width: screenWidth * (8 / 360),
                      ),
                      Container(
                          height: screenHeight * (30 / 640),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "만원",
                              style: TextStyle(
                                  fontSize: screenWidth * (20 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: monthlyRentCheckBox == true
                                      ? Color(0xffE9E8E6)
                                      : Color(0xff222222)),
                            ),
                          )),
                      Spacer(),
                    ],
                  ),
                  data.transferType != 0 ?Container(): SizedBox(
                    height: screenHeight * (4 / 640),
                  ),
                  data.transferType != 0 ?Container(): Divider(thickness: 1, color: hexToColor("#CCCCCC"), indent: screenWidth*0.03333, endIndent: screenWidth*0.03333,),
                  data.transferType != 0 ?Container(): SizedBox(height: screenHeight*0.05625,),
                ],
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: (){
              if(!data.FlagEnterRoomInfo[3]) {
                if(data.CheckCompleteFlag == true) {
                  data.ChangeFlagEnterRoomInfo(3, true);
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

  void CheckForProposePrice(EnterRoomInfoProvider data) {
    if(data.transferType == 0) {
      if (!data.depositCheckBox &&
          (data.ProposedDeposit == null || data.ProposedDeposit == -1)) {
        data.ChangeCheckComplete(false);
      }
      else if (!data.monthlyCheckBox && (data.ProposedMonthlyRent == null ||
          data.ProposedMonthlyRent == -1)) {
        data.ChangeCheckComplete(false);
      }
      else {
        data.ChangeCheckComplete(true);
      }
    }
    else{
      if(data.ProposedDeposit != null)
        data.ChangeCheckComplete(true);
    }
  }
}
