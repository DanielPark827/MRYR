import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';


InkWell DashBoardNotificationButton(double screenHeight, double screenWidth, bool isHaveNoti, NavigationNumProvider navigationNumProvider) {

 return InkWell(
    onTap:() async {
      navigationNumProvider.setNum(TOTAL_NOTIFICATION_PAGE);
    },
    child: SizedBox(
      width: screenHeight * (28/640),
      height: screenHeight * (28/640),
      child: ButtonTheme(
        minWidth: screenHeight * (28/640),
        height: screenHeight * (28/640),
        child: SvgPicture.asset(
            NotificationButton,
            width: screenHeight * (28/640),
            height: screenHeight * (28/640)
        ),
      ),
    ),
  );
 /* return InkWell(
    onTap:() async {
      navigationNumProvider.setNum(TOTAL_NOTIFICATION_PAGE);
    },
    child: Badge(
      showBadge: isHaveNoti,
      position: BadgePosition.topLeft(top: screenHeight*0.039375, left: screenWidth*0.043333),
      padding: EdgeInsets.all(screenHeight*0.007375),
      badgeColor: Color(0xfff9423a),
      badgeContent: Text(
        '',
        style:
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      child: SizedBox(
        width: screenHeight * (28/640),
        height: screenHeight * (28/640),
        child: ButtonTheme(
          minWidth: screenHeight * (28/640),
          height: screenHeight * (28/640),
          child: SvgPicture.asset(
              NotificationButton,
              width: screenHeight * (28/640),
              height: screenHeight * (28/640)
          ),
        ),
      ),
    ),
  );*/
}

