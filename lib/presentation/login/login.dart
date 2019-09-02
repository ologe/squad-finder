import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/presentation/login/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginPageController _controller;

  @provide
  LoginPage(this._controller);

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
    _controller.login();
  }
}
