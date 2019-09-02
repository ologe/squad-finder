import 'package:project_london_corner/core/user.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthService {
  Observable<User> observeUser();

  Future<void> googleSignIn();

  Future<void> logOut();
}
