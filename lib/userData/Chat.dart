import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';

import 'Room.dart';

//채팅창목록
List<Chat> chatInfoList = new List<Chat>();
//안읽은채팅
int chatSum;
//채팅갯수
int chatNum = 0;
//각채팅내 방정보
RoomSalesInfo chatRoomDetail;
//각채팅내 채팅리스트
List<EachChat> eachChatList = new List<EachChat>();

//중복체크
bool mulCheck = false;

class Chat {
  int roomID;
  int senderID;
  String senderNickName;
  String senderImg;
  int receiverID;
  String receiverNickName;
  String receiverImg;
  String contents;
  int messRoomID;
  int maxID;
  String roomImgUrl;
  int notYetView;
  String updatedAt;

  Chat(
      {this.roomID,this.senderID,this.receiverID,this.updatedAt,this.contents,this.maxID,this.messRoomID,this.receiverImg,this.receiverNickName,this.roomImgUrl,this.senderImg,this.senderNickName,this.notYetView});

  factory Chat.fromJson(Map<String, dynamic> json,String json2) {
    /* String url = json["ImgUrl"] as String == null
        ? "BasicImage"s
        : ApiProvider().getImgUrl + json["ImgUrl"];*/

    return Chat(
      roomID: json["RoomID"] as int,
      senderID: json["SenderID"] as int,
      senderNickName: json["SenderIDfk.Sender_Nickname"]as String,
      senderImg:json["SenderIDfk.Sender_ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl + json["SenderIDfk.Sender_ImageUrl1"],
      receiverID: json["ReceiverID"] as int,
      receiverNickName: json["ReceiverIDfk.Receiver_Nickname"]as String,
      receiverImg:  json["ReceiverIDfk.Receiver_ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl + json["ReceiverIDfk.Receiver_ImageUrl1"],
      contents: json2,
      messRoomID: json["MessRoomID"] as int,
      maxID: json["max_id"] as int,
      roomImgUrl: json["RoomSalesInfo.ImageUrl1"] as String == null ? "BasicImage" : ApiProvider().getImgUrl + json["RoomSalesInfo.ImageUrl1"],
      notYetView: json["NotYetView"] as int,
      updatedAt: replaceLocalDate(json["UpdatedAt"] as String),
    );
  }

  Map<String, dynamic> toJson() => {

  };
}



class EachChat {

  int id;
  int senderID;
  int receiverID;
  int roomID;
  List<String> contents = new List<String>();
  bool view;
  int messRoomID;
  bool img;
  String createdAt;
  EachChat(
      {
        this.roomID,this.createdAt,this.receiverID,this.id,this.contents,this.senderID,this.view,this.messRoomID,this.img
      });

  factory EachChat.fromJson(Map<String, dynamic> json) {
    String url = json["ImgUrl"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+json["ImgUrl"];
    String tmp = (json["Img"]as bool == true)?  json["Contents"] as String == null ? "BasicImage" : ApiProvider().getImgUrl+json["Contents"] :json["Contents"]as String;
    List<String> tmpList = new List<String>();
    tmpList.add(tmp);
    return EachChat(
      id:  json["id"] as int,
      senderID: json["SenderID"] as int,
      receiverID: json["ReceiverID"] as int,
      roomID: json["RoomID"] as int,
      contents: tmpList,
      view: json["View"] as bool,
      messRoomID: json["MessRoomID"]as int,
      img: json["Img"]as bool,
      createdAt: (json["createdAt"] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'SenderID': senderID,
    'ReceiverID' : receiverID,
    'RoomID': roomID,
    'Contents': contents,
    "View": view,
    'createdAt':createdAt,
  };
}
