import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  // ignore: constant_identifier_names
  static const TABLE = "users";

  // ignore: constant_identifier_names
  static const UID = "uid";

  // ignore: constant_identifier_names
  static const EMAIL = "email";

  final String uid;
  final String email;
  final String displayName;
  final String photoUrl;
  final DateTime lastSeen;

  User(this.uid, this.email, this.displayName, this.photoUrl, this.lastSeen);

  User.typed(
      {@required this.uid,
      @required this.email,
      @required this.displayName,
      @required this.photoUrl,
      @required this.lastSeen});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl &&
          lastSeen == other.lastSeen;

  @override
  int get hashCode =>
      uid.hashCode ^
      email.hashCode ^
      displayName.hashCode ^
      photoUrl.hashCode ^
      lastSeen.hashCode;

  @override
  String toString() {
    return 'User{uid: $uid, email: $email, displayName: $displayName, photoUrl: $photoUrl, lastSeen: $lastSeen}';
  }
}
