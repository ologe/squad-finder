import 'package:flutter/cupertino.dart';

class CurrentPosition {
  final double lat;
  final double long;
  final double accuracy;

  CurrentPosition(
      {@required this.lat, @required this.long, @required this.accuracy});
}
