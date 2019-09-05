import 'package:flutter/cupertino.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserPositionGateway {
  Observable<UserPosition> observeUserPosition({@required String uid});

  Observable<List<UserPosition>> observeMultipleUsersPosition(
      {@required List<String> uidList});

  Future<void> updateUserPosition(
      {@required String uid, @required CurrentPosition position});

  Future<void> toggleSharePosition({@required String uid});
}
