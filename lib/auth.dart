import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';

import 'main.dart';

final authService = AuthService();

class AuthService {
  final _google = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
  final _db = Firestore.instance;

  Observable<FirebaseUser> user;

  Observable<Map<String, dynamic>> profile;

  final _loading = PublishSubject<bool>();

  Observable<bool> isLoading() => _loading;

  AuthService() {
    // ignore: close_sinks
    final authEventsPublisher = BehaviorSubject<FirebaseUser>();
    authEventsPublisher.addStream(_auth.onAuthStateChanged);
    user = authEventsPublisher;
  }

  Future<void> googleSignIn() async {
    try {
      _loading.add(true);

      final googleUser = await _google.signIn();
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final authResult = await _auth.signInWithCredential(credential);
      _updateUser(authResult.user);
    } catch (e) {
      logger.w(e);
    } finally {
      _loading.add(false);
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

  void signOut() {
    _auth.signOut();
  }
}
