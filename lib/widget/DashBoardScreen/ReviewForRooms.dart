
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';

Container ReviewForRooms(String mainString,String subString,double screenWidth, double screenHeight) {


  return Container(
    width: screenWidth * (320 / 360),
    height: screenHeight * (80 / 640),
    decoration: buildBoxDecoration(),
    child:Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * (12 / 640),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  mainString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth*( 16/360),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * (4 / 640),
            ),
            Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Text(
                  subString,
                  style: TextStyle(
                    fontSize: screenWidth*( 12/360),
                  ),
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        SvgPicture.asset(
          ReviewIconInDashBoardScreen,
          width: screenHeight * (80 / 640),
          height: screenHeight * (80 / 640),
        ),
      ],
    ),
  );
}
