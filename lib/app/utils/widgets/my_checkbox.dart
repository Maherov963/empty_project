import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCheckBox extends StatelessWidget {
  final bool val;
  final String text;
  final bool editable;
  final Color? color;
  final void Function(bool?)? onChanged;

  const MyCheckBox({
    super.key,
    required this.val,
    required this.text,
    this.onChanged,
    this.color,
    this.editable = true,
  });
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: val,
      activeColor: Colors.transparent,
      checkColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      onChanged: (v) {
        if (editable) {
          onChanged!(v);
          HapticFeedback.heavyImpact();
        }
      },
    );
  }
}
