import 'dart:async';
import 'dart:convert';

import 'package:kakao_flutter_sdk/all.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/MoreScreen/model/NoticeModel.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/userData/Room.dart';

import 'CertificationPicture.dart';
import 'Version.dart';





class GlobalProfile {


  static bool booleanButton = false;

  static List<dynamic> personalProfile = new List<dynamic>();
  static List<dynamic> teamProfile = new List<dynamic>();
  //나에게 맞는 매물 추천
  static List<RoomSalesInfo> listForMe = new List<RoomSalesInfo>();
  //내 방이 필요한 사람들
  static List<NeedRoomInfo> listForMe2 = new List<NeedRoomInfo>();
  static List<ReserveDate> reserveDateList = new List<ReserveDate>();

  static List<ModelRoomLikes> RoomLikesList = new List<ModelRoomLikes>();
  static List<int> RoomLikesIdList = new List<int>();



  static List<CertificationPicture> certificationPicture= new List<CertificationPicture>();

  static String banner;
  static User1 loggedInUser;
  static List<RoomSalesInfo> roomSalesInfoList = new List<RoomSalesInfo>();
  static RoomSalesInfo roomSalesInfo;//check
  static NeedRoomInfo  NeedRoomInfoOfloggedInUser;
  static List<NeedRoomProposal> needRoomProposal = new List<NeedRoomProposal>();
  static List<NoticeModel> ListNoticeModel = [];
  static User kakaoInfo;
  static String IdForKakaoLogin;
  static String PhoneForKakaoLogin;
 // static User appleInfo;
  static String IdForAppleLogin;

  static String accessToken;
  static String refreshToken;
  static String accessTokenExpiredAt;

  //나에게 온 제안 목록
  static List<RoomSalesInfo> roomList = new List<RoomSalesInfo>();
  //거래 진행중 리스트
  static List<RoomSalesInfo> tradingList = new List<RoomSalesInfo>();
  static String tmpNum;


  static List<Review> reviewList = new List<Review>();
  static List<Review> reviewListStar = new List<Review>();
  static List<Review> filteredReview = new List<Review>();
  static List<DetailReview> detailReviewList = new List<DetailReview>();
  static List<DetailReview> detailReview3Room = new List<DetailReview>();
  static List<Review> reviewForMain = new List<Review>();

  static User1 getUserByUserIDLogin(int userID){
    User1 user = null;
    Set<dynamic> set = Set.from(personalProfile);
    for (int i = 0; i < set.length; ++i) {
      set.forEach((element) {
        if (element['UserID'] == userID) {
          user = User1.fromJson(element);
        }
      });
    }

    return user;
  }

  static Future<User1> getFutureUserByUserID(int userID) async {
    if(loggedInUser.userID == userID) return Future.value(loggedInUser);

    Set<dynamic> set = Set.from(personalProfile);
    for (int i = 0; i < set.length; ++i) {
      set.forEach((element) {
        if (element['UserID'] == userID) {
          return Future.value(personalProfile[i]);
        }
      });
    }

    var res = await ApiProvider().post('/User/UserSelect', jsonEncode(
        {
          "userID" : userID
        }
    ));

    personalProfile.add(res);

    return Future.value(User1.fromJson(res));
  }


  static User1 getUserByUserID(int userID) {
    User1 user = null;
    Set<dynamic> set = Set.from(personalProfile);
    for (int i = 0; i < set.length; ++i) {
      set.forEach((element) {
        if (element['UserID'] == userID) {
          user = User1.fromJson(element);
        }
      });
    }

    //받아온 데이터 중에서 없으면
    if(null == user){
      if(loggedInUser.userID == userID){
        user = loggedInUser;
      }else{
        Future.microtask(() async => {
          user  = await GlobalProfile().selectAndAddUser(userID)
        });
      }
    }

    return user;
  }

  //데이터를 받아와 저장함
  Future<User1> selectAndAddUser(int userID) async {
    var res = await ApiProvider().post('/User/UserSelect', jsonEncode(
        {
          "userID" : userID
        }
    ));

    if(res == null){
      return null;
    }

    User1 user = User1.fromJson(res);
    personalProfile.add(res);

    return user;
  }

  static User1 getUserByIndex(int index) {
    if (index >= personalProfile.length) return null;

    return User1.fromJson(personalProfile[index]);
  }


  //flag == 1 :최근접속순, flag == 2 :보유 뱃지 순, flag == 3 :신규 가입 순순
  static void sortPersonalProfileListInTime(int flag) {
    int personalProfileLength = GlobalProfile.personalProfile.length;
    List<User1> userList = [];
    for (int i = 0; i < personalProfileLength; i++) {
      userList.add(GlobalProfile.getUserByIndex(i));
    }
    userList.sort((a, b) => flag == 0
        ? int.parse(a.updatedAt).compareTo(int.parse(b.updatedAt))
        : flag == 1
            ? null
            : int.parse(a.createdAt).compareTo(int.parse(b.createdAt)));
    GlobalProfile.personalProfile = userList;
  }

  static void acceceTokenCheck() {
    Timer.periodic(Duration(minutes: 5), (timer) {
      if(int.parse(accessTokenExpiredAt) > int.parse(DateTime.now().millisecondsSinceEpoch.toString().substring(0,10))){
        Future.microtask(() async {
          var res = await ApiProvider().post('/User/Login/Token', jsonEncode({
            "userID" : loggedInUser.userID,
            "refreshToken" : refreshToken
          }));

          accessToken = res['AccessToken'] as String;
          accessTokenExpiredAt =  (res['AccessTokenExpiredAt'] as int).toString();
        });
      }
    });
  }
}
