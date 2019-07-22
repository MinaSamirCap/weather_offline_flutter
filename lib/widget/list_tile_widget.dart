import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline/model/weather_model.dart';

class ListTileWidget extends StatelessWidget {
  final WeatherModel item;

  ListTileWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            getFormatedDate(item.date),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
      title: Text(item.title),
      subtitle: Text(item.subtitle),
    );
    ;
  }

  String getFormatedDate(item) {
    return DateFormat.E()
        .format(DateTime.fromMillisecondsSinceEpoch(item * 1000))
        .toUpperCase();
  }
}
