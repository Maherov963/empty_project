import 'package:flutter/material.dart';

class MyInfoCard extends StatelessWidget {
  final String head;
  final String? body;
  final Widget? child;
  final Function()? onTap;
  final CrossAxisAlignment crossAxisAlignment;
  const MyInfoCard({
    super.key,
    required this.body,
    required this.head,
    this.child,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.surfaceContainer,
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
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
        ),
      ),
    );
  }
}
