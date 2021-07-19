import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';

RichText Notice(BuildContext context,String s1, String s2, String s3) {
  return RichText(
    text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(text: s1,style: TextStyle(color: Color(0xff222222),decoration: TextDecoration.none,fontSize: screenWidth*(12 /360),)),
          TextSpan(text: s2,style: TextStyle(color: kPrimaryColor,decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
          TextSpan(text: s3,style: TextStyle(color: Color(0xff222222),decoration: TextDecoration.none,fontSize: screenWidth*( 12/360),)),
        ]
    ),
  );
}