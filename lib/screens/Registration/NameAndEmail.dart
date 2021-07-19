import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/screens/Registration/PassWord.dart';
import 'package:provider/provider.dart';

class NameAndEmail extends StatefulWidget {
  @override
  _NameAndEmailState createState() => _NameAndEmailState();
}

class _NameAndEmailState extends State<NameAndEmail> {
  final NameController = TextEditingController();

  final EmailController = TextEditingController();

  bool Complete = false;

  @override
  Widget build(BuildContext context) {
    DummyUser data = Provider.of<DummyUser>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

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
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: hexToColor("#FFFFFF"),
            elevation: 0.0,
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth*0.033333, 0, 0, 0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    backArrow,
                    width: screenWidth * 0.057777,
                    height: screenWidth * 0.057777,
                  ),
                ),
              ),
            ),
            title: SvgPicture.asset(
              MryrLogo,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth*0.03333),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.03125,),
                Text(
                  '이름',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight*0.025,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: screenHeight*0.0125,
                ),
                SizedBox(
                  height: screenHeight*0.0625,
                  child: TextField(
                    controller: NameController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(screenHeight*0.01875, screenHeight*0.01875, 0,screenHeight*0.01875),
                      hintText: '실명 입력',
                      hintStyle: TextStyle(
                        color: hexToColor("#D2D2D2"),
                        fontSize: screenHeight*0.01875,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: hexToColor(("#CCCCCC"))),
                      ),
                    ),
                    onChanged: (text) {
                      data.ChangeUserName(text);
                      if(data.UserName != null && data.UserId != null) {
                        setState(() {
                          Complete = true;
                        });
                      } else { setState(() {
                        Complete = false;
                      });}
                    },
                  )
                ),
                SizedBox(height: screenHeight*0.03125,),
                Text(
                  '이메일(아이디)',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenHeight*0.025,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: screenHeight*0.0125,
                ),
                SizedBox(
                    height: screenHeight*0.0625,
                    child: TextField(
                      controller: EmailController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(screenHeight*0.01875, screenHeight*0.01875, 0,screenHeight*0.01875),
                        hintText: '이메일 주소 입력',
                        hintStyle: TextStyle(
                          color: hexToColor("#D2D2D2"),
                          fontSize: screenHeight*0.01875,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: hexToColor(("#6F22D2"))),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1,color: hexToColor(("#CCCCCC"))),
                        ),
                      ),
                      onChanged: (text) {
                        data.ChangeUserId(text);
                        if(data.UserName != null && data.UserId != null) {
                          setState(() {
                            Complete = true;
                          });
                        } else { setState(() {
                          Complete = false;
                        });}
                      },
                    )
                )
              ],
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: (){
              if(Complete == true) {
                Navigator.push(
                    context, // 기본 파라미터, SecondRoute로 전달
                    MaterialPageRoute(
                        builder: (context) =>
                            PassWord()) // SecondRoute를 생성하여 적재
                );
              } else {}
            },
            child: Container(
                height: screenHeight*0.09375,
                decoration: BoxDecoration(
                  color: Complete == true ? kPrimaryColor : hexToColor("#CCCCCC"),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '다음으로',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight*0.025,

                    ),
                  ),
                )
            ),
          ),
        ),
      ),
    );
  }
}
