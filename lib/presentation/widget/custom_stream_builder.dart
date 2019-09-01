import 'package:flutter/material.dart';
import 'package:project_london_corner/presentation/widget/utils.dart';

import '../../main.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final CustomWidgetBuilder<T> builder;

  CustomStreamBuilder({@required this.stream, @required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
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
