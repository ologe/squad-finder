import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateway/user_groups_gateway.dart';

class CreateGroupPageController {
  final UserGroupsGateway _groupsGateway;

  @provide
  CreateGroupPageController(this._groupsGateway);

  void createGroup(String name, String userId, List<String> members) {
    _groupsGateway.createGroup(groupName: name, adminId: userId, emails: members);
  }
}
