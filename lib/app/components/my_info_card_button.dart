import 'package:al_khalil/app/components/waiting_animation.dart';
import 'package:flutter/material.dart';

class MyInfoCardButton extends StatelessWidget {
  const MyInfoCardButton(
      {super.key, this.name, this.onPressed, required this.head});
  final String? name;
  final String head;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        // border: Border.all(color: Theme.of(context).highlightColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            head,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (name == null)
            Text(
              "لا يوجد معلومات",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (name != null)
            TextButton(
              onPressed: onPressed,
              child: onPressed == null
                  ? const MyWaitingAnimation()
                  : Text(
                      "$name",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
            )
        ],
      ),
    );
  }
}
