import 'package:rxdart/rxdart.dart';

import '../group.dart';
import '../user.dart';

abstract class GroupsService {
  Observable<List<Group>> observeUserGroups(String userId);
  Observable<List<User>> observeMemberPosition(Group group);
}