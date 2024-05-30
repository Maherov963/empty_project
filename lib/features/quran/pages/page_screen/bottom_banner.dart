import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:flutter/material.dart';

class BottomBanner extends StatelessWidget {
  const BottomBanner({
    super.key,
    required this.visable,
    required this.isStarted,
    required this.onSave,
    required this.onStart,
  });
  final bool visable;
  final bool isStarted;
  final Function() onSave;
  final Function() onStart;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, visable ? 0 : 1),
      duration: Durations.short4,
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: !isStarted ? buildStart(context) : buildSave(context),
      ),
    );
  }

  buildStart(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomTextButton(
            text: "ابدأ",
            color: const Color.fromARGB(255, 92, 215, 231),
            onPressed: onStart,
          ),
        ),
      ],
    );
  }

  buildSave(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomTextButton(
            text: "إنهاء",
            color: const Color.fromARGB(255, 230, 91, 137),
            onPressed: onSave,
          ),
        ),
      ],
    );
  }
}
