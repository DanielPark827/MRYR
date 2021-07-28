import 'dart:convert';
import 'dart:io';
import 'package:geocoder/geocoder.dart';
import 'package:mryr/screens/Registration/AppleRegisterNameGender.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:kakao_flutter_sdk/all.dart';
import 'package:mryr/chat/models/ChatDatabase.dart';
import 'package:mryr/chat/models/ChatGlobal.dart';
import 'package:mryr/chat/models/ChatRecvMessageModel.dart';
import 'package:mryr/constants/AppConfig.dart';import 'package:mryr/main.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/LoginBloc.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/RegistrationBloc.dart';
import 'package:mryr/model/LoginAndRegistrationBloc/UserRepository.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/network/SocketProvider.dart';
import 'package:mryr/screens/KakaoRegisterNameGender.dart';
import 'package:mryr/screens/LoginScreen.dart';
import 'package:mryr/userData/Chat.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/NeedRoomInfo.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/StatusBar.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/Dialog/OKDialog.dart';
import 'package:mryr/widget/NotificationScreen/NotiDatabase.dart';
import 'package:mryr/widget/NotificationScreen/NotificationModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/screens/Registration/Agreement.dart';
//for applelogin
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

import 'TutorialScreen.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';

class LoginMainScreen extends StatefulWidget {
  @override
  _LoginMainScreenState createState() => _LoginMainScreenState();
}

String name;
String email;
String apple;
String globalLoginID = ""; //괜찮?

class _LoginMainScreenState extends State<LoginMainScreen> {
  bool _isKakaoTalkInstalled = false;


  void initState() {


    (() async {

    })();
    super.initState();
    _initKakaoTalkInstalled();
  }
  _initKakaoTalkInstalled() async{
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : '+installed.toString());
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }
  _issueAccessToken(String authCode/*,SocketProvider provider*/)async{
    try{
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print("토큰%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
          "");
      print(token);
      GlobalProfile.kakaoInfo = await UserApi.instance.me();

      var result2 = await ApiProvider().post('/User/KakaoLogin', jsonEncode(
          {
            "id" :GlobalProfile.kakaoInfo .kakaoAccount.email,
          }
      ));

      if(result2["result"] == "0616"){  //result['Code'] == 0616 ?
        print("확인");
        print(GlobalProfile.kakaoInfo.kakaoAccount.email.toString());
        GlobalProfile.IdForKakaoLogin =GlobalProfile.kakaoInfo.kakaoAccount.email.toString();
        GlobalProfile.PhoneForKakaoLogin =GlobalProfile.kakaoInfo.kakaoAccount.phoneNumber.toString();

        Navigator.pushReplacement(
            context, // 기본 파라미터, SecondRoute로 전달
            MaterialPageRoute(
                builder: (context) => KakaoRegisterNameGender()) // SecondRoute를 생성하여 적재
        );
      }else{
        try{

          var result = await ApiProvider().post('/User/KakaoLogin', jsonEncode(
              {
                "id" : GlobalProfile.kakaoInfo.kakaoAccount.email.toString(),
                "password" : "",
              }
          ));
          if(false != result && null != result){
            loginFunc(GlobalProfile.kakaoInfo.kakaoAccount.email.toString(),"", context,/* provider,*/ result,"kakao");
          }
        }  catch (e) {
          EasyLoading.showError(e.toString());
          print(e);
        }


      }
    }catch(e) {
      print(e.toString());
    }
  }

  _loginWithKakao(/*SocketProvider provider*/) async{
    try{
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code/*,provider*/);

    }catch(e){print(e.toString());}
  }

  _loginWithTalk(/*SocketProvider provider*/)async{
    try{
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code,/*provider*/);

    }catch(e){print(e.toString());}
  }

  Future<void> retryAfterUserAgrees(List<String> requiredScopes) async {
    // Getting a new access token with current access token and required scopes.
    String authCode = await AuthCodeClient.instance.requestWithAgt(requiredScopes);
    AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
    AccessTokenStore.instance.toStore(token); // Store access token in AccessTokenStore for future API requests.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
  //  SocketProvider provider = Provider.of<SocketProvider>(context);

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: (){
          Function okFunc = () {
            exit(0);
          };
          Function cancelFunc = () {
            Navigator.pop(context);
          };
          OKCancelDialog(context,'정말 앱을 종료하시겠습니까?','확인을 누르시면 앱이 종료됩니다\n계속하시겠습니까?',"확인","취소", okFunc,cancelFunc);
          return;
        },
        child: Scaffold(
          body: Stack(
            children: [
              Image.asset(
                "assets/images/loginScreen/LoginBackground3.png",
                width: screenWidth,
                height: screenHeight,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x11222222),Color(0xdd222222)],
                    )
                ),
              ),          Row(
                children: [
                  SizedBox(
                    width: screenWidth * (20 / 360),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * (80 / 640),
                      ),
                      SvgPicture.asset(
                        "assets/images/loginScreen/LoginMainIcon.svg",
                        width: screenWidth * (110 / 360),
                        height: screenHeight * (27 / 640),
                      ),
                      SizedBox(
                        height: screenHeight * (40 / 640),
                      ),
                      SvgPicture.asset(
                        "assets/images/loginScreen/LoginText.svg",
                        width: screenWidth * (184 / 360),
                        height: screenHeight * (176 / 640),
                      ),
                      SizedBox(
                        height: screenHeight * (80 / 640),
                      ),
                      Row(
                        children: [
                          SizedBox(width:screenWidth*(8/360)),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context, // 기본 파라미터, SecondRoute로 전달
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Agreement(),
                                  ) // SecondRoute를 생성하여 적재
                              );

                            },
                            child: Container(
                              width: screenWidth * (304 / 360),
                              height: screenHeight * (36 / 640),
                              decoration: BoxDecoration(  color: kPrimaryColor,borderRadius:  new BorderRadius.all(new Radius.circular(4.0)),),
                              child: Center(
                                child: Text('회원가입하기',
                                    style: TextStyle(
                                      color:Colors.white,
                                      fontSize:screenWidth*(14 /360),)),
                              ),
                            ),

                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
                      Row(
                        children: [

                          SizedBox(width:screenWidth*(8/360)),
                          InkWell(
                            onTap: (){
                              return _isKakaoTalkInstalled ? _loginWithTalk(/*provider*/):_loginWithKakao(/*provider*/);
                            },
                            child: Container(
                              width: screenWidth * (304 / 360),
                              height: screenHeight * (36 / 640),
                              decoration: BoxDecoration(  color: Color(0xffFEE500),borderRadius:  new BorderRadius.all(new Radius.circular(4.0)),),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(

                                      "assets/images/loginScreen/kakao.svg",
                                      width: screenWidth * (20 / 360),
                                      color: Color(0xff181600),
                                      //height: screenHeight * (176 / 640),
                                    ),
                                    SizedBox(
                                      width: screenWidth * (8 / 360),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom:screenHeight*(0/640)),
                                      child: Text('카카오 로그인',
                                          style: TextStyle(
                                            color: Color(0xff181600),
                                            fontSize: screenWidth*( 14/360),)),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * (8 / 640),
                      ),
                      (Platform.isIOS)
                          ? Row(
                            children: [

                              SizedBox(width:screenWidth*(8/360)),
                              InkWell(
                        onTap: () async {
                          //apple login AP
                          // 애플로그인 유의사항
                          // 처음 로그인했을때 이후로는 인자가 Null 로 넘어오게된다.
                          // 따라서, 애플로그인 return 값이 null 이냐 아니냐로 Flow 가 나뉘게 된다.
                          AuthorizationResult apple_login_result;

                          try {
                            apple_login_result = await AppleSignIn.performRequests([ AppleIdRequest(requestedScopes: [ Scope.email,  Scope.fullName ]) ]);
                          } catch (e) {
                            print(e);
                            return null;
                          }

                          print(apple_login_result);
                          switch (apple_login_result.status) {
                            case AuthorizationStatus.authorized:
                            // Store user ID
                              final SharedPreferences prefs = await SharedPreferences.getInstance();

                              print('apple good');
                              print(apple_login_result.credential.email);
                              print(apple_login_result.credential.fullName.familyName);
                              print(apple_login_result.credential.fullName.givenName);
                              print(apple_login_result.credential.user);

                              if (apple_login_result.credential.fullName.familyName == null) {
                                //두번째 로그인이면
                                //family 로 판단하는 이유는,
                                //email 숨기기 하면 ㄹㅇ 처음로그인이어도 email null 임

                                print('apple login not FIRST');
                                apple = apple_login_result.credential.user;
                                print('print global apple');
                                print(apple); //good

                                //email = prefs.getString('autoLoginAppleId');
                                //name = prefs.getString('autoLoginApplePw');
                                //저장해뒀던 sharedPref 에서 정보 가져옴
                                //sharedpref 는 알아서 해주세욥

                              } else {
                                //처음 애플로그인 이면
                                print('apple login FIRST');
                                email = apple_login_result.credential.email; //이메일 저장
                                name = apple_login_result.credential.fullName.familyName + apple_login_result.credential.fullName.givenName; //이름 정보 저장 for 닉네임 부분에 설정
                                apple = apple_login_result.credential.user;
                                print(email);
                                print(name);
                                print(apple); //good

                                //prefs.setString('autoLoginAppleId', email);
                                //prefs.setString('autoLoginApplePw', name);
                                //sharedPref 에 global 하게 저장
                                //sharedpref 는 알아서 해주세욥
                              }

                              var result = await ApiProvider().post('/User/AppleLogin',
                                  jsonEncode( {"apple": apple,
                                    "emailID": email
                                  } ));

                              if (result['result'] == '0616') { //이름, 닉네임, 성별 추가입력 페이지로 이동
                                print('go to add personal info');

                                //그리고 우선 , 추가입력 페이지의 이름 입력란 안에 앞서 받아둔 name 값 넣어 두기 (가능하면 ,,)
                                print("확인");
                                //애플아이디 넣어야함
                                GlobalProfile.IdForAppleLogin =result['result'];
                                //애플 이름 닉네임 성별 등록으로 이동
                                //이름 (name) 을 추가 정보 입력란의 '이름'입력란 안에 갖다 넣어놓기
                                Navigator.pushReplacement(
                                    context, // 기본 파라미터, SecondRoute로 전달
                                    MaterialPageRoute(
                                        builder: (context) =>AppleRegisterNameGender(apple: apple,name: name,email: email)) // SecondRoute를 생성하여 적재
                                );
                              } else { // 로그인 시키기
                                loginFunc( result["result"]["EmailID"],apple, context,/* provider,*/ result,"apple");


                              }
                              break;

                            case AuthorizationStatus.error:
                              print('apple error bad good');
                              break;

                            case AuthorizationStatus.cancelled:
                              print('User cancelled good');
                              break;
                          }
                        },
                        child: Container(
                              width: screenWidth * (304 / 360),
                              height: screenHeight * (36 / 640),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(4.0)),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/loginScreen/apple.svg",
                                      width: screenWidth * (20 / 360),
                                      color: Color(0xff181600),
                                      //height: screenHeight * (176 / 640),
                                    ),
                                    SizedBox(
                                      width: screenWidth * (8 / 360),
                                    ),
                                    Container(
                                      height: screenHeight * (36 / 640),
                                      child: Center(
                                        child: Text('Sign in with Apple',
                                            style: TextStyle(
                                              color: Color(0xff181600),
                                              fontSize:
                                              screenWidth * (14 / 360),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                            ],
                          )
                          : Container(
                        width: screenWidth * (304 / 360),
                        height: screenHeight * (36 / 640),
                      ),
                      SizedBox(
                        height: screenHeight * (24 / 640),
                      ),
                      Row(
                        children: [
                          Container(
                            width: screenWidth * (320 / 360),
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  //ChatDBHelper().dropTable();
                                  // NotiDBHelper().dropTable();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return BlocProvider(
                                          create: (ctx) => LoginBloc(),
                                          child: LoginScreen(),
                                        );
                                      }));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "기존 아이디로 로그인",
                                      style: TextStyle(
                                          fontSize: screenWidth * (12 / 360),
                                          color: Colors.white),
                                    ),
                                    Container(
                                      width: screenWidth * (110 / 360),
                                      height: 1,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void applelogin() async {}

Future loginFunc(var id,var password,BuildContext context,/*SocketProvider provider, */var result, String mode)async{
      ChatDBHelper().dropTable();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('autoLoginKey',mode);

      if(result['res'] == 1){
        Function okFunc = () {
          ApiProvider().post('/User/logout', jsonEncode(
              {
                "userID" : result['userID']
              }
          ));

          Navigator.pop(context);
        };

        Function cancelFunc = () {
          Navigator.pop(context);
        };

        OKCancelDialog(context, "로그아웃", "해당 아이디는 이미 로그인 중입니다.\n로그아웃을 요청하시겠어요?", "예", "아니오", okFunc, cancelFunc);
        return;
      }

      prefs.setString('autoLoginKey',mode);
      prefs.setString('autoLoginId', id);
      prefs.setString('autoLoginPw', password);
      prefs.setString('acceceToken', result['AcceceToken']);
      User1 user = User1.fromJson(result["result"]);
      GlobalProfile.loggedInUser = user;
      //자기 매물 정보
      var list5 = await ApiProvider().post('/RoomSalesInfo/myroomInfo', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID
          }
      ));

      GlobalProfile.roomSalesInfoList.clear();
      if (list5 != null && list5  != false) {
        for (int i = 0; i < list5.length; ++i) {
          RoomSalesInfo tmp = RoomSalesInfo.fromJson(list5[i]);
          if (null ==
              tmp.lng ||
              null == tmp
                  .lat) {
            var addresses = await Geocoder.google(
                'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
                .findAddressesFromQuery(
                tmp
                    .location);
            var first = addresses.first;
            tmp.lat = first.coordinates.latitude;
            tmp.lng = first.coordinates.longitude;
          }
          GlobalProfile.roomSalesInfoList.add(tmp);
        }
      }

      var tmp8 = await ApiProvider().get("/RoomSalesInfo/MonthlyNewBanner");
      GlobalProfile.banner = (tmp8['ImageUrl1'] as String == ""||tmp8['ImageUrl1'] as String == null) ? "BasicImage" : ApiProvider().getImgUrl+ (tmp8['ImageUrl1'] as String);

      chatSum =0;
      //쪽지함 리스트
      chatInfoList.clear();
      var ye = await ApiProvider().post('/Note/MessageRoomListTest', jsonEncode({
        "userID" : GlobalProfile.loggedInUser.userID

      }));

      var tt = ye['result'];
      if (ye != null && ye  != false) {
        for (int i = 0; i < ye['result'].length; ++i) {
          chatInfoList.add(Chat.fromJson(ye['result'][i],ye['Contents'][i]));
        }
      }


      //자기 매물 정보
      var myRoom = await ApiProvider().post('/RoomSalesInfo/Select/User', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID
          }
      ));
      GlobalProfile.roomSalesInfo = null;
      if(myRoom != null){
        RoomSalesInfo tmp = RoomSalesInfo.fromJson(myRoom);
        if (null ==
            tmp.lng ||
            null == tmp
                .lat) {
          var addresses = await Geocoder.google(
              'AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c')
              .findAddressesFromQuery(
              tmp
                  .location);
          var first = addresses.first;
          tmp.lat = first.coordinates.latitude;
          tmp.lng = first.coordinates.longitude;
        }
        GlobalProfile.roomSalesInfo = tmp;
      }

      //역제안 정보
      GlobalProfile.NeedRoomInfoOfloggedInUser = null;
      var t = await ApiProvider().post('/NeedRoomSalesInfo/Select/User', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));


      GlobalProfile.NeedRoomInfoOfloggedInUser = null;
      if(t != null){
        NeedRoomInfo tmp = NeedRoomInfo.fromJson(t);
        GlobalProfile.NeedRoomInfoOfloggedInUser = tmp;
      }
      //매물 리스트
      var list = await ApiProvider().post('/RoomSalesInfo/TransferListWithLike', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));

      globalRoomSalesInfoList.clear();
      if(list != null){
        for(int i = 0 ; i < list.length; ++i){
          RoomSalesInfo tmp = RoomSalesInfo.fromJsonLittle(list[i]);
          globalRoomSalesInfoList.add(tmp);
        }
      }

      var ss = await ApiProvider().post('/RoomSalesInfo/Select/Like', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));
      RoomLikesList.clear();
      if(ss != null){
        for(int i = 0 ; i < ss.length; ++i){
          Map<String, dynamic> t = ss[i]["RoomSalesInfo"];
          RoomLikesList.add(RoomSalesInfo.fromJsonLittle(t));
        }
      }

      //내방니방직영
      nbnbRoom.clear();
      var tmp = await ApiProvider().post('/RoomSalesInfo/ShortListWithLike', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));
      if(null != tmp){
        for(int i = 0;i<tmp.length;i++){
          nbnbRoom.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
        }
      }
      // for(int i = 0;i<nbnbRoom.length;i++){
      //   if (null == nbnbRoom[i].lng ||
      //       null == nbnbRoom[i].lat) {
      //     var addresses = await Geocoder.google('AIzaSyDLuchPkN8r8G0by9NXrzgB23tw47j6w0c').findAddressesFromQuery(nbnbRoom[i].location);
      //     var first = addresses.first;
      //
      //     nbnbRoom[i].lng =
      //         first.coordinates.latitude;
      //     nbnbRoom[i].lat =
      //         first.coordinates.longitude;
      //   }
      // }


      //메인 단기매물 리스트
      mainShortList.clear();
      tmp = await ApiProvider().post('/RoomSalesInfo/MainShortWithLike', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));
      if(null != tmp){
        for(int i = 0;i<tmp.length;i++){
          mainShortList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
        }
      }


      //메인 양도매물 리스트
      mainTransferList.clear();
      tmp = await ApiProvider().post('/RoomSalesInfo/MainTransferWithLike', jsonEncode(
          {
            "userID" : GlobalProfile.loggedInUser.userID
          }
      ));
      if(null != tmp){
        for(int i = 0;i<tmp.length;i++){
          mainTransferList.add(RoomSalesInfo.fromJsonLittle(tmp[i]));
        }
      }

      //메인 리뷰 리스트
      GlobalProfile.reviewForMain.clear();
      tmp = await ApiProvider().get('/Review/MainReviews');
      if(null != tmp){
        for(int i =0;i<tmp.length;i++){
          GlobalProfile.reviewForMain.add(Review.fromJson(tmp[i]));
        }
      }

      //나에게 맞는 매물 추천
      GlobalProfile.listForMe.clear();
      var list2 = await ApiProvider().post('/RoomSalesInfo/Recommend', jsonEncode({
        "userID" :  GlobalProfile.loggedInUser.userID,
      }));
      if(list2 != null){
        for(int i = 0;i<list2.length;i++){
          GlobalProfile.listForMe.add(RoomSalesInfo.fromJson(list2[i]));
        }
      }


      //내방이 필요한 사람들
      GlobalProfile.listForMe2.clear();
      var list3 = await  ApiProvider().post('/NeedRoomSalesInfo/RecommendUserList', jsonEncode(
          {


            "userID" : GlobalProfile.loggedInUser.userID,
          }
      ));
      if(list3 != null){
        for(int i = 0;i<list3.length;i++){
          GlobalProfile.listForMe2.add(NeedRoomInfo.fromJson(list3[i]));
        }
      }

      GlobalProfile.needRoomProposal.clear();

      var needRoomProposal = await ApiProvider().post('/NeedRoomSalesInfo/Proposal/SelectUser', jsonEncode({
        "userID" : user.userID
      }));

      if(needRoomProposal != null){
        for(int i = 0 ; i < needRoomProposal.length; ++i){
          GlobalProfile.needRoomProposal.add(NeedRoomProposal.fromJson(needRoomProposal[i]));
        }
      }

      //Personal Profile 데이터 get
      GlobalProfile.personalProfile = await ApiProvider().post('/User/List', jsonEncode(
          {
            "userID" : user.userID
          }
      ));

      //자기 매물에 채팅한 정보
      var roomByUserIDList = await ApiProvider().post('/ChatRoomUser/SelectUserID', jsonEncode(
          {
            "userID" : user.userID
          }
      ));

      ChatGlobal.roomInfoList.clear();
      chatRoomUserList.clear();
      if(null != roomByUserIDList){
        for(int i = 0 ; i < roomByUserIDList.length; ++i){

          List<ChatRecvMessageModel> chatList = (await ChatDBHelper().getRoomDataByRoomID(roomByUserIDList[i]['id'])).cast<ChatRecvMessageModel>();

          for(int i = 0 ; i < chatList.length; ++i){
            if( getMessageTypeByInt(chatList[i].messageType) == MESSAGE_TYPE.IMAGE){

              var getImageData = await ApiProvider().post('/ChatLog/SelectImageData', jsonEncode({
                "id" : int.parse(chatList[i].message)
              }));

              if(getImageData != null) chatList[i].fileMessage = await ChatGlobal.base64ToFileURL(getImageData['message']);
              else{
                chatList[i].message = '사진을 불러올 수 없습니다';
                chatList[i].messageType = getMessageType(MESSAGE_TYPE.MESSAGE);
              }
            }
          }

          ChatRoomUser chatRoomUser = ChatRoomUser.fromJson(roomByUserIDList[i]);

          await GlobalProfile.getFutureUserByUserID(chatRoomUser.chatID);

          if(chatList == null || chatList.length == 0){
            chatRoomUserList.add(chatRoomUser);

            RoomInfo roomInfo = new RoomInfo(
                lastMessage: "",
                date: "",
                roomState: getRoomStateByValue(roomByUserIDList[i]['RoomState']),
                messageCount: 0,
                chatList: new List<ChatRecvMessageModel>()
            );

            int id = roomByUserIDList[i]['id'];
            ChatGlobal.roomInfoList[id] = roomInfo;
          }else{

            String updatedAt = '';
            if(chatList.last.updatedAt == null){
              DateTime d = DateTime.now();
              d = d.subtract(Duration(days: 30));
              updatedAt = replaceLocalDate(d.toString(),isSend: true);
            }else{
              if(chatList.last.from == GlobalProfile.loggedInUser.userID){
                DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse( chatList.last.updatedAt, true);
                updatedAt = getRoomTime(date);
              }else{
                updatedAt = chatList.last.updatedAt;
              }
            }

            int cnt = 0;
            for(int i = 0; i < chatList.length; ++i){
              if(chatList[i].isRead == 0) cnt++;
            }

            chatRoomUser.updatedAt = updatedAt;
            chatRoomUser.createdAt = updatedAt;

            chatRoomUserList.add(chatRoomUser);

            RoomInfo roomInfo = new RoomInfo(
              lastMessage: getRoomMessage(getMessageTypeByInt(chatList.last.messageType),chatList.last.message),
              date: updatedAt,
              roomState: getRoomStateByValue(roomByUserIDList[i]['RoomState']),
              messageCount: cnt,
              chatList: chatList,
            );

            int id = roomByUserIDList[i]['id'];
            ChatGlobal.roomInfoList[id] = roomInfo;
          }
        }
      }
      //자기가 문의한 매물에 대한 정보
      var roomByChatIDList = await ApiProvider().post('/ChatRoomUser/SelectChatID', jsonEncode(
          {
            "userID" : user.userID
          }
      ));

      if(null != roomByChatIDList){
        for(int i = 0 ; i < roomByChatIDList.length; ++i){

          List<ChatRecvMessageModel> chatList = (await ChatDBHelper()
              .getRoomDataByRoomID(roomByChatIDList[i]['id'])).cast<ChatRecvMessageModel>();

          for(int i = 0 ; i < chatList.length; ++i){
            if( getMessageTypeByInt(chatList[i].messageType) == MESSAGE_TYPE.IMAGE){

              var getImageData = await ApiProvider().post('/ChatLog/SelectImageData', jsonEncode({
                "id" : int.parse(chatList[i].message)
              }));

              if(getImageData != null) chatList[i].fileMessage = await ChatGlobal.base64ToFileURL(getImageData['message']);
              else{
                chatList[i].message = '사진을 불러올 수 없습니다';
                chatList[i].messageType = getMessageType(MESSAGE_TYPE.MESSAGE);
              }
            }
          }

          ChatRoomUser chatRoomUser = ChatRoomUser.fromJson(roomByChatIDList[i]);

          await GlobalProfile.getFutureUserByUserID(chatRoomUser.userID);

          if(chatList == null || chatList.length == 0){
            chatRoomUserList.add(chatRoomUser);

            RoomInfo roomInfo = new RoomInfo(
                lastMessage: "",
                date: "",
                roomState: getRoomStateByValue(roomByChatIDList[i]['RoomState']),
                messageCount: 0,
                chatList: new List<ChatRecvMessageModel>()
            );

            int id = roomByChatIDList[i]['id'];
            ChatGlobal.roomInfoList[id] = roomInfo;
          }else{
            String updatedAt = '';
            if(chatList.last.from == GlobalProfile.loggedInUser.userID){
              DateTime date = new DateFormat("yyyy-MM-dd HH:mm:ss").parse( chatList.last.updatedAt, true);
              updatedAt = getRoomTime(date);
            }else{
              updatedAt = chatList.last.updatedAt;
            }

            int cnt = 0;
            for(int i = 0; i < chatList.length; ++i){
              if(chatList[i].isRead == 0) cnt++;
            }

            chatRoomUser.updatedAt = updatedAt;
            chatRoomUser.createdAt = updatedAt;

            chatRoomUserList.add(chatRoomUser);

            RoomInfo roomInfo = new RoomInfo(
              lastMessage: getRoomMessage(getMessageTypeByInt(chatList.last.messageType),chatList.last.message) ,
              date: updatedAt,
              roomState: getRoomStateByValue(roomByChatIDList[i]['RoomState']),
              messageCount: cnt,
              chatList: chatList,
            );

            int id = roomByChatIDList[i]['id'];
            ChatGlobal.roomInfoList[id] = roomInfo;
          }
        }
      }



      Map<int,int> selfMap = Map<int,int>();
      for(int i = 0 ; i < chatRoomUserList.length; ++i){
        var lastInquireLog = await ApiProvider().post('/ChatLog/Select/LastInquire', jsonEncode(
            {
              "chatRoomUserID" : chatRoomUserList[i].id
            }
        ));

        if(lastInquireLog == null) continue;

        for(int j = lastInquireLog.length - 1  ; j >= 0; --j){
          RoomInfo roomInfo = ChatGlobal.roomInfoList[lastInquireLog[j]['ChatRoomUserID']];

          int getID = GlobalProfile.loggedInUser.userID == lastInquireLog[j]['from'] ? lastInquireLog[j]['to'] : lastInquireLog[j]['from'];

          User1 user = await GlobalProfile.getFutureUserByUserID(getID);

          ChatRecvMessageModel chatRecvMessageModel = ChatRecvMessageModel(
            chatId: lastInquireLog[j]['id'],
            roomId: lastInquireLog[j]['ChatRoomUserID'],
            to: lastInquireLog[j]['to'],
            from:lastInquireLog[j]['from'],
            fromName : user.nickName,
            message: lastInquireLog[j]['message'],
            messageType: lastInquireLog[j]['messageType'],
            date: setRoomDate(replaceLocalDate(lastInquireLog[j]['date'])),
            isRead: 1,
          );
          chatRecvMessageModel.isContinue = true;
          DateTime d = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse( lastInquireLog[j]['date'], true);
          d = d.add(Duration(hours: 9));
          chatRecvMessageModel.updatedAt = d.toString().replaceAll('T', ' ');
          chatRecvMessageModel.createdAt = d.toString().replaceAll('T', ' ');
          chatRecvMessageModel.chatId = await ChatDBHelper().createData(chatRecvMessageModel);

          MESSAGE_TYPE type =  getMessageTypeByInt(lastInquireLog[j]['messageType']);

          //오류나면 채팅방 정보가 없는것 데이터 확인 필요
          String date = lastInquireLog[j]['date'] == null ? '' : replaceLocalDate(lastInquireLog[j]['date']);

          roomInfo.date = date;
          roomInfo.lastMessage = getRoomMessage(type, lastInquireLog[j]['message']);
          switch(type){
            case MESSAGE_TYPE.MESSAGE :
              {
                roomInfo.chatList.add(chatRecvMessageModel);
                break;
              }
            case MESSAGE_TYPE.IMAGE :
              {
                chatRecvMessageModel.fileMessage = await ChatGlobal.base64ToFileURL(chatRecvMessageModel.message);
                roomInfo.chatList.add(chatRecvMessageModel);
              }

              break;
            default:{
              chatRecvMessageModel.isActive = 1;
              roomInfo.chatList.add(chatRecvMessageModel);
              if(selfMap[lastInquireLog[j]['ChatRoomUserID']] == null){
                selfMap[lastInquireLog[j]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
              }else{
                ChatGlobal.roomInfoList[lastInquireLog[j]['ChatRoomUserID']].chatList[selfMap[lastInquireLog[j]['ChatRoomUserID']]].isActive = 0;
                selfMap[lastInquireLog[j]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
              }

              break;
            }
          }

          ChatGlobal.roomInfoList[lastInquireLog[j]['ChatRoomUserID']] = roomInfo;
        }
      }

      var chatLogList = await ApiProvider().post('/ChatLog/SelectUserID', jsonEncode(
          {
            "userID" : user.userID
          }
      ));

      var needRoomList = await ApiProvider().get('/NeedRoomSalesInfo/Select/List');

      if(needRoomSalesInfoList != null)
        needRoomSalesInfoList.clear();
      if(null != needRoomList){
        for(int i = 0 ; i < needRoomList.length; ++i){
          needRoomSalesInfoList.add(NeedRoomInfo.fromJson(needRoomList[i]));
        }
      }

      //알림 초기화
      notiList.clear();
      notiList = await NotiDBHelper().getAllData();

      if(null != chatLogList && null != roomByChatIDList && null != roomByUserIDList){
        Map<int,int> activeMap = Map<int,int>();
        for(int i = 0 ; i < chatLogList.length; ++i){
          RoomInfo roomInfo = ChatGlobal.roomInfoList[chatLogList[i]['ChatRoomUserID']];

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
          chatRecvMessageModel.isContinue = true;
          DateTime d = new DateFormat("yyyy-MM-ddTHH:mm:ss").parse( chatLogList[i]['date'], true);
          d = d.add(Duration(hours: 9));
          chatRecvMessageModel.updatedAt = d.toString().replaceAll('T', ' ');
          chatRecvMessageModel.createdAt = d.toString().replaceAll('T', ' ');
          chatRecvMessageModel.chatId = await ChatDBHelper().createData(chatRecvMessageModel);

          MESSAGE_TYPE type =  getMessageTypeByInt(chatLogList[i]['messageType']);

          //오류나면 채팅방 정보가 없는것 데이터 확인 필요
          String date = chatLogList[i]['date'] == null ? '' : replaceLocalDate(chatLogList[i]['date']);

          roomInfo.date = date;
          roomInfo.lastMessage = getRoomMessage(type, chatLogList[i]['message']);
          roomInfo.messageCount += 1;
          switch(type){
            case MESSAGE_TYPE.MESSAGE :
              {
                roomInfo.chatList.add(chatRecvMessageModel);
                break;
              }
            case MESSAGE_TYPE.IMAGE :
              {
                chatRecvMessageModel.fileMessage = await ChatGlobal.base64ToFileURL(chatRecvMessageModel.message);
                roomInfo.chatList.add(chatRecvMessageModel);
              }

              break;
            default:{
              chatRecvMessageModel.isActive = 1;
              roomInfo.chatList.add(chatRecvMessageModel);
              if(activeMap[chatLogList[i]['ChatRoomUserID']] == null){
                activeMap[chatLogList[i]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
              }else{
                ChatGlobal.roomInfoList[chatLogList[i]['ChatRoomUserID']].chatList[activeMap[chatLogList[i]['ChatRoomUserID']]].isActive = 0;
                activeMap[chatLogList[i]['ChatRoomUserID']] = roomInfo.chatList.length - 1;
              }

              break;
            }
          }



          addNotiByChatRecvMessageModel(chatRecvMessageModel);

          ChatGlobal.roomInfoList[chatLogList[i]['ChatRoomUserID']] = roomInfo;
        }
      }

      chatRoomUserListSort();

     /* if(provider.socket != null)
        provider.socket.disconnect();
      await provider.initSocket(user);*/
      await SetNotificationListByEvent();
      GlobalProfile.acceceTokenCheck();

      bool flag = prefs.getBool(IfNewUser2);
      if(flag == null){
        Navigator.pushReplacement(
            context, // 기본 파라미터, SecondRoute로 전달
            MaterialPageRoute(
                builder: (context) =>
                    TutorialScreen()) // SecondRoute를 생성하여 적재
        );
      }
      else {
        Navigator.pushReplacement(
            context, // 기본 파라미터, SecondRoute로 전달
            MaterialPageRoute(
                builder: (context) =>
                    MainPage()) // SecondRoute를 생성하여 적재
        );
      }
      EasyLoading.dismiss();
}
