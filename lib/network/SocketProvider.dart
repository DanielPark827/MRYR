/*
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:mryr/constants/GlobalAbstractClass.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';

class SocketProvider with ChangeNotifier, StoppableService{

  @override
  void start() {
    super.start();
    if(stopCheck) {
      socket.emit('resumed',[{
        "userID" : GlobalProfile.loggedInUser.userID.toString(),
        "roomStatus" : roomStatus
      }] );
    }
  }

  @override
  void stop() {
    super.stop();
    if(this._fromUser != null){
      stopCheck = true;
      socket.emit('paused',[{
        "test" : 1
      }] );
    }
  }

  int roomStatus;
  bool stopCheck = false;

   SocketIO socket;
  SocketIOManager _manager;

  SocketProvider({this.socket});

  User1 _fromUser;


  //static String _providerserverIP = 'http://13.209.179.158';
  static String _providerserverIP = 'http://13.209.179.158';
  static int PROVIDER_SERVER_PORT = 50002;
  static String _connectUrl = '$_providerserverIP:$PROVIDER_SERVER_PORT';   //server와 연결

  static String ROOM_RECEIVED_EVENT = "room_list_receive_message";
  static String CHAT_RECEIVED_EVENT = "receive_message";
  static String ETC_RECEIVED_EVENT = "etc_receive_message";
  static String JOIN_ROOM_EVENT = "joinRoom";
  static String FORCE_LOGOUT_EVENT = "force_logout";

  initSocket(User1 fromUser) async {
    //async, await : 게으른 연산, 일단 함수가 실행되면 await로가서 처리를하고,
    // 데이터가 들어올때까지 기다리다가, 들어오면 또 처리, stream이 끝나거나 닫힐때 까지 반복

    if(fromUser == null) return;

    print('Connecting user: ${fromUser.name}');
    this._fromUser = fromUser;
    await _init();

    notifyListeners();
  }

  _init() async {
    _manager = SocketIOManager();  //dart 제공
    socket = await _manager.createInstance(_socketOptions());
    socket.connect();
  }

  disconnect() async {
    socket.disconnect();
  }

  setRoomStatus(int status){
    roomStatus = status;

    socket.emit('room_status_online', [{
      'userID' : this._fromUser.userID,
      'value' : status,
    }]);
  }

  _socketOptions() {
    final Map<String, String> userMap = {
      'from': _fromUser.userID.toString(),
    };


    return SocketOptions(
      ApiProvider().getUrl,
      enableLogging: true,
      transports: [Transports.WEB_SOCKET],
      query: userMap,
    );
  }
}*/
