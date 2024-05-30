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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(5)),
      child: ExpansionTile(
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
