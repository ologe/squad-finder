import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/widget/custom_future_builder.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';
import 'package:project_london_corner/service/groups_service.dart';
import 'package:project_london_corner/service/location_service.dart';

class DetailGroupPage extends StatefulWidget {
  final FirebaseUser _user;
  final Group _group;

  DetailGroupPage(this._user, this._group);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends AbsState<DetailGroupPage> {
  final _markers = <Marker>[];
  final _circles = <Circle>[];

  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();

    final locationDisposable = locationService
        .observeLocation()
        .switchMap((position) =>
            locationService.updateUserPosition(widget._user.uid, position))
        .listen((_) {});

    final membersPositionDisposable = groupsService
        .observeMemberPosition(widget._group)
        .listen((users) => setState(() {
              _markers.clear();
              _circles.clear();
              _buildCurrentPosition(users);
            }));

    subscriptions.add(locationDisposable);
    subscriptions.add(membersPositionDisposable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._group.name),
      ),
      body: SafeArea(
        child: _locationPermissionRequest(),
      ),
    );
  }

  Widget _locationPermissionRequest() {
    return CustomFutureBuilder<bool>(
      future: locationService.requestPermission(),
      builder: (context, hasPermission) {
        if (hasPermission) {
          return _body();
        }
        return Text("Please enable storage permission");
      },
    );
  }

  Widget _body() {
    return CustomStreamBuilder<User>(
      stream: groupsService.observeCurrentUser(widget._user.uid).take(1),
      builder: (context, user) {
        return Container(
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: user.position, zoom: 100),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            markers: _markers.toSet(),
            circles: _circles.toSet(),
            indoorViewEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapToolbarEnabled: true,
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _buildCurrentPosition(List<User> users) async {
    final markers = <Marker>[];
    final circles = <Circle>[];

    final me = users.where((user) => user.uid == widget._user.uid).first;

    for (final user in users) {
      if (user.uid == widget._user.uid) {
        continue;
      }

      if (user.allowShareLocation) {
        markers.add(await _newMarker(me, user));
        circles.add(await _newCircle(user));
      }
    }
    _markers.addAll(markers);
    _circles.addAll(circles);
  }

  Future<Marker> _newMarker(User me, User other) async {
    final distance =
        (await locationService.distanceBetween(me.position, other.position))
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
}
