import 'package:flutter/cupertino.dart';

class Member {
  final String uid;
  final bool pending;

  Member({@required this.uid, @required this.pending});

  factory Member.fromJson(Map<String, dynamic> json){
    return Member(
      uid: json['uid'],
      pending: json['pending']
    );
  }
}
