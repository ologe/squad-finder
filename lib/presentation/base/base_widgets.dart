import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_state.dart';

abstract class AbsState<T extends StatefulWidget> extends State<T> {
  List<StreamSubscription> subscriptions = [];

  @protected
  FirebaseUser get user => UserState.of(context).user;

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
  FirebaseUser user(BuildContext context) => UserState.of(context).user;
}
