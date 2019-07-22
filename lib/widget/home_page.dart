import 'package:flutter/material.dart';

import 'body.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Weather'),
        centerTitle: true,
      ),
      body: WeatherBody(),
    );
  }
}
