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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Theme.of(context).highlightColor),
      ),
      child: child,
    );
  }
}
