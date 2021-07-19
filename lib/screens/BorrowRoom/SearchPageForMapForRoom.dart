import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/userData/Room.dart';

class SearchPageForMapForRoom extends StatefulWidget {
  @override
  _SearchPageForMapForRoomState createState() => _SearchPageForMapForRoomState();
}

class _SearchPageForMapForRoomState extends State<SearchPageForMapForRoom> with SingleTickerProviderStateMixin {
  final SearchController = TextEditingController();

  String KeyForRecent = 'RecentLIst';

  List<String> RecentList = [];

  int RecentListIndex = 0;

  Future<bool> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    RecentList = await prefs.getStringList(KeyForRecent);
    RecentListIndex = await RecentList.length;
    print("RecentListIndex : "+" ${RecentList}");
    return true;
  }

  void DeleteRecentAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(KeyForRecent, []);
    RecentList = await prefs.getStringList(KeyForRecent);
    print("RecentList : "+"    ${RecentList}");

  }
  AnimationController extendedController;
  @override
  void initState() {
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    DummyRoom data = Provider.of<DummyRoom>(context);

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.021875,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: screenWidth*0.033333,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      backArrow,
                      width: screenHeight*0.03125,
                      height: screenHeight*0.03125,
                    ),
                  ),
                  SizedBox(width: screenWidth*0.0416666,),
                  Container(
                      height: screenHeight*0.05,
                      width: MediaQuery.of(context).size.width*0.836111,
                      child: TextField(
                        textAlign: TextAlign.left,
                        autofocus: true,
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
              SizedBox(height: screenHeight*0.053125,),
              Padding(
                padding: EdgeInsets.only(left: screenWidth*0.055555),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '최근 조회한 매물',
                      style: TextStyle(
                        fontSize: screenHeight*0.025,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                 Spacer(),
                    GestureDetector(
                      onTap: () async {
                        DeleteRecentAll();
                        setState(() {

                        });
                      },
                      child: Text(
                        '조회기록 지우기',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: screenHeight*0.015625,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth*(12/360),)
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.01875,),
              FutureBuilder(
                  future: init(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                    if (snapshot.hasData == false) {
                      return CircularProgressIndicator();
                    }
                    //error가 발생하게 될 경우 반환하게 되는 부분
                    else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    }
                    else if(RecentListIndex == 0) {
                      return Container(
                        height: screenHeight*0.21875,
                        width: screenWidth,
                        child: Center(
                          child: Text(
                            '조회한 매물이 없습니다.',
                            style: TextStyle(
                                fontSize: screenHeight*0.025,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      );
                    }
                    // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                    else {
                      return SizedBox(
                        height: screenHeight*0.21875,
                        child: ListView.builder(
                          primary: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: RecentListIndex,
                          itemBuilder: (BuildContext context, int index) => Padding(
                            padding: index == 0? EdgeInsets.only(left: screenWidth*0.055555) : EdgeInsets.only(left: screenWidth*0.02222222),
                            child: GestureDetector(
                              onTap: () async {
//                                  await AddRecent(index);
                                Navigator.push(
                                    context, // 기본 파라미터, SecondRoute로 전달
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailedRoomInformation(
                                              roomSalesInfo: globalRoomSalesInfoList[int.parse(RecentList[index])],
                                            )) // SecondRoute를 생성하여 적재
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: screenHeight*0.21875,
                                    height: screenHeight*0.21875,
                                    decoration: BoxDecoration(
                                      color: hexToColor("#E7E7E7"),
                                      borderRadius: BorderRadius.all(Radius.circular(4)),
                                    ),
                                    child:
                                    ClipRRect(
                                        borderRadius: new BorderRadius.circular(4.0),
                                        child:
                                        globalRoomSalesInfoList[int.parse(RecentList[index])].imageUrl1=="BasicImage"
                                            ?
                                        SvgPicture.asset(
                                          ProfileIconInMoreScreen,
                                          width: screenHeight * (60 / 640),
                                          height: screenHeight * (60 / 640),
                                        )
                                            : FittedBox(
                                          fit: BoxFit.cover,
                                          child:  getExtendedImage(get_resize_image_name(globalRoomSalesInfoList[int.parse(RecentList[index])].imageUrl1,360), 0,extendedController),

                                        )

                                    ),



                                    ),
                                  Positioned(
                                    top: screenHeight*0.1375,
                                    child: Container(
                                      width: screenHeight*0.21875,
                                      height: screenHeight*0.08125,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(bottomRight: Radius.circular(4.0),bottomLeft: Radius.circular(4.0)),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: screenWidth*0.022222),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: screenHeight*0.0125,),
                                            Text(
                                              globalRoomSalesInfoList[index].monthlyRentFees.toString() +
                                                  '만원 / 월',
                                              style: TextStyle(
                                                  fontSize: screenHeight*0.01875,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: screenHeight*0.00625,),
                                            Text(
                                              globalRoomSalesInfoList[index].information,
                                              style: TextStyle(
                                                color: hexToColor("#888888"),
                                                fontSize: screenHeight*0.015625,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
