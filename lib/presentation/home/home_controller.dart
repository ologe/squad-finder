import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/gateway/auth_service.dart';
import 'package:project_london_corner/core/gateway/group_service.dart';
import 'package:project_london_corner/core/gateway/location_service.dart';
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

  Future<void> toggleSharePosition(String userId) async {
    await _locationService.toggleSharePosition(userId);
  }

  Observable<List<Group>> observeUserGroups(String userId) {
    return _groupsService.observeUserGroups(userId);
  }

  Future<void> approveGroup(String userId, Group group) async {
    await _groupsService.approveGroup(userId, group);
  }
}
