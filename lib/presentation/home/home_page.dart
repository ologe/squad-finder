import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:project_london_corner/core/entity/user_position.dart';
import 'package:project_london_corner/di/injection_utils.dart';
import 'package:project_london_corner/presentation/base/base_widgets.dart';
import 'package:project_london_corner/presentation/create_group/create_group.dart';
import 'package:project_london_corner/presentation/home/home_page_controller.dart';
import 'package:project_london_corner/presentation/map/map_page.dart';
import 'package:project_london_corner/presentation/widget/backdrop/backdrop.dart';
import 'package:project_london_corner/presentation/widget/custom_stream_builder.dart';
import 'package:project_london_corner/presentation/widget/location_button.dart';

import 'my_groups_widget.dart';

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

  @override
  void afterInit() {
    super.afterInit();
    final onGroupChangeDisposable =
        appController.observeCurrentGroup.listen((_) => _collapseBackdrop());

    subscriptions.add(onGroupChangeDisposable);
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      key: _backdropKey,
      backPage: widget._mapPage().inject(backdropPeek),
      frontPage: _frontPage(),
      backdropPeek: backdropPeek,
    );
  }

  Widget _frontPage() {
    return Column(
      children: <Widget>[
        _toolbar(),
        Expanded(
          child: MyGroups(
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
    return CustomStreamBuilder<UserPosition>(
        stream: appController.observeCurrentFireBaseUser.switchMap((user) {
      return widget._controller.observeUserPosition(user.uid);
    }), builder: (context, userPosition) {
      return LocationButton(
        enabled: userPosition.allowShareLocation,
        onTap: () => _toggleSharePosition(userPosition.uid),
      );
    });
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

  void _toggleSharePosition(String uid) {
    widget._controller.toggleSharePosition(uid);
  }

  void _toCreateGroup() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => widget._createGroup()));
  }

  void _logout() {
    widget._controller.logout();
  }
}
