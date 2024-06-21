import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'intl_phone_plugin/field.dart';

class MyPhoneField extends StatefulWidget {
  final String labelText;
  final bool enabled;
  final bool isRequired;
  final void Function(String)? onChanged;
  final void Function(bool)? onTap;
  final String? initVal;
  final Widget? preIcon;

  const MyPhoneField({
    super.key,
    required this.labelText,
    this.enabled = true,
    this.onChanged,
    this.isRequired = false,
    this.initVal,
    this.preIcon,
    this.onTap,
  });

  @override
  State<MyPhoneField> createState() => _MyPhoneFieldState();
}

class _MyPhoneFieldState extends State<MyPhoneField> {
  late TextEditingController controller =
      TextEditingController(text: widget.initVal);
  @override
  Widget build(BuildContext context) {
    final textField = Directionality(
      textDirection: TextDirection.ltr,
      child: IntlPhoneField(
        initialCountryCode: "SY",
        languageCode: "ar",
        enabled: widget.enabled,
        initialValue: widget.initVal,
        isRequired: widget.isRequired,
        disableLengthCheck: !widget.isRequired,
        onChanged: (phone) => widget.onChanged?.call(phone.completeNumber),
        decoration: InputDecoration(
          suffixIcon: !widget.enabled
              ? null
              : IconButton(
                  onPressed: () => widget.onTap?.call(false),
                  icon: Icon(FontAwesomeIcons.whatsapp,
                      color: Theme.of(context).colorScheme.primary),
                ),
          labelText: widget.labelText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          border: const OutlineInputBorder(),
        ),
      ),
    );

    if (widget.enabled) {
      return textField;
    }
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: widget.initVal ?? ""));
              CustomToast.showToast(CustomToast.copySuccsed);
            },
            child: textField,
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
        if (!widget.enabled && widget.preIcon != null) widget.preIcon!,
      ],
    );
  }
}
