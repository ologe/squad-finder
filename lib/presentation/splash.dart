import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_london_corner/presentation/home.dart';
import 'package:project_london_corner/presentation/login.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';
import 'package:project_london_corner/service/auth_service.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilder<FirebaseUser>(
      stream: authService.user,
      builder: (context, user) {
        if (user == null) {
          return LoginPage();
        } else {
          return HomePage(user);
        }
      },
    );
  }
}
