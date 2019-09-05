import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/position.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/core/gateway/user_position_gateway.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/src/observables/observable.dart';

class UserPositionService implements UserPositionGateway {
  final Firestore _db;

  @provide
  UserPositionService(this._db);

  @override
  Observable<List<UserPosition>> observeMultipleUsersPosition({List<String> uidList}) {
    assert(uidList != null);

    final streams = uidList.map((uid) => observeUserPosition(uid: uid));
    return Observable.combineLatestList(streams);
  }

  UserPosition _mapToPosition(QuerySnapshot snapshot) {
    if (snapshot.documents.isEmpty) {
      return null;
    }
    return UserPosition.fromJson(snapshot.documents.first.data);
  }

  @override
  Observable<UserPosition> observeUserPosition({String uid}) {
    assert(uid != null);

    return _db
        .collection(UserPosition.TABLE)
        .where(UserPosition.UID, isEqualTo: uid)
        .snapshots()
        .map(_mapToPosition);
  }

  @override
  Future<void> updateUserPosition({String uid, CurrentPosition position}) async {
    assert(position != null);

    final ref = _db.collection(UserPosition.UID).document(uid);
    await ref.setData({
      UserPosition.LATITUDE: position.latitude,
      UserPosition.LONGITUDE: position.longitude,
    }, merge: true);
  }

  @override
  Future<void> toggleSharePosition({String uid}) async {
    assert(uid != null);

    final ref = await _db.collection(UserPosition.TABLE).document(uid);
    final documents = await ref.get();
    final allowShareLocation = documents[UserPosition.ALLOW_SHARE_LOCATION] as bool;
    await ref.setData({UserPosition.ALLOW_SHARE_LOCATION: !allowShareLocation}, merge: true);
  }
}
