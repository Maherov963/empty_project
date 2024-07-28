import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    this.onTap,
    required this.title,
    this.leading,
    this.trailing,
    this.color,
  });
  final void Function()? onTap;
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      iconColor: color,
      textColor: color,
      tileColor: color?.withAlpha(25),
      title: Text(title),
      leading: leading,
      trailing: trailing,
    );
  }
}
