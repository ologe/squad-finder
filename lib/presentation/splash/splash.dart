import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/home/home_page.dart';
import 'package:project_london_corner/presentation/login/login.dart';
import 'package:project_london_corner/presentation/splash/splash_controller.dart';
import 'package:project_london_corner/presentation/user_state.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';

class SplashPage extends StatelessWidget {
  final SplashController _controller;
  final Provider<LoginPage> _loginPage;
  final Provider<HomePage> _homePage;

  @provide
  SplashPage(this._controller, this._loginPage, this._homePage);

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilder<FirebaseUser>(
      stream: _controller.observeUser(),
      builder: (context, user) {
        return UserState(
          user: user,
          child: _body(user),
        );
      },
    );
  }

  Widget _body(FirebaseUser user) {
    if (user == null) {
      return _loginPage();
    } else {
      return _homePage();
    }
  }
}
