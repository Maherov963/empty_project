import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'my_text_form_field.dart';

// ignore: must_be_immutable
class MyAutoCompleteNumber extends StatefulWidget {
  final void Function(String)? onChanged;
  String? initVal;
  final void Function()? onTap;

  final void Function(String)? onSelected;
  MyAutoCompleteNumber({
    super.key,
    this.onSelected,
    this.onChanged,
    this.initVal,
    this.onTap,
  });

  @override
  State<MyAutoCompleteNumber> createState() => _MyAutoCompleteNumberState();
}

class _MyAutoCompleteNumberState extends State<MyAutoCompleteNumber> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: widget.initVal);
    return TypeAheadFormField<String>(
      validator: (value) {
        return validate(
          text: value,
          min: 10,
          max: 10,
          msgMin: validateMin,
          msgMax: validateMax,
        );
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textFieldConfiguration: TextFieldConfiguration(
        onTap: widget.onTap,
        onChanged: (val) {
          widget.onChanged!(val);
        },
        controller: textEditingController,
        maxLength: 10,
        cursorColor: Theme.of(context).colorScheme.secondary,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'رقم التواصل',
          labelStyle: TextStyle(
            color: Theme.of(context).appBarTheme.foregroundColor!,
          ),
          contentPadding: const EdgeInsets.all(10),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onError),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).appBarTheme.foregroundColor!),
          ),
        ),
      ),
      onSuggestionSelected: (suggestion) {
        widget.onSelected!(suggestion);
      },
      itemBuilder: (context, itemData) {
        return ListTile(
          tileColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(itemData.replaceAll("0", "")),
        );
      },
      suggestionsCallback: (pattern) {
        List<String> matches = <String>[];
        if (context.read<PersonProvider>().withFather) {
          matches.add(context.read<PersonProvider>().numbers[0]);
        }
        if (context.read<PersonProvider>().withMother) {
          matches.add(context.read<PersonProvider>().numbers[1]);
        }
        if (context.read<PersonProvider>().withPersonal) {
          matches.add(context.read<PersonProvider>().numbers[2]);
        }
        if (context.read<PersonProvider>().withKin) {
          matches.add(context.read<PersonProvider>().numbers[3]);
        }
        return matches;
      },
      hideOnEmpty: true,
    );
  }
}
