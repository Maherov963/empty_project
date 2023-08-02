// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyComboBox extends StatefulWidget {
  String hint;
  String? text;
  final List<String> items;
  final bool enabled;
  final bool withBorder;
  final void Function(String?)? onChanged;
  MyComboBox(
      {Key? key,
      required this.text,
      required this.items,
      this.enabled = true,
      this.hint = 'اضغط للاختيار',
      this.onChanged,
      this.withBorder = true})
      : super(key: key);

  @override
  State<MyComboBox> createState() => _MyComboBoxState();
}

class _MyComboBoxState extends State<MyComboBox> {
  late Color color;

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).primaryColor;
    return Container(
      decoration: BoxDecoration(
        //color: color4,
        border: Border.all(
            width: widget.withBorder ? 1 : 0,
            color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        borderRadius: BorderRadius.circular(10),
        dropdownColor: Theme.of(context).colorScheme.surface,
        //style: const TextStyle(color: color1),
        items: widget.items
            .map((e) => DropdownMenuItem(
                  alignment: Alignment.center,
                  enabled: widget.enabled,
                  value: e,
                  child: Text(
                    e,
                  ),
                ))
            .toList(),
        value: widget.text,
        alignment: AlignmentDirectional.center,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        hint: Text(widget.hint),
        underline: const SizedBox(),
        onChanged: (value) => setState(() {
          widget.onChanged!(value);
          widget.text = value!;
          // widget.val.text = value!;
        }),
      ),
    );
  }
}
