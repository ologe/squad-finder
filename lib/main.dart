import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_london_corner/presentation/splash.dart';

final logger = Logger(printer: PrettyPrinter());

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Project London Corner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
