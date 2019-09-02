import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/auth_service.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';
import 'package:project_london_corner/core/gateways/location_service.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:rxdart/rxdart.dart';

class HomePageController {
  final AuthService _authService;
  final LocationService _locationService;
  final GroupsService _groupsService;

  @provide
  HomePageController(
      this._authService, this._locationService, this._groupsService);

  void logout() {
    _authService.logOut();
  }

  Future<void> toggleSharePosition(User user) async {
    await _locationService.toggleSharePosition(user.uid);
  }

  Observable<List<Group>> observeUserGroups(User user) {
    return _groupsService.observeUserGroups(user.uid);
  }
}
