import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/main.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/map/map.dart';
import 'package:project_london_corner/presentation/map/map_page_controller.dart';
import 'package:project_london_corner/presentation/model/presentation_entity.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';

// ignore: must_be_immutable
class MapPage extends StatefulWidget {
  double _backdropPeek;
  final MapController _controller;

  @provide
  MapPage(this._controller);

  MapPage inject(double backdropPeek) {
    this._backdropPeek = backdropPeek;
    return this;
  }

  @override
  State createState() => _MapPageState();
}

class _MapPageState extends AbsState<MapPage> {
  final _mapKey = GlobalKey<MapWidgetState>();

  final _members = <DisplayableUser>[];

  _MapPageState();

  @override
  void afterInit() {
    super.afterInit();
    _initializeAsync();
  }

  void _initializeAsync() async {
    final user = await appController.observeCurrentUser.first;
    final memberPositionDisposable =
        appController.observeCurrentGroupUsers.listen((memberPosition) {
      _mapKey.currentState.buildCurrentPosition(user, memberPosition);
      setState(() {
        _members.clear();
        _members.addAll(memberPosition.where((u) => u.uid != user.uid));
      });
    });

    final myPositionDisposable = appController.observeCurrentUserPosition.listen((position) {
      widget._controller.updateUserPosition(user.uid, position);
    });

    subscriptions.add(memberPositionDisposable);
    subscriptions.add(myPositionDisposable);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MapWidget(key: _mapKey, controller: widget._controller),
        _additional(context)
      ],
    );
  }

  Widget _additional(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: widget._backdropPeek),
        child: Column(
          children: <Widget>[
            SizedBox(height: 100.0, child: _buildUsers()),
            Expanded(child: Container()),
            Row(
              children: <Widget>[
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.my_location,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () => _mapKey.currentState..moveToCurrentPosition,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUsers() {
    return CustomStreamBuilder<List<DisplayableUser>>(
        stream: appController.observeCurrentGroupUsers,
        builder: (context, users) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final item = users[index];
                  return _buildUser(item);
                }),
          );
        });
  }

  Widget _buildUser(DisplayableUser user) {
    return SizedBox(
      width: 200,
      child: Card(
          child: ListTile(
        leading: CircleAvatar(
          child: Image.network(user?.photoUrl ?? ""),
        ),
        title: Text(user.displayName),
        subtitle: FutureBuilder<String>(
          future: widget._controller.getUserAddress(user),
          initialData: "Loading..",
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              logger.e(snapshot.error);
              return Text("Error");
            }
            return Text(snapshot.data);
          },
        ),
      )),
    );
  }
}
