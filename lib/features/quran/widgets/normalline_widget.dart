import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/material.dart';
import '../domain/models/mistake.dart';
import '../domain/models/quran.dart';
import 'span_word.dart';

class NormalLineWidget extends StatelessWidget {
  const NormalLineWidget({
    super.key,
    required this.maxHieght,
    required this.page,
    required this.words,
    required this.onMistake,
    required this.oldMistakes,
    required this.pageState,
    required this.reciting,
    required this.test,
  });
  final double maxHieght;
  final int page;
  final Reciting? reciting;
  final QuranTest? test;
  final PageState pageState;
  final List<Word> words;
  final List<Mistake> oldMistakes;
  final Function(int, List<Mistake>) onMistake;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: maxHieght,
      child: FittedBox(
        child: RichText(
          textDirection: TextDirection.rtl,
          text: TextSpan(
            children: words
                .map(
                  (word) {
                    if (word is NormalWord) {
                      final mistake = oldMistakes
                          .where((element) => element.wordId == word.id);
                      return WidgetSpan(
                        child: SpanWord(
                          reciting: reciting,
                          word: word,
                          page: page,
                          test: test,
                          pageState: pageState,
                          oldMistakes: mistake.toList(),
                          onMistake: onMistake,
                        ),
                      );
                    } else {
                      return WidgetSpan(
                        child: SpanWord(
                          reciting: null,
                          test: null,
                          oldMistakes: const [],
                          word: word,
                          pageState: PageState.nothing,
                          page: page,
                        ),
                      );
                    }
                  },
                )
                .toList()
                .reversed
                .toList(),
          ),
        ),
      ),
    );
  }
}
