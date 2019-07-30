import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mqtt_app/db/topic.dart' as model;

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
        "CREATE TABLE Topic(id INTEGER PRIMARY KEY, name TEXT, symbols TEXT)");
  }

  Future<int> saveTopic(model.Topic topic) async {
    var dbTopic = await db;
    int res = await dbTopic.insert("Topic", topic.toMap());
    return res;
  }

  Future<List<model.Topic>> getTopic() async {
    var dbTopic = await db;
    List<Map> list = await dbTopic.rawQuery('SELECT * FROM Topic');
    List<model.Topic> topics = new List();
    for (int i = 0; i < list.length; i++) {
      var topic =
          new model.Topic(name: list[i]["name"], symbols:list[i]["symbols"]);
      topic.setTopicId(list[i]["id"]);
      topics.add(topic);
    }
    print(topics.length);
    return topics;
  }

  Future<int> deleteTopic(model.Topic topic) async {
    var dbTopic = await db;
    int res = await dbTopic.rawDelete('DELETE FROM Topic WHERE id = ?', [topic.id]);
    return res;
  }

  Future<bool> update(model.Topic topic) async {
    var dbTopic = await db;
    int res =   await dbTopic.update("Topic", topic.toMap(),
        where: "id = ?", whereArgs: <int>[topic.id]);
    return res > 0 ? true : false;
  }
}