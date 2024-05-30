import 'package:flutter/material.dart';

class MyInfoCardEdit extends StatelessWidget {
  final Widget child;
  final bool isfunc;
  final Color? color;

  const MyInfoCardEdit({
    super.key,
    required this.child,
    this.isfunc = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isfunc
            ? color ?? Theme.of(context).colorScheme.surface
            : color ?? Theme.of(context).focusColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
