
export 'kopo_model.dart';

import 'dart:convert';


import 'package:mryr/packages/localHostServer/in_app_localhost_server.dart' as ia;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'kopo_model.dart';


class Kopo extends StatefulWidget {
  static const String PATH = '/kopo';


  final String title;
  final Color colour;
  final String apiKey;

  /// if [userLocalServer] is true, the search page is running on localhost. Default is false.
  ///
  /// [userLocalServer] 값이 ture면, 검색 페이지를 로컬 서버에서 동작시킵니다.
  /// 기본적으로 연결된 웹페이지에 문제가 생기더라도 작동 가능합니다.
  final bool useLocalServer;

  /// Localhost port number. Default is 8080.
  ///
  /// 로컬 서버 포트. 기본값은 8080
  final int localPort;

  Kopo({
    Key key,
    this.title = '주소검색',
    this.colour = Colors.white,
    this.apiKey = '',
    this.useLocalServer = false,
    this.localPort = 8080,
  }) : assert(1024 <= localPort && localPort <= 49151,
  'localPort is out of range. It should be from 1024 to 49151(Range of Registered Port)'),
        super(key: key);

  @override
  KopoState createState() => KopoState();

}

class KopoState extends State<Kopo> {
  WebViewController _controller;
  WebViewController get controller => _controller;


  ia.InAppLocalhostServer _localhost;
  bool isLocalhostOn = false;


  @override
  void initState() {
    super.initState();
    if (widget.useLocalServer) {
      _localhost = ia.InAppLocalhostServer(port: widget.localPort);
      _localhost.start().then((_) {
        setState(() {
          isLocalhostOn = true;
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.useLocalServer) _localhost?.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.colour,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData().copyWith(color: Colors.black),
      ),
      body: _buildWebView()
    );
  }

  Widget _buildWebView() {
    String _initialUrl = widget.useLocalServer
        ? 'http://localhost:${widget.localPort}/packages/kpostal/assets/kakao_postcode_localhost.html'
        : 'https://tykann.github.io/kpostal/assets/kakao_postcode.html';
    if (widget.useLocalServer && !this.isLocalhostOn) {
      return Center(child: CircularProgressIndicator());
    }
    return WebView(
        initialUrl: _initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>[_channel].toSet(),
        onWebViewCreated: (WebViewController webViewController) async {
          this._controller = webViewController;
        });
  }

  // 자바스크립트 채널
  JavascriptChannel get _channel => JavascriptChannel(
      name: 'onComplete',
      onMessageReceived: (JavascriptMessage message) {
        KopoModel result = KopoModel.fromJson(jsonDecode(message.message));

        Navigator.pop(context, result);
      });
}
