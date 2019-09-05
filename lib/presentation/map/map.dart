import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_london_corner/core/entity/user.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/map/map_page_controller.dart';
import 'package:project_london_corner/presentation/model/presentation_entity.dart';

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

  void moveToCurrentPosition() async {
    appController.observeCurrentUserPosition.take(1).listen((position) {
      _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15));
    });
  }

  void buildCurrentPosition(User me, List<DisplayableUser> users) async {
    final markers = <Marker>[];
    final circles = <Circle>[];

    for (final user in users) {
      if (user.uid == me.uid) {
        continue;
      }

      if (user.allowShareLocation) {
        markers.add(await _newMarker(user));
        circles.add(await _newCircle(user));
      }
    }
    setState(() {
      _markers.addAll(markers);
      _circles.addAll(circles);
    });
  }

  Future<Marker> _newMarker(DisplayableUser other) async {
    return Marker(
      markerId: MarkerId(other.uid),
      position: other.latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }

  Future<Circle> _newCircle(DisplayableUser user) async {
    return Circle(
        circleId: CircleId(user.uid),
        center: user.latLng,
        radius: user.accuracy,
        fillColor: Colors.indigoAccent.withAlpha(40),
        strokeWidth: 2,
        strokeColor: Colors.indigoAccent);
  }
}
