import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MyWaitingAnimation extends StatelessWidget {
  const MyWaitingAnimation({
    super.key,
    this.size = 30,
    this.color,
  });
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.inkDrop(
      color: color ?? Theme.of(context).colorScheme.onSecondary,
      size: size,
    );
  }
}
