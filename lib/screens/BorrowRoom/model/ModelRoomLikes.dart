class ModelRoomLikes {
  int id;
  int UserID;
  int RoomSaleID;
  String updateAt;
  String createAt;

  ModelRoomLikes({this.id,this.createAt,this.RoomSaleID,this.updateAt,this.UserID});

  factory ModelRoomLikes.fromJson(Map<String, dynamic> json){
    return ModelRoomLikes(
      id: json['id'] as int,
      UserID: json['UserID'] as int,
      RoomSaleID: json['RoomSaleID'] as int,
      updateAt: json['updatedAt'] as String,
      createAt: json['createdAt'] as String,
    );
  }
}