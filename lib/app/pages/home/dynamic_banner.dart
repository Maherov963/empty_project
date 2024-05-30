import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';

class DynamicBanner extends StatelessWidget {
  const DynamicBanner({
    super.key,
    required this.color,
    required this.visable,
    required this.text,
    required this.icon,
    this.onTap,
  });
  final Color color;
  final bool visable;
  final String text;
  final IconData icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visable,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurStyle: BlurStyle.solid,
              blurRadius: 10,
            ),
            BoxShadow(
              color: color.withOpacity(1),
              blurStyle: BlurStyle.outer,
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.all(2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5),
          splashColor: color.withOpacity(0.2),
          splashFactory: InkSplash.splashFactory,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: TextStyle(color: color)),
              5.getWidthSizedBox,
              Icon(icon, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
