import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable(explicitToJson: true)
class Group {
  // ignore: constant_identifier_names
  static const String TABLE = "groups";

  // ignore: constant_identifier_names
  static const String ID = "id";

  final String id;
  final String name;
  final String adminId;

  Group(this.id, this.name, this.adminId);

  Group.typed(
      {@required this.id, @required this.name, @required this.adminId});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Group &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          adminId == other.adminId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ adminId.hashCode;

  @override
  String toString() {
    return 'Group{id: $id, name: $name, adminId: $adminId}';
  }
}
