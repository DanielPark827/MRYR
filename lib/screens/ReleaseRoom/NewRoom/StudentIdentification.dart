import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/main.dart';
import 'package:mryr/model/EnterRoomInfoProvider.dart';
import 'package:mryr/widget/Dialog/OKCancelDialog.dart';
import 'package:mryr/widget/MainReleaseRoomScreen/StringForMainReleaseRoomScreen.dart';
import 'package:mryr/widget/ReleaseRoomScreen/StringForReleaseRoomScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:mryr/userData/GlobalProfile.dart';

import 'package:mryr/screens/ReleaseRoom/NewRoom/EnterRoomInfo.dart';
import 'package:mryr/screens/ReleaseRoom/NewRoom/ProposeTerm.dart';

File f;

class StudentIdentification extends StatefulWidget {
  @override
  _StudentIdentificationState createState() => _StudentIdentificationState();
}

class _StudentIdentificationState extends State<StudentIdentification> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    EnterRoomInfoProvider data = Provider.of<EnterRoomInfoProvider>(context);
    DummyUser data2 = Provider.of<DummyUser>(context);

    return WillPopScope(
      onWillPop: (){
        Function okFunc = () async {
          data.ResetEnterRoomInfoProvider();
          data2.ResetDummyUser();
          f= null;
          FlagForInitialDate = false;
          FlagForLastDate = false;
          setState(() {
          });
          Navigator.pushReplacement(
              context, // 기본 파라미터, SecondRoute로 전달
              MaterialPageRoute(
                  builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
          );
        };

        Function cancelFunc = () {
          Navigator.pop(context);
        };

        OKCancelDialog(context, "처음으로 돌아가시겠습니까?","입력된 매물의 정보가\n모두 삭제됩니다. 계속하시겠습니까?", "확인", "취소", okFunc, cancelFunc);
        return;
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Function okFunc = () async {
                    data.ResetEnterRoomInfoProvider();
                    data2.ResetDummyUser();
                    f= null;
                    FlagForInitialDate = false;
                    FlagForLastDate = false;
                    setState(() {
                    });
                    Navigator.pushReplacement(
                        context, // 기본 파라미터, SecondRoute로 전달
                        MaterialPageRoute(
                            builder: (context) => MainPage()) // SecondRoute를 생성하여 적재
                    );
                  };

                  Function cancelFunc = () {
                    Navigator.pop(context);
                  };

                  OKCancelDialog(context, "처음으로 돌아가시겠습니까?","입력된 매물의 정보가\n모두 삭제됩니다. 계속하시겠습니까?", "확인", "취소", okFunc, cancelFunc);
                }),
            title: SvgPicture.asset(
              MryrLogoInReleaseRoomTutorialScreen,
              width: screenHeight * (110 / 640),
              height: screenHeight * (27 / 640),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
            Container(
            // height: screenHeight,
            width: screenWidth,
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: screenWidth * (12 / 360),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * (40 / 640),
                    ),
                    Text(
                      "신분증 인증",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth*(24/360),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Text(
                      "신분증 혹은 학생증을 촬영하여 업로드 해주세요\n(신분증의 경우 그림과 같이 주민등록번호를 가려주세요!)",
                      style: TextStyle(
                        color: Color(0xff888888),
                        fontSize: screenHeight * (12 / 640),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * (24 / 640),
                    ),
                    Wrap(
                      children: List.generate(1, (index) {
                        if ( f == null) {
                          return GestureDetector(
                              child: Container(
                                width:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width * (336 / 360),
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height * (180 / 640),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xffeeeeee)),
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: screenHeight * (25 / 640),
                                    ),
                                    SvgPicture.asset(
                                      StudentAuthCard,
                                      height: screenHeight * (114 / 640),
                                    ),
                                    SizedBox(
                                      height: screenHeight * (8 / 640),
                                    ),
                                    Text(
                                      "클릭해서 신분증/학생증 이미지를 업로드 해주세요",
                                      style: TextStyle(
                                          fontSize: screenHeight * (12 / 640),
                                          color: Color(0xff888888)),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight);
                              });
                        } else {
                          return GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: screenWidth * (4 / 360),
                                    bottom: screenHeight * (4 / 640)),
                                child: Container(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width * (336 / 360),
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height *
                                      (180 / 640),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffeeeeee)),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                      image: DecorationImage(
                                          image: FileImage(f),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                              onTap: () async {
                                BottomSheetMoreScreen(
                                    context, screenWidth, screenHeight);
                              });
                        }
                      }),
                    ),
                    SizedBox(
                      height: screenHeight * (8 / 640),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * (336 / 360),
                      height: MediaQuery
                          .of(context)
                          .size
                          .width *(60/640),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "※ ",
                            style: TextStyle(
                              color: Color(0xffDA3D3D),
                              fontSize: screenHeight * (16 / 640),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "신분증 인증이 제대로 되지 않을 경우 등록한 매물이 임의로 삭제 될 수 있습니다.",
                              style: TextStyle(
                                color: Color(0xffDA3D3D),
                                fontSize: screenHeight * (12 / 640),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
            ],
          ),
          bottomNavigationBar: InkWell(
            onTap: () {
              if(null != f) {
                Navigator.push(
                    context, // 기본 파라미터, SecondRoute로 전달
                    MaterialPageRoute(
                      builder: (context) =>
                          EnterRoomInfo(),
                    ) // SecondRoute를 생성하여 적재
                );
              }
            },
            child: Container(
              width: screenWidth,
              height: screenHeight * (60 / 640),
              color: f==null ? hexToColor('#CCCCCC') : kPrimaryColor,
              child: Center(
                child: Text(
                  "다음",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * (16 / 360),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future BottomSheetMoreScreen(
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
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      f = imageFile;
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      f = compressImg;//이미지 들어가는
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
    if(byteToMb(imageFile.lengthSync()) < ImgSizeStandard) {//이미지 파일이 ImgSizeStandard 이하일때
      f = imageFile;
    } else {//이미지 파일이 ImgSizeStandard 이상일때
      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
        ..writeAsBytesSync(Img.encodeJpg(image, quality: ImgEncodeQulity));
      f = compressImg;//이미지 들어가는
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
