import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';

class UsingRule extends StatefulWidget {
  @override
  _UsingRuleState createState() => _UsingRuleState();
}

class _UsingRuleState extends State<UsingRule> {
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          body: Column(
            children: [
              Container(
                color: Colors.white,
                height: screenHeight*(60/640),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SvgPicture.asset(
                          backArrow,
                          width: screenWidth * 0.077777,
                          height: screenWidth * 0.077777,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth*(8/360),),
                    Text('사업자정보',
                      style: TextStyle(
                        color: hexToColor("#222222"),
                        fontSize:screenWidth*( 16/360),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: screenHeight*(20/640),),
              Row(children: [
                SizedBox(width: screenWidth*(20/360),),
                SvgPicture.asset(
                  CompanyInfoInMoreScreen,
                  height: screenHeight*(27/640),
                ),
              ],),
              SizedBox(height: screenHeight*(22/640),),
              Row(children: [
                SizedBox(width: screenWidth*(20/360),),
                Column(children: [
                  Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                  Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                  Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                  Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                  Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                  Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                ],)
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
