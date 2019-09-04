import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/user_state.dart';

import 'create_group_controller.dart';

// ignore: must_be_immutable
class CreateGroupPage extends StatefulWidget {
  final CreateGroupPageController _controller;

  @provide
  CreateGroupPage(this._controller);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends AbsState<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _dialogFormKey = GlobalKey<FormState>();
  final members = <String>[];

  final emailRegex = RegExp(
      r"(\w|\d|\.|!|#|\$|%|&|'|\*|\+|-|\/|=|\?|\^|_|`|{|\||}|~)+@(\w|-)+.(\w){2,}");

  String _groupName;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create group"),
      ),
      body: Scaffold(
        body: SafeArea(
          child: _body(context),
        ),
      ),
      floatingActionButton: members.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _createGroup,
              child: Icon(Icons.add),
            ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validate,
                    onSaved: (input) => _email = input.trim(),
                    onFieldSubmitted: (_) => _addMember(),
                    decoration: InputDecoration(labelText: "Find a friend"),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final item = members[index];
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  key: Key(item),
                  child: ListTile(
                    title: Text(item),
                  ),
                  onDismissed: (direction) {
                    final item = members[direction.index];
                    _removeMember(item);
                  },
                );
              }),
        )
      ],
    );
  }

  void _addMember() {
    final state = _formKey.currentState;
    if (state.validate()) {
      state.save();
      setState(() {
        members.add(_email);
        state.reset();
        _email = null;
      });
    }
  }

  void _removeMember(String item) {
    setState(() {
      members.remove(item);
    });
  }

  String _validate(String input) {
    if (emailRegex.hasMatch(input.trim())) {
      return null;
    }
    if (members.contains(input.trim())) {
      return "Already added";
    }
    return "Email not valid";
  }

  void _createGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("CreateDialog"),
            content: Form(
              key: _dialogFormKey,
              child: TextFormField(
                autocorrect: false,
                validator: (input) {
                  if (input.trim().isEmpty) {
                    return "Cannot be empty";
                  }
                  return null;
                },
                onSaved: (input) => _groupName = input,
                decoration: InputDecoration(labelText: "Group name"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  final formState = _dialogFormKey.currentState;
                  if (formState.validate()) {
                    formState.save();
                    widget._controller
                        .createGroup(_groupName, UserState.of(context).user.uid, members);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
