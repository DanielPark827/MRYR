import 'package:flutter/material.dart';

const int agreement = 0;
const int phoneAuth = 1;
const int inputAuthNumber = 2;
const int studentAuth = 3;

const int authComplete = 4;

class ReleaseRoomAuthStateProvider extends ChangeNotifier{

  int PageStatus = 0;
  int get getPageStatus => PageStatus;
  void setPageStatus(int Status){
    PageStatus = Status;
    notifyListeners();
  }
}

