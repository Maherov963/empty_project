import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import 'package:al_khalil/features/quran/domain/plugin/pop_over_menu.dart';
import 'package:flutter/material.dart';
import '../domain/models/quran.dart';
import '../pages/page_screen/custom_pop_up.dart';

class SpanWord extends StatelessWidget {
  const SpanWord({
    super.key,
    required this.word,
    required this.page,
    this.backgrounColor,
    required this.mistakes,
    this.enable = true,
    this.onMistake,
  });
  final Word word;
  final bool enable;
  final List<Mistake> mistakes;
  final Function(int, List<Mistake>)? onMistake;
  final int page;
  final Color? backgrounColor;

  void onLongPress(BuildContext context, LongPressStartDetails details) {
    showPopover(
      offset: details.globalPosition,
      context: context,
      bodyBuilder: (ctx) => CustomPopUp(
        word: word,
        page: page,
        onMistake: onMistake!,
        mistakes: mistakes,
      ),
      direction: PopoverDirection.bottom,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 1.3,
        // maxHeight: 300,
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: !enable
          ? null
          : (details) {
              onLongPress(context, details);
            },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: mistakes.length < 2
                ? null
                : LinearGradient(
                    colors: getMistakeColor,
                  ),
            color: mistakes.length == 1 ? getMistakeColor.first : null),
        margin: const EdgeInsets.all(2),
        child: Text(
          word.codeV1,
          style: TextStyle(
            color: mistakes.isNotEmpty ? Colors.white : Colors.black,
            fontFamily: 'page$page',
            fontSize: 100,
            letterSpacing: 5,
          ),
        ),
      ),
    );
  }

  List<Color> get getMistakeColor {
    final List<Color> colors = [];
    if (mistakes
        .where((element) => element.type == Mistake.forgetMistake)
        .isNotEmpty) {
      colors.add(forgetColor);
    }
    if (mistakes
        .where((element) => element.type == Mistake.tajweedMistake)
        .isNotEmpty) {
      colors.add(tajweedColor);
    }
    if (mistakes
        .where((element) => element.type == Mistake.tashkelMistake)
        .isNotEmpty) {
      colors.add(tashkelColor);
    }
    return colors;
  }
}

const Color forgetColor = Color(0xff45818e);
const Color tajweedColor = Color(0xffbf9000);
const Color tashkelColor = Color(0xffcc4125);
