import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';

class RoomListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final SearchController = TextEditingController();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: screenHeight*0.07375,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: screenWidth*0.03333,),
                          SvgPicture.asset(
                            backArrow,
                            width: screenHeight*0.03125,
                            height: screenHeight*0.03125,
                          ),
                          SizedBox(width: screenWidth*0.0416666,),
                          Container(
                              height: screenHeight*0.05,
                              width: MediaQuery.of(context).size.width*0.836111,
                              child: TextField(
                                textAlign: TextAlign.left,
                                controller: SearchController,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: '학교 검색하기',
                                  hintStyle: TextStyle(
                                    fontSize: screenHeight*0.01875,
                                    color: hexToColor("#888888"),
                                  ),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.fromLTRB(0, screenHeight*0.0125, 0,screenHeight*0.0125),
                                    child: SvgPicture.asset(
                                      GreyMagnifyingGlass,
                                      width: screenHeight*0.025,
                                      height: screenHeight*0.025,
                                    ),
                                  ),
                                  fillColor: hexToColor("#EEEEEE"),
                                  filled: true,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    borderSide: BorderSide(width: 1,color: hexToColor(("#EEEEEE"))),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.034375,),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
