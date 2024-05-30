import 'package:flutter/material.dart';

class UpperBanner extends StatelessWidget {
  const UpperBanner({super.key, required this.visable});
  final bool visable;
  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, visable ? 0 : -1),
      duration: Durations.short4,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: SafeArea(
          child: Row(
            children: [
              const BackButton(color: Colors.white),
              Text(
                "عبد الرحمن عثمان",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
