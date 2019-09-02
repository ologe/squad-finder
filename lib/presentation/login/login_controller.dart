import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/auth_service.dart';

class LoginPageController {
  final AuthService _authService;

  @provide
  LoginPageController(this._authService);

  void login() {
    _authService.googleSignIn();
  }
}
