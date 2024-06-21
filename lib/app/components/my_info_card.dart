import 'package:flutter/material.dart';

class MyInfoCard extends StatelessWidget {
  final String head;
  final String? body;
  final Widget? child;
  final CrossAxisAlignment crossAxisAlignment;
  const MyInfoCard({
    super.key,
    required this.body,
    required this.head,
    this.child,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).hoverColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: crossAxisAlignment,
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
