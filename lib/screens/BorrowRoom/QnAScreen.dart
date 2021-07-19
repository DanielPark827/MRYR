import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';

class QnAScreen extends StatelessWidget {
  final ReportController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: hexToColor("#FFFFFF"),
          elevation: 0.0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(screenWidth*0.033333, 0, 0, 0),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  backArrow,
                  width: screenWidth * 0.057777,
                  height: screenWidth * 0.057777,
                ),
              ),
            ),
          ),
          title: SvgPicture.asset(
            MryrLogo,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.03125,),
              Text(
                '신고 이유',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth*( 16/360),
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: screenHeight*0.0125,
              ),
              TextField(
                controller: ReportController,
                keyboardType: TextInputType.multiline,
                maxLines: 14,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: '신고 이유를 작성해주세요.',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                  ),
                ),
                onChanged: (text){
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
            height: screenHeight*0.09375,
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '신고하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth*( 16/360),

                ),
              ),
            )
        ),
      ),
    );
  }
}
