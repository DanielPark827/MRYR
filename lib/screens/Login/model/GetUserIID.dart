class GetUserID {
  int UserID;

  GetUserID({this.UserID});

  factory GetUserID.fromJson(Map<String, dynamic> json){
    return GetUserID(
      UserID: json['UserID'] as int,
    );
  }
}