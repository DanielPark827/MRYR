import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mryr/userData/Room.dart';

//나중에 쓸것 날짜적용 provider판
class DateInLookForRoomsScreenProvider extends ChangeNotifier{
  bool TimeState = false;
  List<DateTime> picked = [DateTime.now(),(DateTime.now()).add(Duration(days: 1))];

  List<DateTime> getDate() => picked;
  DateTime getInitialDate() => picked[0];
  DateTime getLastDate() => picked[1];


  String getStringInitialDate() => picked[0].toString()[0]+picked[0].toString()[1]+picked[0].toString()[2]+picked[0].toString()[3]+"."+picked[0].toString()[5]+picked[0].toString()[6]+"."+picked[0].toString()[8]+picked[0].toString()[9];
  String getStringLastDate() =>  picked[1].toString()[0]+picked[1].toString()[1]+picked[1].toString()[2]+picked[1].toString()[3]+"."+picked[1].toString()[5]+picked[1].toString()[6]+"."+picked[1].toString()[8]+picked[1].toString()[9];

  bool getTimeState(){
    return TimeState;
  }
  void setTimeState(){
    TimeState = true;
    notifyListeners();
  }
  void setTimeReset(){
    TimeState = false;
    notifyListeners();
  }

  void setDate(List<DateTime> tmp){
    picked = tmp;
    notifyListeners();
  }
}


class DateInReleaseRoomsScreenProvider extends ChangeNotifier{
  List<DateTime> picked = [DateTime.now(),(DateTime.now()).add(Duration(days: 1))];



  List<DateTime> getDate() => picked;
  DateTime getInitialDate() => picked[0];
  DateTime getLastDate() => picked[1];

  String getStringInitialDate() => DateFormat('y.MM.dd').format(picked[0]);
  String getStringLastDate() => DateFormat('y.MM.dd').format(picked[1]);
  //DateFormat('y.MM.dd').format(DateTime.now())
  List<String> pickedString = ["",""];

  Future<void> setEditStringDate(RoomSalesInfo data) async {
    pickedString[0] =  data.termOfLeaseMin;
    pickedString[1]  = data.termOfLeaseMax;
    notifyListeners();
    return;
  }
  
  String getEditStringInitialDate() => pickedString[0];
  String getEditStringLastDate() => pickedString[1];

  void setStringDate(List<String> tmp){
    pickedString[0] = tmp[0];
    pickedString[1] = tmp[1];
    print(pickedString[0]);
    print(pickedString[1]);
    notifyListeners();
  }

  void setDate(List<DateTime> tmp){
    picked = tmp;
    notifyListeners();
  }

  void resetDate() {
    picked.clear();
    picked = [DateTime.now(),(DateTime.now()).add(Duration(days: 1))];
    notifyListeners();
  }
}

