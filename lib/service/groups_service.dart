import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/group_service.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/main.dart';
import 'package:rxdart/rxdart.dart';

class GroupsServiceImpl implements GroupsService {
  final Firestore _db;

  @provide
  GroupsServiceImpl(this._db);

  @override
  Observable<List<Group>> observeUserGroups(String userId) {
    final memberStream = _db.collection("group").where("members",
        arrayContains: {"uid": userId, "pending": true}).snapshots();

    return Observable(memberStream).map((snapshot) {
      try {
        return snapshot.documents.map((d) => Group.fromJson(d.data)).toList();
      } catch (e) {
        logger.e(e);
        return [];
      }
    });
  }

  @override
  Observable<List<User>> observeMemberPosition(Group group) {
    final membersStream = <Stream<QuerySnapshot>>[];

    for (final member in group.members) {
      final stream = _db
          .collection("users")
          .where("uid", isEqualTo: member.uid)
          .snapshots();
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
}
