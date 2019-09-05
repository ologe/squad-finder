import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthGateway {
  /// Observe user authentication
  Observable<FirebaseUser> observeFireBaseUser();

  Future<void> login();

  Future<void> logout();
}
