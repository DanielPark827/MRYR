import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mryr/chat/models/DateInRequestTradeBottomSheetProvider.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/userData/Room.dart';
import 'package:provider/provider.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

Future BottomSheetInRequestTrade(BuildContext context, double screenWidth, double screenHeight, String title, String description, RoomSalesInfo roomSalesInfo,
    DateInRequestTradeBottomSheetProvider _dateInRequestTradeBottomSheetProvider){
  final RoomPriceController = TextEditingController();

  List<DateTime> dateList = List<DateTime>();

  DateTime min = new DateFormat("yyyy.MM.dd").parse(roomSalesInfo.termOfLeaseMin);
  DateTime max = new DateFormat("yyyy.MM.dd").parse(roomSalesInfo.termOfLeaseMax);

  dateList.add(min);
  dateList.add(max);

  _dateInRequestTradeBottomSheetProvider.setDate(dateList);

  bool bChoiceDates = false;

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: (){
            FocusScopeNode cureentFocus = FocusScope.of(context);

            if(!cureentFocus.hasPrimaryFocus){
              cureentFocus.unfocus();
            }
          },

          child: StatefulBuilder(builder: (BuildContext context, StateSetter myState) {
            return   Container(
              width: screenWidth,
              height: screenHeight * (440 / 640),
              decoration:BoxDecoration(
                border: Border.all(color:  Color(0xffEEEEEE)),
                color:  hexToColor('#FFFFFF'),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8), bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0),),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * (30/640),),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth*(12/360)),
                      child: Container(
                        child: Text(title, style: TextStyle(fontSize: screenWidth * (24/360), fontWeight: FontWeight.bold, color: hexToColor('#222222')),),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * (8/640),),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth*(12/360)),
                      child: Container(
                        child: Text(description, style: TextStyle(fontSize: screenWidth * (12/360), fontWeight: FontWeight.normal, color: hexToColor('#888888')),),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * (30/640),),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth*(12/360)),
                      child: Container(
                        child: Text("임대료", style: TextStyle(fontSize: screenWidth * (12/360), fontWeight: FontWeight.bold, color: hexToColor('#222222')),),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * (12/640),),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.51666,
                      child: Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.277777,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],

                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.right,
                                controller: RoomPriceController,
                                style: TextStyle(
                                    fontSize: screenWidth * (18/360),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  hintText: (roomSalesInfo.monthlyRentFeesOffer).toString(),
                                  contentPadding: EdgeInsets.all(0),
                                  hintStyle: TextStyle(
                                      fontSize: screenHeight*0.03125,
                                      color: hexToColor("#CCCCCC"),
                                      fontWeight: FontWeight.bold
                                  ),
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                ),
                              )
                          ),
                          SizedBox(width: screenWidth*0.02222,),
                          Text(
                            '만 / 월',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * (18/360),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight*0.0125,),
                  Container(
                    height: 1,
                    width: screenWidth*(336/360),
                    color: hexToColor("#CCCCCC"),
                  ),
                  SizedBox(height: screenHeight * (30/640),),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: screenWidth*(12/360)),
                      child: Container(
                        child: Text("임대 기간", style: TextStyle(fontSize: screenWidth * (12/360), fontWeight: FontWeight.bold, color: hexToColor('#222222')),),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * (12/640),),
                  Stack(
                    children: [
                      Container(
                        width: screenWidth*(336/360),
                        child: Row(children: [
                          Spacer(),
                          // SizedBox(width: screenWidth*(20/360),),
                          Text(_dateInRequestTradeBottomSheetProvider.getStringInitialDate(),
                            style: TextStyle(fontSize: screenHeight*(18/640),fontWeight: FontWeight.bold,
                                color: false == bChoiceDates ? hexToColor('#CCCCCC') : Colors.black
                            ),
                          ),
                          SizedBox(width: screenWidth*(55/640),),
                          Text("~",style: TextStyle(fontSize: screenHeight*(20/640),fontWeight: FontWeight.bold),),
                          SizedBox(width: screenWidth*(55/640),),
                          Text(_dateInRequestTradeBottomSheetProvider.getStringLastDate(),style: TextStyle(fontSize: screenHeight*(18/640),fontWeight: FontWeight.bold,
                              color: false == bChoiceDates ? hexToColor('#CCCCCC') : Colors.black
                          ),),
                          Spacer(),
                        ],),
                      ),
                      Positioned(
                        child: FlatButton(
                            color: Colors.transparent,
                            onPressed: () async{

                              List<DateTime> picked = await DateRagePicker.showDatePicker(
                                  context: context,
                                  initialFirstDate: _dateInRequestTradeBottomSheetProvider.getDate().length == 2?_dateInRequestTradeBottomSheetProvider.getInitialDate():_dateInRequestTradeBottomSheetProvider.getDate().length == 1?_dateInRequestTradeBottomSheetProvider.getInitialDate():DateTime.now(),

                                  //_dateInLookForRoomsScreenProvider.getDate().length == 1 ? _dateInLookForRoomsScreenProvider.getInitialDate()==null?DateTime.now():_dateInLookForRoomsScreenProvider.getInitialDate(),
                                  initialLastDate: _dateInRequestTradeBottomSheetProvider.getDate().length == 2?_dateInRequestTradeBottomSheetProvider.getLastDate():_dateInRequestTradeBottomSheetProvider.getDate().length == 1?_dateInRequestTradeBottomSheetProvider.getInitialDate():(DateTime.now()).add(Duration(days: 1)),


                                  //_dateInLookForRoomsScreenProvider.getLastDate()==null?DateTime.now().add(new Duration(days: 1)):_dateInLookForRoomsScreenProvider.getLastDate(),
                                  firstDate:  min,
                                  lastDate:  max
                              );

                              bChoiceDates = true;

                              if(picked != null){
                                if(picked.length ==1){
                                  picked.add(picked[0]);
                                }

                                myState(() {
                                  _dateInRequestTradeBottomSheetProvider.setDate(picked);
                                });
                              }
                            },
                            child: Container(
                              height: screenHeight*(28/640),
                              width: screenWidth*(300/360),)),
                      ),
                    ],
                  ),
                  Container(
                    width: screenWidth*(336/360),
                    child: Row(children: [
                      Spacer(),
                      Container(
                        color: Color(0xffcccccc),
                        width: screenWidth*(148/360),
                        height: screenHeight*(1/640),),
                      SizedBox(width: screenWidth*(40/360),),
                      Container(
                        color: Color(0xffcccccc),
                        width: screenWidth*(148/360),
                        height: screenHeight*(1/640),),
                      Spacer(),
                    ],),
                  ),
                  Spacer(),
                  Container(
                    height: screenHeight * (58/640),
                    color: false == bChoiceDates || RoomPriceController.text.isEmpty ? hexToColor('#CCCCCC') : hexToColor('#6F22D2'),
                    child: GestureDetector(
                      onTap: () {
                        if(false == bChoiceDates || RoomPriceController.text.isEmpty) return;
                        Navigator.pop(context, "${RoomPriceController.text}"+"|"+"${_dateInRequestTradeBottomSheetProvider.getStringInitialDate()}"+"|"+"${_dateInRequestTradeBottomSheetProvider.getStringLastDate()}");
                      },
                      child: Center(child: Text("거래 정보 전송", style: TextStyle(fontSize: screenWidth * (16/screenWidth),
                          color: hexToColor('#FFFFFF'),
                          fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      }
  );
}
