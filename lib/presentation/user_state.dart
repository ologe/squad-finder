import 'package:flutter/material.dart';
import 'package:project_london_corner/core/user.dart';

class UserState extends InheritedWidget {
  final User user;

  const UserState({@required this.user, @required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(UserState oldWidget) {
    return oldWidget.user == user;
  }

  static UserState of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(UserState);
  }
}
