import 'package:al_khalil/app/pages/person/person_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'intl_phone_plugin/countries.dart';

class MyAutoCompleteNumber extends StatefulWidget {
  final void Function(String)? onChanged;
  final String? initVal;
  final List<PhoneNumber>? data;
  final void Function()? onTap;
  final bool enabled;
  final bool enableSearch;
  final void Function(PhoneNumber)? onSelected;

  const MyAutoCompleteNumber({
    super.key,
    this.onSelected,
    this.onChanged,
    this.initVal,
    this.data,
    this.onTap,
    required this.enabled,
    required this.enableSearch,
  });

  @override
  State<MyAutoCompleteNumber> createState() => _MyAutoCompleteNumberState();
}

class _MyAutoCompleteNumberState extends State<MyAutoCompleteNumber> {
  late List<Country> filteredCountries;
  late String number;
  String? validatorMessage;

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController =
        TextEditingController(text: widget.initVal);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TypeAheadFormField<PhoneNumber>(
        // validator: (value) {
        //   if (value == null || !isNumeric(value)) return validatorMessage;
        //   if (!widget.disableLengthCheck) {
        //     return value.length >= _selectedCountry.minLength &&
        //             value.length <= _selectedCountry.maxLength
        //         ? null
        //         : widget.invalidNumberMessage;
        //   }

        //   return validatorMessage;
        // },
        hideOnLoading: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textFieldConfiguration: TextFieldConfiguration(
          onTap: widget.onTap,
          onChanged: (val) {
            widget.onChanged!(val);
          },
          controller: textEditingController,
          maxLength: 15,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                callWhatsApp(textEditingController.text, false);
              },
              icon: FaIcon(FontAwesomeIcons.whatsapp,
                  color: Theme.of(context).colorScheme.primary),
            ),
            border: const OutlineInputBorder(),
            labelText: 'رقم التواصل',
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
        onSuggestionSelected: (suggestion) {
          widget.onSelected!(suggestion);
        },
        itemBuilder: (context, itemData) {
          return ListTile(
            tileColor: Theme.of(context).focusColor,
            title: Text(itemData.name),
          );
        },
        suggestionsCallback: (pattern) {
          List<PhoneNumber>? matches = widget.data
              ?.where((element) => element.number.contains(pattern))
              .toList();
          return matches ?? [];
        },
        hideOnEmpty: true,
      ),
    );
  }
}

class PhoneNumber {
  final String number;
  final String name;

  const PhoneNumber({required this.number, required this.name});

  String get getHash => "$name#$number";
  static String getHashedName(String phoneNumber) => phoneNumber.split("#")[0];

  static String getHashedNumber(String phoneNumber) =>
      phoneNumber.split("#")[1];
}
