
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';

class Version{
  int id;
  String Ios;
  String Android;


  Version({this.id,this.Ios,this.Android});

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      id: json["id"] as int,
      Ios: json["Ios"] as String,
      Android: json["Android"]as String,
      // refreshToken: json["RefreshToken"] as String,
    );
  }

  Map<String, dynamic> toJson() => {

    'id' : id,
    'Ios': Ios,
    'Android' : Android,
  };
}


