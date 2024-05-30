import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String validateMax = "يجب ان لايتعدى الحقل عن عدد محارف ";
const String validateMin = "يجب ان لا يقل الحقل عن عدد محارف ";

// ignore: must_be_immutable
class MyTextFormField extends StatefulWidget {
  final String labelText;
  final TextInputType textInputType;
  final TextEditingController? textEditingController;
  final Widget? preIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final int minimum;
  final int maximum;
  final FocusNode? focusnode;
  final void Function(String)? onChanged;
  final String? initVal;
  final Iterable<String>? autofillHints;

  const MyTextFormField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.preIcon,
    this.suffixIcon,
    this.minimum = 0,
    this.maximum = 250,
    this.onChanged,
    this.initVal,
    this.autofillHints,
    this.focusnode,
    this.textEditingController,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    if (widget.textEditingController == null) {
      textEditingController = TextEditingController(text: widget.initVal);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: 6,
      validator: (value) {
        return validate(
          text: value,
          min: widget.minimum,
          max: widget.maximum,
          msgMin: validateMin,
          msgMax: validateMax,
        );
      },
      textDirection: widget.textInputType == TextInputType.emailAddress
          ? TextDirection.ltr
          : null,
      autofillHints: widget.autofillHints,
      controller: textEditingController,
      enabled: widget.enabled,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      inputFormatters: widget.textInputType != TextInputType.number
          ? null
          : [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      focusNode: widget.focusnode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        prefixText: widget.textInputType == TextInputType.emailAddress
            ? "gmail.com@"
            : null,
        labelText: widget.labelText,
        prefixIcon: widget.preIcon,
        suffixIcon: widget.suffixIcon,
      ),
      keyboardType: widget.textInputType,
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
