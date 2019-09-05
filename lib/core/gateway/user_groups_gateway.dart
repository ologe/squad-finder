import 'package:flutter/cupertino.dart';
import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/entity/user_groups.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserGroupsGateway {
  Observable<UserGroups> observeUserGroups({@required String uid});

  Future<void> createGroup({@required String groupName, @required String adminId, @required List<String> emails});

  Future<void> approveGroup({@required String userId, @required String groupId});

  /// returns members uid
  Observable<List<String>> observeGroupMembers({@required String groupId});

  Observable<Group> observeGroup({@required String groupId});

  Observable<List<Group>> observeMultipleGroups({@required List<String> groupIdList});
}
