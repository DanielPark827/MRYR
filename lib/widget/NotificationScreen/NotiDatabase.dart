import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import './NotificationModel.dart';

final String TableName = "NotiLogs";

class NotiDBHelper {

  NotiDBHelper._();

  static final NotiDBHelper _db = NotiDBHelper._();

  factory NotiDBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'NotiDB.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          try{
            var res = await db.execute(
                "CREATE TABLE $TableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserID INTEGER, ChatID INTEGER, type INTEGER, tableIndex INTEGER, time TEXT, isRead INTEGER)"
            );
          }
          catch(e){
            print(e);
          }

        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  createData(NotificationModel notiModel) async {
    final db = await database;

    var res = await db.rawInsert("INSERT INTO $TableName(UserID, ChatID, type, tableIndex, time, isRead) VALUES(?,?,?,?,?,?)",
        [
          notiModel.from,
          notiModel.to,
          notiModel.type,
          notiModel.index,
          notiModel.time,
          notiModel.isRead
        ]
    );

    if(false == kReleaseMode){
      print("TABLE SIZE" + res.toString());
    }

    return res;
  }

  updateDate(int id, int isRead) async {
    final db = await database;

    var res = await db.rawUpdate('''
      UPDATE $TableName
      SET isRead = ?
      WHERE id = ?
      ''',
        [isRead, id]);
  }

  getData(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $TableName where id = ?', [id]);
    return res.isNotEmpty ?
    NotificationModel(
      id: res.first['id'],
      from: res.first['UserID'],
      to: res.first['ChatID'],
      type: res.first['type'],
      index: res.first['tableIndex'],
      time: res.first['time'],
      isRead: res.first['isRead'],
    )
        : null;
  }

  Future<List<NotificationModel>> getAllData() async {
    final db = await database;

    var res = await db.rawQuery('SELECT * from $TableName');
    List<NotificationModel> list  = res.isNotEmpty ? res.map((c) => NotificationModel(
      id: res.first['id'],
      from: res.first['UserID'],
      to: res.first['ChatID'],
      type: res.first['type'],
      index: res.first['tableIndex'],
      time: res.first['time'],
      isRead: res.first['isRead'],
    )).toList()
        : [];

    return list;
  }

  deleteData(int id) async{
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName where id = ?', [id]);
    return res;
  }

  deleteAllDatas() async {
    final db = await database;
    db.rawDelete("DELETE from $TableName");
  }

  dropTable() async{
    final db = await database;
    db.execute("DROP TABLE IF EXISTS $TableName");
    await db.execute(
        "CREATE TABLE $TableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, UserID INTEGER, ChatID INTEGER, type INTEGER, tableIndex INTEGER, time TEXT, isRead INTEGER)"
    );
  }
}