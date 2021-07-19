import 'dart:ffi';
import 'dart:io';

import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';


class Review {
  String Location;
  String LocationDetail;
  int Type;
  String ImageUrl;
  double StarAvg;
  int CountId;
  String createdAt;
  double lat;
  double lng;

  Review({
    this.Location,
    this.LocationDetail,
    this.Type,
    this.ImageUrl,
    this.StarAvg,
    this.CountId,
    this.createdAt,
    this.lat,
    this.lng,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      Location: json['Location'],
      LocationDetail: json['LocationDetail'],
      Type: json['Type'] as int,
      ImageUrl: json["ImageUrl"] as String == null
          ? "BasicImage"
          : ApiProvider().getImgUrl +  json["ImageUrl"],
      //json["ImageUrl1"] as String,

      StarAvg: (json['StarAvg'] + 0.0) as double,
      CountId: json['CountId'] as int,
      createdAt: replaceUTCDate(json['createdAt'] as String),
      lng: json["Longitude"] as double,
      lat: json["Latitude"] as double,
    );
  }
}

class DetailReview {
  int id;
  int UserId;
  int Type;
  String Location;
  String LocationDetail;
  int MonthlyRentFees;
  int DepositFees;
  int ManagementFees;
  int UtilityFees;
  String ImageUrl1;
  String ImageUrl2;
  String ImageUrl3;
  String ImageUrl4;
  String ImageUrl5;
  String StarRating;
  int HowNoise;
  int HowBug;
  int HowKind;
  String NoiseReviewDetail;
  String BugReviewDetail;
  String KindReviewDetail;
  String InformationDetail;
  String PhoneNumber;
  String createdAt;
  String updatedAt;
  userT user;
  String startdate;
  String enddate;

  DetailReview({
    this.id,
    this.UserId,
    this.Type,
    this.Location,
    this.LocationDetail,
    this.MonthlyRentFees,
    this.DepositFees,
    this.ManagementFees,
    this.UtilityFees,
    this.ImageUrl1,
    this.ImageUrl2,
    this.ImageUrl3,
    this.ImageUrl4,
    this.ImageUrl5,
    this.StarRating,
    this.HowNoise,
    this.HowBug,
    this.HowKind,
    this.NoiseReviewDetail,
    this.BugReviewDetail,
    this.KindReviewDetail,
    this.InformationDetail,
    this.PhoneNumber,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.startdate,
    this.enddate,
  });

  factory DetailReview.fromJson(Map<String, dynamic> json) {
    return DetailReview(
      id: json['id'] as int,
      UserId: json['UserId'] as int,
      Type: json['Type'] as int,
      Location: json['Location'] as String,
      LocationDetail: json['LocationDetail'] as String,
      MonthlyRentFees: json['MonthlyRentFees'] as int,
      DepositFees: json['DepositFees'] as int,
      ManagementFees: json['ManagementFees'] as int,
      UtilityFees: json['UtilityFees']as int,
      ImageUrl1: json["ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl1"], //json["ImageUrl1"] as String,
      ImageUrl2:   json["ImageUrl2"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl2"], // //json["ImageUrl2"] as String,
      ImageUrl3: json["ImageUrl3"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl3"], // //json["ImageUrl3"] as String,
      ImageUrl4:  json["ImageUrl4"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl4"], //  //json["ImageUrl4"] as String,
      ImageUrl5:   json["ImageUrl5"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+ json["ImageUrl5"], ////json["ImageUrl5"] as String,
      StarRating: json['StarRating'] as String,
      HowNoise: json['HowNoise'] as int,
      HowBug: json['HowBug'] as int,
      HowKind: json['HowKind'] as int,
      NoiseReviewDetail: json['NoiseReviewDetail'] as String,
      BugReviewDetail: json['BugReviewDetail'] as String,
      KindReviewDetail: json['KindReviewDetail'] as String,
      InformationDetail: json['InformationDetail'] as String,
      PhoneNumber: json['PhoneNumber'] as String,
      startdate: json['StartDate']as String,
      enddate: json['EndDate'] as String,
      createdAt:  replaceLocalDate(json["createdAt"] as String),
      updatedAt:  replaceLocalDate(json["updatedAt"] as String),
      user: userT.fromJson(json['user']),
    );
  }
}

class userT {
  String Nickname;
  String ImgUrl;

  userT({
    this.Nickname,
    this.ImgUrl,
  });

  factory userT.fromJson(Map<String, dynamic> json) {
    return userT(
      Nickname: json["Nickname"] as String == null ? "익명" : json["Nickname"] as String ,
      ImgUrl: json["ImgUrl"] as String == null ? "BasicImage" : ApiProvider().getUrl+"/"+ json["ImgUrl"], //json["ImageUrl1"] as String,

    );
  }
}

class Review1 {
  int userid;
  int type = -1;
  String location;
  String locationdetail;
  int monthlyrentfees;
  int depositfees;
  int managementfees;
  int utilityfees;
  int starrating;
  int hownoise;
  String noisedetail;
  int howbug;
  String bugdetail;
  int howkind;
  String kinddetail;
  String infodetail;
  List<File> Images = [];

  Review1(
      {this.userid,
      this.type,
      this.location,
      this.locationdetail,
      this.monthlyrentfees,
      this.depositfees,
      this.managementfees,
      this.utilityfees,
      this.starrating,
      this.hownoise,
      this.noisedetail,
      this.howbug,
      this.bugdetail,
      this.howkind,
      this.kinddetail,
      this.infodetail,
      this.Images});

  factory Review1.fromJson(Map<String, dynamic> json) {
    return Review1();
  }
}
