import 'package:flutter/material.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/home/home_controller.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';

import '../list_item.dart';

typedef OnGroupSelected = void Function(Group group);

class MyGroups extends AbsStatelessWidget {
  final HomePageController controller;
  final OnGroupSelected onGroupSelected;

  MyGroups({@required this.controller, @required this.onGroupSelected});

  @override
  Widget build(BuildContext context) {
    final currentUser = user(context);

    return CustomStreamBuilder<List<Group>>(
      stream: controller.observeUserGroups(currentUser),
      builder: (context, originalGroups) {
        if (originalGroups.isEmpty) {
          return Text("No groups found");
        }
        final pendingGroups = <ListItem>[];

        final otherGroups = <ListItem>[];

        for (final group in originalGroups) {
          if (group.members.any((m) => m.uid == currentUser.uid && m.pending)) {
            pendingGroups.add(ActualItem<Group>(group));
          } else {
            otherGroups.add(ActualItem<Group>(group));
          }
        }
        if (pendingGroups.isNotEmpty) {
          pendingGroups.insert(0, HeadingItem("Pending groups"));
        }
        if (otherGroups.isNotEmpty) {
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
                return _buildHeader(context, item);
              } else if (item is ActualItem<Group>) {
                return _buildTile(context, item.item);
              }
              return Text("Error ${item.runtimeType}");
            });
      },
    );
  }

  Widget _buildHeader(BuildContext context, HeadingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        item.title,
        style: Theme.of(context)
            .textTheme
            .headline
            .copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildTile(BuildContext context, Group group) {
    final needApproval = group.members.any((member) {
      return member.uid == user(context).uid && member.pending;
    });

    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.group),
      ),
      title: Text(group.name),
      subtitle: Text("${group.membersCount} members"),
      trailing: needApproval
          ? IconButton(
              onPressed: () => _approveGroup(context, group),
              icon: Icon(Icons.done),
            )
          : null,
      onTap: () => _toDetail(group),
    );
  }

  void _approveGroup(BuildContext context, Group group) {
    controller.approveGroup(user(context), group);
  }

  void _toDetail(Group group) {
    onGroupSelected(group);
  }
}
