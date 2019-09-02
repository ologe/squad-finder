import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/detail_group/detail_group.dart';
import 'package:project_london_corner/presentation/home/home_controller.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final Provider<DetailGroupPage> _detailPage;
  final HomePageController _controller;
  User _user;

  @provide
  HomePage(this._controller, this._detailPage);

  HomePage inject(User user){
    this._user = user;
    return this;
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi, ${widget._user.displayName}"),
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
        stream: widget._controller.observeUserGroups(widget._user),
        builder: (context, originalGroups) {
          if (originalGroups.isEmpty) {
            return Text("No groups found");
          }

          final pendingGroups = <Group>[];
          final otherGroups = <Group>[];

          for (final group in originalGroups) {
            if (group.members
                .any((m) => m.uid == widget._user.uid && m.pending)) {
              pendingGroups.add(group);
            } else {
              otherGroups.add(group);
            }
          }
          var headerCount = 0;
          headerCount = pendingGroups.isEmpty ? headerCount : (headerCount + 1);
          headerCount = otherGroups.isEmpty ? headerCount : (headerCount + 1);

          final groups = pendingGroups + otherGroups;

          return ListView.builder(
              itemCount: groups.length + headerCount,
              itemBuilder: (context, index) {
                if (pendingGroups.isNotEmpty && index == 0) {
                  return Text("Pending groups");
                }
                if (otherGroups.isNotEmpty &&
                    index == pendingGroups.length + 1) {
                  return Text("My groups");
                }

                final item = groups[index - headerCount];

                final needApproval = item.members.any((member) {
                  return member.uid == widget._user.uid && member.pending;
                });

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.group),
                  ),
                  title: Text(item.name),
                  subtitle: Text("${item.membersCount} members"),
                  trailing: needApproval
                      ? IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.done),
                  )
                      : null,
                  onTap: () => _toDetail(item),
                );
              });
        },
      ),
    );
  }

  Widget _sharePositionButton() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () =>
              _toggleSharePosition(widget._user)
          ,
          child: Text(widget._user.allowShareLocation
              ? "Stop sharing position"
              : "Share position"),
        )
    );
  }

  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: _logout,
        child: Text("Logout"),
      ),
    );
  }

  void _toCreateGroup() {}

  void _toggleSharePosition(User user) {
    widget._controller.toggleSharePosition(user);
  }

  void _logout() {
    widget._controller.logout();
  }

  void _toDetail(Group group) {
    final detailPage = widget._detailPage();
    detailPage.inject(widget._user, group);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => detailPage));
  }
}
