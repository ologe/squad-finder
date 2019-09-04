import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/group.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/create_group/create_group.dart';
import 'package:project_london_corner/presentation/home/groups.dart';
import 'package:project_london_corner/presentation/home/home_controller.dart';
import 'package:project_london_corner/presentation/map/map.dart';
import 'package:project_london_corner/presentation/widget/backdrop/backdrop.dart';
import 'package:project_london_corner/presentation/widget/location_button.dart';

const double backdropPeek = 56.0;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final Provider<CreateGroupPage> _createGroup;
  final Provider<MapPage> _mapPage;
  final HomePageController _controller;

  @provide
  HomePage(this._controller, this._createGroup, this._mapPage);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends AbsState<HomePage> {
  final _backdropKey = GlobalKey<BackdropState>();
  GlobalKey<MapPageState> _mapKey;

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      key: _backdropKey,
      backPage: _backPage(),
      frontPage: _frontPage(),
      backdropPeek: backdropPeek,
    );
  }

  Widget _backPage() {
    MapPage result = widget._mapPage();
    _mapKey = result.inject(backdropPeek);
    return result;
  }

  Widget _frontPage() {
    return Column(
      children: <Widget>[
        _toolbar(),
        Expanded(
          child: MyGroups(
            onGroupSelected: _onGroupSelectedCallback,
            controller: widget._controller,
          ),
        ),
      ],
    );
  }

  Widget _toolbar() {
    return SizedBox(
      height: backdropPeek,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: _collapseBackdrop,
          )),
          _sharePositionButton(),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _sharePositionButton() {
    return LocationButton(
      enabled: user.allowShareLocation,
      onTap: _toggleSharePosition,
    );
  }

  Widget _logoutButton() {
    return IconButton(
      icon: Icon(Icons.exit_to_app),
      onPressed: _logout,
    );
  }

  void _collapseBackdrop() {
    _backdropKey.currentState.toggleBackdropLayerVisibility();
  }

  void _toggleSharePosition() {
    widget._controller.toggleSharePosition(user);
  }

  void _toCreateGroup() {
    final page = widget._createGroup().inject(user);
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _onGroupSelectedCallback(Group group) {
    _collapseBackdrop();
    _mapKey.currentState.updateGroup(group);
  }

  void _logout() {
    widget._controller.logout();
  }
}
