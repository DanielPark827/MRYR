import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'dart:math' as Math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mryr/userData/Chat.dart';
import 'package:mryr/utils/ExtendedImage.dart';

import 'package:mryr/constants/AppConfig.dart';
import 'package:path_provider/path_provider.dart';
class ImagePage extends StatefulWidget {
  String imageUrl;
  ImagePage({Key key, this.imageUrl}) : super(key:key);
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> with SingleTickerProviderStateMixin{
  GlobalKey _globalKey = GlobalKey();
  AnimationController extendedController;
  void initState() {


    super.initState();
    _requestPermission();
    extendedController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);

    (() async {

    })();
  }

  @override
  void dispose(){
    super.dispose();
    extendedController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
              icon: Icon(Icons.archive_outlined, color: Colors.black),
              onPressed: () async{
                _getHttp(widget.imageUrl);
              }),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: screenWidth,height: screenHeight,
        child:  FittedBox(
          fit: BoxFit.contain,
          child: getExtendedImage(widget.imageUrl, 0,extendedController),
        ),
      ),
    );
  }




  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
   // _toastInfo(info);
  }

/*  _saveScreen() async {
    RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData?>);
    if (byteData != null) {
      final result =
      await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }*/

  _getHttp(String url) async {

    int rand = new Math.Random().nextInt(1000000);
    var response = await Dio().get(url,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello3"+rand.toString());
    print(result);
   // _toastInfo("$result");
    _toastInfo("사진이 저장되었습니다!");
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }
}
