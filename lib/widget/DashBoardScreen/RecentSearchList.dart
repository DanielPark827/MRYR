import 'package:flutter/material.dart';
import 'package:mryr/screens/DashBoardScreen.dart';

SizedBox RecentSearchList(BuildContext context,double screenHeight, double screenWidth) {
  return SizedBox(
    height: screenHeight * (155 / 640),
    child: ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) => Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: screenHeight * (140 / 640),
              height: screenHeight * (140 / 640),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: Offset(1.5, 1.5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight*(88/640),
                    width: screenHeight* (140 / 640),
                    child: Image.asset(
                        'assets/images/dummy/nice.png',
                        fit: BoxFit.fitWidth),
                  ),
                  SizedBox(height: screenHeight*(8/640),),
                  Padding(
                    padding: EdgeInsets.only(left:screenHeight*(8/640)),
                    child: Text(
                      "인하대학교",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * (12 / 640),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight*(4/640),),
                  Padding(
                    padding: EdgeInsets.only(left:screenHeight*(8/640)),
                    child: Text(
                      "후기 검색하기",
                      style: TextStyle(
                        fontSize: screenHeight * (10 / 640),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * (8/360),
          ),
        ],
      ),
    ),
  );
}