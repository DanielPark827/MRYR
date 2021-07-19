import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/google_map_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/constants/GlobalAbstractClass.dart';
import 'package:provider/provider.dart';
import 'package:mryr/widget/Public/floatButtonWithListIcon.dart';
import 'package:location/location.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/screens/BorrowRoom/GoogleMap/addressComplteForReleaseRoom.dart';
import 'package:mryr/screens/BorrowRoom/model/MapHelper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mryr/constants/KeySharedPreferences.dart';
import 'package:mryr/screens/BorrowRoom/model/MapMarker.dart';
import 'dart:io';
import 'package:mryr/screens/BorrowRoom/model/FilterType.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/TransferRoom/WarningBeforeTransfer.dart';
import 'package:fluster/fluster.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/screens/BorrowRoom/model/FilterPacket.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';

class SearchMapForBorrowRoom extends StatefulWidget {


  bool flagForShort;

  SearchMapForBorrowRoom({Key key, this.flagForShort,}) : super(key : key);

  @override
  _SearchMapForBorrowRoomState createState() => _SearchMapForBorrowRoomState();
}

bool isShortForRoomList = true;

class _SearchMapForBorrowRoomState extends State<SearchMapForBorrowRoom> with SingleTickerProviderStateMixin {

  //마커 클러스터링
  final int _minClusterZoom = 0;
  final int _maxClusterZoom = 19;
  double _currentZoom = 14;
  bool _isMapLoading = true;
  bool _areMarkersLoading = true;
  Fluster<MapMarker> _clusterManager;
  String _markerImageUrl = (Platform.isIOS) ?'assets/images/logo/test2.png' : 'assets/images/logo/testandroid.png';
  bool flagRoomList = false;

  List<RoomSalesInfo> selectedItemList = [];

  final Color _clusterColor = kPrimaryColor;
  final Color _clusterTextColor = Colors.white;

  double extractNum(double v) {
    return v / 10000;
  }

  void AddRecent(int index) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subList = await getRecentList();
    if(subList == null) {
      subList = [];
      prefs.setStringList(KeyForRecent, subList);
    }
    print("ddddddddddddddddd"+"${subList.length.toString()}"+"    ${subList}");

    if(subList.contains(index.toString())) {
      subList.remove(index.toString());
    }
    subList.insert(0,index.toString());
    if(subList.length == 10) {
      subList.removeAt(0);
    }
    prefs.setStringList(KeyForRecent, subList);

    print("ddddddddddddddddd"+"${subList.length.toString()}"+"    ${subList}");
  }
  Future<List<String>> getRecentList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(KeyForRecent);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);


    setState(() {
      _isMapLoading = false;
    });

    _initMarkers();
  }

  void _initMarkers() async {
    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    List<MapMarker> markers = [];
    var list;
    if(widget.flagForShort) {
      list = await ApiProvider().get('/RoomSalesInfo/ShortMarkerList');
    } else {
      list = await ApiProvider().get('/RoomSalesInfo/TransferMarkerList');
    }
    if(null != list) {
      final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 50,
              size: Size(screenWidth*(20/360),screenWidth*(20/360))),
          'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 50,
              size: Size(screenWidth*(20/360),screenWidth*(20/360))),
          'assets/images/logo/testandroid.png');

      for(int i = 0; i < list.length; i++) {
        Map<String, dynamic> data = list[i];
        gCoordinate item = gCoordinate.fromJson(data);
        var finalLat, finalLng;

        if(null == item.lng || null == item.lat) {
          var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
          var first = addresses.first;

          finalLat = first.coordinates.latitude;
          finalLng = first.coordinates.longitude;
        } else {
          finalLat = item.lat;
          finalLng = item.lng;
        }

        setState(() {
          markers.add(
            MapMarker(
              id: 'marker' + i.toString(),
              position: LatLng(finalLat, finalLng),
              icon: markerImage,
              onMarkerTap: () async {
                if(flagRoomList){
                  flagRoomList = !flagRoomList;
                  setState(() {

                  });
                } else {
                  var list;
                  if(isShort){
                    list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarkerWithLike', jsonEncode(
                        {
                          "userID": GlobalProfile.loggedInUser
                              .userID,
                          "longitude" : item.lng,
                          "latitude" : item.lat,
                        }
                    ));
                  }else {
                    list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarkerWithLike', jsonEncode(
                        {
                          "userID": GlobalProfile.loggedInUser
                              .userID,
                          "longitude" : item.lng,
                          "latitude" : item.lat,
                        }
                    ));
                  }
                  selectedItemList.clear();
                  for(int i = 0; i < list.length; i++) {
                    var item = RoomSalesInfo.fromJson(list[i]);
                    selectedItemList.add(item);
                  }
                  flagRoomList = !flagRoomList;
                  setState(() {

                  });
                }
              }
            ),
          );
        });
      }
    }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
    EasyLoading.dismiss();
  }

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) {
      if(flagRoomList) {
        flagRoomList = false;
      }
      setState(() {
      });
      return;
    };

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }


    setState(() {
      _areMarkersLoading = true;
    });

    var updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      (screenWidth*(100/360)).toInt(),
    );

    Function okFunc = () {
      Navigator.pop(context,);
    };



    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }

  ////////////////////////////////////////////////////

  Completer<GoogleMapController> _controller = Completer();
  MapType _googleMapType = MapType.normal;
  Set<Marker> _markers = Set();
  BitmapDescriptor markerIcon;
  String addressJSON = '';
  final textfieldControllerSearchLocation = TextEditingController();

  bool ShortFilterFlag = false;
  FilterPacket fp;

  bool flagForRoomInfo = false;

  bool flagForFilter = false;
  final Start = TextEditingController();
  final End = TextEditingController();

  String SearchLocation = '지역별 검색';


  AnimationController extendedController;

  String KeyForLikes = 'RoomLikesList';
  String KeyForRecent = 'RecentLIst';

  List<gCoordinate> gCoorList = [];

  //단기
  //4가지 필터 카테고리
  // S : 단기, T : 양도
  bool isShort = true;

  List<FilterType> sFilterList = [new FilterType("방 종류"), new FilterType("가격"),new FilterType("임대 기간"),new FilterType("추가 옵션")];
  int sCurFilter = -1;

  //방 종류
  List<FilterType> sListRoomType = [new FilterType("원룸"), new FilterType("투룸 이상"),new FilterType("오피스텔"),new FilterType("아파트")];
  int sCurRoomType = -1;
  var sSubList = [];

  //가격
  double sPriceLowRange = 0;
  double sPriceHighRange = 510000;
  RangeValues sPriceValues = RangeValues(0, 510000);
  String sInfinity = "무제한";

  //임대 기간
  String sFilterRentStart = "";
  String sFilterRentDone = "";

  //추가옵션
  List<FilterType> sListOption = [new FilterType("주차 가능"), new FilterType("현관 CCTV"),new FilterType("와이파이")];


  //양도
  List<FilterType> tFilterList = [new FilterType("방 종류"), new FilterType("가격"),new FilterType("임대 기간"),new FilterType("추가 옵션")];
  int tCurFilter = -1;

  List<FilterType> tListRoomType = [new FilterType("원룸"), new FilterType("투룸 이상"),new FilterType("오피스텔"),new FilterType("아파트")];
  int tCurRoomType = -1;
  var tSubList = [];

  List<FilterType> tListContractType = [new FilterType("월세",flag: true,selected: true), new FilterType("전세")];
  int tCurContractType = -1;
  int flagContractType = null;

  double tDepositLowRange = 0;
  double tDepositHighRange = 301000000;
  RangeValues tDepositValues = RangeValues(0, 301000000);
  String tDepositInfinity = "무제한";

  double tMonthlyFeeLowRange = 0;
  double tMonthlyFeeHighRange = 5010000;
  RangeValues tMonthlyFeeValues = RangeValues(0, 5010000);
  String tMonthlyInfinity = "무제한";

  //임대 기간
  String tFilterRentStart = "";
  String tFilterRentDone = "";

  //추가옵션
  List<FilterType> tListOption = [new FilterType("주차 가능"), new FilterType("현관 CCTV"),new FilterType("와이파이")];



  @override
  Future<void> initState() {
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    if(null != widget.flagForShort) {
      isShort = widget.flagForShort ? true : false;
    } else {
      isShort = true;
    }
  }

  void AddRecentRegion(String index, double lat, double long) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> subList = await prefs.getStringList(keyRecentRegion);
    List<String> subLatList = await prefs.getStringList(keyRecentLatitudeWithRegion);
    List<String> subLongList = await prefs.getStringList(keyRecentLongitudeWithRegion);
    if(subList == null) {
      subList = [];
      subLatList= [];
      subLongList = [];
    }

    if(subList.contains(index)) {
      return;
    }
    if(subList.length == 10) {
      subList.removeAt(9);
      subLatList.removeAt(9);
      subLongList.removeAt(9);

      subList.add(index);
      subLatList.add(lat.toString());
      subLongList.add(long.toString());

      prefs.setStringList(keyRecentRegion, subList);
      prefs.setStringList(keyRecentLatitudeWithRegion, subLatList);
      prefs.setStringList(keyRecentLongitudeWithRegion, subLongList);
    } else {
      subList.add(index);
      subLatList.add(lat.toString());
      subLongList.add(long.toString());

      prefs.setStringList(keyRecentRegion, subList);
      prefs.setStringList(keyRecentLatitudeWithRegion, subLatList);
      prefs.setStringList(keyRecentLongitudeWithRegion, subLongList);
    }
  }

  CameraPosition _initialCameraPostion = CameraPosition(
    target: LatLng(37.45168803074914, 126.65723529828658),
    zoom: 14,
  );

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    globalRoomSalesInfoList;

    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Stack(
          alignment:Alignment.bottomCenter,
          children: [
            Opacity(
              opacity: _isMapLoading ? 0 : 1,
              child: GoogleMap(
                mapType: _googleMapType,
                initialCameraPosition: _initialCameraPostion,
                onMapCreated: (controller) => _onMapCreated(controller),
                onCameraMove: (position) => _updateMarkers(position.zoom),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                markers: _markers,
              ),
            ),
            Column(
              children: [
                Container(
                  height: screenHeight*(60/640),
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightPadding(screenHeight,14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: screenWidth*(12/360),),
                          GestureDetector(
                            onTap: (){
                              navigationNumProvider.setNum(0);
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              backArrow,
                              width: screenHeight*0.03125,
                              height: screenHeight*0.03125,
                            ),
                          ),
                          SizedBox(width: screenWidth*0.0416666,),
                          GestureDetector(
                            onTap:() async {
                              PlaceDetail item = await Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => addressComplteForBorrowRoom(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                              );
                              if(null != item) {
                                GoogleMapController controller = await _controller.future;
                                controller.animateCamera(
                                  CameraUpdate.newLatLng(
                                    LatLng(item.lat, item.lng),
                                  ),
                                );
                                SearchLocation = item.name;
                                await AddRecentRegion(item.name, item.lat, item.lng);
                              }
                              setState(() {
                              });
                            },
                            child: Container(
                              height: screenHeight*0.05,
                              width: screenWidth*0.836111,
                              decoration: BoxDecoration(
                                color: hexToColor('#EEEEEE'),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  widthPadding(screenWidth, 8),
                                  SvgPicture.asset(
                                    GreyMagnifyingGlass,
                                    height: screenWidth*(12/360),
                                    width: screenWidth*(12/360),
                                  ),
                                  widthPadding(screenWidth, 8),
                                  Text(
                                    SearchLocation,
                                    style: TextStyle(
                                        fontSize: screenWidth*(12/360),
                                        color: SearchLocation =='지역별 검색'? hexToColor('#888888') : Colors.black
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight*(44/640),
                  decoration: BoxDecoration(
                      color: Colors.white
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: screenWidth*0.033333,),
                              InkWell(
                                onTap: () async {
                                  ShortFilterFlag = !ShortFilterFlag;
                                  flagRoomList= false;
                                  // fp = new FilterPacket(sSubList,sPriceLowRange.toInt(),sPriceHighRange.toInt(),sFilterRentStart,sFilterRentDone,
                                  //     sListOption[0].selected ? 1 : 0,sListOption[1].selected ? 1 : 0,sListOption[2].selected ? 1 : 0);

                                  setState(() {

                                  });
                                },
                                child: Container(
                                  height: screenHeight * 0.05,
                                  width: screenWidth *0.175,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          GreyFilterIcon,
                                          width: screenHeight * 0.03125,
                                          height: screenHeight * 0.03125,
                                        ),
                                        Spacer(),
                                        Text(
                                          '필터',
                                          style: TextStyle(
                                            fontSize: screenWidth*SearchCaseFontSize,
                                            color: hexToColor('#888888'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.circular(4.0),
                                    border: Border.all(
                                      width: 1,
                                      color: hexToColor("#EEEEEE"),
                                    ),
                                  ),
                                ),
                              ),
                              widthPadding(screenWidth,4),
                              isShort ?  Expanded(
                                child: Container(
                                  height: screenHeight * 0.05,
                                  width: screenWidth*(228/360),
                                  child: ListView.separated(
                                    // controller: _scrollController,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                      itemCount:sFilterList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            flagRoomList = false;
                                            if(sCurFilter != -1) {
                                              //켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                              if(sCurFilter == index){//내가 누른게 지금 현재 필터야
                                                if(sFilterList[index].selected){
                                                  //근데 내가 누른 필터가 선택된 상태면 다시 눌러도 안꺼져야겠고
                                                }else {
                                                  sFilterList[index].flag = false;
                                                }
                                                sCloseFilter();
                                              }
                                              else {
                                                for(int i =0; i < sFilterList.length; i++) {
                                                  if(sFilterList[i].selected)
                                                    continue;
                                                  else
                                                    sFilterList[i].flag = false;
                                                }
                                                sFilterList[index].flag = true;
                                                sCurFilter = index;
                                              }
                                              setState(() {

                                              });
                                            } else {
                                              sFilterList[index].flag = !sFilterList[index].flag;

                                              if(sCurFilter == index)//켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                                sCurFilter = -1;
                                              else
                                                sCurFilter = index;

                                              //선택된 필터말고 나머지는 다 끔
                                              for(int i = 0; i < sFilterList.length; i++) {
                                                if(sFilterList[i].selected)
                                                  continue;
                                                else
                                                  sFilterList[i].flag = false;
                                              }
                                              sFilterList[index].flag = true;


                                              setState(() {

                                              });
                                            }


                                          },
                                          child: Container(
                                            height: screenHeight * (32/640),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                              child: Center(
                                                child: Text(
                                                  '${sFilterList[index].title}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth*SearchCaseFontSize,
                                                    color: sFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: new BorderRadius.circular(4.0),
                                              border: Border.all(
                                                width: 1,
                                                color: sFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ) :
                              Expanded(
                                child: Container(
                                  height: screenHeight * 0.05,
                                  width: screenWidth*(228/360),
                                  child: ListView.separated(
                                    // controller: _scrollController,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                      itemCount:tFilterList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            flagRoomList = false;
                                            if(tCurFilter != -1) {
                                              //켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                              if(tCurFilter == index){//내가 누른게 지금 현재 필터야
                                                if(tFilterList[index].selected){
                                                  //근데 내가 누른 필터가 선택된 상태면 다시 눌러도 안꺼져야겠고
                                                }else {
                                                  tFilterList[index].flag = false;
                                                }
                                                tCloseFilter();
                                              }
                                              else {
                                                for(int i =0; i < tFilterList.length; i++) {
                                                  if(tFilterList[i].selected)
                                                    continue;
                                                  else
                                                    tFilterList[i].flag = false;
                                                }
                                                tFilterList[index].flag = true;
                                                tCurFilter = index;
                                              }
                                              setState(() {

                                              });
                                            } else {
                                              tFilterList[index].flag = !tFilterList[index].flag;

                                              if(tCurFilter == index)//켜져있던 필터를 다시 누르면 -1로 바뀌면서 꺼져야함
                                                tCurFilter = -1;
                                              else
                                                tCurFilter = index;

                                              //선택된 필터말고 나머지는 다 끔
                                              for(int i = 0; i < tFilterList.length; i++) {
                                                if(tFilterList[i].selected)
                                                  continue;
                                                else
                                                  tFilterList[i].flag = false;
                                              }
                                              tFilterList[index].flag = true;


                                              setState(() {

                                              });
                                            }

                                          },
                                          child: Container(
                                            height: screenHeight * 0.05,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                              child: Center(
                                                child: Text(
                                                  '${tFilterList[index].title}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth*SearchCaseFontSize,
                                                    color: tFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: new BorderRadius.circular(4.0),
                                              border: Border.all(
                                                width: 1,
                                                color: tFilterList[index].flag ? kPrimaryColor : hexToColor('#888888'),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),


                            ],
                          ),
                        ),

                        Container(
                          height: screenHeight*(12/640),
                          decoration: BoxDecoration(
                              boxShadow: [

                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isShort ? sReturnFilter(screenWidth, screenHeight) : tReturnFilter(screenWidth, screenHeight),
                    heightPadding(screenHeight,12),
                    Row(
                      children: [
                        widthPadding(screenWidth,12),
                        GestureDetector(
                          onTap: (){
                            _currentLocation();
                          },
                          child: Container(
                            width: screenWidth*(40/360),
                            height: screenWidth*(40/360),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:  EdgeInsets.all(screenWidth*(6/360)),
                              child: SvgPicture.asset(
                                GreyMyLocationIcon,
                                width: screenWidth*(28/360),
                                height: screenWidth*(28/360),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () async {
                            if (isShort == false) {
                              EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                              tCurFilter = -1;
                              isShort = true;
                              isShortForRoomList = true;
                              flagRoomList = false;
                              resetRoomAll();
                              List<MapMarker> markers = [];
                              var list = await ApiProvider().get('/RoomSalesInfo/ShortMarkerList');
                              if(null != list) {
                                final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 50,
                                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                                    'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                              ImageConfiguration(devicePixelRatio: 50,
                              size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                              'assets/images/logo/testandroid.png');

                              for(int i = 0; i < list.length; i++) {
                              Map<String, dynamic> data = list[i];
                              gCoordinate item = gCoordinate.fromJson(data);
                              var finalLat, finalLng;

                              if(null == item.lng || null == item.lat) {
                              var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                              var first = addresses.first;

                              finalLat = first.coordinates.latitude;
                              finalLng = first.coordinates.longitude;
                              } else {
                              finalLat = item.lat;
                              finalLng = item.lng;
                              }

                              setState(() {
                              markers.add(
                              MapMarker(
                              id: 'marker' + i.toString(),
                              position: LatLng(finalLat, finalLng),
                              icon: markerImage,
                              onMarkerTap: () async {
                                if(flagRoomList){
                                  flagRoomList = !flagRoomList;
                                  setState(() {

                                  });
                                } else {
                                  var list;
                                  if(isShort){
                                    list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                        {
                                          "longitude" : item.lng,
                                          "latitude" : item.lat,
                                        }
                                    ));
                                  }else {
                                    list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                        {
                                          "longitude" : item.lng,
                                          "latitude" : item.lat,
                                        }
                                    ));
                                  }
                                  selectedItemList.clear();
                                  for(int i = 0; i < list.length; i++) {
                                    var item = RoomSalesInfo.fromJson(list[i]);
                                    selectedItemList.add(item);
                                  }
                                  flagRoomList = !flagRoomList;
                                  setState(() {

                                  });
                                }
                              }
                              ),
                              );
                              });
                              }
                              }

                              _clusterManager = await MapHelper.initClusterManager(
                              markers,
                              _minClusterZoom,
                              _maxClusterZoom,
                              );

                              await _updateMarkers();
                              setState(() {

                              });
                              EasyLoading.dismiss();
                            }
                          },
                          child: Container(
                            width: screenWidth*(47/360),
                            height: screenHeight*(32/640),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                color:  isShort ? kPrimaryColor : Colors.white
                            ),
                            child: Center(
                              child: Text(
                                "단기",
                                style: TextStyle(
                                    fontSize: 12,
                                    color:  isShort ? Colors.white : hexToColor('#888888')
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if(isShort == true){
                              EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
                              sCurFilter = -1;
                              isShort = false;
                              isShortForRoomList = false;
                              flagRoomList = false;
                              resetTransferAll();
                              List<MapMarker> markers = [];
                              var list = await ApiProvider().get('/RoomSalesInfo/TransferMarkerList');
                              if(null != list) {
                                final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 50,
                                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                                    'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                                    ImageConfiguration(devicePixelRatio: 50,
                                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                                    'assets/images/logo/testandroid.png');

                                for(int i = 0; i < list.length; i++) {
                                  Map<String, dynamic> data = list[i];
                                  gCoordinate item = gCoordinate.fromJson(data);
                                  var finalLat, finalLng;

                                  if(null == item.lng || null == item.lat) {
                                    var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                                    var first = addresses.first;

                                    finalLat = first.coordinates.latitude;
                                    finalLng = first.coordinates.longitude;
                                  } else {
                                    finalLat = item.lat;
                                    finalLng = item.lng;
                                  }

                                  setState(() {
                                    markers.add(
                                      MapMarker(
                                        id: 'marker' + i.toString(),
                                        position: LatLng(finalLat, finalLng),
                                        icon: markerImage,
                                        onMarkerTap: () async {
                                            if(flagRoomList){
                                              flagRoomList = !flagRoomList;
                                              setState(() {

                                              });
                                            } else {
                                              var list;
                                              if(isShort){
                                                list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                                    {
                                                      "longitude" : item.lng,
                                                      "latitude" : item.lat,
                                                    }
                                                ));
                                              }else {
                                                list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                                    {
                                                      "longitude" : item.lng,
                                                      "latitude" : item.lat,
                                                    }
                                                ));
                                              }
                                              selectedItemList.clear();
                                              for(int i = 0; i < list.length; i++) {
                                                var item = RoomSalesInfo.fromJson(list[i]);
                                                selectedItemList.add(item);
                                              }
                                              flagRoomList = !flagRoomList;
                                              setState(() {

                                              });
                                            }
                                          }
                                      ),
                                    );
                                  });
                                }
                              }

                              _clusterManager = await MapHelper.initClusterManager(
                                markers,
                                _minClusterZoom,
                                _maxClusterZoom,
                              );

                              await _updateMarkers();
                              setState(() {

                              });
                              EasyLoading.dismiss();
                            }
                          },
                          child: Container(
                            width: screenWidth*(47/360),
                            height: screenHeight*(32/640),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                                color: !isShort ? kPrimaryColor : Colors.white
                            ),
                            child: Center(
                              child: Text(
                                "양도",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: !isShort ? Colors.white : hexToColor('#888888')
                                ),
                              ),
                            ),
                          ),
                        ),
                        widthPadding(screenWidth,12),
                      ],
                    ),
                  ],
                )
              ],
            ),
            // flagRoomList? GestureDetector(onTap: (){
            //   flagRoomList = false;
            //   setState(() {
            //
            //   });
            // }, child: Container(width:screenWidth,height:screenHeight,color:Colors.transparent)):Container(),
            Positioned(
            right: 0,
              bottom:0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  isShort == false ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (GlobalProfile.roomSalesInfoList.length <= 4) {
                            Navigator.push(
                                context, // 기본 파라미터, SecondRoute로 전달
                                MaterialPageRoute(
                                  builder: (context) =>
                                      WarningBeforeTransfer(),
                                ) // SecondRoute를 생성하여 적재
                            );
                          } else {
                            CustomOKDialog(context, "방 등록은 5개까지 가능합니다", "올리셨던 방을 수정해주세요");
                          }
                        },
                        child: Stack(
                          children: [
                            Container(  height: 52,
                              width:130
                              ,decoration:BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(30))),),
                            Container(
                                height: 52,
                                width:140,
                                child: Row(
                                  children: <Widget>[
                                    Container(width:13),

                                    Container(child:Text("양도하기 ",style: TextStyle(color:Color(0xFF222222)),)),
                                    Container(width:4),

                                    FloatingActionButton(heroTag: "btn2",child:Icon(Icons.add,size: 30))],mainAxisAlignment: MainAxisAlignment.end,)
                            ),
                          ],
                        ),
                      ),
                      Container(width:screenWidth*(8/360)),
                    ],
                  ): Container(),

                  Container(height:screenWidth*(12/360)),
                  AnimatedContainer(
                    height: (flagRoomList&&selectedItemList.length != 0)? (selectedItemList.length >= 2 ? screenHeight*(305/640): screenHeight*(190/640)) : 0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,8),
                          Padding(
                            padding: EdgeInsets.only(left:screenWidth*(164/360)),
                            child: Container(width:screenWidth*(34/360),height:screenWidth*(4/640),color:Color(0xffc4c4c4)),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth*(180/360),
                                height: screenHeight*(40/640),
                                child: Center(
                                  child: Text(
                                    !flagRoomList? "":'전체 방 ('+selectedItemList.length.toString()+')',
                                    style: TextStyle(
                                        fontSize: screenWidth*(12/360),
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(width:screenWidth/2,height:1,color:Color(0xffcccccc)),
                              Container(width:screenWidth/2,height:1,color:Color(0xfff8f8f8)),
                            ],
                          ),
                          heightPadding(screenHeight,12),
                          Container(
                            width: screenWidth,
                            height: selectedItemList.length >= 2 ? screenHeight * (240/640) : screenHeight * (126/640),
                            color: Colors.white,
                            child: ListView.builder(
                              primary: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: selectedItemList.length,
                              itemBuilder: (BuildContext context, int index) => GestureDetector(
                                onTap:() async {
                                  GlobalProfile.detailReviewList.clear();
                                  if (null ==
                                      selectedItemList[index].lng ||
                                      null == selectedItemList[index]
                                          .lat) {
                                    var addresses = await Geocoder.google(
                                        'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                                        .findAddressesFromQuery(
                                        selectedItemList[index]
                                            .location);
                                    var first = addresses.first;
                                    selectedItemList[index].lat = first.coordinates.latitude;
                                    selectedItemList[index].lng = first.coordinates.longitude;
                                  }
                                  await AddRecent(
                                      selectedItemList[index].id);

                                  var detailReviewList = await ApiProvider()
                                      .post('/Review/ReviewListLngLat',
                                      jsonEncode({
                                        "longitude": selectedItemList[index].lng,
                                        "latitude": selectedItemList[index].lat,
                                      }));

                                  if (detailReviewList != null) {
                                    for (int i = 0;
                                    i < detailReviewList.length;
                                    ++i) {
                                      GlobalProfile.detailReviewList.add(
                                          DetailReview.fromJson(
                                              detailReviewList[i]));
                                    }
                                  }

                                  Navigator.push(
                                      context, // 기본 파라미터, SecondRoute로 전달
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailedRoomInformation(
                                                  roomSalesInfo: selectedItemList[index],
                                                nbnb: selectedItemList[index].ShortTerm,

                                              )) // SecondRoute를 생성하여 적재
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.033333,
                                    //  right: screenWidth * 0.033333,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: screenHeight * 0.01875),
                                          Column(
                                            children: [
                                              Container(
                                                width: screenWidth * 0.3333333,
                                                height: screenHeight * 0.15625,
                                                child: ClipRRect(
                                                    borderRadius: new BorderRadius.circular(4.0),
                                                    child:      selectedItemList[index].imageUrl1=="BasicImage"
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
                                                        :  Stack(
                                                          children: [
                                                            FittedBox(
                                                      fit: BoxFit.cover,
                                                      child:    getExtendedImage(get_resize_image_name(selectedItemList[index].imageUrl1,360), 0,extendedController),
                                                    ),
                                                            Center(
                                                              child: SvgPicture.asset(
                                                                  RoomWaterMark,
                                                                  width: screenWidth*(56/360),
                                                                  height:screenHeight*(16/640)
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.033333,
                                      ),
                                      Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: screenHeight * 0.01875),
                                                      SizedBox(
                                                        width: screenWidth*(185/360),
                                                        child: isShort?
                                                        Row(
                                                          children: [
                                                            Wrap(
                                                              alignment: WrapAlignment.center,
                                                              spacing: screenWidth * 0.011111,
                                                              children: [
                                                                Container(
                                                                  height: screenHeight * 0.028125,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        screenWidth * 0.022222,
                                                                        screenHeight * 0.000225,
                                                                        screenWidth * 0.022222,0),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Text(
                                                                        "내방니방 직영",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            screenWidth*TagFontSize,
                                                                            color: kPrimaryColor,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    new BorderRadius.circular(4.0),
                                                                    color: hexToColor('#EEEEEE'),
                                                                  ),
                                                                ),

                                                                Container(
                                                                  height: screenHeight * 0.028125,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        screenWidth * 0.022222,
                                                                        screenHeight * 0.000225,
                                                                        screenWidth * 0.022222,
                                                                        0),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Text(
                                                                        "하루 가능",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            screenWidth*TagFontSize,
                                                                            color: kPrimaryColor,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    new BorderRadius.circular(4.0),
                                                                    color: hexToColor('#EEEEEE'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),

                                                          ],
                                                        ) : Row(
                                                          children: [
                                                            Wrap(
                                                              alignment: WrapAlignment.center,
                                                              spacing: screenWidth * 0.011111,
                                                              children: [
                                                                Container(
                                                                  height: screenHeight * 0.028125,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        screenWidth * 0.022222,
                                                                        screenHeight * 0.000225,
                                                                        screenWidth * 0.022222,
                                                                        screenHeight * 0.003225),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Text(
                                                                        selectedItemList[index].Condition == 1 ? "신축 건물" :  "구축 건물",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            screenWidth*TagFontSize,
                                                                            color: kPrimaryColor,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    new BorderRadius.circular(4.0),
                                                                    color: hexToColor("#E5E5E5"),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: screenHeight * 0.028125,
                                                                  child: Padding(
                                                                    padding: EdgeInsets.fromLTRB(
                                                                        screenWidth * 0.022222,
                                                                        screenHeight * 0.000225,
                                                                        screenWidth * 0.022222,
                                                                        screenHeight * 0.003225),
                                                                    child: Align(
                                                                      alignment: Alignment.center,
                                                                      child: Text(
                                                                        selectedItemList[index].Floor == 1 ? "반지하" : selectedItemList[index].Floor == 2 ? "1층" : "2층 이상",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                            screenWidth*TagFontSize,
                                                                            color: kPrimaryColor,
                                                                            fontWeight: FontWeight.bold
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    new BorderRadius.circular(4.0),
                                                                    color: hexToColor("#E5E5E5"),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),

                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.00625,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text(

                                                  (isShort? selectedItemList[index].DailyRentFeesOffer.toString(): selectedItemList[index].monthlyRentFeesOffer <= 0 ? selectedItemList[index].depositFeesOffer.toString() : selectedItemList[index].monthlyRentFeesOffer.toString()) +
                                                        (isShort? "만원 / 일" :selectedItemList[index].monthlyRentFeesOffer <= 0 ? '만원 / 전세' : '만원 / 월세'),
                                                    style: TextStyle(
                                                        fontSize: screenHeight * 0.025,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  isShort? Text(
                                                    ' ( '+selectedItemList[index].WeeklyRentFeesOffer.toString() +
                                                      '만원 / 주 )',
                                                    style: TextStyle(
                                                        fontSize: screenWidth * (12/360),
                                                      color: Color(0xff888888)),
                                                  ):Container(),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.00625,
                                              ),
                                              Text(
                                                selectedItemList[index].termOfLeaseMin +
                                                    ' ~ ' +
                                                    selectedItemList[index].termOfLeaseMax,
                                                style: TextStyle(color: hexToColor("#44444444")),
                                              ),
                                              Container(
                                                width:screenWidth*(205/360),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      width: screenWidth*0.45,
                                                      height: screenHeight*(36/640),
                                                      child: Text(
                                                        selectedItemList[index].information==null?"":selectedItemList[index].information,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            color: hexToColor("#888888")),
                                                      ),
                                                    ),
                                                    Text(timeCheck( selectedItemList[index].updatedAt.toString()),style: TextStyle(fontSize: screenWidth*(10/360),color: Color(0xff888888)),),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            top: screenWidth*(8/360),
                                            right:screenWidth*(4/360),
                                            child: GestureDetector(

                                                onTap: () async {
                                                  var res = await ApiProvider().post('/RoomSalesInfo/Insert/Like', jsonEncode(
                                                      {
                                                        "userID" : GlobalProfile.loggedInUser.userID,
                                                        "roomSaleID": selectedItemList[index].id,
                                                      }
                                                  ));
                                                  bool sub;
                                                  if(null != selectedItemList[index].Likes) {
                                                    sub = !selectedItemList[index].Likes;
                                                  } else {
                                                    sub = true;
                                                  }
                                                  selectedItemList[index].ChangeLikesWithValue(sub);
                                                  getRoomSalesInfoByIDFromMainTransfer(selectedItemList[index].id).ChangeLikesWithValue(sub);
                                                  setState(() {

                                                  });
                                                },
                                                child:  ( selectedItemList[index].Likes == null || !selectedItemList[index].Likes) ?
                                                SvgPicture.asset(
                                                  GreyEmptyHeartIcon,

                                                  width: screenHeight * 0.0375,
                                                  height: screenHeight * 0.0375,
                                                  color: Color(0xffEEEEEE),
                                                )
                                                    : SvgPicture.asset(
                                                  PurpleFilledHeartIcon,
                                                  width: screenHeight * 0.0375,
                                                  height: screenHeight * 0.0375,
                                                  color: kPrimaryColor,
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ShortFilterFlag && isShortForRoomList ? Container(
              width :screenWidth,
              height : screenHeight,
              color:Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    heightPadding(screenHeight,14),
                    Row(
                      children: [
                        InkWell(
                          onTap:(){
                            ShortFilterFlag = false;
                            setState(() {

                            });
                          },
                          child: SvgPicture.asset(
                            FilterXIcon,
                          ),
                        ),
                        widthPadding(screenWidth,100),
                        Text(
                          '전체 필터',
                          style:TextStyle(
                            fontSize:screenWidth*(18/360),
                            fontWeight: FontWeight.bold,

                          )
                        ),
                       ],
                    ),
                    heightPadding(screenHeight,14),
                    Container(
                      width: screenWidth,
                      height:screenHeight*(114/640),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,14),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Text(
                              "방 종류",
                              style:TextStyle(
                                  fontSize: screenWidth*(14/360),
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                            ),
                          ),
                          heightPadding(screenHeight,12),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Container(
                              height: screenHeight * (34/640),
                              child: ListView.separated(
                                // controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                  itemCount:sListRoomType.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: (){
                                        sListRoomType[index].flag = !sListRoomType[index].flag;
                                        sListRoomType[index].selected = !sListRoomType[index].selected;
                                        sCurRoomType = index;
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                          child: Center(
                                            child: Text(
                                              '${sListRoomType[index].title}',
                                              style: TextStyle(
                                                fontSize: screenWidth*SearchCaseFontSize,
                                                color: sListRoomType[index].flag ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: sListRoomType[index].flag ? kPrimaryColor : Colors.white,
                                          borderRadius: new BorderRadius.circular(4.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(1.5, 1.5),
                                            ),
                                          ],

                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                          height:screenHeight*(4/640),
                          width:screenWidth,
                          color:hexToColor('#FFFFFF'),
                    ),
                    Container(
                      width: screenWidth,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,14),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Row(
                              children: [
                                Text(
                                  "가격 ",
                                  style:TextStyle(
                                      fontSize: screenWidth*(14/360),
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black
                                  ),
                                ),
                                Text(
                                  "(일 단위)",
                                  style:TextStyle(
                                      fontSize: screenWidth*(13.5/360),
                                      color:hexToColor('#888888')
                                  ),
                                ),
                              ],
                            ),
                          ),
                          heightPadding(screenHeight,12),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Row(
                              children: [
                                Text(
                                  "전체",
                                  style:TextStyle(
                                      fontSize: screenWidth*(14/360),
                                      fontWeight: FontWeight.bold,
                                      color:kPrimaryColor
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  sInfinity,
                                  style:TextStyle(
                                      fontSize: screenWidth*(12/360),
                                      color:kPrimaryColor
                                  ),
                                ),
                                widthPadding(screenWidth,16),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              width: screenWidth * (336 / 360),
                              child: SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: Colors.white,
                                ),
                                child: RangeSlider(
                                  min: 0,
                                  max: 310000,
                                  divisions: 31,
                                  inactiveColor: Color(0xffcccccc),
                                  activeColor: kPrimaryColor,
                                  labels: RangeLabels(sPriceLowRange.floor().toString(),
                                      sPriceHighRange.floor().toString()),
                                  values: sPriceValues,
                                  //RangeValues(_lowValue,_highValue),
                                  onChanged: (_range) {
                                    setState(() {
                                      if(_range.end.toInt() == 310000) {
                                        sInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                                      } else {
                                        sInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                                      }

                                      sPriceValues = _range;
                                      sPriceLowRange = _range.start;
                                      sPriceHighRange = _range.end;

                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          heightPadding(screenHeight,8),
                          Row(
                            children: [
                              widthPadding(screenWidth,14),
                              Text(
                                '최소',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Text(
                                '최대',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              widthPadding(screenWidth,14),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:screenHeight*(4/640),
                      width:screenWidth,
                      color:hexToColor('#FFFFFF'),
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight*(126/640),
                      color: Colors.white,
                      child: Column(
                        children: [
                          heightPadding(screenHeight,22),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Row(
                              children: [
                                Text(
                                  "임대 기간",
                                  style:TextStyle(
                                      fontSize: screenWidth*(14/360),
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                          heightPadding(screenHeight,26),
                          Container(
                            width: screenWidth * (336 / 360),
                            child: Row(
                              children: [
                                Spacer(),
                                // SizedBox(width: screenWidth*(20/360),),
                                GestureDetector(
                                  onTap: (){
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                                        maxTime: sFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(sFilterRentDone).year, DateFormat('y.MM.d').parse(sFilterRentDone).month,DateFormat('y.MM.d').parse(sFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                        theme: DatePickerTheme(
                                            headerColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            itemStyle: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                        onChanged: (date) {
                                          sFilterRentStart = DateFormat('y.MM.d').format(date);
                                          setState(() {

                                          });
                                        },
                                        currentTime: DateTime.now(), locale: LocaleType.ko);
                                  },
                                  child: Container(
                                    width: screenWidth * (120 / 360),
                                    child: Center(
                                      child: Text(
                                        sFilterRentStart == "" ? "입주" : sFilterRentStart,
                                        style: TextStyle(
                                          fontSize: screenWidth * (14 / 360),
                                          fontWeight: FontWeight.bold,
                                          color: sFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * (55 / 640),
                                ),
                                Text(
                                  "~",
                                  style: TextStyle(
                                      fontSize: screenWidth * (20 / 360),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: screenWidth * (55 / 640),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: sFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(sFilterRentStart).year, DateFormat('y.MM.d').parse(sFilterRentStart).month,DateFormat('y.MM.d').parse(sFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                        theme: DatePickerTheme(
                                            headerColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            itemStyle: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                        onChanged: (date) {
                                          sFilterRentDone = DateFormat('y.MM.d').format(date);
                                          setState(() {

                                          });
                                        },
                                        currentTime: DateTime.now(), locale: LocaleType.ko);
                                  },
                                  child: Container(
                                    width: screenWidth * (120 / 360),
                                    child: Center(
                                      child: Text(
                                        sFilterRentDone == "" ? "퇴실" : sFilterRentDone,
                                        style: TextStyle(
                                          fontSize: screenWidth * (14 / 360),
                                          fontWeight: FontWeight.bold,
                                          color: sFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              widthPadding(screenWidth,12),
                              Container(
                                width: screenWidth*(148/360),
                                height: 1,
                                color: hexToColor('#CCCCCC'),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                width: screenWidth*(148/360),
                                height: 1,
                                color: hexToColor('#CCCCCC'),
                              ),
                              widthPadding(screenWidth,12),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:screenHeight*(4/640),
                      width:screenWidth,
                      color:hexToColor('#FFFFFF'),
                    ),
                    Container(
                      width: screenWidth,
                      height:screenHeight*(114/640),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,14),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Text(
                              "추가 옵션",
                              style:TextStyle(
                                  fontSize: screenWidth*(14/360),
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                            ),
                          ),
                          heightPadding(screenHeight,12),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Container(
                              height: screenHeight * (34/640),
                              child: ListView.separated(
                                // controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                  itemCount:sListOption.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: (){
                                        sListOption[index].flag = !sListOption[index].flag;
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                          child: Center(
                                            child: Text(
                                              '${sListOption[index].title}',
                                              style: TextStyle(
                                                fontSize: screenWidth*SearchCaseFontSize,
                                                color: sListOption[index].flag ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: sListOption[index].flag ? kPrimaryColor : Colors.white,
                                          borderRadius: new BorderRadius.circular(4.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(1.5, 1.5),
                                            ),
                                          ],

                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height:screenHeight*(4/640),
                      width:screenWidth,
                      color:hexToColor('#FFFFFF'),
                    ),
                  ],
                ),
              ),
            ):
            ShortFilterFlag && !isShortForRoomList ? Container(
              width :screenWidth,
              height : screenHeight,
              color:Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    heightPadding(screenHeight,14),
                    Row(
                      children: [
                        InkWell(
                          onTap:(){
                            ShortFilterFlag = false;
                            setState(() {

                            });
                          },
                          child: SvgPicture.asset(
                            FilterXIcon,
                          ),
                        ),
                        widthPadding(screenWidth,100),
                        Text(
                            '전체 필터',
                            style:TextStyle(
                              fontSize:screenWidth*(18/360),
                              fontWeight: FontWeight.bold,

                            )
                        ),
                      ],
                    ),
                    heightPadding(screenHeight,14),
                    Container(
                      width: screenWidth,
                      height:screenHeight*(114/640),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,14),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Text(
                              "방 종류",
                              style:TextStyle(
                                  fontSize: screenWidth*(14/360),
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                            ),
                          ),
                          heightPadding(screenHeight,12),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Container(
                              height: screenHeight * (34/640),
                              child: ListView.separated(
                                // controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                  itemCount:tListRoomType.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: (){
                                        tListRoomType[index].flag = !tListRoomType[index].flag;
                                        tListRoomType[index].selected = !tListRoomType[index].selected;
                                        tCurRoomType = index;
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                          child: Center(
                                            child: Text(
                                              '${tListRoomType[index].title}',
                                              style: TextStyle(
                                                fontSize: screenWidth*SearchCaseFontSize,
                                                color: tListRoomType[index].flag ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: tListRoomType[index].flag ? kPrimaryColor : Colors.white,
                                          borderRadius: new BorderRadius.circular(4.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(1.5, 1.5),
                                            ),
                                          ],

                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width:screenWidth,
                        height:screenHeight*(4/640),
                        color:hexToColor('#FFFFFF'),
                    ),
                    Container(
                      width: screenWidth,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,14),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Text(
                              "거래유형",
                              style:TextStyle(
                                  fontSize: screenWidth*(14/360),
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                            ),
                          ),
                          heightPadding(screenHeight,12),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Container(
                              height: screenHeight * (34/640),
                              child: ListView.separated(
                                // controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                  itemCount:tListContractType.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: (){
                                        tListContractType[index].flag = !tListContractType[index].flag;
                                        tListContractType[index].selected = !tListContractType[index].selected;
                                        tCurContractType = index;

                                        for(int i = 0; i < tListContractType.length; i++){
                                          if(i != index) {
                                            tListContractType[i].flag = false;
                                            tListContractType[i].selected = false;
                                          }
                                        }

                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth*(47/360),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                          child: Center(
                                            child: Text(
                                              '${tListContractType[index].title}',
                                              style: TextStyle(
                                                fontSize: screenWidth*SearchCaseFontSize,
                                                color: tListContractType[index].flag ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: tListContractType[index].flag ? kPrimaryColor : Colors.white,
                                          borderRadius: new BorderRadius.circular(4.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(1.5, 1.5),
                                            ),
                                          ],

                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          heightPadding(screenHeight,16),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Row(
                              children: [
                                Text(
                                  "보증금",
                                  style:TextStyle(
                                      fontSize: screenWidth*(14/360),
                                      fontWeight: FontWeight.bold,
                                      color:kPrimaryColor
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  tDepositInfinity,
                                  style:TextStyle(
                                      fontSize: screenWidth*(12/360),
                                      color:kPrimaryColor
                                  ),
                                ),
                                widthPadding(screenWidth,16),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              width: screenWidth * (336 / 360),
                              child: SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: Colors.white,
                                ),
                                child: RangeSlider(
                                  min: 0,
                                  max: 10100000,
                                  divisions: 101,
                                  inactiveColor: Color(0xffcccccc),
                                  activeColor: kPrimaryColor,
                                  labels: RangeLabels(tDepositLowRange.floor().toString(),
                                      tDepositHighRange.floor().toString()),
                                  values: tDepositValues,
                                  //RangeValues(_lowValue,_highValue),
                                  onChanged: (_range) {
                                    setState(() {
                                      if(_range.end.toInt() == 10100000) {
                                        tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                                      } else {
                                        tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                                      }

                                      tDepositValues = _range;
                                      tDepositLowRange = _range.start;
                                      tDepositHighRange = _range.end;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: screenHeight*(8/640),
                            width: 1,
                            color: hexToColor('#888888'),
                          ),
                          Row(
                            children: [
                              widthPadding(screenWidth,14),
                              Text(
                                '최소',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              Spacer(),
                              Text(
                                '500만원',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              Spacer(),
                              Text(
                                '최대',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              widthPadding(screenWidth,14),
                            ],
                          ),
                          heightPadding(screenHeight,20),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Row(
                              children: [
                                Text(
                                  "월세",
                                  style:TextStyle(
                                      fontSize: screenWidth*(14/360),
                                      fontWeight: FontWeight.bold,
                                      color:kPrimaryColor
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Text(
                                  tMonthlyInfinity,
                                  style:TextStyle(
                                      fontSize: screenWidth*(12/360),
                                      color:kPrimaryColor
                                  ),
                                ),
                                widthPadding(screenWidth,16),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              width: screenWidth * (336 / 360),
                              child: SliderTheme(
                                data: SliderThemeData(
                                  thumbColor: Colors.white,
                                ),
                                child: RangeSlider(
                                  min: 0,
                                  max: 1010000,
                                  divisions: 101,
                                  inactiveColor: Color(0xffcccccc),
                                  activeColor: kPrimaryColor,
                                  labels: RangeLabels(tMonthlyFeeLowRange.floor().toString(),
                                      tMonthlyFeeHighRange.floor().toString()),
                                  values: tMonthlyFeeValues,
                                  //RangeValues(_lowValue,_highValue),
                                  onChanged: (_range) {
                                    setState(() {
                                      if(_range.end.toInt() == 1010000) {
                                        tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                                      } else {
                                        tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                                      }

                                      tMonthlyFeeValues = _range;
                                      tMonthlyFeeLowRange = _range.start;
                                      tMonthlyFeeHighRange = _range.end;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: screenHeight*(8/640),
                            width: 1,
                            color: hexToColor('#888888'),
                          ),
                          Row(
                            children: [
                              widthPadding(screenWidth,14),
                              Text(
                                '최소',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              Spacer(),
                              Text(
                                '50만원',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              Spacer(),
                              Text(
                                '최대',
                                style: TextStyle(
                                    fontSize: screenWidth*(10/360),
                                    color: hexToColor('#888888')
                                ),
                              ),
                              widthPadding(screenWidth,14),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width:screenWidth,
                      height:screenHeight*(4/640),
                      color:hexToColor('#FFFFFF'),
                    ),
                    Container(
                      width: screenWidth,
                      height: screenHeight*(126/640),
                      color: Colors.white,
                      child: Column(
                        children: [
                          heightPadding(screenHeight,22),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Row(
                              children: [
                                Text(
                                  "임대 기간",
                                  style:TextStyle(
                                      fontSize: screenWidth*(14/360),
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),
                          heightPadding(screenHeight,26),
                          Container(
                            width: screenWidth * (336 / 360),
                            child: Row(
                              children: [
                                Spacer(),
                                // SizedBox(width: screenWidth*(20/360),),
                                GestureDetector(
                                  onTap: (){
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                                        maxTime: tFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(tFilterRentDone).year, DateFormat('y.MM.d').parse(tFilterRentDone).month,DateFormat('y.MM.d').parse(tFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                        theme: DatePickerTheme(
                                            headerColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            itemStyle: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                        onChanged: (date) {
                                          tFilterRentStart = DateFormat('y.MM.d').format(date);
                                          setState(() {

                                          });
                                        },
                                        currentTime: DateTime.now(), locale: LocaleType.ko);
                                  },
                                  child: Container(
                                    width: screenWidth * (120 / 360),
                                    child: Center(
                                      child: Text(
                                        tFilterRentStart == "" ? "입주" : tFilterRentStart,
                                        style: TextStyle(
                                          fontSize: screenWidth * (14 / 360),
                                          fontWeight: FontWeight.bold,
                                          color: tFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * (55 / 640),
                                ),
                                Text(
                                  "~",
                                  style: TextStyle(
                                      fontSize: screenWidth * (20 / 360),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: screenWidth * (55 / 640),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: tFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(tFilterRentStart).year, DateFormat('y.MM.d').parse(tFilterRentStart).month,DateFormat('y.MM.d').parse(tFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                        theme: DatePickerTheme(
                                            headerColor: Colors.white,
                                            backgroundColor: Colors.white,
                                            itemStyle: TextStyle(
                                                color: Colors.black, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                        onChanged: (date) {
                                          tFilterRentDone = DateFormat('y.MM.d').format(date);
                                          setState(() {

                                          });
                                        },
                                        currentTime: DateTime.now(), locale: LocaleType.ko);
                                  },
                                  child: Container(
                                    width: screenWidth * (120 / 360),
                                    child: Center(
                                      child: Text(
                                        tFilterRentDone == "" ? "퇴실" : tFilterRentDone,
                                        style: TextStyle(
                                          fontSize: screenWidth * (14 / 360),
                                          fontWeight: FontWeight.bold,
                                          color: tFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              widthPadding(screenWidth,12),
                              Container(
                                width: screenWidth*(148/360),
                                height: 1,
                                color: hexToColor('#CCCCCC'),
                              ),
                              Expanded(child: SizedBox()),
                              Container(
                                width: screenWidth*(148/360),
                                height: 1,
                                color: hexToColor('#CCCCCC'),
                              ),
                              widthPadding(screenWidth,12),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width:screenWidth,
                      height:screenHeight*(4/640),
                      color:hexToColor('#FFFFFF'),
                    ),
                    Container(
                      width: screenWidth,
                      height:screenHeight*(114/640),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          heightPadding(screenHeight,14),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Text(
                              "추가 옵션",
                              style:TextStyle(
                                  fontSize: screenWidth*(14/360),
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                            ),
                          ),
                          heightPadding(screenHeight,12),
                          Padding(
                            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                            child: Container(
                              height: screenHeight * (34/640),
                              child: ListView.separated(
                                // controller: _scrollController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                                  itemCount:tListOption.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: (){
                                        tListOption[index].flag = !tListOption[index].flag;
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                          child: Center(
                                            child: Text(
                                              '${tListOption[index].title}',
                                              style: TextStyle(
                                                fontSize: screenWidth*SearchCaseFontSize,
                                                color: tListOption[index].flag ? Colors.white : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: tListOption[index].flag ? kPrimaryColor : Colors.white,
                                          borderRadius: new BorderRadius.circular(4.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 0,
                                              blurRadius: 4,
                                              offset: Offset(1.5, 1.5),
                                            ),
                                          ],

                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ) : SizedBox(),
          ],
        ),
        bottomNavigationBar: ShortFilterFlag && widget.flagForShort ? GestureDetector(
          onTap: () async {
            //매물 리스트
            // EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
            ShortFilterFlag = false;
            sSubList.clear();
            for(int i = 1; i <= sListRoomType.length; i++) {
              if(sListRoomType[i-1].selected) {
                sSubList.add(i.toString());
              }
            }
            if(sSubList.length == 0) {//아무것도 선택 안한 경우
              sSubList = ["1","2","3","4"];
              sFilterList[0].flag = false;
              sFilterList[0].title = "방 종류";
              sFilterList[0].selected = false;
            }else {
              sFilterList[0].title = "";
              for(int i =0; i < sListRoomType.length; i++){
                if(sListRoomType[i].flag) {
                  sFilterList[0].title += sListRoomType[i].title + "/";
                }
              }
              String s = sFilterList[0].title;
              int l = sFilterList[0].title.length;
              sFilterList[0].title = s.substring(0,l-1);
              sFilterList[0].selected = true;
              sFilterList[0].flag = true;
              sCloseFilter();
            }

            if((sPriceLowRange == 0 && sPriceHighRange == 310000)) {
              sFilterList[1].flag = false;
              sFilterList[1].title = "가격";
              sFilterList[1].selected = false;
            }else {
              sFilterList[1].title = "일 / " +  extractNum(sPriceLowRange).toInt().toString()+"만원-"+extractNum(sPriceHighRange).toInt().toString()+"만원";
              sFilterList[1].selected = true;
              sFilterList[1].flag = true;
              sCloseFilter();
            }

            if(sFilterRentStart == "" || sFilterRentDone ==""){
              Function okFunc = () async{
                Navigator.pop(context);

              };
              sFilterList[2].flag = false;
              sFilterList[2].title = "임대 기간";
              sFilterList[2].selected = false;
              sCloseFilter();
            }else {
              sFilterList[2].title =
                  sFilterRentStart + "-" + sFilterRentDone;
              sFilterList[2].selected = true;
              sFilterList[2].flag = true;
            }

            sFilterList[3].title = "";
            for(int i =0; i < sListOption.length; i++){
              if(sListOption[i].flag) {
                sFilterList[3].title += sListOption[i].title + "/";
              }
            }
            String s = sFilterList[3].title;
            int l = sFilterList[3].title.length;

            if(l==0) {//아무것도 선택 안한 경우
              sFilterList[3].flag = false;
              sFilterList[3].title = "추가 옵션";
              sFilterList[3].selected = false;
            }else {
              sFilterList[3].selected = true;
              sFilterList[3].flag = true;
              sFilterList[3].title = s.substring(0,l-1);
              sCloseFilter();
            }



            bool subFlag = true;
            for(int i = 0; i <sListOption.length; i++) {
              if(sListOption[i].selected) {
                subFlag = false;
                break;
              }
            }
            sFilterList[2].selected;
            var list = await ApiProvider().post("/RoomSalesInfo/ListShortFilter", jsonEncode(
                {
                  "types" : sSubList.length == 0 ? null : sSubList,
                  "feemin" : sPriceLowRange,
                  "feemax" : sPriceHighRange == 310000 ? 9999999999 : sPriceHighRange,
                  "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                  "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                  "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                  "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                  "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                }
            ));

            if (list != false) {
              List<MapMarker> markers = [];

              if(null != list) {
                final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/testandroid.png');

                for(int i = 0; i < list.length; i++) {
                  Map<String, dynamic> data = list[i];
                  gCoordinate item = gCoordinate.fromJson(data);
                  var finalLat, finalLng;

                  if(null == item.lng || null == item.lat) {
                    var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                    var first = addresses.first;

                    finalLat = first.coordinates.latitude;
                    finalLng = first.coordinates.longitude;
                  } else {
                    finalLat = item.lat;
                    finalLng = item.lng;
                  }

                  setState(() {
                    markers.add(
                      MapMarker(
                          id: 'marker' + i.toString(),
                          position: LatLng(finalLat, finalLng),
                          icon: markerImage,
                          onMarkerTap: () async {
                            if(flagRoomList){
                              flagRoomList = !flagRoomList;
                              setState(() {

                              });
                            } else {
                              var list;
                              if(isShort){
                                list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                    {
                                      "longitude" : item.lng,
                                      "latitude" : item.lat,
                                    }
                                ));
                              }else {
                                list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                    {
                                      "longitude" : item.lng,
                                      "latitude" : item.lat,
                                    }
                                ));
                              }
                              selectedItemList.clear();
                              for(int i = 0; i < list.length; i++) {
                                var item = RoomSalesInfo.fromJson(list[i]);
                                selectedItemList.add(item);
                              }
                              flagRoomList = !flagRoomList;
                              setState(() {

                              });
                            }
                          }
                      ),
                    );
                  });
                }
              }

              _clusterManager = await MapHelper.initClusterManager(
                markers,
                _minClusterZoom,
                _maxClusterZoom,
              );

              await _updateMarkers();
            }
            else {
              Function okFunc = () async{
                Navigator.pop(context);

              };
              resetRoomAll();
              OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
            }
            sCloseFilter();
            setState(() {

            });
            // EasyLoading.dismiss();
          },
          child: Container(
            height: screenHeight*(60/640),
            width: screenWidth,
            color: kPrimaryColor,
            child: Center(
              child: Text(
                '적용하기',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*(16/360),
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ):
        ShortFilterFlag && !widget.flagForShort ? GestureDetector(
          onTap: () async {
            // EasyLoading.show(
            //     status: "",
            //     maskType:
            //     EasyLoadingMaskType
            //         .black);
            ShortFilterFlag = false;
            tSubList.clear();
            for(int i = 1; i <= tListRoomType.length; i++) {
              if(tListRoomType[i-1].selected) {
                tSubList.add(i.toString());
              }
            }
            if(tSubList.length == 0) {//아무것도 선택 안한 경우
              tFilterList[0].flag = false;
              tFilterList[0].title = "방 종류";
              tFilterList[0].selected = false;
            }else {
              for(int i =0; i < tListRoomType.length; i++){
                if(tListRoomType[i].flag) {
                  tFilterList[0].title += tListRoomType[i].title + "/";
                }
              }
              String s = tFilterList[0].title;
              int l = tFilterList[0].title.length;
              tFilterList[0].title = s.substring(0,l-1);

              tFilterList[0].selected = true;
              tFilterList[0].flag = true;
              tCloseFilter();
            }

            String contractType;

            if(!tListContractType[0].selected && !tListContractType[1].selected) {
              if(tDepositLowRange == 0 && tDepositHighRange == 10100000 && tMonthlyFeeLowRange == 0 && tMonthlyFeeHighRange == 1010000) {
                tFilterList[1].flag = false;
                tFilterList[1].title = "가격";
                tFilterList[1].selected = false;
                contractType="";
              } else {
                tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                    extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                tFilterList[1].selected = true;
                tFilterList[1].flag = true;
              }

              Function okFunc = () async{
                Navigator.pop(context);

              };
            } else if(tListContractType[0].selected && !tListContractType[1].selected) {
              flagContractType = 1;
              contractType = "월세";

              tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                  extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
              tFilterList[1].selected = true;
              tFilterList[1].flag = true;
            } else {
              flagContractType = 2;
              contractType = "전세";

              tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                  extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
              tFilterList[1].selected = true;
              tFilterList[1].flag = true;
            }

            if(tFilterRentStart == "" || tFilterRentDone ==""){
              Function okFunc = () async{
                Navigator.pop(context);

              };
              tFilterList[2].flag = false;
              tFilterList[2].title = "임대 기간";
              tFilterList[2].selected = false;
              tCloseFilter();
            }else {
              tFilterList[2].title = tFilterRentStart + "-" + tFilterRentDone;
              tFilterList[2].selected = true;
              tFilterList[2].flag = true;
            }

            tFilterList[3].title = "";
            for(int i =0; i < tListOption.length; i++){
              if(tListOption[i].flag) {
                tFilterList[3].title += tListOption[i].title + "/";
              }
            }
            String s = tFilterList[3].title;
            int l = tFilterList[3].title.length;

            if(l==0) {//아무것도 선택 안한 경우
              tFilterList[3].flag = false;
              tFilterList[3].title = "추가 옵션";
              tFilterList[3].selected = false;
            }else {
              tFilterList[3].selected = true;
              tFilterList[3].title = s.substring(0,l-1);
              sCloseFilter();
            }



            int subFlag2 = -1;
            for(int i = 0; i < tListContractType.length; i++) {
              if(tListContractType[i].flag){
                subFlag2 = i+1;
                break;
              }
            }

            bool subFlag = true;
            for(int i = 0; i <tListOption.length; i++) {
              if(tListOption[i].selected) {
                subFlag = false;
                break;
              }
            }

            var list = await ApiProvider().post("/RoomSalesInfo/MarkerTransferFilter", jsonEncode(
                {
                  "types" : tSubList.length == 0 ? null : tSubList,
                  "jeonse": subFlag2 == -1 ? null : subFlag2,
                  "depositmin" : tDepositLowRange,
                  "depositmax" : tDepositHighRange == 10100000 ? 9999999999 : tDepositHighRange,
                  "monthlyfeemin" : tMonthlyFeeLowRange,
                  "monthlyfeemax" : tMonthlyFeeHighRange == 1010000 ? 9999999999 : tDepositHighRange,
                  "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                  "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                  "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                  "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                  "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                }
            ));

            if (list != false) {
              List<MapMarker> markers = [];

              if(null != list) {
                final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/testandroid.png');

                for(int i = 0; i < list.length; i++) {
                  Map<String, dynamic> data = list[i];
                  gCoordinate item = gCoordinate.fromJson(data);
                  var finalLat, finalLng;

                  if(null == item.lng || null == item.lat) {
                    var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                    var first = addresses.first;

                    finalLat = first.coordinates.latitude;
                    finalLng = first.coordinates.longitude;
                  } else {
                    finalLat = item.lat;
                    finalLng = item.lng;
                  }

                  setState(() {
                    markers.add(
                      MapMarker(
                          id: 'marker' + i.toString(),
                          position: LatLng(finalLat, finalLng),
                          icon: markerImage,
                          onMarkerTap: () async {
                            if(flagRoomList){
                              flagRoomList = !flagRoomList;
                              setState(() {

                              });
                            } else {
                              var list;
                              if(isShort){
                                list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                    {
                                      "longitude" : item.lng,
                                      "latitude" : item.lat,
                                    }
                                ));
                              }else {
                                list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                    {
                                      "longitude" : item.lng,
                                      "latitude" : item.lat,
                                    }
                                ));
                              }
                              selectedItemList.clear();
                              for(int i = 0; i < list.length; i++) {
                                var item = RoomSalesInfo.fromJson(list[i]);
                                selectedItemList.add(item);
                              }
                              flagRoomList = !flagRoomList;
                              setState(() {

                              });
                            }
                          }
                      ),
                    );
                  });
                }
              }

              _clusterManager = await MapHelper.initClusterManager(
                markers,
                _minClusterZoom,
                _maxClusterZoom,
              );

              await _updateMarkers();
            }
            else {
              Function okFunc = () async{
                Navigator.pop(context);

              };
              resetTransferAll();
              OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
            }
            tCloseFilter();


            setState(() {

            });
            // EasyLoading.dismiss();
          },
          child: Container(
            height: screenHeight*(60/640),
            width: screenWidth,
            color: kPrimaryColor,
            child: Center(
              child: Text(
                '적용하기',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*(16/360),
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ):
        GestureDetector(
          onTap: () async {
            //매물 리스트
            EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
            // var list = await ApiProvider().get('/RoomSalesInfo/SelectList');
            //
            // globalRoomSalesInfoList.clear();
            // if (list != null) {
            //   for (int i = 0; i < list.length; ++i) {
            //     globalRoomSalesInfoList.add(RoomSalesInfo.fromJson(list[i]));
            //   }
            // }
            //
            //
            // nbnbRoom.clear();
            // //내방니방직영
            // var tmp= await ApiProvider().get('/RoomSalesInfo/NbnbRooms');
            // if(null != tmp){
            //   for(int i = 0;i<tmp.length;i++){
            //     nbnbRoom.add(RoomSalesInfo.fromJson(tmp[i]));
            //   }
            // }

            navigationNumProvider.setNum(1,flagForNavigate: true);
            Navigator.push(
                context, // 기본 파라미터, SecondRoute로 전달
                MaterialPageRoute(
                    builder: (context) =>
                        MainPage()) // SecondRoute를 생성하여 적재
            );
            EasyLoading.dismiss();
          },
          child: Container(
            height: screenHeight*(60/640),
            width: screenWidth,
            color: kPrimaryColor,
            child: Center(
              child: Text(
                '모든 방 보기',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width*(16/360),
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sCloseFilter() {
    sCurFilter = -1;
  }

  void tCloseFilter() {
    tCurFilter = -1;
  }

  Container sReturnFilter(double screenWidth, double screenHeight) {
    return sCurFilter == -1 ? Container() :
    sCurFilter == 0 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "방 종류",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:sListRoomType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        sListRoomType[index].flag = !sListRoomType[index].flag;
                        sListRoomType[index].selected = !sListRoomType[index].selected;
                        sCurRoomType = index;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${sListRoomType[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: sListRoomType[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: sListRoomType[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: sFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    EasyLoading.show(
                        status: "",
                        maskType:
                        EasyLoadingMaskType
                            .black);


                    sSubList.clear();
                    for(int i = 1; i <= sListRoomType.length; i++) {
                      if(sListRoomType[i-1].selected) {
                        sSubList.add(i.toString());
                      }
                    }
                    if(sSubList.length == 0) {//아무것도 선택 안한 경우
                     sFilterList[0].flag = false;
                     sFilterList[0].title = "방 종류";
                     sFilterList[0].selected = false;
                    }else {
                      sFilterList[0].title = "";
                      for(int i =0; i < sListRoomType.length; i++){
                        if(sListRoomType[i].flag) {
                          sFilterList[0].title += sListRoomType[i].title + "/";
                        }
                      }
                      String s = sFilterList[0].title;
                      int l = sFilterList[0].title.length;
                      sFilterList[0].title = s.substring(0,l-1);

                      sFilterList[0].selected = true;
                      sCloseFilter();
                    }

                    bool subFlag = true;
                    for(int i = 0; i <sListOption.length; i++) {
                      if(sListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }
                    sFilterList[2].selected;
                    var list = await ApiProvider().post("/RoomSalesInfo/MarkerShortFilter", jsonEncode(
                        {
                          "types" : sSubList.length == 0 ? null : sSubList,
                          "feemin" : sPriceLowRange,
                          "feemax" : sPriceHighRange == 510000 ? 9999999999 : sPriceHighRange,
                          "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                          "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                          "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                        }
                    ));

                    if (list != false) {
                      List<MapMarker> markers = [];

                      if(null != list) {
                        final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/testandroid.png');

                        for(int i = 0; i < list.length; i++) {
                          Map<String, dynamic> data = list[i];
                          gCoordinate item = gCoordinate.fromJson(data);
                          var finalLat, finalLng;

                          if(null == item.lng || null == item.lat) {
                            var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                            var first = addresses.first;

                            finalLat = first.coordinates.latitude;
                            finalLng = first.coordinates.longitude;
                          } else {
                            finalLat = item.lat;
                            finalLng = item.lng;
                          }

                          setState(() {
                            markers.add(
                              MapMarker(
                                id: 'marker' + i.toString(),
                                position: LatLng(finalLat, finalLng),
                                icon: markerImage,
                                  onMarkerTap: () async {
                                    if(flagRoomList){
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    } else {
                                      var list;
                                      if(isShort){
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }else {
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }
                                      selectedItemList.clear();
                                      for(int i = 0; i < list.length; i++) {
                                        var item = RoomSalesInfo.fromJson(list[i]);
                                        selectedItemList.add(item);
                                      }
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    }
                                  }
                              ),
                            );
                          });
                        }
                      }

                      _clusterManager = await MapHelper.initClusterManager(
                        markers,
                        _minClusterZoom,
                        _maxClusterZoom,
                      );

                      await _updateMarkers();
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      sFilterList[0].flag = false;
                      sFilterList[0].title = "방 종류";
                      sFilterList[0].selected = false;

                      resetRoomType();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    sCloseFilter();


                    setState(() {

                    });
                    EasyLoading.dismiss();
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    sCurFilter == 1 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "가격 ",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                  ),
                ),
                Text(
                  "(일 단위)",
                  style:TextStyle(
                      fontSize: screenWidth*(13.5/360),
                      color:hexToColor('#888888')
                  ),
                ),
              ],
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "전체",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:kPrimaryColor
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  sInfinity,
                  style:TextStyle(
                      fontSize: screenWidth*(12/360),
                      color:kPrimaryColor
                  ),
                ),
                widthPadding(screenWidth,16),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * (336 / 360),
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                ),
                child: RangeSlider(
                  min: 0,
                  max: 510000,
                  divisions: 51,
                  inactiveColor: Color(0xffcccccc),
                  activeColor: kPrimaryColor,
                  labels: RangeLabels(sPriceLowRange.floor().toString(),
                      sPriceHighRange.floor().toString()),
                  values: sPriceValues,
                  //RangeValues(_lowValue,_highValue),
                  onChanged: (_range) {
                    setState(() {
                      if(_range.end.toInt() == 510000) {
                        sInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                      } else {
                        sInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                      }

                      sPriceValues = _range;
                      sPriceLowRange = _range.start;
                      sPriceHighRange = _range.end;

                    });
                  },
                ),
              ),
            ),
          ),
          heightPadding(screenHeight,8),
          Row(
            children: [
              widthPadding(screenWidth,14),
              Text(
                '최소',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '25만원',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '최대',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              widthPadding(screenWidth,14),
            ],
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: sFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {


                    if((sPriceLowRange == 0 && sPriceHighRange == 310000)) {
                      sFilterList[1].flag = false;
                      sFilterList[1].title = "가격";
                      sFilterList[1].selected = false;
                    }else {
                      sFilterList[1].title = "일 / " +  extractNum(sPriceLowRange).toInt().toString()+"만원-"+extractNum(sPriceHighRange).toInt().toString()+"만원";
                      sFilterList[1].selected = true;
                      sCloseFilter();
                    }



                    bool subFlag = true;
                    for(int i = 0; i <sListOption.length; i++) {
                      if(sListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }
                    var list = await ApiProvider().post("/RoomSalesInfo/MarkerShortFilter", jsonEncode(
                        {
                          "types" : sSubList.length == 0 ? null : sSubList,
                          "feemin" : sPriceLowRange,
                          "feemax" : sPriceHighRange == 510000 ? 9999999999 : sPriceHighRange,
                          "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                          "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                          "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                        }
                    ));

                    if (list != false) {
                      List<MapMarker> markers = [];

                      if(null != list) {
                        final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/testandroid.png');

                        for(int i = 0; i < list.length; i++) {
                          Map<String, dynamic> data = list[i];
                          gCoordinate item = gCoordinate.fromJson(data);
                          var finalLat, finalLng;

                          if(null == item.lng || null == item.lat) {
                            var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                            var first = addresses.first;

                            finalLat = first.coordinates.latitude;
                            finalLng = first.coordinates.longitude;
                          } else {
                            finalLat = item.lat;
                            finalLng = item.lng;
                          }

                          setState(() {
                            markers.add(
                              MapMarker(
                                id: 'marker' + i.toString(),
                                position: LatLng(finalLat, finalLng),
                                icon: markerImage,
                                  onMarkerTap: () async {
                                    if(flagRoomList){
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    } else {
                                      var list;
                                      if(isShort){
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }else {
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }
                                      selectedItemList.clear();
                                      for(int i = 0; i < list.length; i++) {
                                        var item = RoomSalesInfo.fromJson(list[i]);
                                        selectedItemList.add(item);
                                      }
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    }
                                  }
                              ),
                            );
                          });
                        }
                      }

                      _clusterManager = await MapHelper.initClusterManager(
                        markers,
                        _minClusterZoom,
                        _maxClusterZoom,
                      );

                      await _updateMarkers();
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetRoomPrice();

                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    sCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    sCurFilter == 2 ? Container(
      width: screenWidth,
      height: screenHeight*(167/640),
      color: Colors.white,
      child: Column(
        children: [
          heightPadding(screenHeight,22),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "임대 기간",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                  ),
                ),
              ],
            ),
          ),
          heightPadding(screenHeight,26),
          Container(
            width: screenWidth * (336 / 360),
            child: Row(
              children: [
                Spacer(),
                // SizedBox(width: screenWidth*(20/360),),
                GestureDetector(
                  onTap: (){
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                        maxTime: sFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(sFilterRentDone).year, DateFormat('y.MM.d').parse(sFilterRentDone).month,DateFormat('y.MM.d').parse(sFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          sFilterRentStart = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        sFilterRentStart == "" ? "입주" : sFilterRentStart,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: sFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (55 / 640),
                ),
                Text(
                  "~",
                  style: TextStyle(
                      fontSize: screenWidth * (20 / 360),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: screenWidth * (55 / 640),
                ),
                GestureDetector(
                  onTap: (){
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: sFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(sFilterRentStart).year, DateFormat('y.MM.d').parse(sFilterRentStart).month,DateFormat('y.MM.d').parse(sFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          sFilterRentDone = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        sFilterRentDone == "" ? "퇴실" : sFilterRentDone,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: sFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Row(
            children: [
              widthPadding(screenWidth,12),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              Expanded(child: SizedBox()),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              widthPadding(screenWidth,12),
            ],
          ),
          heightPadding(screenHeight,28),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: sFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if(sFilterRentStart == "" || sFilterRentDone ==""){
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      sFilterList[2].flag = false;
                      sFilterList[2].title = "임대 기간";
                      sFilterList[2].selected = false;
                      sCloseFilter();
                      OKDialog(context, "임대 기간을 입력해주세요!", "입주나 퇴실 기간을 선택해주세요", "확인",okFunc);
                    }else {
                      sFilterList[sCurFilter].title = sFilterRentStart + "-"+sFilterRentDone;
                      sFilterList[2].selected = true;

                      bool subFlag = true;
                      for(int i = 0; i <sListOption.length; i++) {
                        if(sListOption[i].selected) {
                          subFlag = false;
                          break;
                        }
                      }
                      sFilterList[2].selected;
                      var list = await ApiProvider().post("/RoomSalesInfo/MarkerShortFilter", jsonEncode(
                          {
                            "types" : sSubList.length == 0 ? null : sSubList,
                            "feemin" : sPriceLowRange,
                            "feemax" : sPriceHighRange == 510000 ? 9999999999 : sPriceHighRange,
                            "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                            "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                            "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                            "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                            "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                          }
                      ));

                      if (list != false) {
                        List<MapMarker> markers = [];

                        if(null != list) {
                          final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                              ImageConfiguration(devicePixelRatio: 50,
                                  size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                              'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                              ImageConfiguration(devicePixelRatio: 50,
                                  size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                              'assets/images/logo/testandroid.png');

                          for(int i = 0; i < list.length; i++) {
                            Map<String, dynamic> data = list[i];
                            gCoordinate item = gCoordinate.fromJson(data);
                            var finalLat, finalLng;

                            if(null == item.lng || null == item.lat) {
                              var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                              var first = addresses.first;

                              finalLat = first.coordinates.latitude;
                              finalLng = first.coordinates.longitude;
                            } else {
                              finalLat = item.lat;
                              finalLng = item.lng;
                            }

                            setState(() {
                              markers.add(
                                MapMarker(
                                  id: 'marker' + i.toString(),
                                  position: LatLng(finalLat, finalLng),
                                  icon: markerImage,
                                    onMarkerTap: () async {
                                      if(flagRoomList){
                                        flagRoomList = !flagRoomList;
                                        setState(() {

                                        });
                                      } else {
                                        var list;
                                        if(isShort){
                                          list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                              {
                                                "longitude" : item.lng,
                                                "latitude" : item.lat,
                                              }
                                          ));
                                        }else {
                                          list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                              {
                                                "longitude" : item.lng,
                                                "latitude" : item.lat,
                                              }
                                          ));
                                        }
                                        selectedItemList.clear();
                                        for(int i = 0; i < list.length; i++) {
                                          var item = RoomSalesInfo.fromJson(list[i]);
                                          selectedItemList.add(item);
                                        }
                                        flagRoomList = !flagRoomList;
                                        setState(() {

                                        });
                                      }
                                    }
                                ),
                              );
                            });
                          }
                        }

                        _clusterManager = await MapHelper.initClusterManager(
                          markers,
                          _minClusterZoom,
                          _maxClusterZoom,
                        );

                        await _updateMarkers();
                      }
                      else {
                        Function okFunc = () async{
                          Navigator.pop(context);

                        };
                        resetRoomRent();
                        OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                      }
                      sCloseFilter();
                    }

                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    sCurFilter == 3 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "추가 옵션",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:sListOption.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        sListOption[index].flag = !sListOption[index].flag;
                        sListOption[index].selected = !sListOption[index].selected;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${sListOption[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: sListOption[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: sListOption[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: sFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    sFilterList[3].title = "";
                    for(int i =0; i < sListOption.length; i++){
                      if(sListOption[i].flag) {
                        sFilterList[3].title += sListOption[i].title + "/";
                      }
                    }
                    String s = sFilterList[3].title;
                    int l = sFilterList[3].title.length;

                    if(l == 0) {//아무것도 선택 안한 경우
                      sFilterList[3].flag = false;
                      sFilterList[3].title = "추가 옵션";
                      sFilterList[3].selected = false;
                    }else {
                      sFilterList[3].title = s.substring(0,l-1);
                      sFilterList[3].selected = true;
                    }
                    sCloseFilter();

                    bool subFlag = true;
                    for(int i = 0; i <sListOption.length; i++) {
                      if(sListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }
                    sFilterList[2].selected;
                    var list = await ApiProvider().post("/RoomSalesInfo/MarkerShortFilter", jsonEncode(
                        {
                          "types" : sSubList.length == 0 ? null : sSubList,
                          "feemin" : sPriceLowRange,
                          "feemax" : sPriceHighRange == 510000 ? 9999999999 : sPriceHighRange,
                          "periodmin" : sFilterList[2].selected == false ? "1900.01.01" : sFilterRentStart,
                          "periodmax" : sFilterList[2].selected == false ? "2900.12.31" : sFilterRentDone,
                          "parking" : subFlag ? null : sListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  sListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  sListOption[2].selected ? 1 : 0,
                        }
                    ));

                    if (list != false) {
                      List<MapMarker> markers = [];

                      if(null != list) {
                        final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                    size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/testandroid.png');

                    for(int i = 0; i < list.length; i++) {
                    Map<String, dynamic> data = list[i];
                    gCoordinate item = gCoordinate.fromJson(data);
                    var finalLat, finalLng;

                    if(null == item.lng || null == item.lat) {
                    var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                    var first = addresses.first;

                    finalLat = first.coordinates.latitude;
                    finalLng = first.coordinates.longitude;
                    } else {
                    finalLat = item.lat;
                    finalLng = item.lng;
                    }

                    setState(() {
                    markers.add(
                    MapMarker(
                    id: 'marker' + i.toString(),
                    position: LatLng(finalLat, finalLng),
                    icon: markerImage,
                        onMarkerTap: () async {
                          if(flagRoomList){
                            flagRoomList = !flagRoomList;
                            setState(() {

                            });
                          } else {
                            var list;
                            if(isShort){
                              list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                  {
                                    "longitude" : item.lng,
                                    "latitude" : item.lat,
                                  }
                              ));
                            }else {
                              list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                  {
                                    "longitude" : item.lng,
                                    "latitude" : item.lat,
                                  }
                              ));
                            }
                            selectedItemList.clear();
                            for(int i = 0; i < list.length; i++) {
                              var item = RoomSalesInfo.fromJson(list[i]);
                              selectedItemList.add(item);
                            }
                            flagRoomList = !flagRoomList;
                            setState(() {

                            });
                          }
                        }
                    ),
                    );
                    });
                    }
                    }

                    _clusterManager = await MapHelper.initClusterManager(
                    markers,
                    _minClusterZoom,
                    _maxClusterZoom,
                    );

                    await _updateMarkers();
                    }
                    else {
                    Function okFunc = () async{
                    Navigator.pop(context);

                    };
                    resetRoomOption();
                    OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    sCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) : Container();
  }
  void resetTransferAll() {
    resetTransferType();
    resetTransferRent();
    resetTransferPrice();
    resetTransferOption();
  }

  void resetRoomAll() {
    resetRoomType();
    resetRoomPrice();
    resetRoomRent();
    resetRoomOption();
  }

  void resetTransferOption() {
    tFilterList[3].flag = false;
    tFilterList[3].title = "추가 옵션";
    tFilterList[3].selected = false;
    for(int i = 0; i < tListOption.length; i++) {
      tListOption[i].flag = false;
      tListOption[i].selected = false;
    }
  }

  void resetTransferRent() {
    tFilterList[2].flag = false;
    tFilterList[2].title = "임대 기간";
    tFilterList[2].selected = false;
    tFilterRentStart = "";
    tFilterRentDone = "";
  }

  void resetTransferPrice() {
    tFilterList[1].flag = false;
    tFilterList[1].title = "가격";
    tFilterList[1].selected = false;

    tCurContractType = -1;
    for(int i = 0; i < tListContractType.length; i++) {
      tListContractType[i].flag  = false;
      tListContractType[i].selected  = false;
    }

    tDepositLowRange = 0;
    tDepositHighRange = 301000000;
    tDepositValues = RangeValues(0, 301000000);

    tMonthlyFeeLowRange = 0;
    tMonthlyFeeHighRange = 5010000;
    tMonthlyFeeValues = RangeValues(0, 5010000);

  }

  void resetTransferType() {
    tFilterList[0].flag = false;
    tFilterList[0].title = "방 종류";
    tFilterList[0].selected = false;

    for(int i = 0; i < tListRoomType.length; i++){
      tListRoomType[i].flag = false;
      tListRoomType[i].selected = false;
    }
    tCurRoomType = -1;

  }

  void resetRoomOption() {
    sFilterList[3].flag = false;
    sFilterList[3].title = "추가 옵션";
    sFilterList[3].selected = false;
    for(int i = 0; i < sListOption.length; i++) {
      sListOption[i].flag = false;
      sListOption[i].selected = false;
    }
  }

  void resetRoomRent() {
    sFilterList[2].flag = false;
    sFilterList[2].title = "임대 기간";
    sFilterList[2].selected = false;
    sFilterRentStart = "";
    sFilterRentDone = "";
  }

  void resetRoomPrice() {
    sFilterList[1].flag = false;
    sFilterList[1].title = "가격";
    sFilterList[1].selected = false;
    sPriceLowRange = 0;
    sPriceHighRange = 0;
  }

  void resetRoomType() {
    sFilterList[0].flag = false;
    sFilterList[0].title = "방 종류";
    sFilterList[0].selected = false;

    for(int i = 0; i < sListRoomType.length; i++){
      sListRoomType[i].flag = false;
      sListRoomType[i].selected = false;
    }
    sCurRoomType = -1;
  }

  Container tReturnFilter(double screenWidth, double screenHeight) {
    return tCurFilter == -1 ? Container() :
    tCurFilter == 0 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "방 종류",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:tListRoomType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        tListRoomType[index].flag = !tListRoomType[index].flag;
                        tListRoomType[index].selected = !tListRoomType[index].selected;
                        tCurRoomType = index;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${tListRoomType[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: tListRoomType[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: tListRoomType[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: tFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    tSubList.clear();
                    for(int i = 1; i <= tListRoomType.length; i++) {
                      if(tListRoomType[i-1].selected) {
                        tSubList.add(i.toString());
                      }
                    }
                    if(tSubList.length == 0) {//아무것도 선택 안한 경우
                      tFilterList[0].flag = false;
                      tFilterList[0].title = "방 종류";
                      tFilterList[0].selected = false;
                    }else {
                      tFilterList[0].title = "";
                      for(int i =0; i < tListRoomType.length; i++){
                        if(tListRoomType[i].flag) {
                          tFilterList[0].title += tListRoomType[i].title + "/";
                        }
                      }
                      String s = tFilterList[0].title;
                      int l = tFilterList[0].title.length;
                      tFilterList[0].title = s.substring(0,l-1);

                      tFilterList[0].selected = true;
                      tCloseFilter();
                    }

                    int subFlag2 = -1;
                    for(int i = 0; i < tListContractType.length; i++) {
                      if(tListContractType[i].flag){
                        subFlag2 = i+1;
                        break;
                      }
                    }

                    bool subFlag = true;
                    for(int i = 0; i <tListOption.length; i++) {
                      if(tListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    var list = await ApiProvider().post("/RoomSalesInfo/MarkerTransferFilter", jsonEncode(
                        {
                          "types" : tSubList.length == 0 ? null : tSubList,
                          "jeonse": subFlag2 == -1 ? null : subFlag2,
                          "depositmin" : tDepositLowRange,
                          "depositmax" : tDepositHighRange == 10100000 ? 9999999999 : tDepositHighRange,
                          "monthlyfeemin" : tMonthlyFeeLowRange,
                          "monthlyfeemax" : tMonthlyFeeHighRange == 1010000 ? 9999999999 : tDepositHighRange,
                          "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                          "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                          "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                        }
                    ));

                    if (list != false) {
                      List<MapMarker> markers = [];

                      if(null != list) {
                        final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/testandroid.png');

                        for(int i = 0; i < list.length; i++) {
                          Map<String, dynamic> data = list[i];
                          gCoordinate item = gCoordinate.fromJson(data);
                          var finalLat, finalLng;

                          if(null == item.lng || null == item.lat) {
                            var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                            var first = addresses.first;

                            finalLat = first.coordinates.latitude;
                            finalLng = first.coordinates.longitude;
                          } else {
                            finalLat = item.lat;
                            finalLng = item.lng;
                          }

                          setState(() {
                            markers.add(
                              MapMarker(
                                  id: 'marker' + i.toString(),
                                  position: LatLng(finalLat, finalLng),
                                  icon: markerImage,
                                  onMarkerTap: () async {
                                    if(flagRoomList){
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    } else {
                                      var list;
                                      if(isShort){
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }else {
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }
                                      selectedItemList.clear();
                                      for(int i = 0; i < list.length; i++) {
                                        var item = RoomSalesInfo.fromJson(list[i]);
                                        selectedItemList.add(item);
                                      }
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    }
                                  }
                              ),
                            );
                          });
                        }
                      }

                      _clusterManager = await MapHelper.initClusterManager(
                        markers,
                        _minClusterZoom,
                        _maxClusterZoom,
                      );

                      await _updateMarkers();
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetTransferType();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    tCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    tCurFilter == 1 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "거래유형",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:tListContractType.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        tListContractType[index].flag = !tListContractType[index].flag;
                        tListContractType[index].selected = !tListContractType[index].selected;
                        tCurContractType = index;

                        for(int i = 0; i < tListContractType.length; i++){
                          if(i != index) {
                            tListContractType[i].flag = false;
                            tListContractType[i].selected = false;
                          }
                        }

                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        width: screenWidth*(47/360),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${tListContractType[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: tListContractType[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: tListContractType[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "보증금",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:kPrimaryColor
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  tDepositInfinity,
                  style:TextStyle(
                      fontSize: screenWidth*(12/360),
                      color:kPrimaryColor
                  ),
                ),
                widthPadding(screenWidth,16),
              ],
            ),
          ),
          Center(
            child: Container(
              width: screenWidth * (336 / 360),
              child: SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                ),
                child: RangeSlider(
                  min: 0,
                  max: 301000000,
                  divisions: 101,
                  inactiveColor: Color(0xffcccccc),
                  activeColor: kPrimaryColor,
                  labels: RangeLabels(tDepositLowRange.floor().toString(),
                      tDepositHighRange.floor().toString()),
                  values: tDepositValues,
                  //RangeValues(_lowValue,_highValue),
                  onChanged: (_range) {
                    setState(() {
                      if(_range.end.toInt() == 301000000) {
                        tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                      } else {
                        tDepositInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                      }

                      tDepositValues = _range;
                      tDepositLowRange = _range.start;
                      tDepositHighRange = _range.end;
                    });
                  },
                ),
              ),
            ),
          ),
          Container(
            height: screenHeight*(8/640),
            width: 1,
            color: hexToColor('#888888'),
          ),
          Row(
            children: [
              widthPadding(screenWidth,14),
              Text(
                '최소',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '1억 5천만원',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              Spacer(),
              Text(
                '최대',
                style: TextStyle(
                    fontSize: screenWidth*(10/360),
                    color: hexToColor('#888888')
                ),
              ),
              widthPadding(screenWidth,14),
            ],
          ),
          tListContractType[1].selected ? SizedBox() : Column(
            children: [
              heightPadding(screenHeight,20),
              Padding(
                padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                child: Row(
                  children: [
                    Text(
                      "월세",
                      style:TextStyle(
                          fontSize: screenWidth*(14/360),
                          fontWeight: FontWeight.bold,
                          color:kPrimaryColor
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      tMonthlyInfinity,
                      style:TextStyle(
                          fontSize: screenWidth*(12/360),
                          color:kPrimaryColor
                      ),
                    ),
                    widthPadding(screenWidth,16),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: screenWidth * (336 / 360),
                  child: SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.white,
                    ),
                    child: RangeSlider(
                      min: 0,
                      max: 5010000,
                      divisions: 101,
                      inactiveColor: Color(0xffcccccc),
                      activeColor: kPrimaryColor,
                      labels: RangeLabels(tMonthlyFeeLowRange.floor().toString(),
                          tMonthlyFeeHighRange.floor().toString()),
                      values: tMonthlyFeeValues,
                      //RangeValues(_lowValue,_highValue),
                      onChanged: (_range) {
                        setState(() {
                          if(_range.end.toInt() == 5010000) {
                            tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-무제한";
                          } else {
                            tMonthlyInfinity = extractNum(_range.start).toInt().toString() + "만원-" + extractNum(_range.end).toInt().toString() + "만원";
                          }

                          tMonthlyFeeValues = _range;
                          tMonthlyFeeLowRange = _range.start;
                          tMonthlyFeeHighRange = _range.end;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: screenHeight*(8/640),
                width: 1,
                color: hexToColor('#888888'),
              ),
              Row(
                children: [
                  widthPadding(screenWidth,14),
                  Text(
                    '최소',
                    style: TextStyle(
                        fontSize: screenWidth*(10/360),
                        color: hexToColor('#888888')
                    ),
                  ),
                  Spacer(),
                  Text(
                    '250만원',
                    style: TextStyle(
                        fontSize: screenWidth*(10/360),
                        color: hexToColor('#888888')
                    ),
                  ),
                  Spacer(),
                  Text(
                    '최대',
                    style: TextStyle(
                        fontSize: screenWidth*(10/360),
                        color: hexToColor('#888888')
                    ),
                  ),
                  widthPadding(screenWidth,14),
                ],
              ),
            ],
          ),
          heightPadding(screenHeight,18),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(child: tFilterCancelWidget(screenHeight, screenWidth)),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    String contractType;

                    if(!tListContractType[0].selected && !tListContractType[1].selected) {
                      if(tDepositLowRange == 0 && tDepositHighRange == 301000000 && tMonthlyFeeLowRange == 0 && tMonthlyFeeHighRange == 5010000) {
                        tFilterList[1].flag = false;
                        tFilterList[1].title = "가격";
                        tFilterList[1].selected = false;
                        contractType="";
                      } else {
                        tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                            extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                        tFilterList[1].selected = true;
                        tFilterList[1].flag = true;
                      }

                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                    } else if(tListContractType[0].selected && !tListContractType[1].selected) {
                      flagContractType = 1;
                      contractType = "월세";

                      tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                          extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                      tFilterList[1].selected = true;
                      tFilterList[1].flag = true;
                    } else {
                      flagContractType = 2;
                      contractType = "전세";

                      tFilterList[1].title = contractType + " / " + "보 " + extractNum(tDepositLowRange).toInt().toString()+"-"+extractNum(tDepositHighRange).toInt().toString()+"만원,월 "+
                          extractNum(tMonthlyFeeLowRange).toInt().toString()+"-"+extractNum(tMonthlyFeeHighRange).toInt().toString()+"만원";
                      tFilterList[1].selected = true;
                      tFilterList[1].flag = true;
                   }

                    int subFlag2 = -1;
                    for(int i = 0; i < tListContractType.length; i++) {
                      if(tListContractType[i].flag){
                        subFlag2 = i+1;
                        break;
                      }
                    }

                    bool subFlag = true;
                    for(int i = 0; i <tListOption.length; i++) {
                      if(tListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    var list = await ApiProvider().post("/RoomSalesInfo/MarkerTransferFilter", jsonEncode(
                        {
                          "types" : tSubList.length == 0 ? null : tSubList,
                          "jeonse": subFlag2 == -1 ? null : subFlag2,
                          "depositmin" : tDepositLowRange,
                          "depositmax" : tDepositHighRange == 301000000 ? 9999999999 : tDepositHighRange,
                          "monthlyfeemin" : tMonthlyFeeLowRange,
                          "monthlyfeemax" : tMonthlyFeeHighRange == 5010000 ? 9999999999 : tDepositHighRange,
                          "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                          "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                          "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                        }
                    ));

                    if (list != false) {
                      List<MapMarker> markers = [];

                      if(null != list) {
                        final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/testandroid.png');

                        for(int i = 0; i < list.length; i++) {
                          Map<String, dynamic> data = list[i];
                          gCoordinate item = gCoordinate.fromJson(data);
                          var finalLat, finalLng;

                          if(null == item.lng || null == item.lat) {
                            var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                            var first = addresses.first;

                            finalLat = first.coordinates.latitude;
                            finalLng = first.coordinates.longitude;
                          } else {
                            finalLat = item.lat;
                            finalLng = item.lng;
                          }

                          setState(() {
                            markers.add(
                              MapMarker(
                                  id: 'marker' + i.toString(),
                                  position: LatLng(finalLat, finalLng),
                                  icon: markerImage,
                                  onMarkerTap: () async {
                                    if(flagRoomList){
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    } else {
                                      var list;
                                      if(isShort){
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }else {
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }
                                      selectedItemList.clear();
                                      for(int i = 0; i < list.length; i++) {
                                        var item = RoomSalesInfo.fromJson(list[i]);
                                        selectedItemList.add(item);
                                      }
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    }
                                  }
                              ),
                            );
                          });
                        }
                      }

                      _clusterManager = await MapHelper.initClusterManager(
                        markers,
                        _minClusterZoom,
                        _maxClusterZoom,
                      );

                      await _updateMarkers();
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetTransferPrice();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    tCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    tCurFilter == 2 ? Container(
      width: screenWidth,
      height: screenHeight*(167/640),
      color: Colors.white,
      child: Column(
        children: [
          heightPadding(screenHeight,22),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Row(
              children: [
                Text(
                  "임대 기간",
                  style:TextStyle(
                      fontSize: screenWidth*(14/360),
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                  ),
                ),
              ],
            ),
          ),
          heightPadding(screenHeight,26),
          Container(
            width: screenWidth * (336 / 360),
            child: Row(
              children: [
                Spacer(),
                // SizedBox(width: screenWidth*(20/360),),
                GestureDetector(
                  onTap: (){
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                        maxTime: tFilterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(tFilterRentDone).year, DateFormat('y.MM.d').parse(tFilterRentDone).month,DateFormat('y.MM.d').parse(tFilterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          tFilterRentStart = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        tFilterRentStart == "" ? "입주" : tFilterRentStart,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: tFilterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * (55 / 640),
                ),
                Text(
                  "~",
                  style: TextStyle(
                      fontSize: screenWidth * (20 / 360),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: screenWidth * (55 / 640),
                ),
                GestureDetector(
                  onTap: (){
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: tFilterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(tFilterRentStart).year, DateFormat('y.MM.d').parse(tFilterRentStart).month,DateFormat('y.MM.d').parse(tFilterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                        maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                        theme: DatePickerTheme(
                            headerColor: Colors.white,
                            backgroundColor: Colors.white,
                            itemStyle: TextStyle(
                                color: Colors.black, fontSize: 18),
                            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                          tFilterRentDone = DateFormat('y.MM.d').format(date);
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                  child: Container(
                    width: screenWidth * (120 / 360),
                    child: Center(
                      child: Text(
                        tFilterRentDone == "" ? "퇴실" : tFilterRentDone,
                        style: TextStyle(
                          fontSize: screenWidth * (14 / 360),
                          fontWeight: FontWeight.bold,
                          color: tFilterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Row(
            children: [
              widthPadding(screenWidth,12),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              Expanded(child: SizedBox()),
              Container(
                width: screenWidth*(148/360),
                height: 1,
                color: hexToColor('#CCCCCC'),
              ),
              widthPadding(screenWidth,12),
            ],
          ),
          heightPadding(screenHeight,28),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: tFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if(tFilterRentStart == "" || tFilterRentDone ==""){
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      tFilterList[2].flag = false;
                      tFilterList[2].title = "임대 기간";
                      tFilterList[2].selected = false;
                      tCloseFilter();
                      OKDialog(context, "임대 기간을 입력해주세요!", "입주나 퇴실 기간을 선택해주세요", "확인",okFunc);
                    }else {
                      tFilterList[2].title = tFilterRentStart + "-"+tFilterRentDone;
                      tFilterList[2].selected = true;

                      int subFlag2 = -1;
                      for(int i = 0; i < tListContractType.length; i++) {
                        if(tListContractType[i].flag){
                          subFlag2 = i+1;
                          break;
                        }
                      }

                      bool subFlag = true;
                      for(int i = 0; i <tListOption.length; i++) {
                        if(tListOption[i].selected) {
                          subFlag = false;
                          break;
                        }
                      }

                      var list = await ApiProvider().post("/RoomSalesInfo/MarkerTransferFilter", jsonEncode(
                          {
                            "types" : tSubList.length == 0 ? null : tSubList,
                            "jeonse": subFlag2 == -1 ? null : subFlag2,
                            "depositmin" : tDepositLowRange,
                            "depositmax" : tDepositHighRange == 301000000 ? 9999999999 : tDepositHighRange,
                            "monthlyfeemin" : tMonthlyFeeLowRange,
                            "monthlyfeemax" : tMonthlyFeeHighRange == 5010000 ? 9999999999 : tDepositHighRange,
                            "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                            "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                            "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                            "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                            "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                          }
                      ));

                      if (list != false) {
                        List<MapMarker> markers = [];

                        if(null != list) {
                          final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                              ImageConfiguration(devicePixelRatio: 50,
                                  size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                              'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                              ImageConfiguration(devicePixelRatio: 50,
                                  size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                              'assets/images/logo/testandroid.png');

                          for(int i = 0; i < list.length; i++) {
                            Map<String, dynamic> data = list[i];
                            gCoordinate item = gCoordinate.fromJson(data);
                            var finalLat, finalLng;

                            if(null == item.lng || null == item.lat) {
                              var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                              var first = addresses.first;

                              finalLat = first.coordinates.latitude;
                              finalLng = first.coordinates.longitude;
                            } else {
                              finalLat = item.lat;
                              finalLng = item.lng;
                            }

                            setState(() {
                              markers.add(
                                MapMarker(
                                    id: 'marker' + i.toString(),
                                    position: LatLng(finalLat, finalLng),
                                    icon: markerImage,
                                    onMarkerTap: () async {
                                      if(flagRoomList){
                                        flagRoomList = !flagRoomList;
                                        setState(() {

                                        });
                                      } else {
                                        var list;
                                        if(isShort){
                                          list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                              {
                                                "longitude" : item.lng,
                                                "latitude" : item.lat,
                                              }
                                          ));
                                        }else {
                                          list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                              {
                                                "longitude" : item.lng,
                                                "latitude" : item.lat,
                                              }
                                          ));
                                        }
                                        selectedItemList.clear();
                                        for(int i = 0; i < list.length; i++) {
                                          var item = RoomSalesInfo.fromJson(list[i]);
                                          selectedItemList.add(item);
                                        }
                                        flagRoomList = !flagRoomList;
                                        setState(() {

                                        });
                                      }
                                    }
                                ),
                              );
                            });
                          }
                        }

                        _clusterManager = await MapHelper.initClusterManager(
                          markers,
                          _minClusterZoom,
                          _maxClusterZoom,
                        );

                        await _updateMarkers();
                      }
                      else {
                        Function okFunc = () async{
                          Navigator.pop(context);

                        };
                        resetTransferRent();
                        OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                      }
                      tCloseFilter();

                    }

                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) :
    tCurFilter == 3 ? Container(
      width: screenWidth,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightPadding(screenHeight,14),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Text(
              "추가 옵션",
              style:TextStyle(
                  fontSize: screenWidth*(14/360),
                  fontWeight: FontWeight.bold,
                  color:Colors.black
              ),
            ),
          ),
          heightPadding(screenHeight,12),
          Padding(
            padding:  EdgeInsets.only(left: screenWidth*(12/360)),
            child: Container(
              height: screenHeight * (34/640),
              child: ListView.separated(
                // controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                  itemCount:tListOption.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        tListOption[index].flag = !tListOption[index].flag;
                        tListOption[index].selected = !tListOption[index].selected;
                        setState(() {

                        });
                      },
                      child: Container(
                        height: screenHeight * 0.05,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                          child: Center(
                            child: Text(
                              '${tListOption[index].title}',
                              style: TextStyle(
                                fontSize: screenWidth*SearchCaseFontSize,
                                color: tListOption[index].flag ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: tListOption[index].flag ? kPrimaryColor : Colors.white,
                          borderRadius: new BorderRadius.circular(4.0),
                          boxShadow: [
                            new BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(1.5, 1.5),
                            ),
                          ],

                        ),
                      ),
                    );
                  }),
            ),
          ),
          heightPadding(screenHeight,16),
          Container(height: 1,color:hexToColor('#EEEEEE'),),
          Row(
            children: [
              Expanded(
                child: tFilterCancelWidget(screenHeight, screenWidth),
              ),
              Container(
                width: 1,
                height: screenHeight*(40/640),
                color: hexToColor('#EEEEEE'),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    tFilterList[3].title = "";
                    for(int i =0; i < tListOption.length; i++){
                      if(tListOption[i].flag) {
                        tFilterList[3].title += tListOption[i].title + "/";
                      }
                    }
                    String s = tFilterList[3].title;
                    int l = tFilterList[3].title.length;

                    if(l==0) {//아무것도 선택 안한 경우
                      tFilterList[3].flag = false;
                      tFilterList[3].title = "추가 옵션";
                      tFilterList[3].selected = false;
                    }else {
                      tFilterList[3].selected = true;
                      tFilterList[3].title = s.substring(0,l-1);
                      sCloseFilter();
                    }

                    int subFlag2 = -1;
                    for(int i = 0; i < tListContractType.length; i++) {
                      if(tListContractType[i].flag){
                        subFlag2 = i+1;
                        break;
                      }
                    }

                    bool subFlag = true;
                    for(int i = 0; i <tListOption.length; i++) {
                      if(tListOption[i].selected) {
                        subFlag = false;
                        break;
                      }
                    }

                    var list = await ApiProvider().post("/RoomSalesInfo/MarkerTransferFilter", jsonEncode(
                        {
                          "types" : tSubList.length == 0 ? null : tSubList,
                          "jeonse": subFlag2 == -1 ? null : subFlag2,
                          "depositmin" : tDepositLowRange,
                          "depositmax" : tDepositHighRange == 10100000 ? 9999999999 : tDepositHighRange,
                          "monthlyfeemin" : tMonthlyFeeLowRange,
                          "monthlyfeemax" : tMonthlyFeeHighRange == 1010000 ? 9999999999 : tDepositHighRange,
                          "periodmin" : tFilterList[2].selected == false ? "1900.01.01" : tFilterRentStart,
                          "periodmax" : tFilterList[2].selected == false ? "2900.12.31" : tFilterRentDone,
                          "parking" : subFlag ? null : tListOption[0].selected ? 1 : 0,
                          "cctv" : subFlag ? null :  tListOption[1].selected ? 1 : 0,
                          "wifi" : subFlag ? null :  tListOption[2].selected ? 1 : 0,
                        }
                    ));

                    if (list != false) {
                      List<MapMarker> markers = [];

                      if(null != list) {
                        final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                            ImageConfiguration(devicePixelRatio: 50,
                                size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                            'assets/images/logo/testandroid.png');

                        for(int i = 0; i < list.length; i++) {
                          Map<String, dynamic> data = list[i];
                          gCoordinate item = gCoordinate.fromJson(data);
                          var finalLat, finalLng;

                          if(null == item.lng || null == item.lat) {
                            var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(item.loc);
                            var first = addresses.first;

                            finalLat = first.coordinates.latitude;
                            finalLng = first.coordinates.longitude;
                          } else {
                            finalLat = item.lat;
                            finalLng = item.lng;
                          }

                          setState(() {
                            markers.add(
                              MapMarker(
                                  id: 'marker' + i.toString(),
                                  position: LatLng(finalLat, finalLng),
                                  icon: markerImage,
                                  onMarkerTap: () async {
                                    if(flagRoomList){
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    } else {
                                      var list;
                                      if(isShort){
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectShortMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }else {
                                        list = await ApiProvider().post('/RoomSalesInfo/SelectTransferMarker', jsonEncode(
                                            {
                                              "longitude" : item.lng,
                                              "latitude" : item.lat,
                                            }
                                        ));
                                      }
                                      selectedItemList.clear();
                                      for(int i = 0; i < list.length; i++) {
                                        var item = RoomSalesInfo.fromJson(list[i]);
                                        selectedItemList.add(item);
                                      }
                                      flagRoomList = !flagRoomList;
                                      setState(() {

                                      });
                                    }
                                  }
                              ),
                            );
                          });
                        }
                      }

                      _clusterManager = await MapHelper.initClusterManager(
                        markers,
                        _minClusterZoom,
                        _maxClusterZoom,
                      );

                      await _updateMarkers();
                    }
                    else {
                      Function okFunc = () async{
                        Navigator.pop(context);

                      };
                      resetTransferOption();
                      OKDialog(context, "조건에 맞는 방이 없어요!", "새로운 조건으로 다시 입력해주세요!", "확인",okFunc);
                    }
                    tCloseFilter();


                    setState(() {

                    });
                  },
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ) : Container();
  }

  InkWell sFilterCancelWidget(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: (){
        sCloseFilter();
        for(int i =0; i < sFilterList.length; i++) {
          if(sFilterList[i].selected)
            continue;
          else
            sFilterList[i].flag = false;
        }
        setState(() {

        });
      },
      child: Container(
        height: screenHeight*(40/640),
        child: Center(
          child: Text(
            '취소하기',
            style: TextStyle(
                fontSize: screenWidth*(12/360),
                fontWeight: FontWeight.bold,
                color: hexToColor('#CCCCCC')
            ),
          ),
        ),
      ),
    );
  }
  InkWell tFilterCancelWidget(double screenHeight, double screenWidth) {
    return InkWell(
      onTap: (){
        tCloseFilter();
        for(int i =0; i < tFilterList.length; i++) {
          if(tFilterList[i].selected)
            continue;
          else
            tFilterList[i].flag = false;
        }
        setState(() {

        });
      },
      child: Container(
        height: screenHeight*(40/640),
        child: Center(
          child: Text(
            '취소하기',
            style: TextStyle(
                fontSize: screenWidth*(12/360),
                fontWeight: FontWeight.bold,
                color: hexToColor('#CCCCCC')
            ),
          ),
        ),
      ),
    );
  }

  Container returnShortTermFilter(double screenWidth, double screenHeight) {
    if(sCurRoomType == -1)
      return Container();
    else if(sCurRoomType == 0) {
      return Container(
        width: screenWidth,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightPadding(screenHeight,14),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*(12/360)),
              child: Text(
                "방 종류",
                style:TextStyle(
                    fontSize: screenWidth*(14/360),
                    fontWeight: FontWeight.bold,
                    color:Colors.black
                ),
              ),
            ),
            heightPadding(screenHeight,12),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*(12/360)),
              child: Container(
                height: screenHeight * (34/640),
                child: ListView.separated(
                  // controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                    itemCount:sListRoomType.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          sListRoomType[index].flag = !sListRoomType[index].flag;
                          sCurRoomType = index;
                          cChangeOthersFilterFlag(sListRoomType[index].title,false,1);//선택된 필터말고 나머지는 다 끔
                          setState(() {

                          });
                        },
                        child: Container(
                          height: screenHeight * 0.05,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                            child: Center(
                              child: Text(
                                '${sListRoomType[index].title}',
                                style: TextStyle(
                                  fontSize: screenWidth*SearchCaseFontSize,
                                  color: sListRoomType[index].flag ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: sListRoomType[index].flag ? kPrimaryColor : Colors.white,
                            borderRadius: new BorderRadius.circular(4.0),

                          ),
                        ),
                      );
                    }),
              ),
            ),
            heightPadding(screenHeight,16),
            Container(height: 1,color:hexToColor('#EEEEEE'),),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '취소하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: hexToColor('#CCCCCC')
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: screenHeight*(40/640),
                  color: hexToColor('#EEEEEE'),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  void cChangeOthersFilterFlag(String title,bool flag,int type) {
    if(type == 0) {//필터 카테고리 변형시
      for(int i = 0; i < sFilterList.length; i++) {
        if(sFilterList[i].title == title)
          continue;
        if(sFilterList[i].selected=true)
          continue;

        sFilterList[i].flag = flag;
      }
    }
    if(type==1){//방종류
      for(int i = 0; i < sListRoomType.length; i++) {
        if(sListRoomType[i].title == title)
          continue;

        sListRoomType[i].flag = flag;
      }
    }
  }

  void tChangeOthersFilterFlag(String title,bool flag,int type) {
    if(type == 0) {//필터 카테고리 변형시

    }
  }



  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14.0,
      ),
    ));
  }

}

class sAllFilter extends StatefulWidget {
  @override
  _sAllFilterState createState() => _sAllFilterState();
}

class _sAllFilterState extends State<sAllFilter> {
  List<FilterType> filterList = [new FilterType("방 종류"), new FilterType("가격"),new FilterType("임대 기간"),new FilterType("추가 옵션")];
  int curFilterList = -1;

  //방 종류
  List<FilterType> listRoomType = [new FilterType("원룸"), new FilterType("투룸 이상"),new FilterType("오피스텔"),new FilterType("아파트")];
  int curlistRoomType = -1;
  bool isShort = true;

  //가격
  double priceLowRange = 0;
  double priceHighRange = 30000;
  RangeValues priceValues = RangeValues(0, 30000);

  //임대 기간
  String filterRentStart = "";
  String filterRentDone = "";

  //추가옵션
  List<FilterType> listOption = [new FilterType("주차 가능"), new FilterType("현관 CCTV"),new FilterType("와이파이")];
  int curlistOption = -1;

  var subList = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: Text(
          "전체 필터",
          style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth*(18/360),
              fontWeight: FontWeight.bold
          ),
        ),
        actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightPadding(screenHeight,14),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Text(
                      "방 종류",
                      style:TextStyle(
                          fontSize: screenWidth*(14/360),
                          fontWeight: FontWeight.bold,
                          color:Colors.black
                      ),
                    ),
                  ),
                  heightPadding(screenHeight,12),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Container(
                      height: screenHeight * (34/640),
                      child: ListView.separated(
                        // controller: _scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                          itemCount:listRoomType.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                listRoomType[index].flag = !listRoomType[index].flag;
                                curlistRoomType = index;
                                changeOthersFilterFlag(listRoomType[index].title,false,1);//선택된 필터말고 나머지는 다 끔
                                setState(() {

                                });
                              },
                              child: Container(
                                height: screenHeight * 0.05,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                  child: Center(
                                    child: Text(
                                      '${listRoomType[index].title}',
                                      style: TextStyle(
                                        fontSize: screenWidth*SearchCaseFontSize,
                                        color: listRoomType[index].flag ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: listRoomType[index].flag ? kPrimaryColor : Colors.white,
                                  borderRadius: new BorderRadius.circular(4.0),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],

                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  heightPadding(screenHeight,32),
                ],
              ),
            ),
            Container(
              height: screenHeight*(4/640),
              color: hexToColor('#FFFFFF'),
            ),
            Container(
              width: screenWidth,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightPadding(screenHeight,14),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Row(
                      children: [
                        Text(
                          "가격 ",
                          style:TextStyle(
                              fontSize: screenWidth*(14/360),
                              fontWeight: FontWeight.bold,
                              color:Colors.black
                          ),
                        ),
                        Text(
                          "(일 단위)",
                          style:TextStyle(
                              fontSize: screenWidth*(13.5/360),
                              color:hexToColor('#888888')
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightPadding(screenHeight,12),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Text(
                      "전체",
                      style:TextStyle(
                          fontSize: screenWidth*(14/360),
                          fontWeight: FontWeight.bold,
                          color:kPrimaryColor
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: screenWidth * (336 / 360),
                      child: SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.white,
                        ),
                        child: RangeSlider(
                          min: 0,
                          max: 30000,
                          divisions: 30,
                          inactiveColor: Color(0xffcccccc),
                          activeColor: kPrimaryColor,
                          labels: RangeLabels(priceLowRange.floor().toString(),
                              priceHighRange.floor().toString()),
                          values: priceValues,
                          //RangeValues(_lowValue,_highValue),
                          onChanged: (_range) {
                            setState(() {
                              priceValues = _range;
                              priceLowRange = _range.start;
                              priceHighRange = _range.end;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  heightPadding(screenHeight,8),
                  Row(
                    children: [
                      widthPadding(screenWidth,14),
                      Text(
                        '최소',
                        style: TextStyle(
                            fontSize: screenWidth*(10/360),
                            color: hexToColor('#888888')
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        '최대',
                        style: TextStyle(
                            fontSize: screenWidth*(10/360),
                            color: hexToColor('#888888')
                        ),
                      ),
                      widthPadding(screenWidth,14),
                    ],
                  ),
                  heightPadding(screenHeight,24),
                ],
              ),
            ),
            Container(
              height: screenHeight*(4/640),
              color: hexToColor('#FFFFFF'),
            ),
            Container(
              width: screenWidth,
              height: screenHeight*(126/640),
              color: Colors.white,
              child: Column(
                children: [
                  heightPadding(screenHeight,22),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Row(
                      children: [
                        Text(
                          "임대 기간",
                          style:TextStyle(
                              fontSize: screenWidth*(14/360),
                              fontWeight: FontWeight.bold,
                              color:Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                  heightPadding(screenHeight,26),
                  Container(
                    width: screenWidth * (336 / 360),
                    child: Row(
                      children: [
                        Spacer(),
                        // SizedBox(width: screenWidth*(20/360),),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                                maxTime: filterRentDone != "" ? DateTime(DateFormat('y.MM.d').parse(filterRentDone).year, DateFormat('y.MM.d').parse(filterRentDone).month,DateFormat('y.MM.d').parse(filterRentDone).day) : DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                theme: DatePickerTheme(
                                    headerColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    itemStyle: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                onChanged: (date) {
                                  filterRentStart = DateFormat('y.MM.d').format(date);
                                  setState(() {

                                  });
                                },
                                currentTime: DateTime.now(), locale: LocaleType.ko);
                          },
                          child: Container(
                            width: screenWidth * (120 / 360),
                            child: Center(
                              child: Text(
                                filterRentStart == "" ? "입주" : filterRentStart,
                                style: TextStyle(
                                  fontSize: screenWidth * (14 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: filterRentStart == "" ? hexToColor('#CCCCCC') : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * (55 / 640),
                        ),
                        Text(
                          "~",
                          style: TextStyle(
                              fontSize: screenWidth * (20 / 360),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: screenWidth * (55 / 640),
                        ),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: filterRentStart != null ? DateTime(DateFormat('y.MM.d').parse(filterRentStart).year, DateFormat('y.MM.d').parse(filterRentStart).month,DateFormat('y.MM.d').parse(filterRentStart).day) : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                                maxTime: DateTime(DateTime.now().year+1, DateTime.now().month, DateTime.now().day),
                                theme: DatePickerTheme(
                                    headerColor: Colors.white,
                                    backgroundColor: Colors.white,
                                    itemStyle: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
                                onChanged: (date) {
                                  filterRentDone = DateFormat('y.MM.d').format(date);
                                  setState(() {

                                  });
                                },
                                currentTime: DateTime.now(), locale: LocaleType.ko);
                          },
                          child: Container(
                            width: screenWidth * (120 / 360),
                            child: Center(
                              child: Text(
                                filterRentDone == "" ? "퇴실" : filterRentDone,
                                style: TextStyle(
                                  fontSize: screenWidth * (14 / 360),
                                  fontWeight: FontWeight.bold,
                                  color: filterRentDone == "" ? hexToColor('#CCCCCC') : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      widthPadding(screenWidth,12),
                      Container(
                        width: screenWidth*(148/360),
                        height: 1,
                        color: hexToColor('#CCCCCC'),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        width: screenWidth*(148/360),
                        height: 1,
                        color: hexToColor('#CCCCCC'),
                      ),
                      widthPadding(screenWidth,12),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: screenHeight*(4/640),
              color: hexToColor('#FFFFFF'),
            ),
            Container(
              width: screenWidth,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightPadding(screenHeight,14),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Text(
                      "추가 옵션",
                      style:TextStyle(
                          fontSize: screenWidth*(14/360),
                          fontWeight: FontWeight.bold,
                          color:Colors.black
                      ),
                    ),
                  ),
                  heightPadding(screenHeight,12),
                  Padding(
                    padding:  EdgeInsets.only(left: screenWidth*(12/360)),
                    child: Container(
                      height: screenHeight * (34/640),
                      child: ListView.separated(
                        // controller: _scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                          itemCount:listOption.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: (){
                                listOption[index].flag = !listOption[index].flag;
                                setState(() {

                                });
                              },
                              child: Container(
                                height: screenHeight * 0.05,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                                  child: Center(
                                    child: Text(
                                      '${listOption[index].title}',
                                      style: TextStyle(
                                        fontSize: screenWidth*SearchCaseFontSize,
                                        color: listOption[index].flag ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: listOption[index].flag ? kPrimaryColor : Colors.white,
                                  borderRadius: new BorderRadius.circular(4.0),
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: Offset(1.5, 1.5),
                                    ),
                                  ],

                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  heightPadding(screenHeight,16),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          subList.clear();
          for(int i = 1; i <= listRoomType.length; i++) {
            if(listRoomType[i-1].flag) {
              subList.add(i.toString());
            }
          }
          if(subList.length == 0)
            subList = ["1","2","3","4"];

          final packet = new FilterPacket(subList, priceLowRange.toInt(),priceHighRange.toInt(),filterRentStart,filterRentDone,listOption[0].flag ? 1 : 0, listOption[1].flag ? 1 : 0,listOption[2].flag ? 1 : 0,);
          packet;
          Navigator.pop(context, packet);
        },
        child: Container(
          height: screenHeight*(60/640),
          width: screenWidth,
          color: kPrimaryColor,
          child: Center(
            child: Text(
              '적용하기',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width*(16/360),
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
  void changeOthersFilterFlag(String title,bool flag,int type) {
    if(type == 0) {//필터 카테고리 변형시
      for(int i = 0; i < filterList.length; i++) {
        if(filterList[i].title == title)
          continue;

        filterList[i].flag = flag;
      }
    }
    if(type==1){//방종류
      for(int i = 0; i < listRoomType.length; i++) {
        if(listRoomType[i].title == title)
          continue;

        listRoomType[i].flag = flag;
      }
    }
  }

  Container returnShortTermFilter(double screenWidth, double screenHeight) {
    if(curlistRoomType == -1)
      return Container();
    else if(curlistRoomType == 0) {
      return Container(
        width: screenWidth,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightPadding(screenHeight,14),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*(12/360)),
              child: Text(
                "방 종류",
                style:TextStyle(
                    fontSize: screenWidth*(14/360),
                    fontWeight: FontWeight.bold,
                    color:Colors.black
                ),
              ),
            ),
            heightPadding(screenHeight,12),
            Padding(
              padding:  EdgeInsets.only(left: screenWidth*(12/360)),
              child: Container(
                height: screenHeight * (34/640),
                child: ListView.separated(
                  // controller: _scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (BuildContext context, int index) => widthPadding(screenWidth,4),
                    itemCount:listRoomType.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: (){
                          listRoomType[index].flag = !listRoomType[index].flag;
                          curlistRoomType = index;
                          changeOthersFilterFlag(listRoomType[index].title,false,1);//선택된 필터말고 나머지는 다 끔
                          setState(() {

                          });
                        },
                        child: Container(
                          height: screenHeight * 0.05,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.009375),
                            child: Center(
                              child: Text(
                                '${listRoomType[index].title}',
                                style: TextStyle(
                                  fontSize: screenWidth*SearchCaseFontSize,
                                  color: listRoomType[index].flag ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: listRoomType[index].flag ? kPrimaryColor : Colors.white,
                            borderRadius: new BorderRadius.circular(4.0),

                          ),
                        ),
                      );
                    }),
              ),
            ),
            heightPadding(screenHeight,16),
            Container(height: 1,color:hexToColor('#EEEEEE'),),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '취소하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: hexToColor('#CCCCCC')
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: screenHeight*(40/640),
                  color: hexToColor('#EEEEEE'),
                ),
                Expanded(
                  child: Container(
                    height: screenHeight*(40/640),
                    child: Center(
                      child: Text(
                        '적용하기',
                        style: TextStyle(
                            fontSize: screenWidth*(12/360),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  }
}