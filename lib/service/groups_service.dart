import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/main.dart';
import 'package:rxdart/rxdart.dart';

GroupsService _groupsService;

GroupsService get groupsService {
  if (_groupsService == null) {
    _groupsService = GroupsService();
  }
  return _groupsService;
}

class GroupsService {
  final _db = Firestore.instance;

  Observable<List<Group>> observeUserGroups(String userId) {
    final memberStream = _db
        .collection("group")
        .where("members", arrayContains: userId)
        .snapshots();

    return Observable(memberStream).map((snapshot) {
      try {
        return snapshot.documents.map((d) => Group.fromJson(d.data)).toList();
      } catch (e) {
        logger.e(e);
        return [];
      }
    });
  }

  Observable<List<User>> observeMemberPosition(Group group) {
    final membersStream = <Stream<QuerySnapshot>>[];

    for (final member in group.members) {
      final stream =
          _db.collection("users").where("uid", isEqualTo: member).snapshots();
      membersStream.add(stream);
    }

    return Observable.combineLatestList(membersStream).map((list) {
      final result = <User>[];
      for (final snapshot in list) {
        final user = User.fromJson(snapshot.documents.first.data);
        result.add(user);
      }
      return result;
    });
  }

  Observable<User> observeCurrentUser(String uid) {
    final stream =
        _db.collection("users").where("uid", isEqualTo: uid).snapshots();

    return Observable(stream).map((snapshot) {
      return User.fromJson(snapshot.documents.first.data);
    });
  }
}
