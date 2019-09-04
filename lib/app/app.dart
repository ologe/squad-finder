import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/splash/splash.dart';

class App extends StatelessWidget {
  final Provider<SplashPage> _splashPage;

  @provide
  App(this._splashPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squad Finder',
      debugShowCheckedModeBanner: false,
      theme: _theme(),
      home: _splashPage(),
    );
  }

  ThemeData _theme() {
    return ThemeData.light().copyWith(
        primaryColor: Colors.indigo, accentColor: Colors.indigoAccent);
  }
}
