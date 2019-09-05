import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateway/auth_gateway.dart';

class LoginPageController {
  final AuthGateway _authService;

  @provide
  LoginPageController(this._authService);

  void login() {
    _authService.login();
  }
}
