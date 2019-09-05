import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/core/gateway/location_gateway.dart';
import 'package:project_london_corner/core/gateway/user_position_gateway.dart';
import 'package:project_london_corner/presentation/model/presentation_entity.dart';
import 'package:rxdart/rxdart.dart';

class MapController {
  final LocationGateway _locationService;
  final UserPositionGateway _userPositionGateway;

  @provide
  MapController(this._locationService, this._userPositionGateway);

  Future<double> distanceBetweenLatLng(LatLng from, LatLng to) {
    return _locationService.distanceBetween(from: from, to: to);
  }

  Observable<void> updateUserPosition(String uid, CurrentPosition position) {
    return Observable.fromFuture(
        _userPositionGateway.updateUserPosition(uid: uid, position: position));
  }

  Future<String> getUserAddress(DisplayableUser user) {
    final position = UserPosition(
        user.uid, user.latitude, user.longitude, user.accuracy, user.allowShareLocation);
    return _locationService.getUserAddress(position: position);
  }
}
