import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';

class NavigationNumProvider extends ChangeNotifier{
  int pastNum = 0;
  int _num = 0;
  int flagForNavigate = 0;

  int getNum() => _num;
  int getPastNum() => pastNum;

  void setNum(int num, {bool flagForNavigate = false}){
    setPastNum(_num);

  /*  if(socket != null){
      GlobalProfile.loggedInUser;

      if(num == CHAT_LIST_SCREEN_NUM){
        socket.setRoomStatus(ROOM_STATUS_ROOM);
      }else{
        socket.setRoomStatus(ROOM_STATUS_ETC);
      }
    }*/

    _num = num;
    notifyListeners();
  }
  void setPastNum(int num){
    pastNum = _num;
    notifyListeners();

  }
}

