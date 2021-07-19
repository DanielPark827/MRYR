
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';

class User1 {
  int userID;
  String name;
  String nickName;
  String id;
  String password;
  bool sex;
  String phone;
  String apple;
  bool kakao;
  String profileUrlList;
  String createdAt;
  String updatedAt;
  String accessToken;
  String refreshToken;

  User1({this.userID, this.name, this.nickName, this.id, this.sex, this.phone, this.apple, this.kakao,
    this.profileUrlList, this.createdAt, this.updatedAt, this.accessToken, this.refreshToken});

  factory User1.fromJson(Map<String, dynamic> json) {

    String url = json["ImgUrl"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+json["ImgUrl"];

    return User1(
        userID: json["UserID"] as int,
        name: json["Name"] as String,
        nickName: json["Nickname"] as String,
        id: json["EmailID"] as String,
        sex : json["Sex"] == null ? false : (json["Sex"] as int).isOdd,
        phone: json["Phone"] as String,
        apple :json["Apple"] as String,
        kakao: json["Kakao"] == null ? false : (json["Kakao"] as int).isOdd,
        profileUrlList: url,
        createdAt: replaceDate(json["createdAt"] as String),
        updatedAt: replaceDate(json["updatedAt"] as String),
        accessToken: json["AccessToken"] as String,
       // refreshToken: json["RefreshToken"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'userID' : userID,
    'name': name,
    'nickName' : nickName,
    'id' : id,
    'sex' : sex,
    'phone' : phone,
    'Apple' : apple,
    'kakao' : kakao,
    'profileURL' : profileUrlList,
    'createdAt' : createdAt,
    'updatedAt' : updatedAt,
    'accessToken' : accessToken,
    'refreshToken' : refreshToken,
  };
}




class ReserveDate {
  int year;
  int month;
  int day;

  ReserveDate({this.year, this.month, this.day});

  factory ReserveDate.fromJson(Map<String, dynamic> json) {

   String tmp =  json["Date"] as String;
    var arr = tmp.split('.');

    return ReserveDate(
     year: int.parse(arr[0]),
     month: int.parse(arr[1]),
     day: int.parse(arr[2]),

    );
  }
  Map<String, dynamic> toJson() => {
    'Date' : (year.toString() + "." + month.toString() + "." +day.toString()),
  };
}


