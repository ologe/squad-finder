import 'package:flutter/material.dart';
import 'package:project_london_corner/presentation/widget/utils.dart';

import '../../main.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final CustomWidgetBuilder<T> builder;

  CustomFutureBuilder({@required this.future, @required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          throw StateError("can not return null");
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData &&
            !snapshot.hasError) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e(snapshot.error);
          return new Text('Error: ${snapshot.error}');
        }
        return builder(context, snapshot.data);
      },
    );
  }
}
