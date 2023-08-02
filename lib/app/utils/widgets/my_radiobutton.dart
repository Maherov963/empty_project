import 'package:flutter/material.dart';

class MyRadioButton extends StatelessWidget {
  final dynamic value;
  final dynamic groupValue;
  final String text;
  final void Function(dynamic)? onChanged;
  const MyRadioButton(
      {super.key,
      this.value,
      this.groupValue,
      required this.text,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.2, color: Colors.blue),
          borderRadius: BorderRadius.circular(15)),
      groupValue: groupValue,
      value: value,
      onChanged: onChanged,
      title: Text(text),
    );
  }
}
