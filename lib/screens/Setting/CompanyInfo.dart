import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';

class CompanyInfo extends StatefulWidget {
  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

class _CompanyInfoState extends State<CompanyInfo> {
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white,
              height: screenHeight*(60/640),
              child: Row(
                children: [
                  SizedBox(width: screenWidth*(8/360),),
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      }),

                  SizedBox(width: screenWidth*(8/360),),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight*(1.5/640)), child: Text('사업자정보',
                      style: TextStyle(
                        color: hexToColor("#222222"),
                        fontSize:screenWidth*( 16/360),
                        fontWeight: FontWeight.bold,
                      ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("상호 : 내방니방",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                Text("대표자명 : 남근호",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                Text("사업자등록번호 : 139-78-00379",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                Text("통신 판매업 신고 번호 : 2020-인천미추홀-1122",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                Text("대표번호 : 0507-1314-6160",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                Text("대표 이메일 : mryrhelp@gmail.com",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                Text("주소 : 인천광역시 미추홀구 경인남길16, 103호\n\n",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
                  Text("고객센터 : mryrhelp@gmail.com / 0507-1314-6160",style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),),
              ],)
            ],)
          ],
        ),
      ),
    );
  }
}
