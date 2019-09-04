import 'package:flutter/cupertino.dart';
import 'package:project_london_corner/core/member.dart';

class Group {
  final String uid;
  final String name;
  final String adminId;
  final List<Member> members;

  Group(
      {@required this.uid,
      @required this.name,
      @required this.adminId,
      @required this.members});

  int get membersCount {
    return members.length;
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    final members = (json['members'] as List<dynamic>)
        .map((item) => item as Map<dynamic, dynamic>)
        .map((e) {
          return e.map((k, v) => MapEntry(k.toString(), v));
        })
        .map((map) => Member.fromJson(map))
        .toList();

    return Group(
        uid: json['uid'] as String,
        name: json['name'] as String,
        adminId: json['adminId'] as String,
        members: members);
  }

  @override
  String toString() {
    return 'Group{uid: $uid, name: $name, adminId: $adminId, members: $members}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          adminId == other.adminId &&
          members == other.members;

  @override
  int get hashCode =>
      uid.hashCode ^ name.hashCode ^ adminId.hashCode ^ members.hashCode;
}
