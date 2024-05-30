import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:al_khalil/app/utils/themes/dark_theme.dart';
import 'package:flutter/material.dart';

class MyFabGroup extends StatefulWidget {
  final void Function()? editPressed;
  final void Function()? attendencePressed;
  const MyFabGroup({
    super.key,
    this.editPressed,
    // this.testPressed,
    this.attendencePressed,
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
  final Curve _curve = Curves.easeOut;
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
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget edit() {
    return FloatingActionButton(
      heroTag: "btn1",
      onPressed: widget.editPressed,
      tooltip: "تعديل الحلقة",
      backgroundColor: Theme.of(context).primaryColor,
      child: widget.editPressed == null
          ? const MyWaitingAnimation(
              color: Colors.white,
            )
          : Icon(
              Icons.edit,
              color: Colors.grey[100],
            ),
    );
  }

  Widget attendence() {
    return FloatingActionButton(
      heroTag: "btn2",
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: widget.attendencePressed,
      tooltip: "تفقد الحلقة",
      child: widget.attendencePressed == null
          ? const MyWaitingAnimation(
              color: Colors.white,
            )
          : Icon(
              Icons.date_range_outlined,
              color: Colors.grey[100],
            ),
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: 'المزيد',
      child: AnimatedIcon(
        color: Colors.grey[100],
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
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: edit(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 1.0,
            0.0,
          ),
          child: attendence(),
        ),
        toggle(),
      ],
    );
  }
}
