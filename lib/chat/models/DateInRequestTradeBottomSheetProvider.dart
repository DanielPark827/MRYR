import 'dart:math';

import 'package:flutter/material.dart';

class DateInRequestTradeBottomSheetProvider extends ChangeNotifier{
  List<DateTime> picked = [DateTime.now(),(DateTime.now()).add(Duration(days: 1))];

  List<DateTime> getDate() => picked;
  DateTime getInitialDate() => picked[0];
  DateTime getLastDate() => picked[1];


  String getStringInitialDate() => picked[0].toString()[0]+picked[0].toString()[1]+picked[0].toString()[2]+picked[0].toString()[3]+"."+picked[0].toString()[5]+picked[0].toString()[6]+"."+picked[0].toString()[8]+picked[0].toString()[9];
  String getStringLastDate() =>  picked[1].toString()[0]+picked[1].toString()[1]+picked[1].toString()[2]+picked[1].toString()[3]+"."+picked[1].toString()[5]+picked[1].toString()[6]+"."+picked[1].toString()[8]+picked[1].toString()[9];

  void setDate(List<DateTime> tmp){
    picked = tmp;
    notifyListeners();
  }
}

