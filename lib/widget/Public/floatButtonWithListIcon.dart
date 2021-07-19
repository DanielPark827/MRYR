import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
Container floatButtonWithListIcon(double screenHeight, double screenWidth, String value) {
  return Container(
    height: screenHeight*(40/640),
    width: screenWidth*(200/360),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.7),
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(
              1, 1), // changes position of shadow
        ),
      ],
      borderRadius: BorderRadius.circular(4.0),
      color: Colors.white,
      border: Border.all(color: Color(0xfff2f2f2),width: 1),
    ),
    child: Row(
      children: [
        Spacer(),
        SvgPicture.asset(
          PurpleMenuIcon,
          height: screenWidth*(20/360),
          width: screenWidth*(20/360),
        ),
        widthPadding(screenWidth,12),
        Text(
          value,
          style: TextStyle(
              fontSize: screenWidth*(12/360),
              color: Colors.black
          ),
        ),
        Spacer(),
      ],
    ),
  );
}