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
    final pendingMemberStream = _db.collection("group").where("members",
        arrayContains: {"uid": userId, "pending": true}).snapshots();

    final finalMemberStream = _db.collection("group").where("members",
        arrayContains: {"uid": userId, "pending": false}).snapshots();

    return Observable.combineLatestList(
        [pendingMemberStream, finalMemberStream]).map((snapshots) {
      try {
        final result = <Group>[];
        for (var snapshot in snapshots) {
          final current =
              snapshot.documents.map((d) => Group.fromJson(d.data)).toList();
          result.addAll(current);
        }
        return result;
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
      if (member.pending){
        continue;
      }
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

  @override
  Future<void> createGroup(String name, User user, List<String> members) async {
    final usersUid = <String>[];
    usersUid.add(user.uid);
    for (var value in members) {
      final userQuery = await _db
          .collection("users")
          .where("email", isEqualTo: value)
          .getDocuments();
      final user = userQuery.documents.map((data) => User.fromJson(data.data));
      if (user.isEmpty) {
        final ref = _db.collection("tmp_user").document();
        await ref.setData({"uid": ref.documentID, "email": value});
        usersUid.add(ref.documentID);
      } else {
        usersUid.add(user.first.uid);
      }
    }

    final ref = _db.collection("group").document();
    await ref.setData({
      "uid": ref.documentID,
      "adminId": user.uid,
      "name": name,
      "members": usersUid
          .map((uid) => {"uid": uid, "pending": user.uid != uid})
          .toList()
    });
  }

  @override
  Future<void> approveGroup(User user, Group group) async {
    final ref = _db.collection("group").document(group.uid);
    final members = group.members.map((member) {
      return {"uid": member.uid, "pending": false};
    }).toList();
    await ref.setData({"members": members}, merge: true);
  }
}
