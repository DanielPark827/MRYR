import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/screens/Review/ReviewScreenInMap2.dart';
import 'package:mryr/utils/DefaultButton.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';

import '../../main.dart';

class ReviewScreenInMap extends StatefulWidget {
  @override
  _ReviewScreenInMapState createState() => _ReviewScreenInMapState();
}

class _ReviewScreenInMapState extends State<ReviewScreenInMap> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            child: Stack(
              children: [
                Container(width: screenWidth,height: screenHeight,child:
                Image.asset(
                    'assets/images/review/reviewBack.png',
                    fit: BoxFit.cover),
                  ),
                Column(
                  children: [
                    SizedBox(height: screenHeight*(46/640),),
                    Row(children: [
                      SizedBox(width: screenWidth*(17/360),),
                      IconButton(
                          icon:Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                      ),
                    ],),
                    SizedBox(height: screenHeight*(24/640),),
                    Container(width: screenWidth*(281/360),child:
                    Image.asset(
                        'assets/images/review/text.png',
                        fit: BoxFit.contain),
                    ),

                    SizedBox(height: screenHeight*(342/640),),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*(320/360),
                      height: MediaQuery.of(context).size.height*(40/640),
                      child:FlatButton(


                        onPressed:  () {
                          Navigator.push(
                              context, // 기본 파라미터, SecondRoute로 전달
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewScreenInMap2()) // SecondRoute를 생성하여 적재
                          );
                        },
                        child: Container(
                          width: screenWidth*(292/360),
                          height: screenHeight*(48/640),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(40)),),
                          child: Center(
                            child: Text(
                              "시작하기",
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width*(16/360),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    FlatButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Container(

                        child: Text(
                          '처음으로 돌아가기',
                          style: TextStyle(

                            color: Colors.white,
                            fontSize:
                            MediaQuery.of(context).size.height * (12 / 640),
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
