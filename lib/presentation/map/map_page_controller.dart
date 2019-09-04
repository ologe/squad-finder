import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/gateway/group_service.dart';
import 'package:project_london_corner/core/gateway/location_service.dart';
import 'package:rxdart/rxdart.dart';

class MapController {
  final GroupsService _groupsService;
  final LocationService _locationService;

  @provide
  MapController(this._groupsService, this._locationService);

  Observable<CurrentPosition> observeCurrentPosition() {
    return _locationService.observeLocation();
  }

  Observable<List<User>> observeMemberPosition(Group group) {
    if (group == null) {
      return Observable.just([]);
    }
    return _groupsService.observeMemberPosition(group);
  }

  Future<double> distanceBetweenLatLng(LatLng from, LatLng to) {
    return _locationService.distanceBetween(from, to);
  }

  Observable<void> updateUserPosition(String userId, CurrentPosition position) {
    return _locationService.updateUserPosition(userId, position);
  }

  Future<String> getUserAddress(User user) async {
    return await _locationService.getUserAddress(user);
  }
}
