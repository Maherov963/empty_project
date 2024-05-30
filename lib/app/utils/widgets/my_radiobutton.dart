import 'package:flutter/material.dart';

class MyRadioButton extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final String text;
  final Color? color;
  final void Function(dynamic)? onChanged;
  const MyRadioButton({
    super.key,
    this.value,
    this.color,
    this.groupValue,
    required this.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      groupValue: groupValue,
      value: value,
      onChanged: onChanged,
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: color,
        ),
      ),
    );
  }
}
