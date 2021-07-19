
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';

class CertificationPicture{
  int id;
  int userID;
  int roomID;
  String imageUrl;
  String createdAt;
  String updatedAt;
  String nickName;

  CertificationPicture({this.id,  this.userID, this.roomID, this.imageUrl, this.createdAt, this.updatedAt,this.nickName});

  factory CertificationPicture.fromJson(Map<String, dynamic> json){
    return CertificationPicture(
      id : json['id'],
      userID: json['UserID'],
      roomID: json['RoomID'],
      imageUrl: json["ImgUrl"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImgUrl"],
      createdAt: replaceLocalDate(json['createdAt'] as String),
      updatedAt: replaceLocalDate(json['updatedAt'] as String),
      nickName: json['user']['Nickname'] as String,
    );
  }
}
