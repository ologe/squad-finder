import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';
import 'package:project_london_corner/core/user.dart';

class CreateGroupPageController {
  final GroupsService _groupsService;

  @provide
  CreateGroupPageController(this._groupsService);

  void createGroup(String name, User user, List<String> members){
    _groupsService.createGroup(name, user, members);
  }
}
