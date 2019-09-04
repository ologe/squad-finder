import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_london_corner/core/user.dart';

import '../user_state.dart';

abstract class AbsState<T extends StatefulWidget> extends State<T> {
  List<StreamSubscription> subscriptions = [];

  @protected
  User get user => UserState.of(context).user;

  @override
  void dispose() {
    super.dispose();
    for (var value in subscriptions) {
      value.cancel();
    }
  }
}

abstract class AbsStatelessWidget extends StatelessWidget {
  @protected
  User user(BuildContext context) => UserState.of(context).user;
}
