import 'package:flutter/material.dart';

class RoomListScreenProvider with ChangeNotifier {
  String Filter1 = Filter1List[0];
  String Filter2 = Filter2List[0];
  String Filter3 = Filter3List[0];

  void ChangeFilter1(String value) {
    Filter1 = value;
    notifyListeners();
  }
  void ChangeFilter2(String value) {
    Filter2 = value;
    notifyListeners();
  }
  void ChangeFilter3(String value) {
    Filter3 = value;
    notifyListeners();
  }
}

List<String> Filter1List = ['월세', '전세', '매매'];
List<String> Filter2List = ['가','나','다'];
List<String> Filter3List = ['기', '니', '디'];