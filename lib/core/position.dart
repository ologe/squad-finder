import 'package:flutter/cupertino.dart';

class CurrentPosition {
  final double lat;
  final double long;
  final double accuracy;

  CurrentPosition(
      {@required this.lat, @required this.long, @required this.accuracy});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentPosition &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          long == other.long &&
          accuracy == other.accuracy;

  @override
  int get hashCode => lat.hashCode ^ long.hashCode ^ accuracy.hashCode;

  @override
  String toString() {
    return 'CurrentPosition{lat: $lat, long: $long, accuracy: $accuracy}';
  }
}
