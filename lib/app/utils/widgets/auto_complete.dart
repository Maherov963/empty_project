import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_text_form_field.dart';

// ignore: must_be_immutable
class MyAutoComplete extends StatelessWidget {
  final void Function(String)? onChanged;
  String? initVal;
  final String labelText;
  final void Function(int)? onSelected;
  MyAutoComplete({
    super.key,
    required this.labelText,
    this.onSelected,
    this.onChanged,
    this.initVal,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) =>
              MyTextFormField(
        minimum: 2,
        labelText: labelText,
        focusnode: focusNode,
        initVal: initVal,
        onChanged: (val) {
          onChanged!(val);
          textEditingController.text = val;
        },
      ),
      optionsBuilder: (textEditingController) {
        if (textEditingController.text == '') {
          return const Iterable<String>.empty();
        } else {
          List<String> matches = <String>[];
          matches.addAll(context
              .read<PersonProvider>()
              .people
              .map((e) => "${e.getFullName()}/${e.id}")
              .toList());

          matches.retainWhere((s) {
            return s.replaceAll("أ", "ا").replaceAll("إ", "ا").contains(
                textEditingController.text
                    .replaceAll("أ", "ا")
                    .replaceAll("إ", "ا"));
          });
          return matches;
        }
      },
      displayStringForOption: (option) => option.split("/")[0],
      onSelected: (option) {
        onSelected!(int.parse(option.split("/")[1]));
      },
    );
  }
}
