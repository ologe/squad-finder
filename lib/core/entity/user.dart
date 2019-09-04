import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/entity/position.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final bool allowShareLocation;
  final CurrentPosition lastPosition;

  User(
      {@required this.uid,
      @required this.email,
      @required this.allowShareLocation,
      @required this.displayName,
      @required this.photoUrl,
      @required this.lastPosition});

  LatLng get position {
    return LatLng(lastPosition.lat, lastPosition.long);
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    final lastPosition = CurrentPosition(
        lat: json['lastPosition']['lat'],
        long: json['lastPosition']['long'],
        accuracy: json['lastPosition']['accuracy']);

    return User(
        uid: json['uid'] as String,
        email: json['name'] as String,
        allowShareLocation: json['allowShareLocation'],
        displayName: json['displayName'] as String,
        lastPosition: lastPosition,
        photoUrl: json['photoUrl']);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          allowShareLocation == other.allowShareLocation &&
          lastPosition == other.lastPosition;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode ^
      allowShareLocation.hashCode ^
      lastPosition.hashCode;

  @override
  String toString() {
    return 'User{uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, allowShareLocation: $allowShareLocation, lastPosition: $lastPosition}';
  }
}
