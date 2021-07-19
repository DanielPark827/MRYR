import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

class NeedRoomDescription extends StatefulWidget {
  @override
  _NeedRoomDescriptionState createState() => _NeedRoomDescriptionState();
}

class _NeedRoomDescriptionState extends State<NeedRoomDescription> {
  TextEditingController Description;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);

    if(data.ItemDescription != null && data.ItemDescription != "") {
      Description = TextEditingController(text: data.ItemDescription);
      data.ChangeCheckComplete(true);
    }
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              elevation: 0,
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//              onPressed: () {
//                Navigator.pop(context);
//              }),
              title: SvgPicture.asset(
                MryrLogoInReleaseRoomTutorialScreen,

                width: screenHeight * (110 / 640),
                height: screenHeight * (27 / 640),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight*0.0625,),
                  Text(
                    '매물 상세 설명',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*0.066666,
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
                    controller: Description,
                    keyboardType: TextInputType.multiline,
                    maxLines: 15,
                    maxLength: 225,

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
                    onChanged: (text){
                      data.ChangeItemDescription(text);
                      if(data.ItemDescription != null && data.ItemDescription != "") {
                        data.ChangeCheckComplete(true);
                      } else {
                        data.ChangeCheckComplete(false);
                      }
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: GestureDetector(
              onTap: (){
                if(!data.FlagEnterRoomInfo[7]) {
                  if(data.CheckCompleteFlag == true) {
                    data.ChangeFlagEnterRoomInfo(7, true);
                    data.ChangeCompleteCheck(++data.CompleteCheck);
                    data.ChangeCheckComplete(false);
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
            )
        ),
      ),
    );
  }
}
