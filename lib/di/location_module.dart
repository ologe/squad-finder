import 'package:geolocator/geolocator.dart';
import 'package:inject/inject.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:project_london_corner/core/gateways/location_service.dart';
import 'package:project_london_corner/service/location_service.dart';

@module
class LocationModule {

  @provide
  @singleton
  Geolocator provideGeolocator() => Geolocator();

  @provide
  @singleton
  LocationPermissions provideLocationPermission() => LocationPermissions();

  @provide
  @singleton
  LocationService provideLocationService(LocationServiceImpl impl) => impl;

}