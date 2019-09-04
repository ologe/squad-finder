import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class LocationService {
  Observable<CurrentPosition> observeLocation();

  Observable<void> updateUserPosition(String uid, CurrentPosition position);

  Future<void> toggleSharePosition(String uid);

  Future<double> distanceBetween(LatLng from, LatLng to);

  Stream<bool> requestPermission();

  Future<String> getUserAddress(User user);
}
