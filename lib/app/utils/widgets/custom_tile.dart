import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    this.onTap,
    required this.title,
    this.leading,
    this.trailing,
    this.color,
    this.subTitle,
  });
  final void Function()? onTap;
  final String title;
  final String? subTitle;
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
      subtitle: subTitle == null ? null : Text(subTitle!),
      leading: leading,
      trailing: trailing,
    );
  }
}
