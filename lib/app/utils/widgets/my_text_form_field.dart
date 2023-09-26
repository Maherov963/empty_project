import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String validateMax = "يجب ان لايتعدى الحقل عن عدد محارف ";
const String validateMin = "يجب ان لا يقل الحقل عن عدد محارف ";

// ignore: must_be_immutable
class MyTextFormField extends StatelessWidget {
  final String labelText;
  final TextInputType textInputType;
  TextEditingController? textEditingController;
  final Widget? preIcon;
  final bool enabled;
  final int minimum;
  final int maximum;
  final FocusNode? focusnode;
  final void Function(String)? onChanged;
  String? initVal;
  final Iterable<String>? autofillHints;

  MyTextFormField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.textInputType = TextInputType.text,
    this.preIcon,
    this.minimum = 0,
    this.maximum = 250,
    this.onChanged,
    this.initVal,
    this.autofillHints,
    this.focusnode,
    this.textEditingController,
  });
  @override
  Widget build(BuildContext context) {
    textEditingController ??= TextEditingController(text: initVal);

    return TextFormField(
      minLines: 1,
      maxLines: 6,
      validator: (value) {
        return validate(
          text: value,
          min: minimum,
          max: maximum,
          msgMin: validateMin,
          msgMax: validateMax,
        );
      },
      textDirection: textInputType == TextInputType.emailAddress
          ? TextDirection.ltr
          : null,
      autofillHints: autofillHints,
      controller: textEditingController,
      enabled: enabled,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
        initVal = value;
      },
      inputFormatters: textInputType != TextInputType.number
          ? null
          : [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      focusNode: focusnode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.onError),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).appBarTheme.foregroundColor!),
        ),
        prefixText:
            textInputType == TextInputType.emailAddress ? "gmail.com@" : null,
        floatingLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor!,
        ),
        prefixIcon: preIcon,
      ),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      keyboardType: textInputType,
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
