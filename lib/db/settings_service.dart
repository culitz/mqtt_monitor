import 'package:mqtt_app/db/db.dart' as db;
import 'package:mqtt_app/db/models.dart';
import 'package:sqflite/sqflite.dart';

class SettingsService{
  Database database;

  SettingsService(){
    // var sql = db.DatabaseHelper();
    // sql.db.then((db){
    //   database = db;
    // });
    // database = await sql.db;
  }

  Future<int> saveSettings(Settings settings) async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    int res = await database.insert("Settings", settings.toMap());
    return res;
  }

  Future<List<Settings>> getSettings() async {
    var sql = db.DatabaseHelper();
    database = await sql.db;
    List<Map> list = await database.rawQuery('SELECT * FROM Settings');
    List<Settings> settingsList = new List();
    for (int i = 0; i < list.length; i++) {
      var settings =
          new Settings(brokerHost: list[i]["brokerHost"], brokerPort:list[i]["brokerPort"]);
      settings.setSettingsId(list[i]["id"]);
      settingsList.add(settings);
    }
    return settingsList;
  }

  Future<int> deleteSettings(Settings settings) async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    int res = await database.rawDelete('DELETE FROM Settings WHERE id = ?', [settings.id]);
    return res;
  }

  Future<bool> update(Settings settings) async {
    var sql = db.DatabaseHelper();
    database  =  await sql.db;
    int res =   await database.update("Settings", settings.toMap(),
        where: "id = ?", whereArgs: <int>[settings.id]);
    return res > 0 ? true : false;
  }
}