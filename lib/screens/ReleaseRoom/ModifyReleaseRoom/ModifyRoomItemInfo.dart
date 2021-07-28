import 'dart:convert';
import 'package:geocoder/geocoder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/ReleaseRoom/model/ModelModifyReleaseRoom.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'dart:math' as Math;
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class ModifyRoomItemInfo extends StatefulWidget {
  RoomSalesInfo roomSalesInfo;

  ModifyRoomItemInfo({Key key, this.roomSalesInfo,}) : super(key : key);

  @override
  _ModifyRoomItemInfoState createState() => _ModifyRoomItemInfoState();
}

class _ModifyRoomItemInfoState extends State<ModifyRoomItemInfo> {
  List<String> RoomInfoList = ['매물 종류','매물 위치','기본 정보','보증금월세','임대 기간','기타 제안','옵션 선택','상세 정보','매물 사진'];
  List<String> RouteList = ['/ModifyItemCategory','/ModifyItemLocation','/ModifyItemInfo','/ModifyPrice','/ModifyTerm','/ModifySuggestion','/ModifyOption','/ModifyDescription','/ModifyImg','/ModifyOpenchat'];

  FormData formData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context, listen: false);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider =
    Provider.of<DateInReleaseRoomsScreenProvider>(context,listen: false);
    (() async {
      await data.SetEnterRoomInfo(widget.roomSalesInfo);
    })();
  }

  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DateInReleaseRoomsScreenProvider _dateInReleaseRoomsScreenProvider =
    Provider.of<DateInReleaseRoomsScreenProvider>(context);
    DummyUser _UserProvider = Provider.of<DummyUser>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                data.ResetEnterRoomInfoProvider();
                _UserProvider.ResetDummyUser();
                Navigator.pop(context);
              }),
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: (){
            data.ResetEnterRoomInfoProvider();
            _UserProvider.ResetDummyUser();
            Navigator.pop(context);
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight*0.059375,),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.033333),
                  child: Text(
                    '방 정보 입력',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth*(24/360),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*(8/640),),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth*0.033333),
                  child: Text(
                    '방에 대한 정확한 정보를 입력해주세요',
                    style: TextStyle(
                      fontSize: screenWidth*0.033333,
                      color: hexToColor("#888888"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: screenWidth*(8/360)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "9/9",
                      style: TextStyle(
                          fontSize: screenWidth*(14/360),
                          color: kPrimaryColor
                      ),
                    ),
                  ),
                ),
                heightPadding(screenHeight,4),
                Row(
                  children: [
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color:kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color:kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color: kPrimaryColor ,
                    ),
                    Spacer(),
                    Container(
                      width: screenWidth*(36/360),
                      height: screenHeight*(4/640),
                      color:kPrimaryColor ,
                    ),
                  ],
                ),
                Container(
                  color: hexToColor("#F8F8F8"),
                  height: screenHeight * 0.0015625,
                ),
                SizedBox(
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Container(
                        color: hexToColor("#F8F8F8"),
                        height: screenHeight * 0.0015625,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: RoomInfoList.length,
                      itemBuilder: (BuildContext context, int index) => RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        onPressed: (){
                          Navigator.pushNamed(context, '${RouteList[index]}',arguments: widget.roomSalesInfo);
                        },
                        child: Container(
                          height: screenHeight*0.0671875,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: screenWidth*0.03333,
                              ),
                              Container(
                                width: screenWidth*0.2111111111111111,
                                child: Text(
                                  index ==3 &&  data.transferType != 0 ? "전세금제안" : '${RoomInfoList[index]}' ,
                                  style: TextStyle(
                                      fontSize: screenWidth*0.03888,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                              ( index == 3 && (CheckForEdit(data) == false))? Container():Container(
                                height: screenHeight*0.0296875,
                                width: screenWidth*0.15,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '입력 완료',
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: screenWidth*0.0277777
                                    ),
                                  ),
                                ),
                              ) ,
                              Expanded(child: SizedBox()),
                              SvgPicture.asset(
                                GreyNextIcon,
                                height: screenHeight*0.025,
                                width: screenHeight*0.025,
                              ),
                              SizedBox(
                                width: screenWidth*0.03333,
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () async {
            if((CheckForEdit(data) == false)){

            }
            else {
              Function cancelFunc = () {
                Navigator.pop(context);
              };
              Function okFunc = () async {
                EasyLoading.show(
                    status: "", maskType: EasyLoadingMaskType.black);

                Dio dio = new Dio();
                dio.options.headers = {
                  'Content-Type': 'application/json',
                  'user': 'codeforgeek',
                };
                var addresses = await Geocoder.google(
                    'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                    .findAddressesFromQuery(data.Address.toString());
                var first = addresses.first;
                data;
                Future.microtask(() async {
                  formData = new FormData.fromMap({
                    "roomID": widget.roomSalesInfo.id,
                    "type": data.ItemCategory,
                    "location": data.Address.toString(),
                    "locationdetail": data.DetailAddress.toString(),
                    "jeonse": data.transferType == 1 ? 1 : 0,
                    "monthlyrentfees": data.ExistingMonthlyRent,
                    "depositfees": data.ExistingDeposit,
                    "managementfees": data.AdministrativeExpenses,
                    "utilityfees": data.AverageUtilityBill,
                    "square": data.AreaSize,
                    "depositfeesoffer": data.depositCheckBox == true
                        ? null
                        : data
                        .ProposedDeposit,
                    "monthlyrentfeesoffer": data.ProposedMonthlyRent == -1
                        ? 0
                        : data.ProposedMonthlyRent,
                    "rentstart": data.rentStart,
                    "rentdone": data.rentDone,
                    "condition": data.condition,
                    "floor": data.floor.toInt(),
                    "bed": data.OptionList[0],
                    "desk": data.OptionList[1],
                    "chair": data.OptionList[2],
                    "closet": data.OptionList[3],
                    "aircon": data.OptionList[4],
                    "induction": data.OptionList[5],
                    "refrigerator": data.OptionList[6],
                    "tv": data.OptionList[7],
                    "doorlock": data.OptionList[8],
                    "microwave": data.OptionList[9],
                    "washingmachine": data.OptionList[10],
                    "hallwaycctv": data.OptionList[11],
                    "wifi": data.OptionList[12],
                    "parking": data.OptionList[13],
                    "information": data.ItemDescription,
                    "openchat": "",
                    "longitude": first.coordinates.longitude,
                    "latitude": first.coordinates.latitude
                  });
                  int len = data.ItemImgList.length;
                  int rand = new Math.Random().nextInt(100000);
                  for (int i = 0; i < len; ++i) { //파일 형식에 대한 처릴 ex) png, jpeg
                    formData.files.add(
                        MapEntry("img", MultipartFile.fromFileSync(
                            data.ItemImgList[i].path,
                            filename: GlobalProfile.loggedInUser.userID
                                .toString() + "_$rand.jpeg")));
                  }
                  var res = await dio.post(
                      ApiProvider().getUrl + "/RoomSalesInfo/TransferUpdate",
                      data: formData).timeout(const Duration(seconds: 17));

                  data.ResetEnterRoomInfoProvider();
                  _UserProvider.ResetDummyUser();


                  mainTransferList.clear();
                  var tmp = await ApiProvider().post(
                      '/RoomSalesInfo/MainTransferWithLike', jsonEncode(
                      {
                        "userID": GlobalProfile.loggedInUser.userID
                      }
                  ));
                  if (null != tmp) {
                    for (int i = 0; i < tmp.length; i++) {
                      mainTransferList.add(
                          RoomSalesInfo.fromJsonLittle(tmp[i]));
                    }
                  }
                  print("mainTransferList[0].Likes.toString() : " +
                      mainTransferList[0].Likes.toString());

                  //매물 리스트
                  var list = await ApiProvider().post(
                      '/RoomSalesInfo/TransferListWithLike', jsonEncode(
                      {
                        "userID": GlobalProfile.loggedInUser.userID,
                      }
                  ));

                  globalRoomSalesInfoList.clear();
                  if (list != null) {
                    for (int i = 0; i < list.length; ++i) {
                      RoomSalesInfo tmp = RoomSalesInfo.fromJsonLittle(list[i]);
                      globalRoomSalesInfoList.add(tmp);
                    }
                  }


                  nbnbRoom.clear();
                  tmp = await ApiProvider().post('/RoomSalesInfo/ShortListWithLike', jsonEncode(
                      {
                        "userID" : GlobalProfile.loggedInUser.userID,
                      }
                  ));
                  if(null != tmp){
                    for(int i = 0;i<tmp.length;i++){
                      nbnbRoom.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                    }
                  }



                  //메인 단기매물 리스트
                  mainShortList.clear();
                  tmp = await ApiProvider().post('/RoomSalesInfo/MainShortWithLike', jsonEncode(
                      {
                        "userID" : GlobalProfile.loggedInUser.userID,
                      }
                  ));
                  if(null != tmp){
                    for(int i = 0;i<tmp.length;i++){
                      mainShortList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
                    }
                  }




                  //자기 매물 정보
                  var list5 = await ApiProvider().post(
                      '/RoomSalesInfo/myroomInfo', jsonEncode(
                      {
                        "userID": GlobalProfile.loggedInUser.userID
                      }
                  ));

                  GlobalProfile.roomSalesInfoList.clear();
                  if (list5 != null && list5 != false) {
                    for (int i = 0; i < list5.length; ++i) {
                      GlobalProfile.roomSalesInfoList.add(
                          RoomSalesInfo.fromJson(list5[i]));
                    }
                  }

                  GlobalProfile.listForMe2.clear();
                  var list3 = await ApiProvider().post(
                      '/NeedRoomSalesInfo/RecommendUserPerRoom', jsonEncode(
                      {
                        "roomID": widget.roomSalesInfo.id
                      }
                  ));
                  if (list3 != null) {
                    for (int i = 0; i < list3.length; i++) {
                      GlobalProfile.listForMe2.add(
                          NeedRoomInfo.fromJson(list3[i]));
                    }
                  }

                  setState(() {

                  });

                  EasyLoading.dismiss();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {

                  });
                }

                );
              };

              OKCancelDialog(
                  context,
                  "수정을 완료하시겠습니까?",
                  "매물의 정보가 입력된 정보로\n수정됩니다. 계속하시겠습니까?",
                  "확인",
                  "취소",
                  okFunc,
                  cancelFunc);
            }},
          child: Container(
            height: screenHeight*0.09375,
            width: screenWidth,
            decoration: BoxDecoration(
                color: ((CheckForEdit(data) == false))?Color(0xffcccccc):kPrimaryColor
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                '수정 완료',
                style: TextStyle(
                    fontSize: screenWidth*0.0444444,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        )
    );
  }
}
bool CheckForEdit(EnterRoomInfoProvider data){
  if(data.transferType == 0) {
    if (!data.depositCheckBox &&
        (data.ProposedDeposit == null || data.ProposedDeposit == -1)) {
      return false;
    }
    else if (!data.monthlyCheckBox && (data.ProposedMonthlyRent == null ||
        data.ProposedMonthlyRent == -1)) {
      return false;
    }
    else {
      return true;
    }
  }

  else{
    if(data.depositCheckBox){
      return false;
    }
    else if(data.ProposedDeposit == null || data.ProposedDeposit == -1) {
      return false;
    }
    else {
      return true;
    }
  }
}
