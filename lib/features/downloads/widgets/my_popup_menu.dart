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

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      enableFeedback: true,
      color: const Color.fromARGB(255, 15, 33, 41),
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.grey,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => list,
    );
  }
}
