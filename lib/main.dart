import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_london_corner/presentation/splash.dart';

final logger = Logger(printer: PrettyPrinter());

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
