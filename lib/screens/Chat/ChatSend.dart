import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyRoom.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/model/RoomListScreenProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/BorrowRoom/DetailedRoomInformation.dart';
import 'package:mryr/screens/BorrowRoom/SearchPageForMapForRoom.dart';
import 'package:mryr/screens/BorrowRoom/model/ModelRoomLikes.dart';
import 'package:mryr/screens/LookForRoomsScreen.dart';
import 'package:mryr/screens/Registration/RegistrationPage.dart';
import 'package:mryr/screens/RoomWannaLive.dart';
import 'package:mryr/screens/TutorialScreenInLookForRooms.dart';
import 'package:mryr/userData/Chat.dart';
import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/Review.dart';
import 'package:mryr/userData/Room.dart';
import 'package:mryr/utils/ExtendedImage.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mryr/widget/Public/floatButtonWithListIcon.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:mryr/userData/User.dart';
import 'package:transition/transition.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;

final PurpleMenuIcon = 'assets/images/Map/PurpleMenuIcon.svg';
final MessageIcon = 'assets/images/Chat/message.svg';
final CloseIcon = 'assets/images/Chat/Close.svg';

class ChatSendScreen extends StatefulWidget {
  bool isChatList;
  Chat chatInfo;
  int roomID;
  int oppoID;
  ChatSendScreen({Key key, this.chatInfo, this.isChatList,this.roomID,this.oppoID}) : super(key:key);
  @override
  _ChatSendScreenState createState() => _ChatSendScreenState();
}

SharedPreferences localStorage;

class _ChatSendScreenState extends State<ChatSendScreen>with SingleTickerProviderStateMixin  {
  final DescriptionController = TextEditingController();

  bool isPicture = true;

  double sizeUnit = 1;

  List<File> filesList = [];

  void initState() {

    super.initState();

    (() async {

    })();
  }

  @override
  void dispose(){
    super.dispose();
    DescriptionController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;


    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: hexToColor("#FFFFFF"),
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
              icon:SvgPicture.asset(
                CloseIcon,

                height: screenWidth * (14 / 360),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('쪽지 보내기',
            style: TextStyle(
              color: hexToColor("#222222"),
              fontSize:screenWidth*( 16/360),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              width: screenWidth*(85/360),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if(mulCheck == false) {
                        mulCheck = true;
                        if ((DescriptionController.text.trim() == "" ||
                            DescriptionController.text == null) && (filesList.length == 0||filesList == null)) {
                          Navigator.pop(context);
                        }
                        else {

                          Function okFunc = () async {
                            EasyLoading.show(
                                status: "쪽지 전송 중...",
                                maskType:
                                EasyLoadingMaskType
                                    .black);


                            var result;
                            if (DescriptionController.text.trim() != "" &&
                                DescriptionController.text != null) {
                              result = false;
                              result = await ApiProvider().post(
                                  '/Note/Send', jsonEncode(
                                  {
                                    "userID": GlobalProfile.loggedInUser
                                        .userID,
                                    "receiverID": widget.isChatList==true? widget.chatInfo
                                        .senderID ==
                                        GlobalProfile.loggedInUser
                                            .userID ? widget.chatInfo
                                        .receiverID : widget.chatInfo
                                        .senderID
                                        :widget.oppoID,
                                    "roomID": widget.isChatList==true?widget.chatInfo.roomID : widget.roomID,
                                    "contents": DescriptionController.text.trim(),
                                  }
                              ));
                              if (result == false || result == null) {
                                EasyLoading.dismiss();
                                CustomOKDialog(context, "쪽지가 전송되지 않았습니다", "다시 전송해주세요!");
                              }
                            }




                            int rand = new Math.Random().nextInt(100000);
                            if(isPicture == true) {
                              if (filesList.length != 0 && filesList != null) {
                                for (int i = 0; i < filesList.length; i++) {
                                  Dio dio = new Dio();
                                  dio.options.headers = {
                                    'Content-Type': 'application/json',
                                    'user': 'codeforgeek'
                                  };
                                  FormData formData = new FormData.fromMap({
                                    "userID": GlobalProfile.loggedInUser
                                        .userID,
                                    "receiverID": widget.isChatList == true
                                        ? widget.chatInfo
                                        .senderID ==
                                        GlobalProfile.loggedInUser
                                            .userID ? widget.chatInfo
                                        .receiverID : widget.chatInfo
                                        .senderID
                                        : widget.oppoID,
                                    "roomID": widget.isChatList == true ? widget
                                        .chatInfo.roomID : widget.roomID,
                                    "img": await MultipartFile.fromFile(
                                        filesList[i].path,
                                        filename: GlobalProfile.loggedInUser
                                            .userID.toString() +
                                            "_image_$rand.jpeg"),
                                  });

                                  await dio.post(
                                      ApiProvider().getUrl + "/Note/SendImg",
                                      data: formData).timeout(const Duration(seconds: 17));
                                }
                              }
                            }
                            else{
                              if (filesList.length != 0 && filesList != null) {
                                for (int i = 0; i < filesList.length; i++) {
                                  Dio dio = new Dio();
                                  dio.options.headers = {
                                    'Content-Type': 'application/json',
                                    'user': 'codeforgeek'
                                  };
                                  FormData formData = new FormData.fromMap({
                                    "userID": GlobalProfile.loggedInUser
                                        .userID,
                                    "roomID": widget.isChatList == true ? widget
                                        .chatInfo.roomID : widget.roomID,
                                    "img": await MultipartFile.fromFile(
                                        filesList[i].path,
                                        filename: GlobalProfile.loggedInUser
                                            .userID.toString() +
                                            "_image_$rand.jpeg"),
                                  });

                                  await dio.post(
                                      ApiProvider().getUrl + "/Note/RenterAuthImg",
                                      data: formData).timeout(const Duration(seconds: 17));
                                }
                                await ApiProvider().post(
                                    '/Note/Send', jsonEncode(
                                    {
                                      "userID": GlobalProfile.loggedInUser
                                          .userID,
                                      "receiverID": widget.isChatList==true? widget.chatInfo
                                          .senderID ==
                                          GlobalProfile.loggedInUser
                                              .userID ? widget.chatInfo
                                          .receiverID : widget.chatInfo
                                          .senderID
                                          :widget.oppoID,
                                      "roomID": widget.isChatList==true?widget.chatInfo.roomID : widget.roomID,
                                      "contents": "신분증이 전송되었습니다",
                                    }
                                ));
                              }

                            }
                            await Future.delayed(const Duration(milliseconds: 2000), (){});



                            eachChatList.clear();
                            var ye2 = await ApiProvider().post('/Note/MessageList',jsonEncode({
                              "roomID": widget.isChatList==true? widget.chatInfo.roomID:widget.roomID,//chatInfoList[index].roomID,
                              "senderID": GlobalProfile.loggedInUser
                                  .userID,
                              "receiverID": widget.isChatList==true?  widget.chatInfo
                                  .senderID ==
                                  GlobalProfile.loggedInUser
                                      .userID ? widget.chatInfo
                                  .receiverID : widget.chatInfo
                                  .senderID :widget.oppoID,
                            }));



                            chatNum = ye2.length;
                            if (ye2 != null && ye2 != false) {
                              for (int i = 0; i < ye2.length; ++i) {
                                var tmp =  EachChat.fromJson(ye2[i]);

                                if(i ==0){
                                  eachChatList.add(tmp);
                                }
                                else{
                                  if(eachChatList[eachChatList.length-1].img != true || tmp.img != true){
                                    eachChatList.add(tmp);
                                  }
                                  else{
                                    if(
                                    replaceDateToDatetime(eachChatList[eachChatList.length-1].createdAt).difference( replaceDateToDatetime(tmp.createdAt)).inSeconds <1
                                    ){
                                      eachChatList[eachChatList.length-1].contents.add(tmp.contents[0]);
                                    }
                                    else{
                                      eachChatList.add(tmp);
                                    }
                                  }
                                }
                              }
                            }

                            EasyLoading.dismiss();
                            Navigator.pop(context);
                            Navigator.pop(context);

                            Fluttertoast.showToast(
                                msg: "쪽지가 전송되었습니다. ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color.fromRGBO(
                                    0, 0, 0, 0.51),
                                textColor: hexToColor('#FFFFFF'));

                            setState(() {

                            });


                          };
                          Function cancelFunc = () {
                            Navigator.pop(context);
                          };
                          OKCancelDialog(
                              context,
                              "쪽지를 보내시겠습니까?",
                              "확인을 누르면 쪽지가 전송됩니다!",
                              "확인",
                              "취소",
                              okFunc,
                              cancelFunc);
                        }
                        mulCheck = false;
                      }
                      mulCheck = false;
                    },
                    child: Container(

                      height: screenHeight * (22 / 640),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(

                        padding: EdgeInsets.only(left: 16.0,right: 16.0),
                        child: Center(
                          child: Text(
                            "전송",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * (12/ 360),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width:screenWidth*(12/360)),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: screenWidth,
            height: screenHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    TextField(
                      controller: DescriptionController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines:filesList.length != 0?22 :22,
                      minLines: 22,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(

                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "내용을 입력해주세요. ",
                        hintStyle: TextStyle(
                          color: Color(0xFFCCCCCC),

                        ),
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                      ),
                      onChanged: (text){
                        setState(() {

                        });
                      },
                    ),
                    SizedBox(height:12/640*screenHeight),

                  ],
                ),
                Spacer(),
                filesList.length ==0?Container(): Row(
                  children: [

                    Container(
                      height: 108/640*screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        cacheExtent: 3,
                        reverse: false,
                        shrinkWrap: true,
                        itemCount:filesList.length != 3 ? filesList.length +1 : filesList.length,
                        itemBuilder: (context, index) {
                          if (index ==filesList.length &&
                              filesList.length != 3){
                            return isPicture == false?Container(): GestureDetector(
                                child: Row(
                                  children: [
                                    SizedBox(width: 6/640*screenHeight),
                                    Container(
                                      width: 108/360*screenWidth,
                                      height: 108/360*screenWidth,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: kPrimaryColor,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(8/360*screenWidth)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "+",
                                          style: TextStyle(fontSize: 20/360*screenWidth,color: kPrimaryColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  FocusScopeNode currentFocus = FocusScope.of(context); //텍스트 포커스 해제
                                  if (!currentFocus.hasPrimaryFocus) {
                                    if(Platform.isIOS){
                                      FocusManager.instance.primaryFocus.unfocus();
                                    } else{
                                      currentFocus.unfocus();
                                    }
                                  }
                                  //_settingModalBottomSheetForGallery(context);
                                  BottomSheetInChat(
                                      context, screenWidth, screenHeight);
                                }
                            );
                          }

                          return Row(
                            children: [
                              SizedBox(width:9/360*screenWidth),
                              Container(
                                width: 108/360*screenWidth,
                                height: 108/360*screenWidth,
                                decoration: BoxDecoration(
                                    color: hexToColor("#EEEEEE"),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    image: DecorationImage(
                                        image: FileImage(filesList[index]),
                                        fit: BoxFit.cover)),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 6*sizeUnit,
                                      right: 6*sizeUnit,
                                      child: GestureDetector(
                                        onTap: (){
                                          filesList.removeAt(index);
                                          setState(() {
                                          });
                                        },
                                        child: Container(
                                          width: 16*sizeUnit,
                                          height: 16*sizeUnit,
                                          decoration: BoxDecoration(
                                              color:Colors.grey,
                                              borderRadius: BorderRadius.circular(8*sizeUnit)),
                                          child: Center(
                                            child:
                                            Icon(Icons.clear, color: Colors.white,size: 16*sizeUnit),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Container(height: screenHeight*(20/640),),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: screenWidth,
          height: screenHeight*(48/640),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,

            ),
          ],
        ),
          child: Row(children: [
            Container(
              width: screenWidth/2,
              height: screenHeight*(48/640),
              child: FlatButton(
                onPressed: (){

                  FocusScopeNode currentFocus = FocusScope.of(context); //텍스트 포커스 해제
                  if (!currentFocus.hasPrimaryFocus) {
                    if(Platform.isIOS){
                      FocusManager.instance.primaryFocus.unfocus();
                    } else{
                      currentFocus.unfocus();
                    }
                  }
                  if(isPicture == true && filesList.length !=0){}
                  else {
                    //_settingModalBottomSheetForGallery(context);
                    BottomSheetInChat(
                        context, screenWidth, screenHeight);
                  }
                },
                child: Container(  width: screenWidth/2,
                  height: screenHeight*(48/640),
                child: Row(children: [
                  Container(width: screenWidth*(20/360),),
                  Icon(
                    Icons.picture_in_picture,
                    color:isPicture == true?kPrimaryColor: Color(0xff888888),
                  ),
                  Container(width: screenWidth*(4/360),),
                  Text("사진 보내기",style: TextStyle(color: isPicture == true?kPrimaryColor:Color(0xff888888),),),

                ],),),
              ),
            ),
            Container(

              width: screenWidth/2,
              height: screenHeight*(48/640),
              child: FlatButton(
                onPressed: (){

                  FocusScopeNode currentFocus = FocusScope.of(context); //텍스트 포커스 해제
                  if (!currentFocus.hasPrimaryFocus) {
                    if(Platform.isIOS){
                      FocusManager.instance.primaryFocus.unfocus();
                    } else{
                      currentFocus.unfocus();
                    }
                  }
                  //_settingModalBottomSheetForGallery(context);

                  BottomSheetForCerInChat(
                      context, screenWidth, screenHeight);
                },
                child: Container(  width: screenWidth/2,
                  height: screenHeight*(48/640),
                  child: Row(children: [
                    Spacer(),
                    Icon(
                      Icons.picture_in_picture,
                      color: isPicture == false?kPrimaryColor:Color(0xff888888),
                    ),
                    Container(width: screenWidth*(4/360),),
                    Text("신분증 인증하기",style: TextStyle(color: isPicture == false?kPrimaryColor:Color(0xff888888),),),
                    Container(width: screenWidth*(20/360),),
                  ],),),
              ),
            ),

          ],),


        ),
      ),
    );
  }

  Future BottomSheetInChat(
      BuildContext context, double screenWidth, double screenHeight) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.transparent,
            width: screenWidth,
            height: screenHeight * (173 / 640),
            child: Column(
              children: [
                Container(
                  width: screenWidth * (336 / 360),
                  height: screenHeight * (97 / 640),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      FlatButton(
                        onPressed: () {

                          getImageGallery(context);
                          setState(() {

                          });
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "갤러리",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1,
                        color: Color(0xfffafafa),
                      ),
                      FlatButton(
                        onPressed: () {
                          getImageCamera(context);
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "카메라",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1,
                        color: Color(0xfffafafa),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: screenWidth * (336 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "취소",
                        style: TextStyle(
                            fontSize: screenWidth * (16 / 360),
                            color: Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * (20 / 640),
                ),
              ],
            ),
          );
        });
  }

  Future getImageGallery(BuildContext context) async {


    var imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery); //camera
    if (imageFile == null) return;

    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);

    if(isPicture== false){
      filesList.clear();
    }
    isPicture = true;

    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      filesList.add(imageFile);
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      filesList.add(compressImg);//이미지 들어가는
    }

    EasyLoading.dismiss();
    // Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));
    // int rand = new Math.Random().nextInt(10000000);
    // var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    //   ..writeAsBytesSync(Img.encodeJpg(image, quality: 100));


    // f = compressImg;
    setState(() {

    });
    return;
  }

  Future getImageCamera(BuildContext context) async {

    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);


    if(isPicture== false){
      filesList.clear();
    }
    isPicture = true;

    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      filesList.add(imageFile);
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      filesList.add(compressImg);//이미지 들어가는
    }
    EasyLoading.dismiss();
    // Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));
    //
    // var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    //   ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));
    //
    // f = compressImg;

    setState(() {

    });
    return;
  }


  Future BottomSheetForCerInChat(
      BuildContext context, double screenWidth, double screenHeight) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.transparent,
            width: screenWidth,
            height: screenHeight * (173 / 640),
            child: Column(
              children: [
                Container(
                  width: screenWidth * (336 / 360),
                  height: screenHeight * (97 / 640),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      FlatButton(
                        onPressed: () {

                          getImageGalleryForCer(context);
                          setState(() {

                          });
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "갤러리",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1,
                        color: Color(0xfffafafa),
                      ),
                      FlatButton(
                        onPressed: () {
                          getImageCameraForCer(context);
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: screenWidth * (2 / 360),
                                ),
                                Container(
                                  height: screenHeight * (30 / 640),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: screenHeight * (2 / 640)),
                                    child: Center(
                                      child: Text(
                                        "카메라",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: screenWidth * (16 / 360),
                                            color: Color(0xff222222)),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * (8.6667 / 640),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenWidth,
                        height: 1,
                        color: Color(0xfffafafa),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * (8 / 640),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: screenWidth * (336 / 360),
                    height: screenHeight * (48 / 640),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        new BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "취소",
                        style: TextStyle(
                            fontSize: screenWidth * (16 / 360),
                            color: Color(0xff222222)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * (20 / 640),
                ),
              ],
            ),
          );
        });
  }

  Future getImageGalleryForCer(BuildContext context) async {


    var imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery); //camera
    if (imageFile == null) return;

    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);
    isPicture = false;
    filesList.clear();

    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      filesList.add(imageFile);
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      filesList.add(compressImg);//이미지 들어가는
    }

    EasyLoading.dismiss();
    // Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));
    // int rand = new Math.Random().nextInt(10000000);
    // var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    //   ..writeAsBytesSync(Img.encodeJpg(image, quality: 100));


    // f = compressImg;
    setState(() {

    });
    return;
  }

  Future getImageCameraForCer(BuildContext context) async {

    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;

    EasyLoading.show(status: "",maskType: EasyLoadingMaskType.black);
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = new Math.Random().nextInt(10000000);

    isPicture = false;
    filesList.clear();

    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      filesList.add(imageFile);
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      print('@@@@@@@@@@@@@@@'+byteToMb(compressImg.lengthSync()).toString());
      filesList.add(compressImg);//이미지 들어가는
    }
    EasyLoading.dismiss();
    // Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    // Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));
    //
    // var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    //   ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));
    //
    // f = compressImg;

    setState(() {

    });
    return;
  }
}

class Triangle extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(size.width,size.height);
    path.lineTo(size.width,0);

    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}
