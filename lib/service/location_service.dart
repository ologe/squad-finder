import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:project_london_corner/core/gateways/location_service.dart';
import 'package:project_london_corner/core/position.dart';
import 'package:rxdart/rxdart.dart';

class LocationServiceImpl implements LocationService {
  final Geolocator _location;
  final LocationPermissions _locationPermission;
  final Firestore _db;

  @provide
  LocationServiceImpl(this._location, this._locationPermission, this._db);

  @override
  Stream<bool> requestPermission() async* {
    final level = LocationPermissionLevel.locationAlways;
    var hasPermission = await _locationPermission.checkPermissionStatus(level: level) ==
            PermissionStatus.granted;
    if (!hasPermission) {
      hasPermission = await _locationPermission.requestPermissions(
              permissionLevel: level) ==
          PermissionStatus.granted;
    }
    yield hasPermission;
    var serviceEnabled = false;
    if (hasPermission) {
      serviceEnabled =
          await _locationPermission.checkServiceStatus(level: level) ==
              ServiceStatus.enabled;
    }
    yield hasPermission && serviceEnabled;
  }

  @override
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

  @override
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

  @override
  Future<double> distanceBetween(LatLng from, LatLng to) async {
    return _location.distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);
  }

  @override
  Future<void> toggleSharePosition(String uid) async {
    final ref = _db.collection("users").document(uid);
    final snapshot = await ref.get();
    await ref.setData(
        {"allowShareLocation": !(snapshot.data['allowShareLocation'] as bool)},
        merge: true);
  }
}
