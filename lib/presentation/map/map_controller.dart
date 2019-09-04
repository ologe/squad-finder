import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/auth_service.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';
import 'package:project_london_corner/core/gateways/location_service.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/position.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:rxdart/rxdart.dart';

class MapController {
  final AuthService _authService;
  final GroupsService _groupsService;
  final LocationService _locationService;

  @provide
  MapController(this._groupsService, this._authService, this._locationService);

  Observable<CurrentPosition> observeCurrentPosition() {
    return _authService.observeUser().map((user) => user.lastPosition);
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

  Observable<void> observeLocation(User user) {
    return _locationService.observeLocation().switchMap(
        (position) => _locationService.updateUserPosition(user.uid, position));
  }
}
