import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/app_controller.dart';
import 'package:project_london_corner/presentation/splash/splash.dart';

class App extends StatefulWidget {
  final AppControllerInternal _appController;
  final Provider<SplashPage> _splashPage;

  @provide
  App(this._splashPage, this._appController);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Squad Finder',
      debugShowCheckedModeBanner: false,
      theme: _theme(),
      home: AppControllerHolder(controller: widget._appController, child: widget._splashPage()),
    );
  }

  ThemeData _theme() {
    return ThemeData.light()
        .copyWith(primaryColor: Colors.indigo, accentColor: Colors.indigoAccent);
  }
}
