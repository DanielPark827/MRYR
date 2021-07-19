import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mryr/constants/AppConfig.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'ChatRecvMessageModel.dart';

final String TableName = "ChatLogs";

class ChatDBHelper {

  ChatDBHelper._();

  static final ChatDBHelper _db = ChatDBHelper._();

  factory ChatDBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'SheepsDB.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          try{
            var res = await db.execute(
                "CREATE TABLE $TableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, roomID INTEGER, userID INTEGER, chatID INTEGER, message TEXT, messageType INTEGER, date TEXT, isRead INTEGER, updatedAt TEXT, isActive INTEGER)"
            );
          }
          catch(e){
            print(e);
          }

        },
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  Future<int> createData(ChatRecvMessageModel messageModel) async {
    final db = await database;

    String resMessage = messageModel.message;
    if(messageModel.messageType ==  getMessageType(MESSAGE_TYPE.IMAGE)){
      resMessage = messageModel.chatId.toString();
    }

    var res = await db.rawInsert("INSERT INTO $TableName(roomID, userID, chatID, message, messageType, date, isRead, updatedAt, isActive) VALUES(?,?,?,?,?,?,?,?,?)",
        [
          messageModel.roomId,
          messageModel.from,
          messageModel.to,
          resMessage,
          messageModel.messageType,
          messageModel.date,
          messageModel.isRead,
          messageModel.updatedAt,
          messageModel.isActive
        ]
    );

    if(false == kReleaseMode){
      print("TABLE SIZE" + res.toString());
    }

    return Future.value(res);
  }

  updateDate(int chatId, int isRead) async {
    final db = await database;

    var res = await db.rawUpdate('''
      UPDATE $TableName
      SET isRead = ?
      WHERE id = ?
      ''',
        [isRead, chatId]);
  }

  updateIsActive(int chatId, int isActive) async {
    final db = await database;

    var res = await db.rawUpdate('''
      UPDATE $TableName
      SET isActive = ?
      WHERE id = ?
      ''',
        [isActive, chatId]);
  }

  updateRoomRead(int roomId, int isRead) async {
    final db = await database;

    var res = await db.rawUpdate('''
      UPDATE $TableName
      SET isRead = ?
      WHERE roomID = ?
      ''',
        [isRead, roomId]);
  }

  Future<List<ChatRecvMessageModel>> getRoomDataByRoomID(int roomID) async {
    final db = await database;
    var res = await db.query(TableName, where: 'roomID = ?', whereArgs: [roomID]);
    List<ChatRecvMessageModel> list  = res.isNotEmpty ? res.map((c) => ChatRecvMessageModel(
      chatId: c['id'],
      roomId: c['roomID'],
      from: c['userID'],
      to: c['chatID'],
      message: c['message'],
      messageType: c['messageType'],
      date: c['date'],
      isRead: c['isRead'],
      updatedAt: c['updatedAt'],
      isActive: c['isActive'],
      isContinue: true,
    )).toList()
        : [];

    return list;
  }

  getData(int id) async {
    final db = await database;
    var res = await db.rawQuery(
        'SELECT * FROM $TableName where roomId = ?', [id]);
    return res.isNotEmpty ?
    ChatRecvMessageModel(
      chatId: res.first['id'],
      roomId: res.first['roomID'],
      from: res.first['userID'],
      to: res.first['chatID'],
      message: res.first['message'],
      messageType: res.first['messageType'],
      date: res.first['date'],
      isRead: res.first['isRead'],
      updatedAt: res.first['updatedAt'],
      isActive: res.first['isActive']
    )
        : null;
  }

  Future<List<ChatRecvMessageModel>> getAllData() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FRom $TableName');
    List<ChatRecvMessageModel> list  = res.isNotEmpty ? res.map((c) => ChatRecvMessageModel(
      chatId: c['id'],
      roomId: c['roomID'],
      from: c['userID'],
      to: c['chatID'],
      message: c['message'],
      messageType: c['messageType'],
      date: c['date'],
      isRead: c['isRead'],
      updatedAt: c['updatedAt'],
      isActive: c['isActive']
    )).toList()
        : [];

    return list;
  }

  deleteData(int id) async{
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName where roomId = ?', [id]);
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
        "CREATE TABLE $TableName(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, roomID INTEGER, userID INTEGER, chatID INTEGER, message TEXT, messageType INTEGER, date TEXT, isRead INTEGER, updatedAt TEXT, isActive INTEGER)"
    );
  }
}