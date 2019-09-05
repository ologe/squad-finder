import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_london_corner/presentation/app_controller.dart';

// main
abstract class AbsState<T extends StatefulWidget> extends State<T> {
  @protected
  AppControllerInternal get appController => AppController.of(context);

  List<StreamSubscription> subscriptions = [];

  bool _hasInit = false;

  @override
  @mustCallSuper
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_hasInit) {
      afterInit();
      _hasInit = true;
    }
  }

  @protected
  void afterInit() {}

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
  AppControllerInternal appController(BuildContext context) => AppController.of(context);
}
