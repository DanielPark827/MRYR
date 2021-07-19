import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:flutter/cupertino.dart';

OKCancelDialog(BuildContext context,@required String title, @required String description,@required String ok,@required String cancel, @required Function okFunc, @required Function cancelFunc) {
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
              child: Text(cancel),
              onPressed: cancelFunc,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
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


