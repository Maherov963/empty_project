import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/intl_phone_plugin/field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'intl_phone_plugin/countries.dart';

class MyAutoCompleteNumber extends StatefulWidget {
  final void Function(String)? onChanged;
  final bool isRequired;
  final String? initVal;
  final List<PhoneNumber>? data;
  final void Function(bool)? onTap;

  final bool enabled;
  final bool enableSearch;
  final void Function(PhoneNumber)? onSelected;
  final String labelText;

  const MyAutoCompleteNumber({
    super.key,
    this.onSelected,
    this.onChanged,
    this.initVal,
    this.data,
    required this.enabled,
    required this.enableSearch,
    required this.isRequired,
    required this.labelText,
    this.onTap,
  });

  @override
  State<MyAutoCompleteNumber> createState() => _MyAutoCompleteNumberState();
}

class _MyAutoCompleteNumberState extends State<MyAutoCompleteNumber> {
  late List<Country> filteredCountries;
  late String number;
  String? validatorMessage;
  late TextEditingController textEditingController =
      TextEditingController(text: widget.initVal);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.enabled) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: TypeAheadField<PhoneNumber>(
          controller: textEditingController,
          decorationBuilder: (context, child) {
            return Material(
              type: MaterialType.card,
              elevation: 4,
              color: theme.colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(15),
              child: child,
            );
          },
          builder: (context, controller, focusNode) {
            return IntlPhoneField(
              initialCountryCode: "SY",
              languageCode: "ar",
              enabled: widget.enabled,
              focusNode: focusNode,
              controller: controller,
              initialValue: widget.initVal,
              isRequired: widget.isRequired,
              disableLengthCheck:
                  !widget.isRequired && textEditingController.text.isEmpty,
              onChanged: (phone) =>
                  widget.onChanged?.call(phone.completeNumber),
              decoration: InputDecoration(
                enabled: true,
                suffixIcon: IconButton(
                  onPressed: () => widget.onTap?.call(false),
                  icon: Icon(FontAwesomeIcons.whatsapp,
                      color: Theme.of(context).colorScheme.primary),
                ),
                labelText: widget.labelText,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: const OutlineInputBorder(),
              ),
            );
          },
          hideOnLoading: true,
          onSelected: (value) {
            textEditingController.text = value.number;
            widget.onSelected?.call(value);
          },
          itemBuilder: (context, value) {
            return CupertinoListTile(
              // onTap: () {
              //   textEditingController.text = value.number;
              //   widget.onSelected?.call(value);
              // },
              title: Text(
                value.name,
                style: theme.textTheme.bodyMedium,
              ),
            );
          },
          suggestionsCallback: (pattern) {
            if (pattern.isEmpty) {
              return widget.data;
            }
            List<PhoneNumber>? matches = widget.data
                ?.where((element) => element.name.contains(pattern))
                .toList();
            return matches ?? [];
          },
          hideOnEmpty: true,
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: widget.initVal ?? ""));
              CustomToast.showToast(CustomToast.copySuccsed);
            },
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: IntlPhoneField(
                initialCountryCode: "SY",
                languageCode: "ar",
                enabled: widget.enabled,
                initialValue: widget.initVal,
                isRequired: widget.isRequired,
                disableLengthCheck:
                    !widget.isRequired && textEditingController.text.isEmpty,
                onChanged: (phone) =>
                    widget.onChanged?.call(phone.completeNumber),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => widget.onTap?.call(false),
          icon: Icon(FontAwesomeIcons.whatsapp,
              color: Theme.of(context).colorScheme.primary),
        ),
        IconButton(
          onPressed: () => widget.onTap?.call(true),
          icon: const Icon(Icons.phone),
        ),
      ],
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
