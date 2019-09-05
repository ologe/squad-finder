import 'package:flutter/cupertino.dart';

class CurrentPosition {
  final double latitude;
  final double longitude;
  final double accuracy;

  CurrentPosition({@required this.latitude, @required this.longitude, @required this.accuracy});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentPosition &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ accuracy.hashCode;

  @override
  String toString() {
    return 'Position{latitude: $latitude, longitude: $longitude, accuracy: $accuracy}';
  }
}
