import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
    String path = join(documentsDirectory.path, "mqtt_app.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Topic(id INTEGER PRIMARY KEY, name TEXT, symbols TEXT)").then((value){
          print('table Topic created');
        }).catchError((error){
          print(error);
        });
    await db.execute(
         "CREATE TABLE Settings(id INTEGER PRIMARY KEY, brokerHost TEXT, symbols brokerPort)").then((value){
           print('table settings created.');
         }).catchError((error){
           print(error);
         });
  }
}