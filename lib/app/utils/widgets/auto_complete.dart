import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'my_text_form_field.dart';

class MyAutoComplete extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? initVal;
  final String labelText;
  final bool enabled;
  final List<Person>? people;
  final void Function(Person) onSelected;
  final void Function()? onTap;

  const MyAutoComplete({
    super.key,
    required this.labelText,
    this.onTap,
    this.enabled = true,
    required this.onSelected,
    this.onChanged,
    required this.people,
    this.initVal,
  });

  @override
  State<MyAutoComplete> createState() => _MyAutoCompleteState();
}

class _MyAutoCompleteState extends State<MyAutoComplete> {
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: widget.initVal);
    return TypeAheadFormField<Person>(
      validator: (value) {
        return validate(
          text: value,
          min: 2,
          max: 50,
          msgMin: validateMin,
          msgMax: validateMax,
        );
      },
      hideOnLoading: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textFieldConfiguration: TextFieldConfiguration(
        enabled: widget.enabled,
        onTap: widget.onTap,
        onChanged: (val) {
          widget.onChanged!(val);
        },
        controller: textEditingController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
      onSuggestionSelected: widget.onSelected,
      itemBuilder: (context, itemData) {
        return ListTile(
          tileColor: Theme.of(context).focusColor,
          title: Text(itemData.getFullName(fromSearch: true)),
        );
      },
      suggestionsCallback: (pattern) {
        if (pattern.isEmpty) {
          return [];
        }
        List<Person>? matches = widget.people
            ?.where((element) => element
                .getFullName(fromSearch: true)
                .getSearshFilter()
                .contains(pattern.getSearshFilter()))
            .toList();
        return matches ?? [];
      },
      hideOnEmpty: true,
    );
  }
}