import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/core/gateway/auth_gateway.dart';
import 'package:project_london_corner/core/gateway/user_groups_gateway.dart';
import 'package:project_london_corner/core/gateway/user_position_gateway.dart';
import 'package:rxdart/rxdart.dart';

class HomePageController {
  final AuthGateway _authGateway;
  final UserPositionGateway _userPositionGateway;
  final UserGroupsGateway _userGroupsGateway;

  @provide
  HomePageController(this._userPositionGateway, this._authGateway, this._userGroupsGateway);

  Observable<UserPosition> observeUserPosition(String uid) {
    return _userPositionGateway.observeUserPosition(uid: uid);
  }

  void toggleSharePosition(String userId) async {
    await _userPositionGateway.toggleSharePosition(uid: userId);
  }

  void logout() async {
    await _authGateway.logout();
  }

  Future<void> approveGroup(String userId, String groupId) async {
    await _userGroupsGateway.approveGroup(userId: userId, groupId: groupId);
  }
}
