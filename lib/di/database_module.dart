import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateway/user_gateway.dart';
import 'package:project_london_corner/core/gateway/user_groups_gateway.dart';
import 'package:project_london_corner/core/gateway/user_position_gateway.dart';
import 'package:project_london_corner/service/user_groups_service.dart';
import 'package:project_london_corner/service/user_position_service.dart';
import 'package:project_london_corner/service/user_service.dart';

@module
class DatabaseModule {
  @provide
  @singleton
  Firestore provideFirestore() => Firestore.instance;

  @provide
  @singleton
  UserGateway provideUserGateway(UserService impl) => impl;

  @provide
  @singleton
  UserGroupsGateway provideUserGroupsGateway(UserGroupsService impl) => impl;

  @provide
  @singleton
  UserPositionGateway provideUserPositionGateway(UserPositionService impl) =>
      impl;
}
