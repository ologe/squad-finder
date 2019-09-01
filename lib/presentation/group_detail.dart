import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/core/user.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/widget/custom_future_builder.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';
import 'package:project_london_corner/service/groups_service.dart';

class DetailGroupPage extends StatefulWidget {
  final FirebaseUser _user;
  final Group _group;

  DetailGroupPage(this._user, this._group);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends AbsState<DetailGroupPage> {
  final _markers = <Marker>[];

  final _location = Location();
  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    final stream = groupsService.observeMemberPosition(widget._group)
    .listen((users) => setState(() {
      _markers.clear();
      _markers.addAll(_buildMarkers(users));
    }));
    subscriptions.add(stream);
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

  Widget _locationPermissionRequest(){
    return CustomFutureBuilder<bool>(
      future: _checkLocationPermission(),
      builder: (context, hasPermission){
        if (hasPermission){
          return _body();
        }
        return Text("Please enable storage permission");
      },
    );
  }

  Future<bool> _checkLocationPermission() async {
    final level = LocationPermissionLevel.locationAlways;
    final result = await _locationPermissions.checkPermissionStatus(level: level);
    final hasPermission = result == PermissionStatus.granted;
    return hasPermission || await _locationPermissions.requestPermissions(permissionLevel: level) == PermissionStatus.granted;

//    await _locationPermissions.shouldShowRequestPermissionRationale(permissionLevel: level); TODO
  }

  Widget _body() {
    return CustomStreamBuilder<User>(
      stream: groupsService.observeCurrentUser(widget._user.uid).take(1),
      builder: (context, user) {
        return Container(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: user.lastPosition,
              zoom: 100
            ),
            mapType: MapType.normal,
            onMapCreated: _onMapCreated,
            markers: _markers.toSet(),
            indoorViewEnabled: true,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
  }

  List<Marker> _buildMarkers(List<User> users){
    final markers = <Marker>[];
    for (final user in users) {
      if (user.uid == widget._user.uid) {
        continue;
      }
      final marker = Marker(
        markerId: MarkerId(user.uid),
        position: user.lastPosition,
        infoWindow: InfoWindow(
          title: user.displayName
        )
      );
      markers.add(marker);
    }
    return markers;
  }

}
