import 'package:al_khalil/app/utils/widgets/cell.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/features/quran/domain/models/quran.dart';
import 'package:al_khalil/features/quran/widgets/span_word.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/mistake.dart';

class MisakePopUp extends StatefulWidget {
  const MisakePopUp({
    super.key,
    required this.word,
    required this.oldMistakes,
    required this.page,
  });
  final Word word;
  final int page;
  final List<Mistake> oldMistakes;

  @override
  State<MisakePopUp> createState() => _MisakePopUpState();
}

class _MisakePopUpState extends State<MisakePopUp> {
  late List<String> chars = removeHarakat(widget.word.text).split("");

  getSpan(Mistake mistake) {
    List<TextSpan> textSpans = [];
    if (mistake.isFoget) {
      return [const TextSpan(text: "ــــــــــــــــ")];
    }
    for (int i = 0; i < chars.length; i++) {
      if (i == mistake.pos) {
        textSpans.add(
          TextSpan(
            text: chars[i],
            style: TextStyle(
              color: getMistakeColor(mistake.type!),
              fontSize: 18,
            ),
          ),
        );
      } else {
        textSpans.add(
          TextSpan(
            text: chars[i],
            style: const TextStyle(fontSize: 18),
          ),
        ); // Or your default color
      }
    }
    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              text: "﴿ ",
              style: GoogleFonts.scheherazadeNew().copyWith(
                  fontSize: 30,
                  color: Theme.of(context).textTheme.bodyLarge!.color),
              children: [
                TextSpan(
                  text: widget.word.codeV1,
                  style: TextStyle(
                    fontFamily: 'page${widget.page}',
                    fontSize: 30,
                  ),
                ),
                const TextSpan(text: "﴾"),
              ],
            ),
          ),
          const Row(
            children: [
              MyCell(
                text: "نوع الخطأ",
                flex: 6,
              ),
              MyCell(
                text: "الموضع",
                flex: 6,
              ),
            ],
          ),
          ...widget.oldMistakes.map(
            (e) => Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.1,
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  MyCell(
                    text: Mistake.mistakes[e.type! - 1],
                    flex: 6,
                  ),
                  // MyCell(
                  //   text: e.pos?.toString(),
                  //   flex: 6,
                  // ),
                  Expanded(
                    flex: 6,
                    child: RichText(
                      text: TextSpan(
                        children: getSpan(e),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          5.getHightSizedBox,
        ],
      ),
    );
  }

  Color? getMistakeColor(int type) {
    return switch (type) {
      Mistake.tashkelMistake => tashkelColor,
      Mistake.testTashkelMistake => tashkelColor,
      Mistake.testTashkelSelfCorrectionMistake => tashkelColor,
      Mistake.forgetMistake => forgetColor,
      Mistake.testForgetMistake => forgetColor,
      Mistake.testForgetSelfCorrectionMistake => forgetColor,
      Mistake.tajweedMistake => tajweedColor,
      Mistake.testTajweedMistake => tajweedColor,
      Mistake.testTajweedSelfCorrectionMistake => tajweedColor,
      int() => null,
    };
  }
}
