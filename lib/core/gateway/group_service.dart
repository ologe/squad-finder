import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class GroupsService {
  Observable<List<Group>> observeUserGroups(String userId);

  Observable<List<User>> observeMemberPosition(Group group);

  Future<void> createGroup(String name, String userId, List<String> members);

  Future<void> approveGroup(String userId, Group group);
}
