import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';
import 'package:project_london_corner/service/groups_service.dart';

@module
class DatabaseModule {

  @provide
  @singleton
  Firestore provideFirestore() => Firestore.instance;

  @provide
  @singleton
  GroupsService provideGroupService(GroupsServiceImpl impl) => impl;

}