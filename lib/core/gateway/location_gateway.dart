import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:rxdart/rxdart.dart';

abstract class LocationGateway {
  Observable<CurrentPosition> observeLocation();

  Future<double> distanceBetween({@required LatLng from, @required LatLng to});

  Stream<bool> requestPermission();

  Future<String> getUserAddress({@required UserPosition position});
}
