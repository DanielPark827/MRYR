import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';

class ModelModifyReleaseRoom with ChangeNotifier {
  int     id;
  int     userID;
  int     type;
  String  location;
  String  locationDetail;
  int     square;
  int     monthlyRentFees;
  int     depositFees;
  int     managementFees;
  int     utilityFees;
  int     depositFeesOffer;
  int     monthlyRentFeesOffer;

  String  termOfLeaseMin;
  String  termOfLeaseMax;
  int     preferenceSex;
  int     preferenceSmoking;
  int     preferenceTerm;
  bool    bed;
  bool    desk;
  bool    chair;
  bool    closet;
  bool    aircon;
  bool    induction;
  bool    refrigerator;
  bool    doorLock;
  bool    tv;
  bool    microwave;
  bool    washingMachine;
  bool    hallwayCCTV;
  bool    wifi;
  String  information;
  String  imageUrl1;
  String  imageUrl2;
  String  imageUrl3;
  String  imageUrl4;
  String  imageUrl5;
  int     tradingState;
  String openchat;
  String  createdAt;
  String  updatedAt;


  bool Likes = false;

  void ChangeLikes(bool value) {
    Likes = value;
    notifyListeners();
  }

  ModelModifyReleaseRoom({
    this.id,this.userID,this.type,this.location,this.locationDetail,this.square,this.monthlyRentFees,this.depositFees,this.managementFees,this.depositFeesOffer,this.utilityFees,this.monthlyRentFeesOffer,
    this.termOfLeaseMin,this.termOfLeaseMax,this.preferenceSex,this.preferenceSmoking,this.preferenceTerm,
    this.bed, this.desk, this.chair, this.closet, this.aircon, this.induction, this.refrigerator,
    this.doorLock, this.tv,this.microwave, this.washingMachine, this.hallwayCCTV, this.wifi,
    this.information,this.imageUrl1,this.imageUrl2,this.imageUrl3,this.imageUrl4,this.imageUrl5,this.tradingState,
    this.createdAt,this.updatedAt,this.openchat,
  });

  factory ModelModifyReleaseRoom.fromJson(Map<String, dynamic> json) {
    return ModelModifyReleaseRoom(
      id: json["id"] as int,
      userID: json["UserID"] as int,
      type: json["Type"] as int,
      location: json["Location"] as String,
      locationDetail: json["LocationDetail"] as String,
      square: json["square"] as int,
      monthlyRentFees: json["MonthlyRentFees"] as int,
      depositFees: json["DepositFees"] as int,
      depositFeesOffer : json["DepositFeesOffer"] as int,
      managementFees: json["ManagementFees"] as int,
      utilityFees: json["UtilityFees"] as int,
      monthlyRentFeesOffer: json["MonthlyRentFeesOffer"] as int,
      termOfLeaseMin: json["RentStart"] as String,
      termOfLeaseMax: json["RentDone"] as String,
      preferenceSex: json["PreferenceSex"] as int,
      preferenceSmoking: json["PreferenceSmoking"] as int,
      preferenceTerm: json["PreferenceTerm"] as int,
      bed: json["Bed"] as bool,
      desk: json["Desk"] as bool,
      chair: json["Chair"] as bool,
      closet: json["Closet"] as bool,
      aircon: json["Aircon"] as bool,
      induction: json["Induction"] as bool,
      refrigerator: json["Refrigerator"] as bool,
      doorLock: json["DoorLock"] as bool,
      tv: json["TV"] as bool,
      microwave: json["Microwave"] as bool,
      washingMachine: json["WashingMachine"] as bool,
      hallwayCCTV: json["HallwayCCTV"] as bool,
      wifi: json["Wifi"] as bool,
      information: json["Information"] as String,
      imageUrl1: json["ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+json["ImageUrl1"], //json["ImageUrl1"] as String,
      imageUrl2:   json["ImageUrl2"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+json["ImageUrl2"], // //json["ImageUrl2"] as String,
      imageUrl3: json["ImageUrl3"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+json["ImageUrl3"], // //json["ImageUrl3"] as String,
      imageUrl4:  json["ImageUrl4"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl4"], //  //json["ImageUrl4"] as String,
      imageUrl5:   json["ImageUrl5"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl5"], ////json["ImageUrl5"] as String,
      tradingState: json["TradingState"] as int,
      openchat: json["Openchat"] as String,
      createdAt:  replaceDate(json["createdAt"] as String),
      updatedAt:  replaceDate(json["updatedAt"] as String),
    );
  }
}