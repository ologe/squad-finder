import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/create_group/create_group.dart';
import 'package:project_london_corner/presentation/detail_group/detail_group.dart';
import 'package:project_london_corner/presentation/home/home_controller.dart';
import 'package:project_london_corner/presentation/list_item.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final Provider<DetailGroupPage> _detailPage;
  final Provider<CreateGroupPage> _createGroup;
  final HomePageController _controller;
  User _user;

  @provide
  HomePage(this._controller, this._detailPage, this._createGroup);

  HomePage inject(User user) {
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
          final pendingGroups = <ListItem>[];

          final otherGroups = <ListItem>[];

          for (final group in originalGroups) {
            if (group.members
                .any((m) => m.uid == widget._user.uid && m.pending)) {
              pendingGroups.add(ActualItem<Group>(group));
            } else {
              otherGroups.add(ActualItem<Group>(group));
            }
          }
          if (pendingGroups.isNotEmpty){
            pendingGroups.insert(0, HeadingItem("Pending groups"));
          }
          if (otherGroups.isNotEmpty){
            otherGroups.insert(0, HeadingItem("My groups"));
          }

          final groups = pendingGroups + otherGroups;

          return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                if (otherGroups.isNotEmpty &&
                    index == pendingGroups.length + 1) {}

                final item = groups[index];
                if (item is HeadingItem) {
                  return _buildHeader(item);
                } else if (item is ActualItem<Group>) {
                  return _buildTile(item.item);
                }
                return Text("Error ${item.runtimeType}");
              });
        },
      ),
    );
  }

  Widget _buildHeader(HeadingItem item) {
    return Text(item.title);
  }

  Widget _buildTile(Group group) {
    final needApproval = group.members.any((member) {
      return member.uid == widget._user.uid && member.pending;
    });

    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.group),
      ),
      title: Text(group.name),
      subtitle: Text("${group.membersCount} members"),
      trailing: needApproval
          ? IconButton(
              onPressed: () => _approveGroup(group),
              icon: Icon(Icons.done),
            )
          : null,
      onTap: () => _toDetail(group),
    );
  }

  Widget _sharePositionButton() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => _toggleSharePosition(widget._user),
          child: Text(widget._user.allowShareLocation
              ? "Stop sharing position"
              : "Share position"),
        ));
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

  void _toCreateGroup() {
    final page = widget._createGroup().inject(widget._user);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

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

  void _approveGroup(Group group){
    widget._controller.approveGroup(widget._user, group);
  }

}
