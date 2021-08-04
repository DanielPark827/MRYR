import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/model/MultipartImgFilesProvider.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/widget/MoreScreen/StringForMoreScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'dart:math' as Math;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'package:mryr/userData/GlobalProfile.dart';
Container MyProfileLineInSetting(
    BuildContext context, double screenWidth, double screenHeight) {
  DummyUser _UserProvider = Provider.of<DummyUser>(context);
  return Container(
    width: screenWidth,
    height: screenHeight * (116 / 640),
    decoration: buildBoxDecoration(),
    child: Row(
      children: [
        SizedBox(
          width: screenWidth * (20 / 360),
        ),
        Container(
          width: screenHeight * (60 / 640),
          height: screenHeight * (60 / 640),
          child: Stack(
            children: [
              _UserProvider.profileImagesList.length == 0
                  ? GestureDetector(
                onTap: () {
                  BottomSheetMoreScreen(
                      context, screenWidth, screenHeight);
                },
                child: SvgPicture.asset(
                  ProfileIconInMoreScreen,
                  width: screenHeight * (60 / 640),
                  height: screenHeight * (60 / 640),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  _UserProvider.removeProfileImage(
                      targetFile: _UserProvider.profileImage[0]);
                },
                child: Container(
                  width: screenHeight * (60 / 640),
                  height: screenHeight * (60 / 640),
                  decoration: BoxDecoration(
                      color: hexToColor("#EEEEEE"),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                          image: FileImage(_UserProvider.profileImage[0]),
                          fit: BoxFit.cover)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * (12 / 360),
        ),
        Container(
          height: screenHeight * (60 / 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * (8 / 640),
              ),
              Text(
                "김내방",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontSize: screenHeight * (16 / 640),
                    fontSize: screenWidth * (16 / 360),
                    color: Color(0xff222222)),
              ),
              SizedBox(
                height: screenHeight * (4 / 640),
              ),
              Text(
                "9entle@gmail.com",
                style: TextStyle(
                  // fontSize: screenHeight * (12 / 640),
                    fontSize: screenWidth * (12 / 360),
                    color: Color(0xff888888)),
              ),
              SizedBox(
                //height: screenHeight * (8 / 640),
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth * (55 / 360),
        ),
      ],
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
                                          fontSize: screenWidth*( 16/360),
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
                                          fontSize: screenWidth*( 16/360),
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
                          fontSize: screenWidth*( 16/360),
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
  DummyUser _UserProvider = Provider.of<DummyUser>(context, listen: false);

  var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery); //camera
  print(imageFile);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand= new Math.Random().nextInt(1000000);
  Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));

  var compressImg= new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));


  _UserProvider.addProfileImage(compressImg);
  return;
}

Future getImageCamera(BuildContext context) async {
  DummyUser _UserProvider = Provider.of<DummyUser>(context, listen: false);
  var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand= new Math.Random().nextInt(100000);
  Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));


  var compressImg= new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));


  _UserProvider.addProfileImage(compressImg);
  return;
}