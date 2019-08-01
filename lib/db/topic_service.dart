import 'package:mqtt_app/db/db.dart' as db;
import 'package:mqtt_app/db/models.dart';
import 'package:sqflite/sqflite.dart';

class TopicService{
  Database database;

  TopicService() {
    // var sql = db.DatabaseHelper();
    // sql.db.then((db){
    //   database = db;
    // });
  }

  Future<int> saveTopic(Topic topic) async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    int res = await database.insert("Topic", topic.toMap());
    return res;
  }

  Future<List<Topic>> getTopic() async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    List<Map> list = await database.rawQuery('SELECT * FROM Topic');
    List<Topic> topics = new List();
    for (int i = 0; i < list.length; i++) {
      var topic =
          new Topic(name: list[i]["name"], symbols:list[i]["symbols"]);
      topic.setTopicId(list[i]["id"]);
      topics.add(topic);
    }
    return topics;
  }

  Future<int> deleteTopic(Topic topic) async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    int res = await database.rawDelete('DELETE FROM Topic WHERE id = ?', [topic.id]);
    return res;
  }

  Future<bool> update(Topic topic) async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    int res =   await database.update("Topic", topic.toMap(),
        where: "id = ?", whereArgs: <int>[topic.id]);
    return res > 0 ? true : false;
  }
}