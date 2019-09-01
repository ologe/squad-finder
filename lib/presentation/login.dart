import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_london_corner/service/auth_service.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    return Center(
      child: RaisedButton(
        onPressed: () => _login(),
        child: Text("Login with Google"),
      ),
    );
  }

  void _login() {
    authService.googleSignIn();
  }
}
