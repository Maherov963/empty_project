import 'package:flutter/material.dart';

class MySearchField extends StatefulWidget {
  final String labelText;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final Widget? suff;
  final Widget? pref;
  final bool enabled;
  final int minimum;
  final int maximum;
  final FocusNode? focusnode;
  final void Function(String)? onChanged;
  final String? initVal;
  final Iterable<String>? autofillHints;

  const MySearchField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.suff,
    this.minimum = 0,
    this.maximum = 250,
    this.onChanged,
    this.initVal,
    this.autofillHints,
    this.focusnode,
    this.textEditingController,
    this.pref,
  });

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: 1,
      textAlign: TextAlign.right,
      controller: widget.textEditingController,
      onChanged: widget.onChanged,
      focusNode: widget.focusnode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        hintText: widget.labelText,
        suffixIcon: widget.suff,
        prefixIcon: widget.pref,
        hintStyle: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}

validate(
    {required String? text,
    required int min,
    required int max,
    required String msgMin,
    required String msgMax}) {
  if (text!.length < min) {
    return '$msgMin $min';
  } else if (text.length > max) {
    return '$msgMax $max';
  } else {
    return null;
  }
}
