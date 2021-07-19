import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mryr/constants/AppConfig.dart';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/screens/MoreScreen/model/NoticeModel.dart';
import 'dart:convert';
import 'package:mryr/network/ApiProvider.dart';
import 'package:mryr/userData/GlobalProfile.dart';

class Notice extends StatefulWidget {
  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              '공지사항',
              style: TextStyle(
                  fontSize: screenWidth * 0.04444,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
//    body: Column(
//      children: [
//        ExpansionTile(title: Text(
//            obj.Title,
//          style: TextStyle(
//            fontSize: screenWidth*0.03333,
//            color: Colors.black
//          ),
//        )),
//
//      ],
//    ),

          body: ListView.builder(
            shrinkWrap: true,
            itemCount: GlobalProfile.ListNoticeModel.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ExpansionTile(
                      title: new Text(
                        GlobalProfile.ListNoticeModel[index].Title == null?"":GlobalProfile.ListNoticeModel[index].Title,
                        style: TextStyle(fontSize: screenWidth * 0.03333),
                      ),
                      subtitle: Text(GlobalProfile.ListNoticeModel[index].updatedAt == null?"":
                      DateFormat('y.MM.d').format(
                          DateTime.parse(GlobalProfile.ListNoticeModel[index].updatedAt)),
                          style: TextStyle(
                              fontSize: screenWidth * 0.027777,
                              color: Colors.grey
                          )),
                      backgroundColor: Colors.white,
                      children: <Widget>[
                        new ListTile(
                          leading: Text(GlobalProfile.ListNoticeModel[index].Contents== null?"":GlobalProfile.ListNoticeModel[index].Contents),
                        )
                      ]),
                  Container(height: 0.5,color: Color(0xffE5E5E5),)
                ],
              );
            },
          )
      ),
    );
  }
}
