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
    required this.mistakes,
    required this.isStated,
  });
  final double maxHieght;
  final int page;
  final bool isStated;
  final List<Word> words;
  final List<Mistake> mistakes;
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
            style: TextStyle(
              fontFamily: 'page$page',
              fontSize: 100,
              height: 0,
              letterSpacing: 5,
              color: Colors.black,
            ),
            children: words
                .map(
                  (word) {
                    if (word is NormalWord) {
                      final mistake = mistakes
                          .where((element) => element.idWord == word.id);
                      return WidgetSpan(
                        child: SpanWord(
                          word: word,
                          page: page,
                          enable: isStated,
                          mistakes: mistake.toList(),
                          onMistake: onMistake,
                        ),
                      );
                    } else {
                      return WidgetSpan(
                        child: SpanWord(
                          mistakes: const [],
                          word: word,
                          enable: false,
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
