class ModelReverse {
  int id;
  int UserID;
  int NeedRoomSaleID;
  String createdAt;
  String updatedAt;



  ModelReverse({this.id,this.UserID,this.createdAt,this.updatedAt,this.NeedRoomSaleID});

  factory ModelReverse.fromJson(Map<String, dynamic> json){
    return ModelReverse(
      id: json['id'] as int,
      UserID: json['UserID'] as int,
      NeedRoomSaleID: json['NeedRoomSaleID'] as int,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}