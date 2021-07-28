import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotiProvider.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotification.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SocketProvider.dart';

bool isFirebaseCheck = false;
//Firebase관련 class
class FirebaseNotifications {
  static FirebaseMessaging _firebaseMessaging;
  static String _fcmToken = '';

  FirebaseMessaging get getFirebaseMessaging => _firebaseMessaging;
  // SocketProvider socket;
  LocalNotification _localNotification;
  String get getFcmToken => _fcmToken;

  void setFcmToken (String token) {
    _fcmToken = token;
    isFirebaseCheck = false;
  }

  FirebaseNotifications(){

  }

  void setUpFirebase(BuildContext context) {
    if(GlobalProfile.loggedInUser == null) return;
    if(isFirebaseCheck == false){
      isFirebaseCheck = true;
    }else{
      return;
    }
    if(null == _localNotification) _localNotification = Provider.of<LocalNotiProvider>(context).localNotification;
    // if(null == socket) socket = Provider.of<SocketProvider>(context);

    Future.microtask(() async {
      _firebaseMessaging = FirebaseMessaging();

      firebaseCloudMessaging_Listeners();
      return _firebaseMessaging;
    }) .then((_) async{
      if(_fcmToken == ''){
        _fcmToken = await _.getToken();
        await ApiProvider().post('/Fcm/Token/Save', jsonEncode({
          "userID" : GlobalProfile.loggedInUser.userID,
          "token" : _fcmToken,
        }));
        return;
      }
    });
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message){
    if(message.containsKey('data'))
      if(message.containsKey('notification')){
        final dynamic notification = message['notification'];
      }
  }

  void firebaseCloudMessaging_Listeners() {

    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });


    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {

        Future.microtask(() async {
          FlutterRingtonePlayer.playNotification();


          print('on message!!!!!!!!!! $message');


          if(Platform.isAndroid) return (message['data']['res'] as String).split('|');
          return (message['res'] as String).split('|');
        }).then((strList) async {
          if(kReleaseMode){
            if(Platform.isAndroid){
              if(message['notification']['body'] == 'undefined') return;
            }else if(Platform.isIOS){
              if(message['aps']['alert']['body'] == 'undefined') return;
            }
          }else{
            if(message['notification']['body'] == 'undefined') return;
          }

          if(strList != null && strList.length != 0 && strList[0].length != 0 && strList[0] != ''){
            if(strList[3] == 'LOGOUT'){
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('autoLoginKey',null);// null, normal, kakao, apple
              prefs.setString('autoLoginId', null);
              prefs.setString('autoLoginPw', null);

              //Fluttertoast.showToast(msg: ("다른 사용자가 해당 아이디로 접근하여 로그아웃됩니다.\n프로그램이 종료됩니다."),);
              Fluttertoast.showToast(msg: ("로그아웃됩니다.\n프로그램이 종료됩니다."),);

              //socket.disconnect();
              await Future.delayed(Duration(microseconds: 3000));
              SystemNavigator.pop();
            }

            NotificationModel notificationModel = NotificationModel(
              id: int.parse(strList[0]),
              from: int.parse(strList[1]),
              to: int.parse(strList[2]),
              type: GetType(strList[3]),
              index: (strList[4] == null|| strList[4] == "")? -100: int.parse(strList[4]),
              time: strList[5],
              isRead: 0,
            );

            notiList.add(notificationModel);

            if (notificationModel.type == NOTI_EVENT_FIND_ROOM) {
              NeedRoomProposal needRoomProposal = NeedRoomProposal(
                id: notificationModel.id,
                userID: notificationModel.from,
                targetID: notificationModel.to,
                roomSalesID: notificationModel.index,
                updatedAt: notificationModel.time,
                createdAt: notificationModel.time,
              );

              GlobalProfile.needRoomProposal.add(needRoomProposal);
            }
          }

          if(strList[3] != 'LOGOUT'){
            if(kReleaseMode){
              if(Platform.isAndroid){
                Future.microtask(() async => await _localNotification.showNoti(title: message['notification']['title'] as String, des: message['notification']['body'] as String));
              }else if(Platform.isIOS){
                Future.microtask(() async => await _localNotification.showNoti(title: message['aps']['alert']['title']as String, des: message['aps']['alert']['body'] as String));
              }
            }else{
              Future.microtask(() async => await _localNotification.showNoti(title: message['notification']['title'] as String, des: message['notification']['body'] as String));
            }
          }

          return;
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );


  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      //print("Settings registered: $settings");
    });
  }

  showNotification(Map<String, dynamic> msg){
  }

  void SetSubScriptionToTopic(String topic){
    _firebaseMessaging.subscribeToTopic(topic);
  }

  void SetUnSubScriptionToTopic(String topic){
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}