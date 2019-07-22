import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_offline/model/weather_model.dart';

class TempWidget extends StatelessWidget {
  final WeatherModel item;

  TempWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Day: ${item.day}'),
              Text('Min: ${item.min}'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Max: ${item.max}'),
              Text('Night: ${item.night}')
            ],
          )
        ],
      ),
    );
  }

  String getFormatedDate(item) {
    return DateFormat.E()
        .format(DateTime.fromMillisecondsSinceEpoch(item * 1000))
        .toUpperCase();
  }
}
