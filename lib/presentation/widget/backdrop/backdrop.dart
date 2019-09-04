import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final Widget frontPage;
  final Widget backPage;
  final double backdropPeek;

  Backdrop({
    Key key,
    @required this.frontPage,
    @required this.backPage,
    @required this.backdropPeek,
  })  : assert(frontPage != null),
        assert(backPage != null),
        assert(backdropPeek > 0),
        super(key: key);

  static BackdropState of(BuildContext context) {
    assert(context != null);
    return context.ancestorStateOfType(const TypeMatcher<BackdropState>());
  }

  @override
  State createState() => BackdropState();
}

class BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  bool get _frontLayerVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void toggleBackdropLayerVisibility() {
    _controller.fling(
        velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: _buildStack,
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final double layerTitleHeight =
        widget.backdropPeek + 8 + MediaQuery.of(context).viewPadding.top;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, layerTop, 0.0, layerTop - layerSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        widget.backPage,
        PositionedTransition(
          rect: layerAnimation,
          child: _FrontPage(
            child: widget.frontPage,
            backdropPeek: widget.backdropPeek,
          ),
        ),
      ],
    );
  }
}

class _FrontPage extends StatelessWidget {
  final double backdropPeek;
  final Widget child;

  _FrontPage({
    @required this.child,
    @required this.backdropPeek,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 16.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(backdropPeek)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
