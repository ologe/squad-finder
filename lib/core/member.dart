import 'package:flutter/cupertino.dart';

class Member {
  final String uid;
  final bool pending;

  Member({@required this.uid, @required this.pending});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(uid: json['uid'], pending: json['pending']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Member &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          pending == other.pending;

  @override
  int get hashCode => uid.hashCode ^ pending.hashCode;

  @override
  String toString() {
    return 'Member{uid: $uid, pending: $pending}';
  }
}
