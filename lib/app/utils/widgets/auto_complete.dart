import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:flutter/cupertino.dart';
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
    final theme = Theme.of(context);
    return TypeAheadField<Person>(
      controller: textEditingController,
      builder: (context, controller, focusNode) {
        return MyTextFormField(
          focusnode: focusNode,
          onChanged: (val) {
            widget.onChanged!(val);
          },
          labelText: widget.labelText,
          textEditingController: controller,
          enabled: widget.enabled,
          minimum: 2,
          maximum: 20,
        );
      },
      hideOnLoading: true,
      onSelected: widget.onSelected,
      decorationBuilder: (context, child) {
        return Material(
          type: MaterialType.card,
          elevation: 4,
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(15),
          child: child,
        );
      },
      itemBuilder: (context, itemData) {
        return CupertinoListTile(
          title: Text(
            itemData.getFullName(fromSearch: true),
            style: theme.textTheme.bodyMedium,
          ),
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
/**
 *  textFieldConfiguration: TextFieldConfiguration(
        enabled: widget.enabled,
        onTap: widget.onTap,
        onChanged: (val) {
          widget.onChanged!(val);
        },
        controller: textEditingController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainer,
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          contentPadding: const EdgeInsets.all(10),
        ),
      ),
     
 */