import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';

class CreateGroupPageController {

  final GroupsService _groupsService;

  @provide
  CreateGroupPageController(this._groupsService);
}