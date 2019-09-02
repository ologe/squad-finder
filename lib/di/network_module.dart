import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/gateways/auth_service.dart';
import 'package:project_london_corner/service/auth_service.dart';

@module
class NetworkModule {
  @provide
  @singleton
  GoogleSignIn provideGoogleSignIn() => GoogleSignIn();

  @provide
  @singleton
  FirebaseAuth provideFirebaseAuth() => FirebaseAuth.instance;

  @provide
  @singleton
  AuthService provideAuthService(AuthServiceImpl impl) => impl;
}
