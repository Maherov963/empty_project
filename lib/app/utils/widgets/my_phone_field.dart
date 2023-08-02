import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_text_form_field.dart';

// ignore: must_be_immutable
class MyPhoneField extends StatelessWidget {
  final String labelText;
  //final TextInputType textInputType;
  final bool enabled;
  final void Function(String)? onChanged;
  String? initVal;
  final int minimum;
  final int maximum;
  final FocusNode? focusnode;
  MyPhoneField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.focusnode,
    this.onChanged,
    this.initVal,
    this.minimum = 0,
    this.maximum = 50,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.secondary,
      enabled: enabled,
      focusNode: focusnode,
      maxLength: 10,
      validator: (value) {
        return validate(
          text: value,
          min: minimum,
          max: maximum,
          msgMin: validateMin,
          msgMax: validateMax,
        );
      },
      controller: TextEditingController(text: initVal),
      autofillHints: const [
        AutofillHints.telephoneNumber,
      ],
      onChanged: (value) {
        onChanged!(value);
        initVal = value;
      },
      cursorWidth: 2,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
      textDirection: TextDirection.ltr,
      enableSuggestions: true,
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
        floatingLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor!,
        ),
        prefixIcon: const Icon(Icons.phone),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
