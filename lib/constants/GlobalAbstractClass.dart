import 'package:flutter/material.dart';

abstract class StoppableService {
  bool _serviceStoped = false;
  bool get serviceStopped => _serviceStoped;

  @mustCallSuper
  void stop() {
    _serviceStoped = true;
  }

  @mustCallSuper
  void start() {
    _serviceStoped = false;
  }
}

class gCoordinate {
  double lat;
  double lng;
  String loc;

  gCoordinate({this.lng,this.lat,this.loc});

  factory gCoordinate.fromJson(Map<String, dynamic> json){
    return gCoordinate(
      lng: json['Longitude'] as double,
      lat: json['Latitude'] as double,
      loc: json['Location'] as String,
    );
  }
}