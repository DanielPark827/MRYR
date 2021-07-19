import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/RegistrationBloc.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/UserRepository.dart';
import 'package:mryr/screens/MyPage.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class Certification_Result extends StatelessWidget {
  static const Color successColor = Color(0xff52c41a);
  static const Color failureColor = Color(0xfff5222d);

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();

    Map<String, String> result = ModalRoute.of(context).settings.arguments;
    String message;
    String Description;
    String img;
    String navMsg;
    Color color;
    bool isErrorMessageRendering;
    if (result['success'] == 'true') {
      message = '본인인증 완료!';
      Description = '매물을 등록하러 가볼까요?';
      img = 'assets/images/public/PurpleCheck.svg';
      navMsg = '회원가입';
      isErrorMessageRendering = false;
    } else {
      message = '본인인증 실패!';
      Description = '본인 인증을 다시 한번 해주세요';
      img = 'assets/images/releaseRoomScreen/RedErrorIcon.svg';
      navMsg = '다시하기';
      isErrorMessageRendering = true;
    }

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: (){
        DialogForExitRegistration(context, screenHeight, screenWidth);
        return;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  DialogForExitRegistration(context, screenHeight, screenWidth);
                }),
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.28888),
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
//          EnterRoomInfo
              if(result['success'] == 'true') {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return BlocProvider(
                    create: (ctx) => RegistrationBloc(userRepository),
                    child: RegistrationPage(),
                  );
                }));
              } else {
                Navigator.pop(context);
              }
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
        ),
      ),
    );
  }
}