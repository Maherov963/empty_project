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
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(5)),
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
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      body ?? "لا يوجد معلومات",
                      style: TextStyle(
                        color: body != null
                            ? null
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ]),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
