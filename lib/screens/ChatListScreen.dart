import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatBubble.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/ChatScreenDropDownProvider.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/ChatListScreen/BottomSheetInChatListScreen.dart';
import 'package:mryr/widget/DashBoardScreen/StringForDashBoardScreen.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:provider/provider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with SingleTickerProviderStateMixin {

  ChatGlobal _global;
 // SocketProvider _socket;

  _chatBubble(int messageCount) {
    TextStyle textStyle = TextStyle(
      fontSize: screenHeight * 0.015625,
      //color: fromMe ? Colors.white : Colors.black54,
      color: hexToColor('#FFFFFF'),
    );
    //Color chatBgColor = fromMe ? Colors.blue : Colors.black12;
    Color chatBgColor = hexToColor('#6F22D2');

    String messageCountText = messageCount.toString();
    if (messageCount >= 100) messageCountText = "99+";

    //if (messageCount == 0) return Container();

    return Container(
      color: Colors.white,
      //margin: margins,
      child: Column(
        children: <Widget>[
          CustomPaint(
            painter: ChatBubble(
              color: chatBgColor,
              alignment: Alignment.topRight,
            ),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 12, 5),
                    child: Text(
                      messageCountText,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimationController extendedController;
  @override
  void initState() {
    super.initState();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

    chatRoomUserListSort();
  }
  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    _global = Provider.of<ChatGlobal>(context);

   /* if(null == _socket) _socket = Provider.of<SocketProvider>(context);

    if(_socket != null && _socket.socket != null) {

      _socket.socket.on(SocketProvider.ROOM_RECEIVED_EVENT, (data) async{
        if(!mounted) return;

        await Future.microtask(() {
          setState(() {
            ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel.fromJson(data);
            chatRecvMessageModel.isRead = 0;
            chatRecvMessageModel.isContinue = true;

            bool isHave = false;
            for(int i = 0 ; i < chatRoomUserList.length; ++i){
              if(chatRecvMessageModel.roomId == chatRoomUserList[i].id){
                _global.getRoomInfoList[chatRecvMessageModel.roomId].date = getRoomTime(DateTime.now().toLocal());
                //_global.getRoomInfoList[chatRecvMessageModel.roomId].messageCount += 1;
                _global.getRoomInfoList[chatRecvMessageModel.roomId].lastMessage = getRoomMessage( getMessageTypeByInt(chatRecvMessageModel.messageType), chatRecvMessageModel.message);

                if(getMessageTypeByInt(chatRecvMessageModel.messageType) != MESSAGE_TYPE.MESSAGE && getMessageTypeByInt(chatRecvMessageModel.messageType) != MESSAGE_TYPE.IMAGE)
                  _global.setRoomState(chatRoomUserList[i].id, getRoomStateByMessageType(getMessageTypeByInt(chatRecvMessageModel.messageType)));

                //_global.getRoomInfoList[chatRecvMessageModel.roomId].chatList.add(chatRecvMessageModel);
                ChatGlobal.addChatRecvMessage(chatRecvMessageModel.roomId, chatRecvMessageModel);

                if(getMessageTypeByInt(chatRecvMessageModel.messageType) != MESSAGE_TYPE.MESSAGE && getMessageTypeByInt(chatRecvMessageModel.messageType) != MESSAGE_TYPE.IMAGE)
                  chatRoomUserList[i].roomState = getValueByRoomState(getRoomStateByMessageType(getMessageTypeByInt(chatRecvMessageModel.messageType)));

                chatRoomUserList[i].updatedAt = getRoomTime(DateTime.now().toLocal());
                chatRoomUserList[i].createdAt = getRoomTime(DateTime.now().toLocal());

                isHave = true;
                chatRoomUserListSort();
                break;
              }
            }

            if(false == isHave){
              RoomInfo roomInfo = new RoomInfo(
                  lastMessage: "문의를 보냈습니다",
                  date: chatRecvMessageModel.updatedAt,
                  roomState: ROOM_STATE.INQUIRE,
                  messageCount: 0,
                  chatList: new List<ChatRecvMessageModel>()
              );

              roomInfo.chatList.add(chatRecvMessageModel);

              int id = chatRecvMessageModel.roomId;
              _global.getRoomInfoList[id] = roomInfo;

              ChatRoomUser chatRoomUser = ChatRoomUser();
              chatRoomUser.id = chatRecvMessageModel.roomId;
              chatRoomUser.roomSaleID = chatRecvMessageModel.roomSalesID;
              chatRoomUser.roomState = getValueByRoomState(ROOM_STATE.INQUIRE);
              chatRoomUser.userID = chatRecvMessageModel.to;
              chatRoomUser.chatID = chatRecvMessageModel.from;
              chatRoomUser.updatedAt = getRoomTime(DateTime.now().toLocal());
              chatRoomUser.createdAt = getRoomTime(DateTime.now().toLocal());
              chatRoomUserList.add(chatRoomUser);
              chatRoomUserListSort();
            }
          });
        });
      }
      );
    }
*/
    setState(() {

    });

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          title: SvgPicture.asset(
            MryrLogoInReleaseRoomTutorialScreen,
            width: screenHeight * (110 / 640),
            height: screenHeight * (27 / 640),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.white,
                child: SizedBox(height: screenHeight * (20/640),)),
            Container(
              padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                child:
                Text('채팅 목록', style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 16/360), textAlign: TextAlign.start,)),
            SizedBox(height: screenHeight * 12/640,),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context,index) => Container(
                    height: 1, width: double.infinity, color: Color(0xFFEFEFEF)),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: chatRoomUserList.length ,
                itemBuilder: (BuildContext context, int index) =>
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: screenWidth * 12/360,),
                          GestureDetector(
                            onTap: () {
                           //   _socket.setRoomStatus(ROOM_STATUS_CHAT);

                              _global.getRoomInfoList[chatRoomUserList[index].id].messageCount = 0;

                              int chatID = GlobalProfile.loggedInUser.userID == chatRoomUserList[index].chatID ? chatRoomUserList[index].userID : chatRoomUserList[index].chatID;

                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChatPage(
                                            chatUser: GlobalProfile.getUserByUserID(chatID),
                                            chatRoomUser: chatRoomUserList[index],
                                            roomSalesInfo: getRoomSalesInfoByID(chatRoomUserList[index].roomSaleID),
                                            isProposal: false,
                                          )
                                  ) // SecondRoute를 생성하여 적재
                              ).then((value) {

                             //   _socket.setRoomStatus(ROOM_STATUS_ROOM);

                              setState(() {
                                _global.getRoomInfoList[chatRoomUserList[index].id].messageCount = 0;
                              });
                              });
                            },
                            child: Container(
                              width: screenWidth * ((360-24) / 360),
                              child: Row(
                                children: [
                                  Container(
                                    width:screenHeight * (36/640),
                                    height: screenHeight * (36/640),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Color.fromRGBO(166, 125, 130, 0.2),
                                          blurRadius: 4,
                                        ),],
                                    ),
                                    child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(8.0),
                                        child: GlobalProfile.getUserByUserID(
                                            GlobalProfile.loggedInUser.userID == chatRoomUserList[index].chatID ?
                                            chatRoomUserList[index].userID :
                                            chatRoomUserList[index].chatID
                                          ).profileUrlList =="BasicImage"
                                            ?
                                        SvgPicture.asset(
                                          ProfileIconInMoreScreen,
                                          width: screenHeight * (60 / 640),
                                          height: screenHeight * (60 / 640),
                                        )
                                            :  FittedBox(
                                          fit: BoxFit.cover,
                                          child:    getExtendedImage( get_resize_image_name(GlobalProfile.getUserByUserID(
                                              GlobalProfile.loggedInUser.userID == chatRoomUserList[index].chatID ?
                                              chatRoomUserList[index].userID :
                                              chatRoomUserList[index].chatID
                                          ).profileUrlList,120), 60,extendedController),
                                        )
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * (4/360),),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: screenHeight * 12/640,),
                                      Row(
                                        children: [

                                          Text(
                                            GlobalProfile.loggedInUser.userID == chatRoomUserList[index].chatID ?
                                            GlobalProfile.getUserByUserID(chatRoomUserList[index].userID).nickName :
                                            GlobalProfile.getUserByUserID(chatRoomUserList[index].chatID).nickName
                                            ,
                                            style: TextStyle(fontSize: screenWidth * 14/360,fontWeight: FontWeight.bold),),
                                          SizedBox(width: screenWidth * 4/360,),
                                          _chatBubble(_global.getRoomInfoList[chatRoomUserList[index].id].messageCount)
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 4/640,),
                                      Text(
                                        _global.getRoomInfoList[chatRoomUserList[index].id].lastMessage,
                                        style: TextStyle(fontSize: screenWidth * 10/360,
                                            color: hexToColor('#888888')),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                      SizedBox(height: screenHeight * 12/640,),
                                    ],
                                  ),
                                  //SizedBox(width: screenWidth * 136/360,),
                                  Spacer(),
                                  Column(

                                  children: [
                                    SizedBox(height: screenHeight * 23/640,),
                                    Text(timeCheck(_global.getRoomInfoList[chatRoomUserList[index].id].date), style: TextStyle(fontSize: screenWidth * 10/360, color: hexToColor('#888888')),),
                                  ],
                                  ),

                                  SizedBox(width: screenWidth * 4/360,),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context, // 기본 파라미터, SecondRoute로 전달
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailedRoomInformation(
                                                    roomSalesInfo: getRoomSalesInfoByID(chatRoomUserList[index].roomSaleID),
                                                  )) // SecondRoute를 생성하여 적재
                                      );
                                    },
                                    child: Container(
                                      width: screenWidth * (44/360),
                                      height: screenHeight * (36/640),
                                      child: ClipRRect(
                                        borderRadius: new BorderRadius.circular(4.0),
                                        child:
                                        getRoomSalesInfoByID(chatRoomUserList[index].roomSaleID).imageUrl1=="BasicImage"
                                            ?
                                        SvgPicture.asset(
                                          ProfileIconInMoreScreen,
                                          width: screenHeight * (60 / 640),
                                          height: screenHeight * (60 / 640),
                                        )
                                            :  FittedBox(
                                            fit: BoxFit.cover,
                                            child: getExtendedImage(get_resize_image_name(getRoomSalesInfoByID(chatRoomUserList[index].roomSaleID).imageUrl1,360), 0,extendedController),
                                        )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                        ],
                      ),
                      Container(
                          height: 1, width: double.infinity, color: Color(0xFFEFEFEF)),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
