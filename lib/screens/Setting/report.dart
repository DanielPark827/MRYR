import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final Description = TextEditingController();

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Color(0xfff8f8f8),
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
        body:
          Column(children: [
            SizedBox(height: screenHeight*(20/640),),
            Row(children: [
              SizedBox(width: screenWidth*(12/360),),
              Text("신고 이유",style: TextStyle(fontSize: screenWidth*(16/360),fontWeight: FontWeight.bold),),
            ],),
            SizedBox(height: screenHeight*(8/640),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth*(332/360),
                  height: screenHeight*(240/640),

                  child:TextField(
                    controller: Description,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 14,
                    maxLength: 225,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      hintText: '신고 이유를 작성해주세요.',
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
                    },
                  ),
                ),
              ],
            ),
          ],),
        bottomNavigationBar: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            color: kPrimaryColor,
            width: screenWidth,
            height: screenHeight*(60/640),
              child: Center(
              child: Text("신고하기",style: TextStyle(fontWeight: FontWeight.bold,fontSize: screenWidth*(16/360),color: Colors.white),),
          ),
          ),
        ),
      ),
    );
  }
}
