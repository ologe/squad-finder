import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/map/map_page_controller.dart';

class MapWidget extends StatefulWidget {
  final MapController controller;

  MapWidget({
    Key key,
    @required this.controller,
  }) : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends AbsState<MapWidget> {
  GoogleMapController _mapController;

  final _markers = <Marker>[];
  final _circles = <Circle>[];

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
    );
  }

  Future<void> _setMapStyle(GoogleMapController controller) async {
    final style = await rootBundle.loadString("assets/map_style.json");
    await controller.setMapStyle(style);
  }

  void moveToCurrentPosition() {
    widget.controller.observeCurrentPosition().take(1).listen((position) {
      _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(position.lat, position.long), 15));
    });
  }

  void buildCurrentPosition(List<User> users) async {
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
    setState(() {
      _markers.addAll(markers);
      _circles.addAll(circles);
    });
  }

  Future<Marker> _newMarker(User me, User other) async {
    final distance = (await widget.controller
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
}
