import 'package:mryr/constants/AppConfig.dart';

class NoticeModel{
  int id;
  String Title;
  String Contents;
  String updatedAt;
  String createAt;

  NoticeModel({this.Title,this.Contents,this.createAt,this.id,this.updatedAt});

  factory NoticeModel.fromJson(Map<String, dynamic> json){
    return NoticeModel(
       Title: json['Title'] as String,
      id: json['id'] as int,
      Contents: json['Contents'] as String,
      updatedAt: (json['updatedAt'] as String),
      createAt: (json['createAt'] as String),
    );
  }
}