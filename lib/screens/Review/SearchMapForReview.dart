import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/google_map_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/ReviewScreenInMap/StringForReviewScreenInMap.dart';
import 'package:mryr/constants/MryrTextStyle.dart';
import 'package:mryr/screens/Review/addressComplteForReview.dart';
import 'package:provider/provider.dart';
import 'package:mryr/screens/Review/ReviewScreenInMapDetail.dart';
import 'package:mryr/constants/GlobalAbstractClass.dart';
import 'package:location/location.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/constants/KeySharedPreferences.dart';

import 'ReviewScreenInMap.dart';
import 'ReviewScreenInMapMain.dart';

class SearchMapForReview extends StatefulWidget {


  SearchMapForReview({Key key}) : super(key : key);

  @override
  _SearchMapForReviewState createState() => _SearchMapForReviewState();
}

class _SearchMapForReviewState extends State<SearchMapForReview> with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  MapType _googleMapType = MapType.normal;
  Set<Marker> _markers = Set();
  BitmapDescriptor markerIcon;
  String addressJSON = '';
  final textfieldControllerSearchLocation = TextEditingController();


  bool flag = false;
  bool markerActive = false;
  String SearchLocation = '지역별 검색';

  Review selectedItem;

  AnimationController extendedController;

  static LatLng _initialPosition;


  @override
  Future<void> initState() {
    flag = false;
    super.initState();
    // setCustomMapPin();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    doubleCheck = false;
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

  Future<void> _updateMarkers([double updatedZoom]) async {
    if(flag) {
      flag = false;
      setState(() {
      });
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

    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);
    return SafeArea(
      bottom: false,
      child: Scaffold(

        body: Stack(
          children: [
            GoogleMap(
              mapType: _googleMapType,
              initialCameraPosition: _initialCameraPostion,
              onCameraMove: (position) => _updateMarkers(position.zoom),
              onMapCreated: (GoogleMapController controller) async {
                _controller.complete(controller);
                final BitmapDescriptor markerImage = (Platform.isIOS) ? await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/test2.png') : await BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(devicePixelRatio: 50,
                        size: Size(screenWidth*(20/360),screenWidth*(20/360))),
                    'assets/images/logo/testandroid.png');

                _currentLocation();


                var gCoorList = await ApiProvider().get('/Review/LongLatList');
                if(null != gCoorList) {
                  for(int i = 0; i < gCoorList.length; i++) {
                    Map<String, dynamic> data = gCoorList[i];
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
                      _markers.add(
                        Marker(
                            markerId: MarkerId('marker' + i.toString()),
                            position: LatLng(finalLat, finalLng),
                            // infoWindow: InfoWindow(title: 'My Position', snippet: 'Where am I?'),
                            icon: markerImage,
                            onTap: () async {
                              var list = await ApiProvider().post('/Review/SelectMarker', jsonEncode(
                                  {
                                    "location" : item.loc,
                                  }
                              ));
                              selectedItem = Review.fromJson(list);

                              flag = !flag;

                              setState(() {
                              });
                            }
                        ),
                      );
                    });
                  }
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap:() async {
                    PlaceDetail item = await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => addressComplteForReview(),
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
                      await AddRecentRegion(item.name,item.lat,item.lng);
                    }
                    setState(() {
                    });
                  },
                  child: Container(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
            Positioned(
              left : screenWidth*(12/360),
              top: screenHeight*(78/640),
              child: GestureDetector(
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
            ),
            Positioned(right:0,bottom:0,child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context, // 기본 파라미터, SecondRoute로 전달
                            MaterialPageRoute(
                                builder: (context) =>
                                    ReviewScreenInMap()) // SecondRoute를 생성하여 적재
                        );
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

                                  Container(child:Text("후기남기기",style: TextStyle(color:Color(0xFF222222)),)),
                                  Container(width:4),

                                  FloatingActionButton(heroTag: "btn2",child:Icon(Icons.add,size: 30))],mainAxisAlignment: MainAxisAlignment.end,)
                          ),
                        ],
                      ),
                    ),
                    Container(width:screenWidth*(8/360)),
                  ],
                ),
                Container(height:screenWidth*(12/360)),
                AnimatedContainer(
                  height: flag? screenHeight*(184/640) : 0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                  child: GestureDetector(
                    onTap: ()async{


                      if(doubleCheck == false){
                        doubleCheck = true;



                        GlobalProfile.detailReviewList.clear();

                        double finalLat;
                        double finalLng;
                        if(null == selectedItem.lng || null == selectedItem.lat) {
                          var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(selectedItem.Location);
                          var first = addresses.first;

                          finalLat = first.coordinates.latitude;
                          finalLng = first.coordinates.longitude;
                        } else {
                          finalLat = selectedItem.lat;
                          finalLng =  selectedItem.lng;
                        }
                        var detailReviewList= await ApiProvider()
                            .post('/Review/ReviewListLngLat', jsonEncode({
                          "longitude":finalLng,
                          "latitude":finalLat,
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
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ReviewScreenInMapMainDetail( review : selectedItem,isRoom: false,)));
                      }

                    },
                    child: Container(
                      width: screenWidth,
                      height: screenHeight*(184/640),
                      color: Colors.white,
                      child: Column(
                        children: [
                          heightPadding(screenHeight,8),
                          Container(width:screenWidth*(34/360),height:screenWidth*(4/640),color:Color(0xffc4c4c4)),
                          Row(
                            children: [
                              GestureDetector(
                                onTap:() async {

                                },
                                child: Container(
                                  width: screenWidth*(180/360),
                                  height: screenHeight*(40/640),
                                  child: Center(
                                    child: Text(
                                      !flag? "":'상세 후기 ('+selectedItem.CountId.toString()+')',
                                      style: TextStyle(
                                          fontSize: screenWidth*(12/360),
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widthPadding(screenWidth,12),
                              Container(
                                width: screenWidth*(120/360),
                                height: screenHeight*(100/640),
                                child:
                                ClipRRect(
                                    borderRadius: new BorderRadius.circular(4.0),
                                    child:
                                        !flag? Container():
                                    selectedItem.ImageUrl=="BasicImage"||selectedItem.ImageUrl==null
                                        ?
                                    SvgPicture.asset(
                                      mryrInReviewScreen,
                                      width: screenHeight * (60 / 640),
                                      height: screenHeight * (60 / 640),
                                    )
                                        :
                                    FittedBox(
                                      fit: BoxFit.cover,
                                      child: getExtendedImage(get_resize_image_name(selectedItem.ImageUrl,360), 0,extendedController),
                                    )

                                ),
                              ),
                              widthPadding(screenWidth,12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenWidth * (185 / 360),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  star,
                                                  width: screenWidth * (19 / 360),
                                                  height:
                                                  screenWidth * (19 / 360),
                                                  color: !flag? kPrimaryColor:selectedItem.StarAvg>= 1
                                                      ? kPrimaryColor
                                                      : starColor,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (5 / 360),
                                                ),
                                                SvgPicture.asset(
                                                  star,
                                                  width: screenWidth * (19 / 360),
                                                  height:
                                                  screenWidth * (19 / 360),
                                                  color:  !flag? kPrimaryColor:selectedItem.StarAvg>= 2
                                                      ? kPrimaryColor
                                                      : starColor,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (5 / 360),
                                                ),
                                                SvgPicture.asset(
                                                  star,
                                                  width: screenWidth * (19 / 360),
                                                  height:
                                                  screenWidth * (19 / 360),
                                                  color:  !flag? kPrimaryColor:selectedItem.StarAvg>= 3
                                                      ? kPrimaryColor
                                                      : starColor,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (5 / 360),
                                                ),
                                                SvgPicture.asset(
                                                  star,
                                                  width: screenWidth * (19 / 360),
                                                  height:
                                                  screenWidth * (19 / 360),
                                                  color:  !flag? kPrimaryColor:selectedItem.StarAvg>= 4
                                                      ? kPrimaryColor
                                                      : starColor,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (5 / 360),
                                                ),
                                                SvgPicture.asset(
                                                  star,
                                                  width: screenWidth * (19 / 360),
                                                  height:
                                                  screenWidth * (19 / 360),
                                                  color: !flag? kPrimaryColor: selectedItem.StarAvg>= 5
                                                      ? kPrimaryColor
                                                      : starColor,
                                                ),
                                                SizedBox(
                                                  width: screenWidth * (5 / 360),
                                                ),
                                                Text(
                                                  !flag? "": selectedItem.StarAvg.toStringAsFixed(1) + "점",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize:
                                                      screenWidth * (10 / 360),
                                                      color: !flag? kPrimaryColor: selectedItem.StarAvg!= -1
                                                          ? kPrimaryColor
                                                          : Color(0xffeeeeee)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  heightPadding(screenHeight,8),
                                  Row(
                                    children: [
                                      Text(
                                        '매물 종류',
                                        style: TextStyle(
                                            fontSize: screenWidth*(12/360),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      widthPadding(screenWidth,8),
                                      Text(
                                        !flag? "":returnRoomType(selectedItem.Type),
                                        style: TextStyle(
                                          fontSize: screenWidth*(12/360),
                                          color: hexToColor('#888888'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  heightPadding(screenHeight,4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '매물 위치',
                                        style: TextStyle(
                                            fontSize: screenWidth*(12/360),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      widthPadding(screenWidth,8),
                                      Container(
                                        width: screenWidth*(148/360),
                                        child: Text(
                                          !flag? "": selectedItem.Location,
                                          style: TextStyle(
                                            fontSize: screenWidth*(12/360),
                                            color: hexToColor('#888888'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                          heightPadding(screenHeight,12),
                        ],
                      ),
                    ),
                  ),
                ) ,
              ],
            ))
          ],
        ),

        bottomNavigationBar: GestureDetector(
          onTap: () async {
            flag = false;
            EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
            GlobalProfile.reviewList.clear();

            var reviewList = await ApiProvider().post('/Review/SelectListLonlat', jsonEncode({
              "option" : false
            }));

            if(reviewList != null){
              for(int i = 0 ; i < reviewList.length; ++i){
                GlobalProfile.reviewList.add(Review.fromJson(reviewList[i]));
              }
            }
            EasyLoading.dismiss();
            Navigator.push(
                context, // 기본 파라미터, SecondRoute로 전달
                MaterialPageRoute(
                    builder: (context) =>
                        ReviewScreenInMapMain() ) // SecondRoute를 생성하여 적재
            );
          },
          child: Container(
            height: screenHeight*(60/640),
            width: screenWidth,
            color: kPrimaryColor,
            child: Center(
              child: Text(
                '모든 후기 보기',
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
