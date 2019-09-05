import 'package:flutter/cupertino.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class UserGateway {
  Future<void> updateUser({@required User user});

  Observable<User> observeUser({@required String uid});

  Observable<List<User>> observeMultipleUsers({@required List<String> uidList});
}
