import 'package:flutter/cupertino.dart';

/// json.
/// uid is the documentId
///
/// {
///   "uid": "actualUserId",
///   "groups": {
///     "actual_group_id": {
///       "approved": bool
///     }
///   }
/// }
class UserGroups {
  // ignore: constant_identifier_names
  static const String TABLE = "user_groups";

  // ignore: constant_identifier_names
  static const String UID = "uid";

  // ignore: constant_identifier_names
  static const String GROUPS = "groups";

  // ignore: constant_identifier_names
  static const String APPROVED = "groups";

  final String uid;
  final List<UserGroup> groups;

  const UserGroups({@required this.uid, @required this.groups});

  factory UserGroups.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> groupsMap = json['groups'];
    final groups = <UserGroup>[];
    groupsMap.forEach((k, v) {
      final group = UserGroup(id: k, approved: v['approved']);
      groups.add(group);
    });

    return UserGroups(uid: json['uid'], groups: groups);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGroups &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          groups == other.groups;

  @override
  int get hashCode => uid.hashCode ^ groups.hashCode;

  @override
  String toString() {
    return 'UserGroups{uid: $uid, groupsId: $groups}';
  }
}

class UserGroup {
  final String id;
  final bool approved;

  const UserGroup({@required this.id, @required this.approved});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          approved == other.approved;

  @override
  int get hashCode => id.hashCode ^ approved.hashCode;

  @override
  String toString() {
    return 'UserGroup{id: $id, approved: $approved}';
  }
}
