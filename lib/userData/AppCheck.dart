
import 'package:mryr/constants/AppConfig.dart';

class AppCheck {
  int id;
  String Title;
  String Ment;
  int Switch;

  AppCheck(
      {this.id,this.Title,this.Ment,this.Switch});

  factory AppCheck.fromJson(Map<String, dynamic> json) {
    /* String url = json["ImgUrl"] as String == null
        ? "BasicImage"s
        : ApiProvider().getImgUrl + json["ImgUrl"];*/

    return AppCheck(
      id: json["id"] as int,
      Title:  json["Title"] as String,
      Ment: json["Ment"]as String,
      Switch: json["Switch"]as int,
    );
  }

  Map<String, dynamic> toJson() => {

  };
}
