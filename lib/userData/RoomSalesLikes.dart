class RoomSalesLikes{
  int id;

  RoomSalesLikes({this.id,});

  factory RoomSalesLikes.fromJson(Map<String, dynamic> json){
    return RoomSalesLikes(
      id : json['UserID'],
    );
  }
}