import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';

import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/packages/kopo/kopo.dart';
import 'package:mryr/packages/kopo/kopo_model.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:provider/provider.dart';

class ModifyItemLocation extends StatefulWidget {
  @override
  _ModifyItemLocationState createState() => _ModifyItemLocationState();
}

class _ModifyItemLocationState extends State<ModifyItemLocation> {
  String adressValue = "주소를 검색해주세요";
  TextEditingController addressController;

  String addressJSON = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context,listen: false);
    if(data.Address != null) {
      addressJSON = data.Address;
    }
    if(data.DetailAddress != null) {
      addressController= TextEditingController(text: data.DetailAddress);
    }
    CheckForItemLocation(data);
  }

  @override
  Widget build(BuildContext context) {
    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//              onPressed: () {
//                Navigator.pop(context);
//              }),
              title: SvgPicture.asset(
                MryrLogoInReleaseRoomTutorialScreen,
                width: screenHeight * (110 / 640),
                height: screenHeight * (27 / 640),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SizedBox(height: screenHeight*0.0625,),
                Row(
                  children: [
                    SizedBox(
                      width: screenWidth * (12 / 360),
                    ),
                    Text(
                      "방 위치 입력",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth*(24/360),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenWidth * (12 / 360),
                    ),
                    Text(
                      "지도에서 정확한 매물의 위치를 확인해주세요",
                      style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: screenHeight * (12 / 640),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * (36 / 640),
                ),
                GestureDetector(
                  onTap: () async {
                    /*KopoModel model = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Kopo(),
                          ),
                        );*/
                    KopoModel model = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Kopo(
                          useLocalServer: false,
                          localPort: 1024,
                        ),
                      ),
                    );

                    setState(() {
                      addressJSON =
                      '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}';
                      data.ChangeAddress(addressJSON);
                    });
                    var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(data.Address.toString());
                    var first = addresses.first;
                    print(first.coordinates.longitude);
                    print(first.coordinates.latitude);

                    CheckForItemLocation(data);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * (16 / 360),
                      ),
                      Text(
                        addressJSON == '' ? '주소를 입력해주세요.' : '${addressJSON}' ,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: screenWidth*(14/360),
                            color:addressJSON == '' ? Color(0xff928E8E):Colors.black),),
                      Spacer(),
                      SvgPicture.asset(
                        GreyMagnifyingGlass,
                        width: screenHeight * 0.025,
                        height: screenHeight * 0.025,
                      ),
                      SizedBox(
                        width: screenWidth * (20 / 360),
                      )
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*(8/640),),
                Container(width: screenWidth*(328/360),height: 1,color: Color(0xffcccccc),),
                Container(
                  width: screenWidth*(328/360),
                  child: TextField(
                    controller: this.addressController,
                    textInputAction: TextInputAction.done,
                    decoration: new InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffcccccc)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffcccccc)),
                      ),
                      hintText: "상세 주소를 입력하세요",
                      hintStyle: TextStyle(fontSize: screenWidth*(14/360)),
                      labelStyle: new TextStyle(
                          color: const Color(0xFF424242)
                      ),
                      isDense: true,
                    ),
                    onChanged: (text){
                      data.ChangeDetailAddress(text);
                      CheckForItemLocation(data);
                    },
                  ),
                ),
                Container(
                  height: screenHeight * (40 / 640),
                  color: Color(0xffffffff),
                ),
              ],
            ),
            bottomNavigationBar: GestureDetector(
              onTap: (){
                if(!data.FlagEnterRoomInfo[1]) {
                  if(data.CheckCompleteFlag == true) {
                    data.ChangeFlagEnterRoomInfo(1, true);
                    data.ChangeCheckComplete(false);
                    data.ChangeCompleteCheck(++data.CompleteCheck);
                    Navigator.pop(context);
                  }
                } else {
                  data.ChangeCheckComplete(false);
                  Navigator.pop(context);
                }
              },
              child: Container(
                height: screenHeight*0.09375,
                width: screenWidth,
                decoration: BoxDecoration(
                    color: data.CheckCompleteFlag == true ? kPrimaryColor : hexToColor("#CCCCCC")
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '완료',
                    style: TextStyle(
                        fontSize: screenWidth*0.0444444,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  void CheckForItemLocation(EnterRoomInfoProvider data) {
    if(addressJSON != '' && data.DetailAddress != null && data.DetailAddress != "") {
      data.ChangeCheckComplete(true);
    } else {
      data.ChangeCheckComplete(false);
    }
  }
}
