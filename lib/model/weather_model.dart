import 'package:weather_offline/util/database_helper.dart';

class WeatherModel {
  int id;
  int date;
  String title;
  String subtitle;

  double day;
  double min;
  double max;
  double night;

  WeatherModel(this.date, this.title, this.subtitle, this.day, this.min,
      this.max, this.night);

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        json['dt'],
        json['weather'][0]['main'],
        json['weather'][0]['description'],
        json['temp']['day'],
        json['temp']['min'],
        json['temp']['max'],
        json['temp']['night']);
  }

  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    map[DatabaseHelper.columnDate] = this.date;
    map[DatabaseHelper.columnTitle] = this.title;
    map[DatabaseHelper.columnSubTitle] = this.subtitle;
    map[DatabaseHelper.columnNight] = this.night;
    map[DatabaseHelper.columnDay] = this.day;
    map[DatabaseHelper.columnMin] = this.min;
    map[DatabaseHelper.columnMax] = this.max;
    if (id != null) map[DatabaseHelper.columnId] = this.id;
    return map;
  }

  factory WeatherModel.map(dynamic obj) {
    return WeatherModel(
        obj[DatabaseHelper.columnDate],
        obj[DatabaseHelper.columnTitle],
        obj[DatabaseHelper.columnSubTitle],
        obj[DatabaseHelper.columnNight],
        obj[DatabaseHelper.columnMin],
        obj[DatabaseHelper.columnMax],
        obj[DatabaseHelper.columnDay]);
  }
}
