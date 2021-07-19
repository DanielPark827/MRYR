
import 'package:flutter/cupertino.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/userData/User.dart';

class NeedRoomInfo  with ChangeNotifier {
  int id;
  int UserID;
  int Type;
  int DepositeFeesMin;
  int DepositeFeesMax;
  int MonthlyFeesMin;
  int MonthlyFeesMax;
  String TermOfLeaseMin;
  String TermOfLeaseMax;
  int PreferTerm;
  int PreferSex;
  int SmokingPossible;
  String Location;
  String Information;
  String createdAt;
  String updatedAt;
  String ImgUrl;

  bool Likes = false;

  void ChangeTotal(int type, int depositeFeesMin, int depositeFeesMax,int monthlyFeesMin, int monthlyFeesMax,String termOfLeaseMin,String termOfLeaseMax,
      int preferTerm, int preferSex, int smokingPossible,String location,String information ){
    Type = type;
    DepositeFeesMin = depositeFeesMin.toInt();

    DepositeFeesMax= depositeFeesMax.toInt();
    MonthlyFeesMin = monthlyFeesMin.toInt();
    MonthlyFeesMax = monthlyFeesMax.toInt();
    TermOfLeaseMin = termChange(termOfLeaseMin);
    TermOfLeaseMax = termChange(termOfLeaseMax);
    PreferTerm = preferTerm;
    PreferSex = preferSex;
    SmokingPossible = smokingPossible;
    Location = "인하대학교";
    Information = information;
    notifyListeners();
  }

  void ChangeLikes(bool value) {
    Likes = value;
    notifyListeners();
  }



  NeedRoomInfo({this.id, this.UserID, this.Type, this.DepositeFeesMax, this.DepositeFeesMin, this.MonthlyFeesMax, this.MonthlyFeesMin, this.TermOfLeaseMax
  , this.TermOfLeaseMin, this.PreferSex, this.PreferTerm, this.SmokingPossible, this.Location,this.Information ,this.createdAt, this.updatedAt,this.ImgUrl,this.Likes});

  factory NeedRoomInfo.fromJson(Map<String, dynamic> json) {

    return NeedRoomInfo(
      id: json["id"] as int,
      UserID: json["UserID"] as int,
      Type: json["Type"] as int,
      DepositeFeesMin: json["DepositeFeesMin"] as int,
      DepositeFeesMax : json["DepositeFeesMax"] as int,
      MonthlyFeesMin: json["MonthlyFeesMin"] as int,
      MonthlyFeesMax: json["MonthlyFeesMax"] as int,
      TermOfLeaseMin: json["TermOfLeaseMin"] as String,
      TermOfLeaseMax: json["TermOfLeaseMax"] as String,
      PreferTerm: json["PreferTerm"] as int,
      PreferSex: json["PreferSex"] as int,
      SmokingPossible: json["SmokingPossible"] as int,
      Location: json["Location"] as String,
      Information: json["Information"] as String,
      createdAt: replaceDate(json["createdAt"] as String),
      updatedAt: replaceDate(json["updatedAt"] as String),
     // ImgUrl:User1.fromJson(json["user"]).profileUrlList,
      Likes: false,
     );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'UserID':UserID,
    'Type':Type,
    "DepositeFeesMin": DepositeFeesMin,
    "DepositeFeesMax":DepositeFeesMax,
    "MonthlyFeesMin":MonthlyFeesMin,
    "MonthlyFeesMax":MonthlyFeesMax,
    "TermOfLeaseMin": TermOfLeaseMin,
    "TermOfLeaseMax": TermOfLeaseMax,
    "PreferTerm":PreferTerm,
    "PreferSex":PreferSex,
    "SmokingPossible":SmokingPossible,
    "Location":Location,
    "Information" : Information,
    "createdAt":createdAt,
    "updatedAt":updatedAt,
    "ImgUrl":ImgUrl,
  };
}

List<NeedRoomInfo> needRoomSalesInfoList = new List<NeedRoomInfo>();
List<NeedRoomInfo> needRoomSalesInfoListFiltered = new List<NeedRoomInfo>();

NeedRoomInfo getRoomSalesInfoById(int id) {
  NeedRoomInfo item;


  for(int i = 0; i < needRoomSalesInfoList.length; i++) {
    if(needRoomSalesInfoList[i].id == id) {
      item = needRoomSalesInfoList[i];
      break;
    }
  }

  return item;
}

String getTermStr(int type){
  String str;

  switch(type){
    case 0:
      str = '단기임대';
      break;
    case 1:
      str = '장기임대';
      break;
    case 2:
      str = '기간무관';
      break;
    default:
      str = '기간무관';
      break;
  }

  return str;
}

String getSexStr(int type){
  String str;

  switch(type){
    case 0:
      str = '남자선호';
      break;
    case 1:
      str = '여자선호';
      break;
    case 2:
      str = '성별무관';
      break;
    default:
      str = '성별무관';
      break;
  }

  return str;
}

String getSmokingPossibleStr(int type){
  String str;

  switch(type){
    case 0:
      str = '흡연가능';
      break;
    case 1:
      str = '흡연불가';
      break;
    case 2:
      str = '흡연무관';
      break;
    default:
      str = "흡연무관";
      break;
  }

  return str;
}

String getMonthlyFeesStr(int min, int max){
  return "월세 " + min.toString() + ' ~ ' + max.toString() + ' 만원';
}

String getDepositeFeesStr(int min, int max){
  return "희망보증금 " + min.toString() + '만원'+ ' ~ ' + max.toString() + ' 만원';
}

String getMonthAndDay(String date){
  List<String> strList = date.split('.');
  return strList[1] + '/' + strList[2];
}

String getYearMonthDay(String date){
  List<String> strList = date.split('.');

  return strList[0] + "년" + strList[1] + '월' + strList[2] + '일';
}