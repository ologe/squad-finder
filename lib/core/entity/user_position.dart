import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_position.g.dart';

@JsonSerializable(explicitToJson: true)
class UserPosition {
  // ignore: constant_identifier_names
  static const TABLE = "users";

  // ignore: constant_identifier_names
  static const UID = "uid";

  // ignore: constant_identifier_names
  static const LATITUDE = "lat";

  // ignore: constant_identifier_names
  static const LONGITUDE = "long";

  // ignore: constant_identifier_names
  static const ALLOW_SHARE_LOCATION = "allowShareLocation";

  final String uid;
  final double latitude;
  final double longitude;
  final double accuracy;
  final bool allowShareLocation;

  UserPosition(this.uid, this.latitude, this.longitude, this.accuracy,
      this.allowShareLocation);

  LatLng get latLng {
    return LatLng(latitude, longitude);
  }

  factory UserPosition.fromJson(Map<String, dynamic> json) =>
      _$UserPositionFromJson(json);

  Map<String, dynamic> toJson() => _$UserPositionToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPosition &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy &&
          allowShareLocation == other.allowShareLocation;

  @override
  int get hashCode =>
      uid.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      allowShareLocation.hashCode;

  @override
  String toString() {
    return 'UserPosition{uid: $uid, latitude: $latitude, longitude: $longitude, accuracy: $accuracy, allowShareLocation: $allowShareLocation}';
  }
}
