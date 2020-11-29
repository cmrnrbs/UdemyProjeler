import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'dart:core';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;

    _db = await initDb();

    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "/users.db";
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);

    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Users(id INTEGER PRIMARY KEY, name TEXT, surname TEXT, email TEXT)");
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<User> results = new List<User>();
    List<Map> list = await dbClient.rawQuery("SELECT * FROM Users");
    for (var i = 0; i < list.length; i++) {
      var user = new User(
          name: list[i]["name"],
          surname: list[i]["surname"],
          email: list[i]["email"]);
      user.setIUserId(list[i]["id"]);
      results.add(user);
    }

    return results;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;
    int res = await dbClient.update("Users", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);

    return res > 0 ? true : false;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    int res =
        await dbClient.delete("Users", where: "id = ?", whereArgs: <int>[id]);

    return res;
  }

  Future<int> insertUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("Users", user.toMap());
    return res;
  }
}
