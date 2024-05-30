import 'package:flutter/material.dart';

class MyComboBox extends StatefulWidget {
  final String hint;
  final String? text;
  final List<String> items;
  final bool enabled;
  final void Function(String?)? onChanged;
  const MyComboBox({
    Key? key,
    required this.text,
    required this.items,
    this.enabled = true,
    this.hint = 'اضغط للاختيار',
    this.onChanged,
  }) : super(key: key);

  @override
  State<MyComboBox> createState() => _MyComboBoxState();
}

class _MyComboBoxState extends State<MyComboBox> {
  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      expandedInsets: const EdgeInsets.all(0),
      initialSelection: widget.text,
      label: Text(
        widget.hint,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          border: OutlineInputBorder()),
      hintText: widget.hint,
      enabled: widget.enabled,
      dropdownMenuEntries: widget.items
          .map((e) => DropdownMenuEntry(value: e, label: e))
          .toList(),
      onSelected: widget.onChanged,
    );
  }
}
