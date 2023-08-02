import 'package:flutter/material.dart';

const String validateMax = "يجب ان لايتعدى الحقل عن عدد محارف ";
const String validateMin = "يجب ان لا يقل الحقل عن عدد محارف ";

// ignore: must_be_immutable
class MySearchField extends StatelessWidget {
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

  MySearchField({
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
      maxLines: 1,
      textAlign: TextAlign.right,
      // onTap: () {
      //   if (textEditingController!.selection ==
      //       TextSelection.fromPosition(
      //           TextPosition(offset: textEditingController!.text.length - 1))) {
      //     textEditingController!.selection = TextSelection.fromPosition(
      //         TextPosition(offset: textEditingController!.text.length));
      //   }
      // },
      controller: textEditingController,
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
        initVal = value;
      },
      focusNode: focusnode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        filled: true,
        fillColor: Theme.of(context).appBarTheme.backgroundColor,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none),
        hintText: labelText,
        hintStyle: TextStyle(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
        // suffixIcon: IconButton(
        //     onPressed: () {
        //       textEditingController!.text = "";
        //     },
        //     icon: Icon(Icons.cancel)),
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
