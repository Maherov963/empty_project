import 'package:flutter/material.dart';
import '../plugins/custom_dropdown_menu.dart' as dropdown;

class MyComboBox extends StatefulWidget {
  final String hint;
  final String? text;
  final List<String> items;
  final bool enabled;
  final void Function(String?)? onChanged;
  const MyComboBox({
    super.key,
    required this.text,
    required this.items,
    this.enabled = true,
    this.hint = 'اضغط للاختيار',
    this.onChanged,
  });

  @override
  State<MyComboBox> createState() => _MyComboBoxState();
}

class _MyComboBoxState extends State<MyComboBox> {
  @override
  Widget build(BuildContext context) {
    return dropdown.DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      initialSelection: widget.text,
      label: Text(
        widget.hint,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        filled: true,
        fillColor: Theme.of(context).hoverColor,
        border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(15))),
      ),
      width: MediaQuery.of(context).size.width / 2,
      hintText: widget.hint,
      enabled: widget.enabled,
      textStyle: const TextStyle(),
      dropdownMenuEntries: widget.items
          .map((e) => dropdown.DropdownMenuEntry(value: e, label: e))
          .toList(),
      onSelected: widget.onChanged,
    );
  }
}
