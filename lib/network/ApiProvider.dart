import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:mryr/network/CustomException.dart';
import 'package:mryr/userData/GlobalProfile.dart';

class Response<T> {
  Status status;
  T data;
  String message;

  Response.loading(this.message) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }

class ApiProvider {
  //디버그용
  final String _baseUrl = "http://13.124.127.27:50002";
//  릴리즈용
  final String _imgBaseUrl = "https://mryr-development.s3.ap-northeast-2.amazonaws.com/";
  //  final String _imgBaseUrl = "https://mryr-production.s3.ap-northeast-2.amazonaws.com/";

  // final String _baseUrl = "http://13.209.179.158:50002"; //서버 붙는 위치
  String get getUrl => _baseUrl;
  String get getImgUrl => _imgBaseUrl;

  var refreshToken = GlobalProfile.loggedInUser == null ? null : GlobalProfile.loggedInUser.refreshToken;

  //get 만들기
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url,
        headers: {
          'Content-Type' : 'application/json',
          'user' : 'codeforgeek'
        },).timeout(const Duration(seconds: 17));

      if(response.body == "" || response.body == null) return null;

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic data) async{
    var responseJson;

    var refreshToken = GlobalProfile.loggedInUser == null ? null : GlobalProfile.loggedInUser.refreshToken;

    try {
      final response = await http.post(_baseUrl + url,
          headers: {
            'Content-Type' : 'application/json',
            'user' : 'codeforgeek',
            'refreshToken' : refreshToken
          },
          body: data,
          encoding: Encoding.getByName('utf-8')
      ).timeout(const Duration(seconds: 17));

      if(response.body == "" || response.body == null) return null;

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('접속 불량');
    }
    return responseJson;
  }

  //img용 get과 post
  Future<dynamic> imgGet(String url) async {
    var responseJson;
    try {
      final response = await http.get(_imgBaseUrl + url,
        headers: {
          'Content-Type' : 'application/json',
          'user' : 'codeforgeek'
        },);

      if(response.body == "" || response.body == null) return null;

      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        if(!kReleaseMode) print(responseJson);
        return responseJson;
      case 400:
      //throw BadRequestException(response.body.toString());
        BadRequestException(response.body.toString());
        return null;
      case 401:
        return null;
      case 403:
      //throw UnauthorisedException(response.body.toString());
        BadRequestException(response.body.toString());
        return null;
      case 500:
        return null;
      default:
      //throw FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        FetchDataException('Error occured while Communication with Server with StatusCode : ${response.statusCode}');
        return null;
    }
  }
}