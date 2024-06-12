import 'package:al_khalil/app/utils/themes/dark_theme.dart';
import 'package:flutter/material.dart';

class MyFabGroup extends StatefulWidget {
  final List<FabModel> fabModel;

  const MyFabGroup({
    super.key,
    required this.fabModel,
  });

  @override
  State<MyFabGroup> createState() => _MyFabState();
}

class _MyFabState extends State<MyFabGroup>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;

  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: null,
      end: color10,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: isOpened ? 'إغلاق' : 'المزيد',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ...widget.fabModel
            .map(
              (e) => Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * e.tag,
                  0.0,
                ),
                child: FloatingActionButton(
                  heroTag: e.tag,
                  onPressed: e.onTap,
                  tooltip: e.tooltip,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(e.icon),
                ),
              ),
            )
            .toList(),
        toggle(),
      ],
    );
  }
}

class FabModel {
  final IconData icon;
  final Function() onTap;
  final String? tooltip;
  final int tag;

  const FabModel({
    required this.icon,
    required this.onTap,
    this.tooltip,
    required this.tag,
  });
}
