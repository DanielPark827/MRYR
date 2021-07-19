
import 'package:flutter/material.dart';
import 'package:mryr/constants/AppConfig.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*(320/360),
      height: MediaQuery.of(context).size.height*(40/640),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: kPrimaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height*(16/640),
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}