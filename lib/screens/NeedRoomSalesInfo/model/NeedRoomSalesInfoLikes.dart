class NeedRoomSalesInfoLikes {
  int id;
  int UserID;
  int NeedRoomSaleID;
  String updateAt;
  String createAt;

  NeedRoomSalesInfoLikes({this.id,this.createAt,this.NeedRoomSaleID,this.updateAt,this.UserID});

  factory NeedRoomSalesInfoLikes.fromJson(Map<String, dynamic> json){
    return NeedRoomSalesInfoLikes(
      id: json['id'] as int,
      UserID: json['UserID'] as int,
      NeedRoomSaleID: json['NeedRoomSaleID'] as int,
      updateAt: json['updatedAt'] as String,
      createAt: json['createdAt'] as String,
    );
  }
}