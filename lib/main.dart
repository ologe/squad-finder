import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:logger/logger.dart';
import 'package:project_london_corner/di/database_module.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/di/location_module.dart';
import 'package:project_london_corner/presentation/splash/splash.dart';

import 'di/app_component.dart';
import 'di/network_module.dart';

final logger = Logger(printer: PrettyPrinter());

void main() async {
  final container = await AppComponent.create(
      LocationModule(), NetworkModule(), DatabaseModule());
  runApp(container.app());
}

class App extends StatelessWidget {
  final Provider<SplashPage> _splashPage;

  @provide
  App(this._splashPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project London Corner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _splashPage(),
    );
  }
}
