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
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(color?.withOpacity(0.0)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              side: showBorder
                  ? BorderSide(color: color ?? Colors.transparent)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          overlayColor: MaterialStatePropertyAll(color?.withOpacity(0.3)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}