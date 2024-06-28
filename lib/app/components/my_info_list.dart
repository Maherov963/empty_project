import 'package:flutter/material.dart';

class MyInfoList extends StatelessWidget {
  const MyInfoList({
    super.key,
    required this.title,
    required this.data,
    this.subtitle,
  });
  final String title;
  final Widget? subtitle;
  final List<Widget> data;
  @override
  Widget build(BuildContext context) {
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
    final color = Theme.of(context).colorScheme.surfaceContainer;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        collapsedBackgroundColor: color,
        collapsedShape: shape,
        backgroundColor: color,
        shape: shape,
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        subtitle: subtitle,
        children: data,
      ),
    );
  }
}
