import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/gateway/auth_gateway.dart';
import 'package:project_london_corner/core/gateway/user_gateway.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

class AuthServiceImpl implements AuthGateway {
  final GoogleSignIn _google;
  final FirebaseAuth _auth;
  final UserGateway _userGateway;

  final _userPublisher = BehaviorSubject<FirebaseUser>();

  @provide
  AuthServiceImpl(this._google, this._auth, this._userGateway) {
    _auth.onAuthStateChanged.listen(_userPublisher.add);
  }

  @override
  Observable<FirebaseUser> observeFireBaseUser() => _userPublisher;

  @override
  Future<void> login() async {
    try {
      final googleUser = await _google.signIn();
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final authResult = await _auth.signInWithCredential(credential);
      await _updateUser(authResult.user);
    } catch (e) {
      logger.w(e);
    }
  }

  Future<void> _updateUser(FirebaseUser fireBaseUser) async {
    final user = User.typed(
        uid: fireBaseUser.uid,
        email: fireBaseUser.email,
        displayName: fireBaseUser.displayName,
        photoUrl: fireBaseUser.photoUrl,
        lastSeen: DateTime.now());
    return await _userGateway.updateUser(user: user);
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}
