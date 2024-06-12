import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import 'package:al_khalil/features/quran/domain/plugin/pop_over_menu.dart';
import 'package:al_khalil/features/quran/pages/page_screen/mistakes_pop_up.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:al_khalil/features/quran/pages/page_screen/test_pop_up.dart';
import 'package:flutter/material.dart';
import '../domain/models/quran.dart';
import '../pages/page_screen/recite_pop_up.dart';

class SpanWord extends StatelessWidget {
  final Word word;
  final PageState pageState;
  final Reciting? reciting;
  final QuranTest? test;
  final List<Mistake> oldMistakes;
  final Function(int, List<Mistake>)? onMistake;
  final int page;
  final Color? backgrounColor;

  const SpanWord({
    super.key,
    required this.word,
    required this.page,
    this.backgrounColor,
    required this.oldMistakes,
    required this.reciting,
    required this.pageState,
    this.onMistake,
    required this.test,
  });

  void onLongPress(BuildContext context, LongPressStartDetails details) {
    showPopover(
      offset: details.globalPosition,
      context: context,
      bodyBuilder: (ctx) => pageState == PageState.reciting
          ? RecitePopUp(
              word: word,
              page: page,
              onMistake: onMistake!,
              mistakes: (reciting?.mistakes ?? [])
                  .where((element) => element.wordId == word.id)
                  .toList(),
            )
          : TestPopUp(
              word: word,
              page: page,
              onMistake: onMistake!,
              mistakes: (test?.mistakes ?? [])
                  .where((element) => element.wordId == word.id)
                  .toList(),
            ),
      direction: PopoverDirection.bottom,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.3,
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }

  void onTap(BuildContext context, TapUpDetails details) {
    showPopover(
      offset: details.globalPosition,
      context: context,
      bodyBuilder: (ctx) => MisakePopUp(
        word: word,
        page: page,
        oldMistakes: oldMistakes,
      ),
      direction: PopoverDirection.bottom,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.3,
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = getMistakeColor;
    return GestureDetector(
      onTapUp: oldMistakes.isEmpty
          ? null
          : (details) {
              onTap(context, details);
            },
      onLongPressStart: pageState == PageState.nothing
          ? null
          : (details) {
              onLongPress(context, details);
            },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: colors.length < 2
              ? null
              : LinearGradient(
                  colors: colors,
                ),
          color: colors.length == 1 ? colors.first : null,
        ),
        margin: const EdgeInsets.all(2),
        child: Text(
          word.codeV1,
          style: TextStyle(
            color: colors.isNotEmpty ? Colors.white : Colors.black,
            fontFamily: 'page$page',
            fontSize: 100,
            letterSpacing: 5,
          ),
        ),
      ),
    );
  }

  List<Color> get getMistakeColor {
    final mistakes = pageState == PageState.reciting
        ? (reciting?.mistakes ?? [])
            .where((element) => element.wordId == word.id)
        : (test?.mistakes ?? []).where((element) => element.wordId == word.id);
    final oldMistake =
        oldMistakes.where((element) => element.wordId == word.id);
    final List<Color> colors = [];

    if (mistakes
        .where((element) =>
            element.type == Mistake.forgetMistake ||
            element.type == Mistake.testForgetMistake ||
            element.type == Mistake.testForgetSelfCorrectionMistake)
        .isNotEmpty) {
      colors.add(forgetColor);
    } else if (oldMistake
        .where((element) =>
            element.type == Mistake.forgetMistake ||
            element.type == Mistake.testForgetMistake ||
            element.type == Mistake.testForgetSelfCorrectionMistake)
        .isNotEmpty) {
      colors.add(pageState != PageState.nothing
          ? forgetColor.withOpacity(0.4)
          : forgetColor);
    }

    if (mistakes
        .where((element) =>
            element.type == Mistake.tajweedMistake ||
            element.type == Mistake.testTajweedMistake ||
            element.type == Mistake.testTajweedSelfCorrectionMistake)
        .isNotEmpty) {
      colors.add(tajweedColor);
    } else if (oldMistake
        .where((element) =>
            element.type == Mistake.tajweedMistake ||
            element.type == Mistake.testTajweedMistake ||
            element.type == Mistake.testTajweedSelfCorrectionMistake)
        .isNotEmpty) {
      colors.add(pageState != PageState.nothing
          ? tajweedColor.withOpacity(0.4)
          : tajweedColor);
    }

    if (mistakes
        .where((element) =>
            element.type == Mistake.tashkelMistake ||
            element.type == Mistake.testTashkelMistake ||
            element.type == Mistake.testTashkelSelfCorrectionMistake)
        .isNotEmpty) {
      colors.add(tashkelColor);
    } else if (oldMistake
        .where((element) =>
            element.type == Mistake.tashkelMistake ||
            element.type == Mistake.testTashkelMistake ||
            element.type == Mistake.testTashkelSelfCorrectionMistake)
        .isNotEmpty) {
      colors.add(pageState != PageState.nothing
          ? tashkelColor.withOpacity(0.4)
          : tashkelColor);
    }

    return colors;
  }
}

const Color forgetColor = Color(0xff45818e);
const Color tajweedColor = Color(0xffbf9000);
const Color tashkelColor = Color(0xffcc4125);
