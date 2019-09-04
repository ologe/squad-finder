import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/group.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/main.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/map/map.dart';
import 'package:project_london_corner/presentation/map/map_page_controller.dart';
import 'package:rxdart/rxdart.dart';

// ignore: must_be_immutable
class MapPage extends StatefulWidget {
  double _backdropPeek;
  final MapController _controller;

  @provide
  MapPage(this._controller) : super(key: GlobalKey<MapPageState>());

  Key inject(double backdropPeek) {
    this._backdropPeek = backdropPeek;
    return key;
  }

  @override
  State createState() => MapPageState();
}

class MapPageState extends AbsState<MapPage> {
  final _mapKey = GlobalKey<MapWidgetState>();
  final _groupPublisher = BehaviorSubject<Group>();

  final _members = <User>[];

  @override
  void initState() {
    super.initState();
    final memberPositionDisposable = _groupPublisher
        .delay(Duration(seconds: 1))
        .switchMap((group) => widget._controller.observeMemberPosition(group))
        .listen((members) {
      _mapKey.currentState.buildCurrentPosition(members);
      setState(() {
        _members.clear();
        _members.addAll(members.where((u) => u.uid != user.uid));
      });
    });

    final myPositionDisposable = Observable.timer(1, Duration(seconds: 2))
        .switchMap((_) => widget._controller.observeCurrentPosition())
        .switchMap((position) =>
            widget._controller.updateUserPosition(user.uid, position))
        .listen((_) {});

    subscriptions.add(memberPositionDisposable);
    subscriptions.add(myPositionDisposable);
  }

  void updateGroup(Group group) {
    _groupPublisher.add(group);
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
                    onPressed: () =>
                        _mapKey.currentState..moveToCurrentPosition,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _members.length,
          itemBuilder: (context, index) {
            final item = _members[index];
            return _buildUser(item);
          }),
    );
  }

  Widget _buildUser(User user) {
    print(user);
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
