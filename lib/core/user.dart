import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final LatLng lastPosition;

  User(
      {@required this.uid,
      @required this.email,
      @required this.displayName,
      @required this.photoUrl,
      @required this.lastPosition});

  factory User.fromJson(Map<dynamic, dynamic> json) {
    final lastPosition =
        LatLng(json['lastPosition']['lat'], json['lastPosition']['long']);

    return User(
        uid: json['uid'] as String,
        email: json['name'] as String,
        displayName: json['displayName'] as String,
        lastPosition: lastPosition,
        photoUrl: json['photoUrl']);
  }
}
