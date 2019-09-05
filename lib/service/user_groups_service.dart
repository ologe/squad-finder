import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/entity/tmp_user.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/entity/user_groups.dart';
import 'package:project_london_corner/core/gateway/user_groups_gateway.dart';
import 'package:rxdart/src/observables/observable.dart';

class UserGroupsService implements UserGroupsGateway {
  final Firestore _db;

  @provide
  UserGroupsService(this._db);

  @override
  Observable<UserGroups> observeUserGroups({String uid}) {
    assert(uid != null);

    return _db
        .collection(UserGroups.TABLE)
        .where(UserGroups.UID, isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.documents)
        .map((documents) {
      if (documents.isEmpty) {
        return [];
      }
      return documents.map((a) => UserGroups.fromJson(a.data));
    });
  }

  @override
  Future<void> createGroup({String groupName, String adminId, List<String> emails}) async {
    assert(groupName != null);
    assert(adminId != null);
    assert(emails != null && emails.isNotEmpty);

    // create group
    final ref = _db.collection(Group.TABLE).document();
    final group = Group.typed(id: ref.documentID, name: groupName, adminId: adminId);
    await ref.setData(group.toJson());

    // add members to group
    final uids = emails.map((e) => _getUidByEmail(email: e)).toList();
    final userGroups = _db.collection(UserGroups.TABLE);
    for (final futureUid in uids) {
      final uid = await futureUid;
      await userGroups.document(uid).setData({
        UserGroups.UID: uid,
        UserGroups.GROUPS: {
          group.id: {UserGroups.APPROVED: uid == adminId}
        }
      }, merge: true);
    }
  }

  Future<String> _getUidByEmail({@required String email}) async {
    assert(email != null);

    final userQuery =
        await _db.collection(User.TABLE).where(User.EMAIL, isEqualTo: email).getDocuments();

    final user = userQuery.documents.map((data) => User.fromJson(data.data));
    if (user.isEmpty) {
      final ref = _db.collection(TmpUser.TABLE).document();
      final tmpUser = TmpUser(ref.documentID, email);
      await ref.setData(tmpUser.toJson());
      return ref.documentID;
    }
    return user.first.uid;
  }

  @override
  Future<void> approveGroup({String userId, String groupId}) async {
    assert(userId != null);
    assert(groupId != null);

    final ref = _db.collection(UserGroups.TABLE).document(userId);
    await ref.setData({
      UserGroups.GROUPS: {
        groupId: {UserGroups.APPROVED: true}
      }
    }, merge: true);
  }

  @override
  Observable<List<String>> observeGroupMembers({String groupId}) {
    assert(groupId != null);

    final path = "${UserGroups.GROUPS}.$groupId";
    return _db
        .collection(UserGroups.TABLE)
        .where(path, isEqualTo: groupId)
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => item.data[UserGroups.UID]));
  }

  @override
  Observable<List<Group>> observeMultipleGroups({List<String> groupIdList}) {
    assert(groupIdList != null);

    final streams = groupIdList.map((id) => observeGroup(groupId: id));
    return Observable.combineLatestList(streams);
  }

  @override
  Observable<Group> observeGroup({String groupId}) {
    assert(groupId != null);

    return _db
        .collection(Group.TABLE)
        .where(Group.ID, isEqualTo: groupId)
        .snapshots()
        .map((snapshot) => snapshot.documents)
        .map((documents) {
      if (documents.isEmpty) {
        return [];
      }
      return documents.map((a) => Group.fromJson(a.data));
    });
  }
}
