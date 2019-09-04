import 'package:inject/inject.dart';
import 'package:project_london_corner/app/app.dart';
import 'package:project_london_corner/di/database_module.dart';
import 'package:project_london_corner/di/location_module.dart';
import 'package:project_london_corner/di/network_module.dart';

import 'app_component.inject.dart' as g;

@Injector([LocationModule, NetworkModule, DatabaseModule])
abstract class AppComponent {

  @provide
  App app();

  static Future<AppComponent> create(
      LocationModule locationModule,
      NetworkModule networkModule,
      DatabaseModule databaseModule) async {
    return await g.AppComponent$Injector.create(
        locationModule, networkModule, databaseModule
    );
  }

}