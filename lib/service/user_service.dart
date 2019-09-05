import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/gateway/user_gateway.dart';
import 'package:project_london_corner/main.dart';
import 'package:rxdart/rxdart.dart';

class UserService implements UserGateway {
  final Firestore _db;

  @provide
  UserService(this._db);

  @override
  Observable<User> observeUser({String uid}) {
    assert(uid != null);

    return _db.collection(User.TABLE).where(User.UID, isEqualTo: uid).snapshots().map((snapshot) {
      try {
        return User.fromJson(snapshot.documents.first.data);
      } on Error catch (e) {
        logger.w(e);
        return null;
      }
    });
  }

  @override
  Observable<List<User>> observeMultipleUsers({List<String> uidList}) {
    assert(uidList != null);

    final streams = uidList.map((uid) => observeUser(uid: uid));
    return Observable.combineLatestList(streams);
  }

  @override
  Future<void> updateUser({User user}) async {
    assert(user != null);

    final ref = _db.collection(User.TABLE).document(user.uid);
    await ref.setData(user.toJson(), merge: true);
  }
}
