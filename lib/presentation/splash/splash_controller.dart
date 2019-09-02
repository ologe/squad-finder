import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/auth_service.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:rxdart/rxdart.dart';

class SplashController {
  final AuthService _authService;

  @provide
  SplashController(this._authService);

  Observable<User> observeUser() => _authService.observeUser();
}
