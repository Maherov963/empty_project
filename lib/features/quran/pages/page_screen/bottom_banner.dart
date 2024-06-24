import 'package:al_khalil/app/utils/messges/sheet.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/material.dart';

class BottomBanner extends StatelessWidget {
  const BottomBanner({
    super.key,
    required this.visable,
    required this.pageState,
    this.reciting,
    this.test,
    required this.reciter,
    required this.onReciteSave,
    required this.onReciteStart,
    this.onReciteDelete,
    required this.onTestSave,
    required this.onTestStart,
    this.onTestDelete,
    required this.reason,
  });

  final Reciting? reciting;
  final QuranTest? test;
  final Person reciter;
  final bool visable;
  final PageState pageState;
  final Function() onReciteSave;
  final Function() onReciteStart;
  final Function()? onReciteDelete;
  final Function() onTestSave;
  final Function() onTestStart;
  final Function()? onTestDelete;
  final PageState reason;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(0, visable ? 0 : 1),
      duration: Durations.short4,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.black.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (reason == PageState.reciting && reciting?.idReciting != null)
              CustomTextButton(
                text: "معلومات",
                color: const Color(0xff57bb8a),
                onPressed: () async {
                  final state = await CustomSheet.showMyBottomSheet(
                    context,
                    (p0) => SaveSheet(
                      reciting: reciting!,
                      reciter: reciter,
                      enable: false,
                    ),
                  );
                  if (state == 1) {
                    onReciteDelete!.call();
                  }
                },
              ),
            if (reason == PageState.reciting && reciting == null)
              CustomTextButton(
                text: "ابدأ",
                color: const Color.fromARGB(255, 92, 215, 231),
                onPressed: onReciteStart,
              ),
            if (pageState == PageState.reciting && reciting != null)
              CustomTextButton(
                text: "إنهاء",
                color: const Color.fromARGB(255, 230, 91, 137),
                onPressed: onReciteSave,
              ),
            if (reason == PageState.testing && test?.idTest != null)
              CustomTextButton(
                text: "معلومات",
                color: const Color(0xff57bb8a),
                onPressed: () async {
                  final state = await CustomSheet.showMyBottomSheet(
                    context,
                    (p0) => TestSaveSheet(
                      quranTest: test!,
                      reciter: reciter,
                      enable: false,
                    ),
                  );
                  if (state == 1) {
                    onTestDelete!.call();
                  }
                },
              ),
            if (reason == PageState.testing && test == null)
              CustomTextButton(
                text: "ابدأ السبر",
                color: const Color.fromARGB(255, 92, 215, 231),
                onPressed: onTestStart,
              ),
            if (pageState == PageState.testing && test != null)
              CustomTextButton(
                text: "إنهاء",
                color: const Color.fromARGB(255, 230, 91, 137),
                onPressed: onTestSave,
              ),
          ],
        ),
      ),
    );
  }
}
