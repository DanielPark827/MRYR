
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
getExtendedImage(String url, int size, AnimationController controller, {bool isRounded = true}){
  return ExtendedImage.network(
    getOptimizeImageURL(url,size),
    fit: BoxFit.cover,
    borderRadius: isRounded == true ? BorderRadius.all(Radius.circular(8.0)) : null,
    shape: BoxShape.rectangle,
    //enableLoadState: false,
    border: Border.all(color: Color.fromRGBO(116, 125, 130, 0.2), width: 1.0),
    cache: true,
    loadStateChanged: (ExtendedImageState state){
      switch( state.extendedImageLoadState ) {
        case LoadState.loading:
          controller.reset();
          return Container(
              width: 100,
              height: 100,
              child: CupertinoActivityIndicator());
          break;
        case LoadState.completed:
          controller.forward();
          return ExtendedRawImage(
            image: state.extendedImageInfo?.image,
          );
          break;
        case LoadState.failed:
          controller.reset();
          return GestureDetector(
            child: Container(),
            onTap: () {
              state.reLoadImage();
            },
          );
          break;
        default:
          controller.reset();
          return Container();
          break;
      }
    },
  );
}
String getOptimizeImageURL(String name, int size) {
  if(size == 0) return name;

  String strHead = name.substring(0, name.lastIndexOf('.'));
  String strTail = name.substring(name.lastIndexOf('.'), name.length);

  return  strHead + '_' + size.toString() + strTail;
}