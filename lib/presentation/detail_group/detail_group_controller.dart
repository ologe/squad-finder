import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/auth_service.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';
import 'package:project_london_corner/core/gateways/location_service.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:rxdart/rxdart.dart';

class DetailGroupPageController {
  final AuthService _authService;
  final LocationService _locationService;
  final GroupsService _groupsService;

  @provide
  DetailGroupPageController(
      this._locationService, this._groupsService, this._authService);

  Observable<void> observeLocation(User user) {
    return _locationService.observeLocation().switchMap(
        (position) => _locationService.updateUserPosition(user.uid, position));
  }

  Stream<bool> requestPermission() {
    return _locationService.requestPermission();
  }

  Observable<User> observeCurrentUser() {
    return _authService.observeUser();
  }

  Future<double> distanceBetweenLatLng(LatLng from, LatLng to){
    return _locationService.distanceBetween(from, to);
  }

  Observable<List<User>> observeMemberPosition(Group group){
    return _groupsService.observeMemberPosition(group);
  }

}
