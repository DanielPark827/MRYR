import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mryr/chat/ChatPage.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/DateInRequestTradeBottomSheetProvider.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/dummyData/DummyModifiedProfile.dart';
import 'package:mryr/dummyData/DummyProposeForBorrow.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/model/ChatScreenDropDownProvider.dart';
import 'package:mryr/model/DashBoardAdPagesProvider.dart';
import 'package:mryr/model/DateInLookForRoomsScreenProvider.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/model/ImgFilesProvider.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/model/ReleaseRoomAuthStateProvider.dart';
import 'package:mryr/model/RoomListScreenProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/RoomForBorrowList.dart';
import 'package:mryr/screens/Certiciation_ModifyPhoneNum.dart';
import 'package:mryr/screens/Chat/ChatScreen.dart';
import 'package:mryr/screens/Login/Certification_FindId.dart';
import 'package:mryr/screens/Login/Certification_FindId_Result.dart';
import 'package:mryr/screens/Login/Certification_FindPW.dart';
import 'package:mryr/screens/Login/Certification_FindPW_Result.dart';
import 'package:mryr/screens/Login/ModifyPWComplete.dart';
import 'package:mryr/screens/LoginMainScreen.dart';
import 'package:mryr/screens/MoreScreen/CertificateResultForMyPage.dart';
import 'package:mryr/screens/MoreScreen/MoreScreen.dart';
import 'package:mryr/screens/Registration/Certification.dart';
import 'package:mryr/screens/ReleaseRoom/MainReleaseRoomScreen.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyDescription.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyImg.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyItemCategory.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyItemInfo.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyItemLocation.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyOption.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyPrice.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyRoomItemInfo.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifySuggestion.dart';
import 'package:mryr/screens/ReleaseRoom/ModifyReleaseRoom/ModifyTerm.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/MyRoomList.dart';
import 'package:mryr/screens/ReleaseRoom/ReleaseRoomTutorialScreen.dart';
import 'package:mryr/screens/RoomWannaLive.dart';
import 'package:mryr/screens/Setting/MainSetting.dart';
import 'package:mryr/screens/Setting/TermsOfUse.dart';
import 'package:mryr/screens/Setting/tutorial/TutorialShortInSetting.dart';
import 'package:mryr/screens/TotalNotificationPage.dart';
import 'package:mryr/screens/TutorialForLong.dart';
import 'package:mryr/screens/TutorialScreen.dart';
import 'package:mryr/screens/ChatListScreen.dart';
import 'package:mryr/screens/DashBoardScreen.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/Chat.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/widget/NotificationScreen/LocalNotiProvider.dart';
import 'package:mryr/widget/NotificationScreen/NotiDatabase.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:mryr/screens/Login/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Registration/RegistrationPage.dart';
import 'screens/ReleaseRoom/NewRoom/ItemDescription.dart';
import 'screens/ReleaseRoom/NewRoom/ItemImg.dart';
import 'screens/ReleaseRoom/NewRoom/ItemLocation.dart';
import 'screens/ReleaseRoom/NewRoom/OtherSuggestion.dart';
import 'screens/ReleaseRoom/NewRoom/ProposePrice.dart';
import 'screens/ReleaseRoom/NewRoom/ProposeTerm.dart';
import 'screens/ReleaseRoom/NewRoom/PutItemInfo.dart';
import 'screens/ReleaseRoom/NewRoom/SelectItemCategory.dart';
import 'screens/ReleaseRoom/NewRoom/SelectOption.dart';
import 'screens/Review/ReviewScreenInMapMain.dart';
import 'package:mryr/screens/BorrowRoom/GoogleMap/SearchMapForReleaseRoom.dart';
import 'package:mryr/screens/BorrowRoom/GoogleMap/addressComplteForReleaseRoom.dart';

import 'userData/Review.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({Key key, this.child}) : super(key: key);

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {

 // SocketProvider socket;
  ChatGlobal _chatGlobal;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');

  /*  List<StoppableService> services = [
      socket
    ];*/

   /* services.forEach((service) async {
      if(state == AppLifecycleState.resumed){
        service.start();

        var notiListGet = await ApiProvider().post('/Notification/UnSendSelect', jsonEncode(
            {
              "userID" : GlobalProfile.loggedInUser.userID,
            }
        ));

        if(null != notiListGet){
          for(int i = 0; i < notiListGet.length; ++i){
            NotificationModel noti = NotificationModel.fromJson(notiListGet[i]);
            notiList.add(noti);
            await NotiDBHelper().createData(noti);

            if (noti.type == NOTI_EVENT_FIND_ROOM) {
              NeedRoomProposal needRoomProposal = NeedRoomProposal(
                id: noti.id,
                userID: noti.from,
                targetID: noti.to,
                roomSalesID: noti.index,
                updatedAt: noti.time,
                createdAt: noti.time,
              );

              GlobalProfile.needRoomProposal.add(needRoomProposal);
            }
          }
        }

        var chatLogList = await ApiProvider().post('/ChatLog/SelectUserID', jsonEncode(
            {
              "userID" : GlobalProfile.loggedInUser.userID
            }
        ));

        if(chatLogList != null){
          for(int i = 0 ; i < chatLogList.length; ++i){
            User1 user = await GlobalProfile.getFutureUserByUserID(chatLogList[i]['from']);

            ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
              chatId: chatLogList[i]['id'],
              roomId: chatLogList[i]['ChatRoomUserID'],
              to: chatLogList[i]['to'],
              from: chatLogList[i]['from'],
              fromName : user.nickName,
              message: chatLogList[i]['message'],
              messageType: chatLogList[i]['messageType'],
              date: setRoomDate(replaceLocalDate(chatLogList[i]['date'])),
              isRead: 0,
            );

            var roomSaleID = await ApiProvider().post('/ChatRoomUser/Select/RoomSaleID', jsonEncode(
              {
                "id" : chatRecvMessageModel.roomId
              }
            ));

            chatRecvMessageModel.isContinue = true;
            chatRecvMessageModel.roomSalesID = roomSaleID['RoomSaleID'];
            chatRecvMessageModel.isRead = 0;

            ChatGlobal.addChatRecvMessage(chatRecvMessageModel.roomId, chatRecvMessageModel);
          }

          chatRoomUserListSort();
        }
      }else if(state == AppLifecycleState.paused){
        service.stop();
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    //if(null == socket) socket = Provider.of<SocketProvider>(context);
    if(null == _chatGlobal) _chatGlobal = Provider.of(context);

    return Container(
      child: widget.child,
    );
  }
}


void main() {
  KakaoContext.clientId = "7383d5477fb65e9b079fa9dfcfe3b67a";
  KakaoContext.javascriptClientId="510179569eaccd7ef3a67301b3b0ebaf";
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
   // statusBarIconBrightness: Brightness.light
  ));
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
//  SharedPreferences.setMockInitialValues({});
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<dummySuggestRoom>(
          create: (_) => new dummySuggestRoom(),
        ),
        ChangeNotifierProvider<RoomImagesProvider>(
          create: (_) => new RoomImagesProvider(),
        ),
        ChangeNotifierProvider<DateInLookForRoomsScreenProvider>(
          create: (_) => new DateInLookForRoomsScreenProvider(),
        ),
        ChangeNotifierProvider<DateInRequestTradeBottomSheetProvider>(
          create: (_) => new DateInRequestTradeBottomSheetProvider(),
        ), ChangeNotifierProvider<DateInReleaseRoomsScreenProvider>(
          create: (_) => new DateInReleaseRoomsScreenProvider(),
        ),        ChangeNotifierProvider<StudentAuthImageProvider>(
          create: (_) => new StudentAuthImageProvider(),
        ),
        ChangeNotifierProvider<NavigationNumProvider>(
          create: (_) => NavigationNumProvider(),
        ),
        ChangeNotifierProvider<DashBoardAdPagesProvider>(
          create: (_) => DashBoardAdPagesProvider(),
        ),
        ChangeNotifierProvider<ReleaseRoomAuthStateProvider>(
          create: (_) => ReleaseRoomAuthStateProvider(),
        ),
        ChangeNotifierProvider<DummyProposeForBorrow>(
          create: (_) => DummyProposeForBorrow(),
        ),
        ChangeNotifierProvider<RoomListScreenProvider>(
          create: (_) => RoomListScreenProvider(),
        ),
        ChangeNotifierProvider<ChatScreenDropDownProvider>(
          create: (_) => ChatScreenDropDownProvider(),
        ),
      /*  ChangeNotifierProvider<SocketProvider>(
          create: (_) => new SocketProvider(),
        ),*/

        ChangeNotifierProvider<DummyUser>(
          create: (_) => new DummyUser(),
        ),
        ChangeNotifierProvider<ChatGlobal>(
          create: (_) => new ChatGlobal(),
        ),
        ChangeNotifierProvider<EnterRoomInfoProvider>(
          create: (_) => new EnterRoomInfoProvider(),
        ),

        Provider<LocalNotiProvider>(create: (_) => LocalNotiProvider(),)
      ],
      child: LifeCycleManager(
        child: MaterialApp(
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Color(0xff6F22D2),
            accentColor: Color(0xff6F22D2),
            primaryColorLight: Color(0xff6F22D2),
            primaryColorDark: Color(0xff6F22D2),
            primarySwatch: MaterialColor((0xff6F22D2), <int, Color>{
              50: Color(0xff6F22D2),
              100: Color(0xff6F22D2),
              200: Color(0xff6F22D2),
              300: Color(0xff6F22D2),
              400: Color(0xff6F22D2),
              500: Color(0xff6F22D2),
              600: Color(0xff6F22D2),
              700: Color(0xff6F22D2),
              800: Color(0xff6F22D2),
              900: Color(0xff6F22D2),
            }),
          ),        debugShowCheckedModeBanner: false,
          initialRoute: '/SplashScreen',
          routes: {
            '/': (BuildContext context) => MainPage(),
            '/MoreScreen': (BuildContext context) => MoreScreen(),
            '/MainReleaseRoomScreen': (BuildContext context) =>
                MainReleaseRoomScreen(),
            '/AppTutorialScreen': (BuildContext context) => TutorialScreen(),
            '/SplashScreen': (BuildContext context) => SplashScreen(),
            '/TutorialScreenInLookForRooms': (BuildContext context) =>
                TutorialScreenInLookForRooms(),
            '/LookForRoomsScreen': (BuildContext context) => LookForRoomsScreen(),
            '/LoginScreen': (BuildContext context) => LoginMainScreen(),
            '/ChatScreen' : (BuildContext context) => ChatPage(),
            '/RoomForBorrowList' : (BuildContext context) =>RoomForBorrowList(),
            '/SelectItemCategory' : (BuildContext context) => SelectItemCategory(),
            '/PutItemInfo' : (BuildContext context) => PutItemInfo(),
            '/ProposePrice' : (BuildContext context) => ProposePrice(),
            '/ProposeTerm' : (BuildContext context) => ProposeTerm(),
            '/OtherSuggestion' : (BuildContext context) => OtherSuggestion(),
            '/SelectOption' : (BuildContext context) => SelectOption(),
            '/MainSetting' : (BuildContext context) => MainSetting(),
            '/TermsOfUse' : (BuildContext context) => TermsOfUse(),
            '/ItemLocation' : (BuildContext context) => ItemLocation(),
            '/ItemImg' : (BuildContext context) => ItemImg(),
            '/ItemDescription' : (BuildContext context) => ItemDescription(),

            '/ModifyDescription': (context) => ModifyDescription(),
            '/ModifyImg': (context) => ModifyImg(),
            '/ModifyItemCategory': (context) => ModifyItemCategory(),
            '/ModifyItemInfo': (context) => ModifyItemInfo(),
            '/ModifyItemLocation': (context) => ModifyItemLocation(),
            '/ModifyOption': (context) => ModifyOption(),
            '/ModifyPrice': (context) => ModifyPrice(),
            '/ModifyRoomItemInfo': (context) => ModifyRoomItemInfo(),
            '/ModifySuggestion': (context) => ModifySuggestion(),
            '/ModifyTerm': (context) => ModifyTerm(),

            '/Certiciation_ModifyPhoneNum': (context) => Certiciation_ModifyPhoneNum(),
            '/certification': (context) => Certification(),
            '/certification-result': (context) => Certification_Result(),
            '/certification-pw': (context) => Certification_FindPW(),
            '/certification-pw-result': (context) => Certification_FindPW_Result(),
            '/certification-id': (context) => Certification_FindId(),
            '/certification-id-result': (context) => Certification_FindId_Result(),


            '/FindPassword': (context) => ModifyPWComplete(),

            '/SplashScreen': (context) => SplashScreen(),
            '/SearchMapForReleaseRoom': (context) => SearchMapForBorrowRoom(),
            '/addressComplteForReleaseRoom': (context) => addressComplteForBorrowRoom(),
            '/ChatScreen': (context) => ChatScreen(),


            '/TutorialShortInSetting': (context) => TutorialShortInSetting(),
           // '/TutorialLongInSetting': (context) => TutorialLongInSetting(),
            //'/TutorialReviewInSetting': (context) => TutorialReviewInSetting(),
          },
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}


void MoveToTop(ScrollController s, int index) {//현재 navigation bar 인덱스가 0인데 다시한번 버튼 누르면 인자로 넣은 컨트롤러의 offset이 0되게 만듬
  if(index == DASHBOARD_SCREEN_NUM) {
    s.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  } else if(index ==LOOK_FOR_ROOMS_SCREEN_NUM) {
    s.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  } else if(index == CHAT_LIST_SCREEN_NUM) {
    s.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  } else if(index == MORE_SCREEN_NUM) {
    s.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static List<Widget> bottomNavigationPages = <Widget>[
    DashBoardScreen(),
    RoomForBorrowList(),
    ChatScreen(),
    MoreScreen(),
    RoomWannaLive(),     //내가 살고 싶은 방 정보
    TotalNotificationPage(), //알람 페이지

    Container(),
    MyRoomList(),
  ];

  final String HomeNavigationIcon =
      'assets/images/bottomNavigationImages/Home.svg';
  final String LookForRoomsNavigationIcon =
      'assets/images/bottomNavigationImages/LookingForRoom.svg';
  final String ChatListNavigationIcon =
      'assets/images/bottomNavigationImages/Chat.svg';
  final String MoreNavigationIcon =
      'assets/images/bottomNavigationImages/More.svg';

  @override
  Widget build(BuildContext context) {
    final navigationNumProvider = Provider.of<NavigationNumProvider>(context);

   // SocketProvider socket = Provider.of<SocketProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: () {
          switch (navigationNumProvider.getNum()) {
            case DASHBOARD_SCREEN_NUM:
              navigationNumProvider.setNum(DASHBOARD_SCREEN_NUM);
              setState(() {

              });
              break;
          }
          return null;
        },
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
          child: Scaffold(
            body: SafeArea(
              child:bottomNavigationPages[navigationNumProvider.getNum()],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              backgroundColor: hexToColor("#FFFFFF"),
              showSelectedLabels: true,
              // <-- HERE
              showUnselectedLabels: true,
              type: BottomNavigationBarType     .fixed,
              onTap: (index) async{
                chatSum =0;
                //쪽지함 리스트
                var yes = await ApiProvider().post('/Note/Notyetview', jsonEncode({
                  "userID" : GlobalProfile.loggedInUser.userID

                }));
               chatSum = yes["number"];

                if(index == 0){
                  navigationNumProvider.setNum(index, /* socket: socket*/);
                  var tmp;

                  setState(() {

                  });
                }
                else if(index == 1){
                  isShortForRoomList = false;
                  setState(() {

                  });
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  bool flag = prefs.getBool(forLong);
                  if(flag == null){
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                TutorialForLong()) // SecondRoute를 생성하여 적재
                    );
                  }
                  else {
                    Navigator.push(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) =>
                                SearchMapForBorrowRoom(flagForShort: false,)) // SecondRoute를 생성하여 적재
                    );
                  }

                }
                else if(index == 2){

                  //쪽지함 리스트
                  chatInfoList.clear();
                  var ye = await ApiProvider().post(
                      '/Note/MessageRoomListTest', jsonEncode({
                    "userID": GlobalProfile.loggedInUser.userID
                  }));
                  var tt = ye['result'];
                  if (ye != null && ye != false) {
                    for (int i = 0; i <
                        ye['result'].length; ++i) {
                      chatInfoList.add(Chat.fromJson(
                          ye['result'][i], ye['Contents'][i]));
                    }
                  }
                  navigationNumProvider.setNum(index, /* socket: socket*/);
                  setState(() {

                  });
                }
                else if(index == 3){
                  navigationNumProvider.setNum(index, /* socket: socket*/);
                  GlobalProfile.needRoomProposal.clear();
                  var list = await ApiProvider().post('/NeedRoomSalesInfo/Proposal/SelectUser', jsonEncode(
                      {
                        "userID" : GlobalProfile.loggedInUser.userID,
                      }
                  ));
                  if(list != null){
                    for(int i = 0 ; i < list.length; ++i){
                      GlobalProfile.needRoomProposal.add(NeedRoomProposal.fromJson(list[i]));
                    }
                  }
                }
                else{
                  CustomOKDialog(context,"서비스 준비중입니다" , "오픈채팅을 이용해주세요.");
                }

              },
              currentIndex:  navigationNumProvider.getNum() ==7 ?DASHBOARD_SCREEN_NUM:navigationNumProvider.getNum() ==6 ?DASHBOARD_SCREEN_NUM:navigationNumProvider.getNum() == TOTAL_NOTIFICATION_PAGE ?DASHBOARD_SCREEN_NUM:navigationNumProvider.getNum()==ROOM_WANNA_LIVE?DASHBOARD_SCREEN_NUM: navigationNumProvider.getNum(),

              items: [
                new BottomNavigationBarItem(
                  icon: SizedBox(
                    width: screenHeight * (24 / 640),
                    height: screenHeight * (24 / 640),
                    child: SvgPicture.asset(
                      HomeNavigationIcon,
                      color:
                      navigationNumProvider.getNum() == DASHBOARD_SCREEN_NUM
                          ? kPrimaryColor
                          : Color(0xff222222),
                    ),
                  ),
                  title: Column(
                    children: [
                      Container(
                        height: screenHeight * (11 / 640),
                        child: Text(
                          '홈',
                          style: TextStyle(
                            fontSize: screenHeight * (8 / 640),
                            color: navigationNumProvider.getNum() ==
                                DASHBOARD_SCREEN_NUM
                                ? kPrimaryColor
                                : Color(0xff222222),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (3 / 640),
                      )
                    ],
                  ),
                ),
                new BottomNavigationBarItem(
                  icon: SizedBox(
                    width: screenHeight * (24 / 640),
                    height: screenHeight * (24 / 640),
                    child: SvgPicture.asset(
                      LookForRoomsNavigationIcon,
                      color: navigationNumProvider.getNum() ==
                          LOOK_FOR_ROOMS_SCREEN_NUM
                          ? kPrimaryColor
                          : Color(0xff222222),
                    ),
                  ),
                  title: Column(
                    children: [
                      Container(
                        height: screenHeight * (11 / 640),
                        child: Text(
                          '방구하기',
                          style: TextStyle(
                            fontSize: screenHeight * (8 / 640),
                            color: navigationNumProvider.getNum() ==
                                LOOK_FOR_ROOMS_SCREEN_NUM
                                ? kPrimaryColor
                                : Color(0xff222222),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (3 / 640),
                      )
                    ],
                  ),
                ),
                new BottomNavigationBarItem(
                  icon: Container(
                    width: screenHeight * (45 / 640),
                    height: screenHeight * (24 / 640),
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: screenHeight * (24 / 640),
                            height: screenHeight * (24 / 640),
                            child: SvgPicture.asset(
                              ChatListNavigationIcon,
                              color:
                              navigationNumProvider.getNum() == CHAT_LIST_SCREEN_NUM
                                  ? kPrimaryColor
                                  : Color(0xff222222),
                            ),
                          ),
                        ),
                        (chatSum ==null||chatSum == 0)?Container() :Positioned(
                          right: screenHeight * (4 / 640),
                          top: 0,
                          child:
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xfff9423a),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5,right: 5,top: 2,bottom: 2),
                              child: Text(
                                chatSum.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * (8 / 360),
                                  // fontSize: screenHeight * (10 / 640)
                                ),
                              ),
                            ),
                          ),
                        ),)
                      ],
                    ),
                  ),
                  title: Column(
                    children: [
                      Container(
                        height: screenHeight * (11 / 640),
                        child: Text(
                          '쪽지함',
                          style: TextStyle(
                            fontSize: screenHeight * (8 / 640),
                            color: navigationNumProvider.getNum() ==
                                CHAT_LIST_SCREEN_NUM
                                ? kPrimaryColor
                                : Color(0xff222222),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (3 / 640),
                      )
                    ],
                  ),
                ),
                new BottomNavigationBarItem(
                  icon: SizedBox(
                    width: screenHeight * (24 / 640),
                    height: screenHeight * (24 / 640),
                    child: SvgPicture.asset(
                      MoreNavigationIcon,
                      color: navigationNumProvider.getNum() == MORE_SCREEN_NUM
                          ? kPrimaryColor
                          : Color(0xff222222),
                    ),
                  ),
                  title: Column(
                    children: [
                      Container(
                        height: screenHeight * (11 / 640),
                        child: Text(
                          '더보기',
                          style: TextStyle(
                            fontSize: screenHeight * (8 / 640),
                            color:
                            navigationNumProvider.getNum() == MORE_SCREEN_NUM
                                ? kPrimaryColor
                                : Color(0xff222222),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * (3 / 640),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
