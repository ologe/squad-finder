import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateway/group_service.dart';

class CreateGroupPageController {
  final GroupsService _groupsService;

  @provide
  CreateGroupPageController(this._groupsService);

  void createGroup(String name, String userId, List<String> members) {
    _groupsService.createGroup(name, userId, members);
  }
}
