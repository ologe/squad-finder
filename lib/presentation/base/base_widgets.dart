import 'dart:async';

import 'package:flutter/material.dart';

abstract class AbsState<T extends StatefulWidget> extends State<T> {
  List<StreamSubscription> subscriptions = [];

  @override
  void dispose() {
    super.dispose();
    for (var value in subscriptions) {
      value.cancel();
    }
  }
}
