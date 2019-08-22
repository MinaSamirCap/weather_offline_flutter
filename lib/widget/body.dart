import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_offline/model/weather_model.dart';
import 'package:weather_offline/util/database_helper.dart';
import 'package:weather_offline/widget/temp_widget.dart';

import 'list_tile_widget.dart';

class WeatherBody extends StatefulWidget {
  @override
  _WeatherBodyState createState() => _WeatherBodyState();
}

class _WeatherBodyState extends State<WeatherBody> {
  String currentState = "loading";
  bool networkState = false;
  bool isApiCalled = false;
  bool isDatabaseCalled = false;

  List<WeatherModel> listWeatherApi = [];

  List<WeatherModel> listWeatherDatabase = [];

  @override
  void initState() {
    super.initState();
    checkTheConnectivity();
  }

  void checkLogicOFConnection() {
    if (isApiCalled) {
    } else {
      if (networkState) {
        print("OFFAPP: get data online");
        print("OFFAPP: get data devNermeen");
        isApiCalled = true;
        getWeather();
      } else {
        if (isDatabaseCalled) {
        } else {
          isDatabaseCalled = true;
          print("OFFAPP: get data offline");
          getWeatherDataFromDatabase();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    /// removed all prints ... ;

    
    checkLogicOFConnection();
    return listWeatherDatabase.length == 0
        ? Center(
            child: Text(currentState),
          )
        : ListView.builder(
            itemCount: listWeatherDatabase.length,
            itemBuilder: (cxt, index) {
              final WeatherModel item = listWeatherDatabase[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 6,
                child: Container(
                  child: Stack(
                    children: <Widget>[ListTileWidget(item), TempWidget(item)],
                  ),
                ),
              );
            });
  }

  void getWeather() async {
    final apiUrl =
        "https://samples.openweathermap.org/data/2.5/forecast/daily?q=M%C3%BCnchen,DE&appid=b6907d289e10d714a6e88b30761fae22";
    http.Response response = await http.get(apiUrl);

    print(json.decode(response.body)['list']);
    setState(() {
      currentState = "data received";
    });
    List list = json.decode(response.body)['list'];
    listWeatherApi.clear();

    for (int i = 0; i < list.length; i++) {
      setState(() {
        listWeatherApi.add(WeatherModel.fromJson(list[i]));
      });
    }
    insertWeatherData();
  }

  void insertWeatherData() {
    var db = DatabaseHelper();
    db.clearTableWeather();

    changeCurrentState("inserting data");

    for (int i = 0; i < listWeatherApi.length; i++) {
      db.saveWeather(listWeatherApi[i]);
    }
    getWeatherDataFromDatabase();
  }

  void getWeatherDataFromDatabase() async {
    var db = DatabaseHelper();

    changeCurrentState("retreive data");

    List list = await db.getAllWeather();
    listWeatherDatabase.clear();
    for (int i = 0; i < list.length; i++) {
      setState(() {
        listWeatherDatabase.add(WeatherModel.map(list[i]));
      });
    }
  }

  void checkTheConnectivity() async {
    networkState = await checkConnection();
    //changeCurrentState("check connection");
  }

  void changeCurrentState(String text) {
    setState(() {
      currentState = text;
    });
  }

  Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi);
  }
}
