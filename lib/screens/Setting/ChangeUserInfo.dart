import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/widget/MoreScreen/MyProfileLine.dart';
import 'package:mryr/widget/Setting/MyProfileLineInSetting.dart';

class ChangeUserInfo extends StatelessWidget {
  final NameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: hexToColor('#EEEEEE'),
        body: Column(
          children: [
            MyProfileLineInSetting(context, screenWidth, screenHeight),
            SizedBox(height: screenHeight*0.03125,),
            Container(height: screenHeight*0.03125,),
            Container(
              width: screenWidth,
              height: screenHeight*0.54375,
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333333),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight*0.03125,),
                    Text(
                      '이름',
                       style: TextStyle(
                         fontSize: screenWidth*0.0444444444444444,
                         fontWeight: FontWeight.bold,
                       ),
                    ),
                    SizedBox(height: screenHeight*0.0125,),
                    SizedBox(
                      height: screenHeight*0.0625,
                      child: TextField(
                        controller: NameController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(screenWidth*0.0333333, screenHeight*0.01875, 0,screenHeight*0.01875),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: kPrimaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: kPrimaryColor),
                          ),
                        ),
                        onChanged: (text){
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight*0.0125,),
                    Text(
                      '닉네임',
                      style: TextStyle(
                        fontSize: screenWidth*0.0444444444444444,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight*0.0125,),
                    SizedBox(
                      height: screenHeight*0.0625,
                      child: TextField(
                        controller: NameController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(screenWidth*0.0333333, screenHeight*0.01875, 0,screenHeight*0.01875),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: kPrimaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1,color: kPrimaryColor),
                          ),
                        ),
                        onChanged: (text){
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
