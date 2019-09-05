import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tmp_user.g.dart';

@JsonSerializable(explicitToJson: true)
class TmpUser {
  // ignore: constant_identifier_names
  static const String TABLE = "tmp_user";

  // ignore: constant_identifier_names
  static const String UID = "tmpUid";

  // ignore: constant_identifier_names
  static const String EMAIL = "email";

  final String tmpUid;
  final String email;

  TmpUser(this.tmpUid, this.email);

  TmpUser.typed({@required this.tmpUid, @required this.email});

  factory TmpUser.fromJson(Map<String, dynamic> json) => _$TmpUserFromJson(json);

  Map<String, dynamic> toJson() => _$TmpUserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TmpUser &&
          runtimeType == other.runtimeType &&
          tmpUid == other.tmpUid &&
          email == other.email;

  @override
  int get hashCode => tmpUid.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'TmpUser{tmpUid: $tmpUid, email: $email}';
  }
}
