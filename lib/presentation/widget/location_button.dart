import 'package:flutter/material.dart';

class LocationButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  LocationButton({@required this.enabled, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(enabled ? Icons.location_on : Icons.location_off),
      color: enabled
          ? Theme.of(context).accentColor
          : Theme.of(context).buttonColor,
      onPressed: onTap,
    );
  }
}
