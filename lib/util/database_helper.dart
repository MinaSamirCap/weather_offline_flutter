import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_offline/model/weather_model.dart';

// this class will responsible for creating database, tables and all operations.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  /// factory word will help us not to create multi instance from the same class ...
  factory DatabaseHelper() => _instance;

  static final String tableWeather = "wetherTable";
  static final String columnId = "id";
  static final String columnDate = "date";
  static final String columnTitle = "title";
  static final String columnSubTitle = "sub_title";
  static final String columnDay = "day";
  static final String columnNight = "night";
  static final String columnMin = "min";
  static final String columnMax = "max";

  /// database object
  static Database _db;

  /// apply singleton pattern ...
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  /// the name of internal can be anything .. we can give it any name ..
  /// the idea of this constructor it is to be private to the class ..
  DatabaseHelper.internal() {}

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "weather.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);

    return ourDb;
  }

  /*
    id | title | subtitle | day | night | min | maz
    -------------------------
     1 | clear  | Sky is clear | 286.25 | 286.25 | 286.25 | 286.25
     2 | snow | light snow | 286.25 | 286.25 | 286.25 | 286.25
   */

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableWeather($columnId INTEGER PRIMARY KEY,"
        " $columnDate INTEGER, $columnTitle TEXT, $columnSubTitle TEXT,"
        " $columnDay REAL, $columnNight REAL, $columnMax REAL, $columnMin REAL )");
  }

  // CRUD --> create read update delete ...

  //Insertion
  Future<int> saveWeather(WeatherModel model) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableWeather, model.toMap());
    return res;
  }

  // get all weather ...
  Future<List> getAllWeather() async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $tableWeather");
    return res.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $tableWeather"));
  }


  Future<int> deleteWeather(int id) async {
    var dbClient = await db;
    var res = await dbClient
        .delete(tableWeather, where: "$columnId = ?", whereArgs: [id]);
    return res;
  }

  void clearTableWeather() async{
    var dbClient = await db;
    dbClient.delete(tableWeather);
  }

  Future closeDb() async {
    return (await db).close();
  }
}
