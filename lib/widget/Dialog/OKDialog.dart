import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:flutter/cupertino.dart';

OKDialog(BuildContext context,@required String title,@required String description,@required String ok, @required Function okFunc) {

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: CupertinoAlertDialog(
          title: Text(title+"\n"),
          content: Text(description),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(ok),
              onPressed: okFunc,
              textStyle: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      );
    },
  );
}