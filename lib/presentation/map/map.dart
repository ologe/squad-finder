import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/map/map_controller.dart';
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
  GoogleMapController _mapController;

  final _groupPublisher = BehaviorSubject<Group>();

  final _markers = <Marker>[];
  final _circles = <Circle>[];

  @override
  void initState() {
    super.initState();
    final memberPositionDisposable = _groupPublisher
        .switchMap((group) => widget._controller.observeMemberPosition(group))
        .listen(_buildCurrentPosition);

    final myPositionDisposable = Observable.timer(1, Duration(seconds: 2))
        .switchMap((_) => widget._controller.observeLocation(user))
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
        GestureDetector(
          child: GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _setMapStyle(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            markers: _markers.toSet(),
            circles: _circles.toSet(),
            indoorViewEnabled: true,
          ),
        ),
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
                    onPressed: _moveToCurrentPosition,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _buildCurrentPosition(List<User> users) async {
    print("user $users");

    final markers = <Marker>[];
    final circles = <Circle>[];

    final me = user;

    for (final user in users) {
      if (user.uid == me.uid) {
        continue;
      }

      if (user.allowShareLocation) {
        markers.add(await _newMarker(me, user));
        circles.add(await _newCircle(user));
      }
    }
    print("marker $markers");
    setState(() {
      _markers.addAll(markers);
      _circles.addAll(circles);
    });
  }

  Future<Marker> _newMarker(User me, User other) async {
    final distance = (await widget._controller
            .distanceBetweenLatLng(me.position, other.position))
        .toInt();
    final accuracy = other.lastPosition.accuracy.toInt();
    return Marker(
      markerId: MarkerId(other.uid),
      position: other.position,
      infoWindow: InfoWindow(
          title: other.displayName, snippet: "$distance±${accuracy}m"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  Future<Circle> _newCircle(User user) async {
    return Circle(
        circleId: CircleId(user.uid),
        center: user.position,
        radius: user.lastPosition.accuracy,
        fillColor: Colors.indigoAccent.withAlpha(40),
        strokeWidth: 2,
        strokeColor: Colors.indigoAccent);
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    final style = await rootBundle.loadString("assets/map_style.json");
    await controller.setMapStyle(style);
  }

  void _moveToCurrentPosition() {
    widget._controller.observeCurrentPosition().take(1).listen((position) {
      _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(position.lat, position.long), 15));
    });
  }
}
