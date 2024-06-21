import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';

class MyButtonMenu extends StatelessWidget {
  const MyButtonMenu({
    super.key,
    this.onTap,
    this.enabled = true,
    required this.title,
    required this.value,
    this.onTapValue,
  });
  final Function()? onTap;
  final Function()? onTapValue;
  final String title;
  final String? value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: theme.hoverColor,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            if (value != null)
              GestureDetector(
                onTap: onTapValue,
                child: Text(
                  value!,
                  style: TextStyle(
                    fontSize: 18,
                    color: onTapValue != null
                        ? theme.colorScheme.tertiary
                        : !enabled
                            ? theme.disabledColor
                            : null,
                  ),
                ),
              ),
            10.getWidthSizedBox,
            Icon(Icons.arrow_drop_down,
                color: !enabled ? theme.disabledColor : null),
          ],
        ),
      ),
    );
  }
}
