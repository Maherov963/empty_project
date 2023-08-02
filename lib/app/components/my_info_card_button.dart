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
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          head,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        name == null || name == ""
            ? Text(
                "لا يوجد معلومات كافية",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSecondary),
              )
            : TextButton(
                onPressed: onPressed,
                child: onPressed == null
                    ? const MyWaitingAnimation()
                    : Text(
                        "$name",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
              )
      ]),
    );
  }
}
