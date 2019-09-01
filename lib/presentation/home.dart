import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/presentation/group_detail.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';
import 'package:project_london_corner/service/auth_service.dart';
import 'package:project_london_corner/service/groups_service.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage(this.user);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, ${widget.user.displayName}"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _toCreateGroup(),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _sharePositionButton()),
              Expanded(child: _logoutButton())
            ],
          ),
          _activeGroups()
        ],
      ),
    );
  }

  Widget _activeGroups() {
    return Expanded(
      child: CustomStreamBuilder<List<Group>>(
        stream: groupsService.observeUserGroups(widget.user.uid),
        builder: (context, groups) {

          return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index){
                final item = groups[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.group),
                  ),
                  title: Text(item.name),
                  subtitle: Text("${item.membersCount} members"),
                  onTap: () => _toDetail(item),
                );
              }
          );
        },
      ),
    );
  }

  Widget _sharePositionButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: _logout,
        child: Text("Share position"),
      ),
    );
  }

  Widget _logoutButton(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: _logout,
        child: Text("Logout"),
      ),
    );
  }

  void _toCreateGroup() {}

  void _logout() {
    authService.logOut();
  }

  void _toDetail(Group group){
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailGroupPage(widget.user, group)));
  }

}
