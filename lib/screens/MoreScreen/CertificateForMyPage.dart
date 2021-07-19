import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:iamport_flutter/iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';

class CertificateForMyPage extends StatelessWidget {
  static const String userCode = 'imp10391932';

  @override
  Widget build(BuildContext context) {
    CertificationData data = ModalRoute.of(context).settings.arguments;

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: IamportCertification(
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
        initialChild: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/iamport-logo.png'),
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                  child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
          ),
        ),
        userCode: userCode,
        data: data,
        callback: (Map<String, String> result) {
          Navigator.pushReplacementNamed(
            context,
            '/certification-result',
            arguments: result,
          );
        },
      ),
    );
  }
}