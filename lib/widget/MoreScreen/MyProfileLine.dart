import 'dart:convert';
import 'package:mryr/model/NavigationNumProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/constants/GlobalAsset.dart';
import 'package:mryr/dummyData/DummyUser.dart';
import 'package:mryr/model/MultipartImgFilesProvider.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/NeedRoomProposalListScreen.dart';import 'package:mryr/userData/GlobalProfile.dart';
import 'package:mryr/userData/User.dart';
import 'package:mryr/utils/BoxDecoration.dart';
import 'package:mryr/utils/ExtendedImage.dart';
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
  print(imageFile);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(100000);
  Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));

  var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_$rand.jpg")
    ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));


  Dio dio = new Dio();
  dio.options.headers = {
    'Content-Type' : 'application/json',
    'user' : 'codeforgeek'
  };
  FormData formData = new FormData.fromMap({
    "userID": GlobalProfile.loggedInUser.userID,
    "img": await MultipartFile.fromFile(compressImg.path, filename:GlobalProfile.loggedInUser.userID.toString()+"_rand.jpeg"),
  });
  var response = await dio.post(ApiProvider().getUrl+"/Information/S3addProfilePhoto", data: formData).timeout(const Duration(seconds: 17));


  User1 tmp = User1.fromJson(response.data);
  GlobalProfile.loggedInUser.profileUrlList = tmp.profileUrlList;

  return;
}

Future getImageCamera(BuildContext context) async {
  var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  if (imageFile == null) return;

  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(100000);
  Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
  Img.Image smallerImg = Img.copyResize(image, width: (image.width*0.7).toInt(), height: (image.height*0.7.toInt()));

  var compressImg = new File("$path/"+GlobalProfile.loggedInUser.id+"_image_$rand.jpg")
    ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 100));


  Dio dio = new Dio();
  dio.options.headers = {
    'Content-Type' : 'application/json',
    'user' : 'codeforgeek'
  };
  FormData formData = new FormData.fromMap({
    "userID": GlobalProfile.loggedInUser.userID,
    "img": await MultipartFile.fromFile(compressImg.path, filename:GlobalProfile.loggedInUser.userID.toString()+"_image_$rand.jpeg"),
  });
  var response = await dio.post(ApiProvider().getUrl+"/Information/S3addProfilePhoto", data: formData).timeout(const Duration(seconds: 17));


  User1 tmp = User1.fromJson(response.data);
  GlobalProfile.loggedInUser.profileUrlList = tmp.profileUrlList;
  return;
}
