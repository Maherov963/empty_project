import 'package:al_khalil/app/router/router.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/pages/page_screen/help_screen.dart';
import 'package:flutter/material.dart';

class UpperBanner extends StatelessWidget {
  const UpperBanner({
    super.key,
    required this.visable,
    required this.title,
    this.memorization,
    required this.pageId,
  });

  final bool visable;
  final String? title;
  final int pageId;
  final Memorization? memorization;

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
              Expanded(
                child: Text(
                  title ?? "المصحف الشريف",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.myPush(const HelpScreen());
                },
                icon: const Icon(Icons.help_outline_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
