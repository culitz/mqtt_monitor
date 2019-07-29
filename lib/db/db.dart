class DBProvider {

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
}