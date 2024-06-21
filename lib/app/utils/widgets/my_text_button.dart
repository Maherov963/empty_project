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
          backgroundColor: WidgetStatePropertyAll(color?.withOpacity(0.1)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side:
                  //  showBorder
                  //     ? BorderSide(
                  //         color: color ?? Theme.of(context).colorScheme.primary)
                  //     :
                  BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          overlayColor: WidgetStatePropertyAll(color?.withOpacity(0.3)),
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
