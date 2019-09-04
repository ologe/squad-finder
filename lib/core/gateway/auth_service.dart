import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthService {
  /// Observe user authentication
  Observable<FirebaseUser> observeFireBaseUser();

  /// Observe user authentication + location
  Observable<User> observeUser();

  Future<void> googleSignIn();

  Future<void> logOut();
}
