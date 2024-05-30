// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/material.dart';
import 'my_text_form_field.dart';

class MyTextPassField extends StatefulWidget {
  final String labelText;
  final String msgMin;
  final int minChar;
  final int maxChar;
  final String msgMax;
  final Icon? preIcon;
  final bool enable;
  final Iterable<String>? autofillHints;
  final void Function(String)? onChanged;
  final String? initVal;
  TextEditingController? textEditingController;

  MyTextPassField({
    super.key,
    required this.labelText,
    this.preIcon,
    this.enable = true,
    this.msgMin = 'اقل من',
    this.msgMax = 'تكثر من',
    this.minChar = 0,
    this.maxChar = 1000,
    this.onChanged,
    this.autofillHints,
    this.initVal,
    this.textEditingController,
  });

  @override
  State<MyTextPassField> createState() => _MyTextPassField();
}

class _MyTextPassField extends State<MyTextPassField> {
  bool _isLocked = true;
  void isLockedChange() {
    setState(() {
      _isLocked = !_isLocked;
    });
  }

  @override
  void initState() {
    widget.textEditingController ??=
        TextEditingController(text: widget.initVal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.secondary,
      onChanged: widget.onChanged,
      enabled: widget.enable,
      controller: widget.textEditingController,
      toolbarOptions: const ToolbarOptions(
        copy: false,
        cut: false,
        paste: true,
        selectAll: true,
      ),
      validator: (value) {
        return validate(
          text: value,
          min: widget.minChar,
          max: widget.maxChar,
          msgMin: widget.msgMin,
          msgMax: widget.msgMin,
        );
      },
      obscureText: _isLocked,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        prefixIcon: widget.preIcon,
        suffixIcon: IconButton(
          icon: Icon(_isLocked ? Icons.visibility_off : Icons.visibility),
          onPressed: isLockedChange,
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
    );
  }
}
