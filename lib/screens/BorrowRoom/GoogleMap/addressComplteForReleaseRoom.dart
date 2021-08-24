import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/model/google_map_place.dart';
import 'package:mryr/model/google_map_service.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/constants/KeySharedPreferences.dart';
import 'package:mryr/screens/BorrowRoom/model/UnivCoordi.dart';

class addressComplteForBorrowRoom extends StatefulWidget {
  @override
  _addressComplteForBorrowRoomState createState() => _addressComplteForBorrowRoomState();
}

class _addressComplteForBorrowRoomState extends State<addressComplteForBorrowRoom> {
  final TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  var sessionToken;
  var googleMapServices;
  PlaceDetail placeDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set();

  final _scrollController = ScrollController();
  List<UnivCoordi> univList = [
    new UnivCoordi("인하대학교",37.45021798095106, 126.65347727041605),
    new UnivCoordi("서강대학교",37.55106326296553, 126.9409271973989),
    new UnivCoordi("홍익대학교 서울캠퍼스",37.551628162095426, 126.92493754832599),
    new UnivCoordi("연세대학교 신촌캠퍼스",37.56596256890242, 126.93861491459872),
    new UnivCoordi("이화여자대학교",37.56204588299348, 126.94679098390817),
    new UnivCoordi("서울대학교",37.456773497452616, 126.95007068576113),
    new UnivCoordi("중앙대학교 서울캠퍼스",37.50523276969037, 126.95710119925293),
    new UnivCoordi("숭실대학교",37.496389155514194, 126.95686472756978),

  ];



  @override
  void initState() {
    super.initState();
  }

  List<String> regionList = [];
  List<double> latList = [];
  List<double> longList = [];
  int countRegionList = 0;

  Future<bool> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    regionList = await prefs.getStringList(keyRecentRegion);
    List<String> subLatList = await prefs.getStringList(keyRecentLatitudeWithRegion);
    List<String> subLongList = await prefs.getStringList(keyRecentLongitudeWithRegion);
    if(null != regionList) {
      countRegionList = regionList.length;
      for(int i = 0; i < countRegionList; i++) {
        latList.add(double.parse(subLatList[i]));
        longList.add(double.parse(subLongList[i]));
      }
      return true;
    }

    return false;
  }

  void ResetRecentRegion() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(keyRecentRegion, []);
    prefs.setStringList(keyRecentLatitudeWithRegion, []);
    prefs.setStringList(keyRecentLongitudeWithRegion, []);

    regionList = await prefs.getStringList(keyRecentRegion);
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              heightPadding(screenHeight,14),
              Row(
                children: [
                  SizedBox(width: screenWidth*(12/360),),
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
                    height: screenHeight*(32/640),
                    width: screenWidth*(300/360),
                    child: TypeAheadField(
                      debounceDuration: Duration(milliseconds: 500),
                      suggestionsBoxDecoration: SuggestionsBoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBuilder: (BuildContext context, Object error) =>
                          Text(
                              '조회가 되지 않습니다. 정확한 건물명을 입력해주세요.',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontSize: screenWidth*(12/360),
                              )
                          ),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: '예) 인하대학교',
                          hintStyle: TextStyle(
                            fontSize: screenWidth*(12/360),
                          ),
                          border: InputBorder.none,
                          hoverColor: Colors.black,
                          filled: true,
                          fillColor:hexToColor('#EEEEEE'),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 1,color: kPrimaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 1,color: Colors.white),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(screenWidth*(8/360)),
                            child: SvgPicture.asset(
                              GreyMagnifyingGlass,
                              height: screenWidth*(16/360),
                              width: screenWidth*(16/360),
                            ),
                          ),
                          contentPadding: EdgeInsets.only(top: screenHeight*(8/640),bottom: screenHeight*(8/640)),
                        ),

                      ),
                      suggestionsCallback: (pattern) async {
                        if (sessionToken == null) {
                          sessionToken = uuid.v4();
                        }
                        googleMapServices =
                            GoogleMapServices(sessionToken: sessionToken);

                        return await googleMapServices.getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggetion) {
                        return ListTile(
                          title: Text(suggetion.description),
                        );
                      },
                      onSuggestionSelected: (suggetion) async {
                        placeDetail = await googleMapServices.getPlaceDetail(
                          suggetion.placeId,
                          sessionToken,
                        );

                        sessionToken = null;
                        Navigator.pop(context,placeDetail);
                      },
                    ),
                  ),
                ],
              ),
              heightPadding(screenHeight, 20),
              Row(
                children: [
                  widthPadding(screenWidth,20),
                  Text(
                    '우리지역 바로가기',
                    style: TextStyle(
                        fontSize: screenWidth*(16/360),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              heightPadding(screenHeight, 12),
              SizedBox(
                height: screenHeight*((50*(univList.length/2))/640),
                width: screenWidth,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 4 / 1,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0),
                    itemCount: univList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: (){
                          PlaceDetail tmp = new PlaceDetail(name: univList[index].title, lat: univList[index].lat, lng: univList[index].lng);
                          Navigator.pop(context, tmp);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                              univList[index].title,
                              style: TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize:screenWidth*(12/360),
                              ),
                          ),
                          decoration: BoxDecoration(
                              border:Border.all(
                                color: hexToColor('#EEEEEE'),
                                width: screenWidth*(1/360)
                              ),

                          )
                        ),
                      );
                    }),
              ),
              heightPadding(screenHeight, 34),
              Row(
                children: [
                  widthPadding(screenWidth,20),
                  Text(
                    '최근 검색한 지역',
                    style: TextStyle(
                        fontSize: screenWidth*(16/360),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () async {
                      await ResetRecentRegion();
                      setState(() {

                      });
                    },
                    child: Text(
                      '검색기록 지우기',
                      style: TextStyle(
                          fontSize: screenWidth*(10/360),
                        color: kPrimaryColor
                      ),
                    ),
                  ),
                  widthPadding(screenWidth,12),
                ],
              ),
              heightPadding(screenHeight,12),
              Divider(height: 1, color: hexToColor('#EEEEEE'),),

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
                    else if(null == regionList || countRegionList == 0) {
                      return Container(
                        height: screenHeight*0.21875,
                        width: screenWidth,
                        child: Center(
                          child: Text(
                            '최근 검색한 지역이 없습니다.',
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
                        height: screenHeight*((44*regionList.length)/640),
                        child: ListView.builder(
                          primary: true,
                          shrinkWrap: true,
                          itemCount: regionList.length,
                            physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) => GestureDetector(
                            onTap: (){
                              PlaceDetail tmp = new PlaceDetail(name: regionList[index], lat: latList[index], lng: longList[index]);
                              Navigator.pop(context, tmp);
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight*(44/screenHeight),
                                  width: screenWidth,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: screenHeight*(14/640), left: screenWidth*(20/360)),
                                    child: Text(
                                      regionList[index],
                                      style: TextStyle(
                                        fontSize: screenWidth*(12/screenWidth),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 1, color: hexToColor('#EEEEEE'),),
                              ],
                            ),
                          )
                        ),
                      );
                    }
                  }),
              Container(width: screenWidth,height: 1,color: hexToColor('#EEEEEE'),),
            ],
          ),
        ),
      ),
    );
  }
}
