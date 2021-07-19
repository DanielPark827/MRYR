import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/GlobalAsset.dart';

class TermsOfUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
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
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.03125),
                Text(
                  '이용약관',
                  style: TextStyle(
                      fontSize: screenWidth*0.0444,
                      fontWeight: FontWeight.bold
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
