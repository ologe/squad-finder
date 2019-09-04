import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends InheritedWidget {
  final FirebaseUser user;

  const UserState({@required this.user, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(UserState oldWidget) {
    return oldWidget?.user?.uid == user?.uid;
  }

  static UserState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(UserState);
  }
}
