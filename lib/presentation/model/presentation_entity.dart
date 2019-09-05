import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/entity/group.dart';

class DisplayableGroup {
  final String id;
  final String name;
  final String adminId;
  final bool approvedByCurrentUser;

  DisplayableGroup(
      {@required this.id,
      @required this.name,
      @required this.adminId,
      @required this.approvedByCurrentUser});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayableGroup &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          adminId == other.adminId &&
          approvedByCurrentUser == other.approvedByCurrentUser;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ adminId.hashCode ^ approvedByCurrentUser.hashCode;

  @override
  String toString() {
    return 'DisplayableGroup{id: $id, name: $name, adminId: $adminId, approvedByCurrentUser: $approvedByCurrentUser}';
  }

  Group toDomain() {
    return Group(this.id, this.name, this.adminId);
  }
}

class DisplayableUser {
  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final double accuracy;
  final bool allowShareLocation;

  DisplayableUser(
      {@required this.uid,
      @required this.email,
      @required this.displayName,
      @required this.photoUrl,
      @required this.latitude,
      @required this.longitude,
      @required this.accuracy,
      @required this.allowShareLocation});

  LatLng get latLng {
    return LatLng(latitude, longitude);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayableUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy &&
          allowShareLocation == other.allowShareLocation;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      allowShareLocation.hashCode;

  @override
  String toString() {
    return 'DisplayableUser{uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, latitude: $latitude, longitude: $longitude, accuracy: $accuracy, allowShareLocation: $allowShareLocation}';
  }
}
