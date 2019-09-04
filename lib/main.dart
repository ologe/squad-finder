import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:project_london_corner/di/database_module.dart';
import 'package:project_london_corner/di/location_module.dart';

import 'di/app_component.dart';
import 'di/network_module.dart';

final logger = Logger(printer: PrettyPrinter());

void main() async {
  final container = await AppComponent.create(
      LocationModule(), NetworkModule(), DatabaseModule());
  runApp(container.app());
}
