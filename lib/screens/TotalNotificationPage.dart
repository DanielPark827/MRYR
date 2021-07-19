
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:provider/provider.dart';

class TotalNotificationPage extends StatefulWidget {
  @override
  _TotalNotificationPageState createState() => _TotalNotificationPageState();
}

class _TotalNotificationPageState extends State<TotalNotificationPage> with SingleTickerProviderStateMixin{
  AnimationController extendedController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

  }

  @override
  Widget build(BuildContext context) {
  //  SocketProvider socket = Provider.of<SocketProvider>(context);
    NavigationNumProvider navigationNum = Provider.of<NavigationNumProvider>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final String backArrow = 'assets/images/public/backArrow.svg';

    setNotiListRead();

    return WillPopScope(
      onWillPop: (){
        navigationNum.setNum(DASHBOARD_SCREEN_NUM/*,socket: socket*/);
        return;
      },
      child: SafeArea(
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
          child: Scaffold(
            backgroundColor: hexToColor("#E5E5E5"),
            appBar: new AppBar(
              backgroundColor: hexToColor("#FFFFFF"),
              centerTitle: true,
              elevation: 0.0,
              leading: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenWidth*0.033333, 0, 0, 0),
                    child: GestureDetector(
                      onTap: (){
                        navigationNum.setNum(DASHBOARD_SCREEN_NUM/*,socket: socket*/);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:  SvgPicture.asset(
                          backArrow,
                          width: screenHeight * 0.03125,
                          height: screenHeight * 0.03125,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text('전체 알림',
                style: TextStyle(
                  color: hexToColor("#222222"),
                  fontSize: screenHeight*0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: WillPopScope(
              onWillPop: (){
                navigationNum.setNum(DASHBOARD_SCREEN_NUM,/*socket: socket*/);
                return;
              },
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: SizedBox(
                      child: notiList.length == 0? Container(
              color: Color(0xffe5e5e5),
              width: screenWidth,height: screenHeight,
              child: Column(

                children: [
                  Container(height: screenHeight*(200/640),),
                  SvgPicture.asset(
                    'assets/images/Chat/snail.svg',
                    width: screenWidth * (112 / 360),
                    height: screenWidth * (110/ 640),
                  ),
                  Container(height: screenWidth*(20/360),),
                  Text("온 알람이 아직 없어요!", style: TextStyle(fontSize: screenWidth*(12/360),color: Color(0xff888888)),)
                ],),)


            :ListView.separated(
                          separatorBuilder: (context,index) => Container(
                              height: 1, width: double.infinity, color: Color(0xFFEFEFEF)),
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: notiList.length,
                          itemBuilder: (BuildContext context, int index) {

                            return Container(
                                height: screenHeight*0.1125,
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(

                                      width: screenWidth*0.0333333333333333,),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width:screenHeight*0.0875,
                                        height: screenHeight*0.0875,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Color.fromRGBO(166, 125, 130, 0.2),
                                              blurRadius: 4,
                                            ),],
                                        ),
                                        child: ClipRRect(

                                            borderRadius: new BorderRadius.circular(8.0),
                                            child: GlobalProfile.getUserByUserID(notiList[index].from).profileUrlList =="BasicImage"
                                                ?
                                            SvgPicture.asset(
                                              ProfileIconInMoreScreen,
                                              width: screenHeight * (60 / 640),
                                              height: screenHeight * (60 / 640),
                                            )
                                                :  FittedBox(
                                              fit: BoxFit.cover,
                                              child:    getExtendedImage( get_resize_image_name(GlobalProfile.getUserByUserID(notiList[index].from).profileUrlList,120), 60,extendedController),
                                            )
                                        ),


                                      ),
                                    ),
                                    SizedBox(width: screenWidth*0.022222,),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          SizedBox(height: screenHeight*0.0125,),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              getNotiInformation(notiList[index]),
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: screenHeight*0.01875,
                                              ),
                                            ),
                                          ),
                                          Expanded(child: SizedBox()),
                                          Row(children: [
                                            Padding(
                                              padding: EdgeInsets.only(bottom: screenHeight*(8/640)),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  notiList[index].time,
                                                  style: TextStyle(
                                                    fontSize: screenWidth * (10/360),
                                                    color: hexToColor("#BEBEBE"),
                                                  ),

                                                ),
                                              ),
                                            ),
                                            Expanded(child: SizedBox(),),
                                            isHaveButton(context, notiList[index].type) == true
                                                ? Padding(
                                              padding: EdgeInsets.only(bottom: screenHeight*(8/640)),
                                              child: GestureDetector(
                                                onTap: (){
                                                  NotiEvent(context, notiList[index], index);
                                                },
                                                child: Text(
                                                  "확인하기>",
                                                  style: TextStyle(fontSize: screenWidth * (10/360), color: hexToColor('#6F22D2'), fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ) : Container(),
                                          ],
                                          ),

                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth*0.0333333,
                                    )
                                  ],
                                )
                            );
                          }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
