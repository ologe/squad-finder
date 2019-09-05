import 'package:flutter/material.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/home/home_page_controller.dart';
import 'package:project_london_corner/presentation/model/presentation_entity.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';

import '../model/list_item.dart';

typedef OnGroupSelected = void Function(String groupId);

class MyGroups extends AbsStatelessWidget {
  final HomePageController controller;

  MyGroups({@required this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilder<List<DisplayableGroup>>(
      stream: appController(context).observeAllUserGroups,
      builder: (context, originalGroups) {
        if (originalGroups.isEmpty) {
          return Text("No groups found");
        }
        final pendingGroups = <ListItem<DisplayableGroup>>[];

        final otherGroups = <ListItem<DisplayableGroup>>[];

        for (final group in originalGroups) {
          if (!group.approvedByCurrentUser) {
            pendingGroups.add(ActualItem<DisplayableGroup>(group));
          } else {
            otherGroups.add(ActualItem<DisplayableGroup>(group));
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
              if (otherGroups.isNotEmpty && index == pendingGroups.length + 1) {}

              final item = groups[index];
              if (item is HeadingItem<DisplayableGroup>) {
                return _buildHeader(context, item);
              } else if (item is ActualItem<DisplayableGroup>) {
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
        style: Theme.of(context).textTheme.headline.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _buildTile(BuildContext context, DisplayableGroup group) {
    final needApproval = !group.approvedByCurrentUser;

    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.group),
      ),
//      title: Text(group.name), TODO
      title: Text("group name placeholder"),
      trailing: needApproval
          ? IconButton(
              onPressed: () => _approveGroup(context, group),
              icon: Icon(Icons.done),
            )
          : null,
      onTap: () => _toDetail(context, group),
    );
  }

  void _approveGroup(BuildContext context, DisplayableGroup group) async {
    final user = await appController(context).observeCurrentUser.first;
    await controller.approveGroup(user.uid, group.id);
  }

  void _toDetail(BuildContext context, DisplayableGroup group) {
    appController(context).updateCurrentGroup(group.toDomain());
  }
}
