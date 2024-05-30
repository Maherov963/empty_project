import 'package:al_khalil/data/extensions/extension.dart';
import 'package:flutter/material.dart';

class MyButtonMenu extends StatelessWidget {
  const MyButtonMenu({
    super.key,
    this.onTap,
    this.enabled = true,
    required this.title,
    required this.value,
  });
  final Function()? onTap;
  final String title;
  final String? value;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border:
              Border.all(color: !enabled ? theme.disabledColor : Colors.grey),
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
              Text(
                value!,
                style: TextStyle(
                    fontSize: 18, color: !enabled ? theme.disabledColor : null),
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
