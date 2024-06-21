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
  late TextEditingController textEditingController =
      TextEditingController(text: widget.initVal);
  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Person>(
      controller: textEditingController,
      builder: (context, controller, focusNode) {
        return MyTextFormField(
          onChanged: (val) {
            widget.onChanged!(val);
          },
          labelText: widget.labelText,
          textEditingController: controller,
          minimum: 2,
          maximum: 20,
        );
      },
      hideOnLoading: true,
      onSelected: widget.onSelected,
      itemBuilder: (context, itemData) {
        return ListTile(
          tileColor: Theme.of(context).focusColor,
          title: Text(itemData.getFullName(fromSearch: true)),
        );
      },
      suggestionsCallback: (pattern) {
        print(pattern);
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
