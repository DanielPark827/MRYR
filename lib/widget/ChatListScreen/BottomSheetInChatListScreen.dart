import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/ChatScreenDropDownProvider.dart';

Future BottomSheetInChatListScreen(BuildContext context, double screenWidth,
    double screenHeight, ChatScreenDropDownProvider chatScreenDropDown) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          color: Colors.transparent,
          width: screenWidth,
          height: screenHeight * (220 / 640),
          child: Column(
            children: [
              Container(
                width: screenWidth * (336 / 360),
                height: screenHeight * (144 / 640),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
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
                  children: [
                    FlatButton(
                      onPressed: () {
                        chatScreenDropDown.setString("나한테 온 문의");
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight * (22 / 640),
                            child: Center(
                              child: Text(
                                "나한테 온 문의",
                                style: TextStyle(
                                    fontSize: screenHeight * (16 / 640),
                                    color: chatScreenDropDown.getString() ==
                                            "나한테 온 문의"
                                        ? kPrimaryColor
                                        : Color(0xff222222)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: 1,
                      color: Color(0xfffafafa),
                    ),
                    FlatButton(
                      onPressed: () {
                        chatScreenDropDown.setString("내가 문의 한 매물");
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight * (22 / 640),
                            child: Center(
                              child: Text(
                                "내가 문의 한 매물",
                                style: TextStyle(
                                    fontSize: screenHeight * (16 / 640),
                                    color: chatScreenDropDown.getString() ==
                                            "내가 문의 한 매물"
                                        ? kPrimaryColor
                                        : Color(0xff222222)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      height: 1,
                      color: Color(0xfffafafa),
                    ),
                    FlatButton(
                      onPressed: () {
                        chatScreenDropDown.setString("거래완료된 목록");
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight * (22 / 640),
                            child: Center(
                              child: Text(
                                "거래완료된 목록",
                                style: TextStyle(
                                    fontSize: screenHeight * (16 / 640),
                                    color: chatScreenDropDown.getString() ==
                                            "거래완료된 목록"
                                        ? kPrimaryColor
                                        : Color(0xff222222)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * (12.6667 / 640),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: screenWidth * (336 / 360),
                  height: screenHeight * (48 / 640),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "취소",
                      style: TextStyle(
                          fontSize: screenHeight * (16 / 640),
                          color: Color(0xff222222)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * (20 / 640),
              ),
            ],
          ),
        );
      });
}
