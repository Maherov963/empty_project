import 'package:flutter/material.dart';

class MyInfoCard extends StatelessWidget {
  final String head;
  final String? body;
  final Widget? child;
  const MyInfoCard({
    super.key,
    required this.body,
    required this.head,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    head,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  body == null || body == ""
                      ? Text(
                          "لا يوجد معلومات كافية",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                        )
                      : Text(body!),
                ]),
          ),
          child == null ? const SizedBox.shrink() : child!,
        ],
      ),
    );
  }
}
