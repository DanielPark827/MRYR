class GetFindID {
  int UserID;
  String EmailID;

  GetFindID({this.UserID,this.EmailID});

  factory GetFindID.fromJson(Map<String, dynamic> json){
    return GetFindID(
      UserID: json['UserID'] as int,
      EmailID: json['EmailID'] as String
    );
  }
}