import 'package:flutter/cupertino.dart';

class Group {
  final String uid;
  final String name;
  final String adminId;
  final List<String> members;

  Group(
      {@required this.uid,
      @required this.name,
      @required this.adminId,
      @required this.members});

  int get membersCount {
    return members.length;
  }

  factory Group.fromJson(Map<String, dynamic> json) {
    final members =
        (json['members'] as List<dynamic>).map((m) => m.toString()).toList();

    return Group(
        uid: json['uid'] as String,
        name: json['name'] as String,
        adminId: json['adminId'] as String,
        members: members);
  }
}
