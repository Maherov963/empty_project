import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'intl_phone_plugin/field.dart';

class MyPhoneField extends StatefulWidget {
  final String labelText;
  final bool enabled;
  final bool isRequired;
  final bool enableSearch;
  final List<PhoneNumber> data;
  final void Function(String)? onSelected;
  final void Function(String)? onChanged;
  final void Function(bool)? onTap;
  final String? initVal;
  final Widget? preIcon;

  const MyPhoneField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.enableSearch = false,
    this.onChanged,
    this.isRequired = false,
    this.data = const [],
    this.initVal,
    this.preIcon,
    this.onSelected,
    this.onTap,
  });

  @override
  State<MyPhoneField> createState() => _MyPhoneFieldState();
}

class _MyPhoneFieldState extends State<MyPhoneField> {
  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: CustomAutocomplete<String>(
          initialValue: TextEditingValue(text: widget.initVal ?? ""),
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) =>
                  IntlPhoneField(
            initialCountryCode: "SY",
            languageCode: "ar",
            enabled: widget.enabled,
            focusNode: focusNode,
            controller: textEditingController,
            initialValue: widget.initVal,
            isRequired: widget.isRequired,
            disableLengthCheck:
                !widget.isRequired && textEditingController.text.isEmpty,
            onChanged: (phone) => widget.onChanged?.call(phone.completeNumber),
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
          ),
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 200,
                      maxWidth: MediaQuery.of(context).size.width / 1.2),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(PhoneNumber.getHashedNumber(option));
                        },
                        child: Builder(builder: (BuildContext context) {
                          final bool highlight =
                              AutocompleteHighlightedOption.of(context) ==
                                  index;
                          if (highlight) {
                            SchedulerBinding.instance
                                .addPostFrameCallback((Duration timeStamp) {
                              Scrollable.ensureVisible(context, alignment: 0.5);
                            });
                          }
                          return Container(
                            color:
                                highlight ? Theme.of(context).focusColor : null,
                            padding: const EdgeInsets.all(16.0),
                            child: Text(PhoneNumber.getHashedName(option)),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          onSelected: widget.onSelected,
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return widget.data.map((e) => e.getHash).toList();
            }
            List<String>? matches = widget.data
                .where(
                    (element) => element.number.contains(textEditingValue.text))
                .map((e) => e.getHash)
                .toList();
            return matches;
          },
        ),
      );
    }
    return Row(
      children: [
        Expanded(
            child: Directionality(
          textDirection: TextDirection.ltr,
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: widget.initVal ?? ""));
              CustomToast.showToast(CustomToast.copySuccsed);
            },
            child: CustomAutocomplete<String>(
              initialValue: TextEditingValue(text: widget.initVal ?? ""),
              fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) =>
                  IntlPhoneField(
                initialCountryCode: "SY",
                languageCode: "ar",
                enabled: widget.enabled,
                focusNode: focusNode,
                controller: textEditingController,
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
              optionsViewBuilder: (context, onSelected, options) => Align(
                alignment: Alignment.topLeft,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Material(
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: 200,
                          maxWidth: MediaQuery.of(context).size.width / 1.2),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final option = options.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(PhoneNumber.getHashedNumber(option));
                            },
                            child: Builder(builder: (BuildContext context) {
                              final bool highlight =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;
                              if (highlight) {
                                SchedulerBinding.instance
                                    .addPostFrameCallback((Duration timeStamp) {
                                  Scrollable.ensureVisible(context,
                                      alignment: 0.5);
                                });
                              }
                              return Container(
                                color: highlight
                                    ? Theme.of(context).focusColor
                                    : null,
                                padding: const EdgeInsets.all(16.0),
                                child: Text(PhoneNumber.getHashedName(option)),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              onSelected: widget.onSelected,
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return widget.data.map((e) => e.getHash).toList();
                }
                List<String>? matches = widget.data
                    .where((element) =>
                        element.number.contains(textEditingValue.text))
                    .map((e) => e.getHash)
                    .toList();
                return matches;
              },
            ),
          ),
        )),
        IconButton(
          onPressed: () => widget.onTap?.call(false),
          icon: Icon(FontAwesomeIcons.whatsapp,
              color: Theme.of(context).colorScheme.primary),
        ),
        IconButton(
          onPressed: () => widget.onTap?.call(true),
          icon: const Icon(Icons.phone),
        ),
        if (!widget.enabled && widget.preIcon != null) widget.preIcon!,
      ],
    );
  }
}

class CustomAutocomplete<T extends Object> extends StatelessWidget {
  /// Creates an instance of [CustomAutocomplete].
  const CustomAutocomplete({
    super.key,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    required this.fieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.initialValue,
  });

  /// {@macro flutter.widgets.RawAutocomplete.displayStringForOption}
  final AutocompleteOptionToString<T> displayStringForOption;

  /// {@macro flutter.widgets.RawAutocomplete.fieldViewBuilder}
  ///
  /// If not provided, will build a standard Material-style text field by
  /// default.
  final AutocompleteFieldViewBuilder fieldViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.onSelected}
  final AutocompleteOnSelected<T>? onSelected;

  /// {@macro flutter.widgets.RawAutocomplete.optionsBuilder}
  final AutocompleteOptionsBuilder<T> optionsBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.optionsViewBuilder}
  ///
  /// If not provided, will build a standard Material-style list of results by
  /// default.
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;

  /// {@macro flutter.widgets.RawAutocomplete.optionsViewOpenDirection}
  final OptionsViewOpenDirection optionsViewOpenDirection;

  /// The maximum height used for the default Material options list widget.
  ///
  /// When [optionsViewBuilder] is `null`, this property sets the maximum height
  /// that the options widget can occupy.
  ///
  /// The default value is set to 200.
  final double optionsMaxHeight;

  /// {@macro flutter.widgets.RawAutocomplete.initialValue}
  final TextEditingValue? initialValue;

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: fieldViewBuilder,
      initialValue: initialValue,
      optionsBuilder: optionsBuilder,
      optionsViewOpenDirection: optionsViewOpenDirection,
      optionsViewBuilder: optionsViewBuilder ??
          (BuildContext context, AutocompleteOnSelected<T> onSelected,
              Iterable<T> options) {
            return _AutocompleteOptions<T>(
              displayStringForOption: displayStringForOption,
              onSelected: onSelected,
              options: options,
              maxOptionsHeight: optionsMaxHeight,
            );
          },
      onSelected: onSelected,
    );
  }
}

// The default Material-style Autocomplete options.
class _AutocompleteOptions<T extends Object> extends StatelessWidget {
  const _AutocompleteOptions({
    super.key,
    required this.displayStringForOption,
    required this.onSelected,
    required this.options,
    required this.maxOptionsHeight,
  });

  final AutocompleteOptionToString<T> displayStringForOption;

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsHeight;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxOptionsHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);
              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(displayStringForOption(option)),
                  );
                }),
              );
            },
          ),
        ),
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
