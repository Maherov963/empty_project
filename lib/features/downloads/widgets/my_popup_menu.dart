import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';

class MyPopUpMenu extends StatelessWidget {
  const MyPopUpMenu({super.key, required this.list});
  final List<PopupMenuEntry> list;

  static PopupMenuEntry getWithIcon(String text, IconData icon,
      {Color? color, void Function()? onTap}) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color),
          10.getWidthSizedBox,
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  static PopupMenuEntry getWithSwitch(
    String text,
    bool checked,
    BuildContext ctx, {
    Color? color,
    void Function()? onTap,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      padding: const EdgeInsets.only(),
      child: Row(
        children: [
          Switch(
            value: checked,
            onChanged: (val) {
              onTap?.call();
              Navigator.pop(ctx);
            },
          ),
          Text(text, style: TextStyle(color: color)),
        ],
      ),
    );
  }

  static PopupMenuEntry getWithCheckBox(String text, bool checked,
      {Color? color, void Function()? onTap}) {
    return CheckedPopupMenuItem(
      onTap: onTap,
      checked: checked,
      padding: const EdgeInsets.only(right: 4),
      child: Text(text, style: TextStyle(color: color)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableFeedback: true,
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.grey,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => list,
    );
  }
}
