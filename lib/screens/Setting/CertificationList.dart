import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/Chat/ChatScreen.dart';
import 'package:mryr/userData/CertificationPicture.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';

class CertificationList extends StatefulWidget {
  @override
  _CertificationListState createState() => _CertificationListState();
}

class _CertificationListState extends State<CertificationList>with SingleTickerProviderStateMixin {
  AnimationController extendedController;

  GlobalKey<RefreshIndicatorState> refreshKey;
  void initState(){
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

  }
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.white,//hexToColor('#F8F8F8'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: SvgPicture.asset(
          MryrLogoInReleaseRoomTutorialScreen,
          width: screenHeight * (110 / 640),
          height: screenHeight * (27 / 640),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: ()async{
          GlobalProfile.certificationPicture.clear();
          var tmp = await ApiProvider().get('/Manage/RenterIdList');
          if(null != tmp){
            for(int i =0;i<tmp.length;i++){
              GlobalProfile.certificationPicture.add(CertificationPicture.fromJson(tmp[i]));
            }
          }

        },
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                children: [
                  Container(
                    height: screenHeight*0.0675,
                    width: screenWidth /3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight*0.0140625,
                        ),
                        Text(
                          '신분증 목록',
                          style: TextStyle(
                              fontSize: screenWidth * (16 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenHeight*0.0109375,),

                      ],
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Container(
                height: screenHeight ,
                width: screenWidth,
                child: ListView.separated(
                  // controller: _scrollController,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                    itemCount:GlobalProfile.certificationPicture.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth,
                            height: screenWidth*(3/4),
                            child: ClipRRect(
                                borderRadius: new BorderRadius.circular(4.0),
                                child:    GlobalProfile.certificationPicture[index].imageUrl=="BasicImage" ||  GlobalProfile.certificationPicture[index].imageUrl==null
                                    ?
                                SvgPicture.asset(
                                  mryrInReviewScreen,
                                  width:
                                  screenHeight *
                                      (60 /
                                          640),
                                  height:
                                  screenHeight *
                                      (60 /
                                          640),
                                )
                                    :

                                FittedBox(
                                  fit: BoxFit.cover,
                                  child:    getExtendedImage( GlobalProfile.certificationPicture[index].imageUrl, 0,extendedController),
                                )
                            ),
                          ),
                          Container(height: 10),
                          Container(
                              height: screenHeight * 0.05,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Column(

                                  children: [
                                    Text("nickName"),
                                    Text(GlobalProfile.certificationPicture[index].nickName),
                                  ],
                                ),
                                Container(width: screenWidth*(20/360),),
                                Column(
                                  children: [
                                    Text("Room ID"),
                                    Text(GlobalProfile.certificationPicture[index].roomID.toString()),
                                  ],
                                ),

                                  Container(width: screenWidth*(20/360),),
                                Column(
                                  children: [
                                    Text("Updated At"),
                                    Text(timeCheckForChat(GlobalProfile.certificationPicture[index].updatedAt)),
                                  ],
                                ),

                              ],)

                          ),
                          Container(height: 50)
                        ],
                      );
                    }),
              ),
            ),
            SizedBox(height: screenHeight*0.0125,),
          ],
        ),
      ),
    );
  }
}
