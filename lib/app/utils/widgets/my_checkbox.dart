import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyCheckBox extends StatelessWidget {
  final bool val;
  final String text;
  final bool editable;
  final void Function(bool?)? onChanged;

  const MyCheckBox(
      {super.key,
      required this.val,
      required this.text,
      this.onChanged,
      this.editable = true});
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: val,
      activeColor: Colors.transparent,
      checkColor: Theme.of(context).colorScheme.secondary,
      //enabled: editable,
      shape: RoundedRectangleBorder(
          //side: const BorderSide(width: 0.5, color: Colors.purple),
          borderRadius: BorderRadius.circular(15)),
      title: Text(text),
      onChanged: (v) {
        if (editable) {
          onChanged!(v);
          HapticFeedback.heavyImpact();
        }
      },
    );
  }
}
