import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/Registration/Agreement.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class ModifyPWComplete extends StatefulWidget {
  bool Success;

  ModifyPWComplete({Key key, @required this.Success,}) : super(key : key);

  @override
  _ModifyPWCompleteState createState() => _ModifyPWCompleteState();
}

class _ModifyPWCompleteState extends State<ModifyPWComplete> {
  final message = '비밀번호 재설정 완료!';

  final Description = '로그인을 하러 가시겠습니까?';

  final img = 'assets/images/releaseRoomScreen/PurpleCircleIcon.svg';

  final navMsg = '로그인';

  final isErrorMessageRendering = false;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: widget.Success ?
        Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.194448),
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
                        LoginMainScreen(),
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
                  navMsg,
                  style: TextStyle(
                      fontSize: screenWidth*0.0444444,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ) :
        Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.033333),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight*(40/640),),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '비밀번호 찾기 결과',
                    style: TextStyle(
                      fontSize: screenWidth*0.066666,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*(88/640),),
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/releaseRoomScreen/RedErrorIcon.svg',
                    width: screenHeight*0.140625,
                    height: screenHeight*0.140625,
                  ),
                ),
                SizedBox(height: screenHeight*0.025,),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '조회 가능한\n회원 정보가 없습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*(16/360),
                    ),
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
                        Agreement(),
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
                  '회원가입 하러 가기',
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
}
