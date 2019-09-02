import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';

import 'create_group_controller.dart';

class CreateGroupPage extends StatefulWidget {
  final CreateGroupPageController _controller;

  @provide
  CreateGroupPage(this._controller);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends AbsState<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create group"),
      ),
      body: Scaffold(
        body: SafeArea(
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Container();
  }
}
