import 'package:firebase_auth/firebase_auth.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateway/auth_service.dart';
import 'package:rxdart/rxdart.dart';

class SplashController {
  final AuthService _authService;

  @provide
  SplashController(this._authService);

  Observable<FirebaseUser> observeUser() => _authService.observeFireBaseUser();
}
