import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:project_london_corner/core/position.dart';
import 'package:rxdart/rxdart.dart';

LocationService _locationService;

LocationService get locationService {
  if (_locationService == null) {
    _locationService = LocationService();
  }
  return _locationService;
}

class LocationService {
  final _location = Geolocator();
  final _locationPermission = LocationPermissions();
  final _db = Firestore.instance;

  Future<bool> requestPermission() async {
    final level = LocationPermissionLevel.locationAlways;
    var hasPermission =
        await _locationPermission.checkPermissionStatus(level: level) ==
            PermissionStatus.granted;
    if (!hasPermission) {
      hasPermission = await _locationPermission.requestPermissions(
              permissionLevel: level) ==
          PermissionStatus.granted;
    }
    var serviceEnabled = false;
    if (hasPermission) {
      serviceEnabled =
          await _locationPermission.checkServiceStatus(level: level) ==
              ServiceStatus.enabled;
    }
    return hasPermission && serviceEnabled;
  }

  Observable<CurrentPosition> observeLocation() {
    final options = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
      forceAndroidLocationManager: true,
    );
    return Observable(_location.getPositionStream(
            options, GeolocationPermission.locationAlways))
        .map((position) => CurrentPosition(
            lat: position.latitude,
            long: position.longitude,
            accuracy: position.accuracy));
  }

  Observable<void> updateUserPosition(String uid, CurrentPosition position) {
    final ref = _db.collection("users").document(uid);
    return Observable.fromFuture(ref.setData({
      "lastPosition": {
        "lat": position.lat,
        "long": position.long,
        "accuracy": position.accuracy
      }
    }, merge: true));
  }

  Future<double> distanceBetween(LatLng me, LatLng other) async {
    return _location.distanceBetween(
        me.latitude, me.longitude, other.latitude, other.longitude);
  }

  Future<void> toggleSharePosition(String uid) async {
    final ref = _db.collection("users").document(uid);
    final snapshot = await ref.get();
    await ref.setData(
        {"allowShareLocation": !(snapshot.data['allowShareLocation'] as bool)},
        merge: true);
  }
}
