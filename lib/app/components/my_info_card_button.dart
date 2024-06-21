import 'package:flutter/material.dart';

class MyInfoCardButton extends StatelessWidget {
  const MyInfoCardButton({
    super.key,
    this.name,
    this.onPressed,
    required this.head,
  });
  final String? name;
  final String head;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.hoverColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            head,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(
              name ?? "لا يوجد معلومات",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: name == null
                    ? theme.colorScheme.error
                    : theme.colorScheme.tertiary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
