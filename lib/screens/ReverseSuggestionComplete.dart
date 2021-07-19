import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/Registration/Agreement.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/main.dart';
class ReverseSuggestionComplete extends StatefulWidget {
  @override
  _ReverseSuggestionCompleteState createState() => _ReverseSuggestionCompleteState();
}

class _ReverseSuggestionCompleteState extends State<ReverseSuggestionComplete> {
  final message = '역제안 완료!';

  final Description = '역제안을 확인한 이용자로부터\n연락을 기다려보세요';

  final img = 'assets/images/releaseRoomScreen/PurpleCircleIcon2.svg';


  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
     // resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        title: SvgPicture.asset(
          MryrLogoInReleaseRoomTutorialScreen,
          width: screenHeight * (110 / 640),
          height: screenHeight * (27 / 640),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight*0.1875,),
            SvgPicture.asset(
              img,
              width: screenHeight*0.140625,
              height: screenHeight*0.140625,
            ),
            SizedBox(height: screenHeight*0.025,),
            Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth*0.06666,
              ),
            ),
            SizedBox(height: screenHeight*0.00625,),
            Text(
              Description,
              textAlign: TextAlign.center,
              style: TextStyle(

                fontSize: screenWidth*0.0333333,
                color: hexToColor('#888888'),
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: (){
          Navigator.push(
              context, // 기본 파라미터, SecondRoute로 전달
              MaterialPageRoute(
                builder: (context) =>
                    MainPage(),
              ) // SecondRoute를 생성하여 적재
          );
        },
        child: Container(
          height: screenHeight*0.09375,
          width: screenWidth,
          decoration: BoxDecoration(
              color: kPrimaryColor
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "홈으로 돌아가기",
              style: TextStyle(
                  fontSize: screenWidth*0.0444444,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    ) ;
  }
}
