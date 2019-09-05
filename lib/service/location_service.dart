import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/core/gateway/location_gateway.dart';
import 'package:rxdart/rxdart.dart';

class LocationServiceImpl implements LocationGateway {
  final Geolocator _location;
  final LocationPermissions _locationPermission;

  @provide
  LocationServiceImpl(this._location, this._locationPermission);

  @override
  Stream<bool> requestPermission() async* {
    final level = LocationPermissionLevel.locationAlways;
    var hasPermission =
        await _locationPermission.checkPermissionStatus(level: level) == PermissionStatus.granted;
    if (!hasPermission) {
      hasPermission = await _locationPermission.requestPermissions(permissionLevel: level) ==
          PermissionStatus.granted;
    }
    yield hasPermission;
    var serviceEnabled = false;
    if (hasPermission) {
      serviceEnabled =
          await _locationPermission.checkServiceStatus(level: level) == ServiceStatus.enabled;
    }
    yield hasPermission && serviceEnabled;
  }

  @override
  Observable<CurrentPosition> observeLocation() {
    final options = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 50,
      forceAndroidLocationManager: true,
    );

    return Observable(_location.getPositionStream(options, GeolocationPermission.locationAlways))
        .map((position) => CurrentPosition(
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy));
  }

  @override
  Future<double> distanceBetween({LatLng from, LatLng to}) async {
    assert(from != null);
    assert(to != null);

    return _location.distanceBetween(from.latitude, from.longitude, to.latitude, to.longitude);
  }

  @override
  Future<String> getUserAddress({UserPosition position}) async {
    final result = await _location.placemarkFromCoordinates(position.latitude, position.longitude);

    if (result.isEmpty) {
      return null;
    }
    final placemark = result.first;
    return "${placemark.thoroughfare}, ${placemark.locality}";
  }
}
