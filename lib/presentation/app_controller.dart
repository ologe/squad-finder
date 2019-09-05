import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/entity/user_groups.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/core/gateway/auth_gateway.dart';
import 'package:project_london_corner/core/gateway/location_gateway.dart';
import 'package:project_london_corner/core/gateway/user_gateway.dart';
import 'package:project_london_corner/core/gateway/user_groups_gateway.dart';
import 'package:project_london_corner/core/gateway/user_position_gateway.dart';
import 'package:project_london_corner/presentation/model/presentation_entity.dart';
import 'package:rxdart/rxdart.dart';

class AppControllerInternal {
  final AuthGateway _authGateway;
  final UserGateway _userGateway;
  final UserGroupsGateway _userGroupsGateway;
  final UserPositionGateway _userPositionGateway;
  final LocationGateway _locationGateway;

  final _currentUserPublisher = BehaviorSubject<FirebaseUser>();
  final _currentGroupPublisher = BehaviorSubject<Group>();

  @provide
  AppControllerInternal(this._userGateway, this._userGroupsGateway, this._userPositionGateway,
      this._locationGateway, this._authGateway);

  // current user
  Observable<User> observeCurrentUser;

  // current fireBase ser
  Observable<FirebaseUser> observeCurrentFireBaseUser;

  // current position
  Observable<CurrentPosition> observeCurrentUserPosition;

  // all user groups
  Observable<List<DisplayableGroup>> observeAllUserGroups;

  // selected group
  Observable<Group> observeCurrentGroup;

  // selected group users
  Observable<List<DisplayableUser>> observeCurrentGroupUsers;

  StreamSubscription _userDisposable;

  void attach() {
    // fireBase user
    _userDisposable = _authGateway.observeFireBaseUser().listen((user) => _currentUserPublisher.add(user));

    observeCurrentFireBaseUser = _currentUserPublisher;
    // user
    observeCurrentUser = _currentUserPublisher
        .where((user) => user != null)
        .map((f) => f.uid)
        .switchMap((uid) => _userGateway.observeUser(uid: uid))
        .asBroadcastStream();

    observeCurrentUserPosition = _locationGateway.observeLocation().asBroadcastStream();

    // current group info
    observeCurrentGroup = _currentGroupPublisher;

    // observe current group members uid
    Observable<List<String>> currentGroupMembersRef = observeCurrentGroup
        .map((g) => g.id)
        .switchMap((groupId) => _userGroupsGateway.observeGroupMembers(groupId: groupId))
        .asBroadcastStream();

    // observe group all user position
    Observable<List<UserPosition>> groupUsersPosition = currentGroupMembersRef
        .switchMap((uidList) => _userPositionGateway.observeMultipleUsersPosition(uidList: uidList))
        .asBroadcastStream();

    // observe group users
    Observable<List<User>> groupUsers = currentGroupMembersRef
        .switchMap((uidList) => _userGateway.observeMultipleUsers(uidList: uidList))
        .asBroadcastStream();

    observeCurrentGroupUsers = Observable.zip2(groupUsers, groupUsersPosition, _zipGroupUsers);

    // all user groups
    observeAllUserGroups = observeCurrentUser
        .switchMap((user) => _userGroupsGateway.observeUserGroups(uid: user.uid))
        .switchMap(_mapGroups)
        .asBroadcastStream();
  }

  void updateCurrentGroup(Group group) {
    _currentGroupPublisher.add(group);
  }

  List<DisplayableUser> _zipGroupUsers(List<User> users, List<UserPosition> positions) {
    assert(users.length == positions.length);

    users.sort((a, b) => a.uid.compareTo(b.uid));
    positions.sort((a, b) => a.uid.compareTo(b.uid));
    final result = <DisplayableUser>[];

    for (var i = 0; i < users.length; i++) {
      final user = users[i];
      final position = positions[i];
      final displayableUser = DisplayableUser(
          uid: user.uid,
          photoUrl: user.photoUrl,
          email: user.email,
          displayName: user.displayName,
          accuracy: position.accuracy,
          latitude: position.latitude,
          longitude: position.longitude);
      result.add(displayableUser);
    }

    return result;
  }

  Observable<List<DisplayableGroup>> _mapGroups(UserGroups userGroups) {
    final groups = userGroups.groups;
    final groupIdList = groups.map((g) => g.id);
    return _userGroupsGateway
        .observeMultipleGroups(groupIdList: groupIdList)
        .map((list) => list.map((group) {
              final isApproved = userGroups.groups.any((g) => g.id == group.id);
              return _toPresentation(group, isApproved);
            }));
  }

  DisplayableGroup _toPresentation(Group group, bool approved) {
    return DisplayableGroup(
        id: group.id, adminId: group.adminId, name: group.name, approvedByCurrentUser: approved);
  }

  void detach() {
    _userDisposable?.cancel();
  }
}

class AppControllerHolder extends StatefulWidget {
  final Widget child;
  final AppControllerInternal controller;

  AppControllerHolder({@required this.controller, @required this.child});

  @override
  State createState() => AppControllerHolderState();
}

class AppControllerHolderState extends State<AppControllerHolder> {
  @override
  void initState() {
    widget.controller.attach();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.detach();
  }

  @override
  Widget build(BuildContext context) {
    return AppController(
      controller: widget.controller,
      child: widget.child,
    );
  }
}

class AppController extends InheritedWidget {
  final AppControllerInternal controller;

  AppController({@required this.controller, @required Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static AppControllerInternal of(BuildContext context) {
    AppController inherited = context.inheritFromWidgetOfExactType(AppController);
    return inherited.controller;
  }
}
