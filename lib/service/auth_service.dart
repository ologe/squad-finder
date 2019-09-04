import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/gateway/auth_service.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

class AuthServiceImpl implements AuthService {
  final GoogleSignIn _google;
  final FirebaseAuth _auth;
  final Firestore _db;

  @provide
  AuthServiceImpl(this._google, this._auth, this._db) {
    _auth.onAuthStateChanged.listen(_userPublisher.add);
  }

  final _userPublisher = BehaviorSubject<FirebaseUser>();

  @override
  Observable<FirebaseUser> observeFireBaseUser() => _userPublisher;

  @override
  Observable<User> observeUser() => _userPublisher.switchMap((user) {
        if (user == null) {
          return Observable.just(null);
        }
        return _db
            .collection("users")
            .document(user.uid)
            .snapshots()
            .map((snapshot) => User.fromJson(snapshot.data));
      });

  Observable<Map<String, dynamic>> profile;

  @override
  Future<void> googleSignIn() async {
    try {
      final googleUser = await _google.signIn();
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final authResult = await _auth.signInWithCredential(credential);
      _updateUser(authResult.user);
    } catch (e) {
      logger.w(e);
    }
  }

  void _updateUser(FirebaseUser user) async {
    final ref = _db.collection("users").document(user.uid);
    await ref.setData({
      "uid": user.uid,
      "email": user.email,
      "photoURL": user.photoUrl,
      "lastSeen": DateTime.now()
    }, merge: true);
  }

  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }
}
