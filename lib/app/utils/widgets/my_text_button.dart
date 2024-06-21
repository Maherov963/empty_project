import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.showBorder = true,
  });
  final void Function()? onPressed;
  final String text;
  final bool showBorder;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final usedColor = color ?? Theme.of(context).colorScheme.primary;
    return TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(usedColor.withOpacity(0.1)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          overlayColor: WidgetStatePropertyAll(usedColor.withOpacity(0.3)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: usedColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
