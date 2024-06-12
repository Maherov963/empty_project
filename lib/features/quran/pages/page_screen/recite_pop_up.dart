import 'package:al_khalil/app/utils/messges/toast.dart';
import 'package:al_khalil/app/utils/widgets/my_text_button.dart';
import 'package:al_khalil/app/utils/widgets/widgets.dart';
import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/features/quran/domain/models/quran.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/mistake.dart';
import '../../widgets/span_word.dart';

class RecitePopUp extends StatefulWidget {
  const RecitePopUp({
    Key? key,
    required this.word,
    required this.mistakes,
    required this.page,
    required this.onMistake,
  }) : super(key: key);
  final Word word;
  final int page;
  final List<Mistake> mistakes;
  final Function(int, List<Mistake>) onMistake;

  @override
  State<RecitePopUp> createState() => _RecitePopUpState();
}

class _RecitePopUpState extends State<RecitePopUp> {
  late List<String> chars = removeHarakat(widget.word.text).split("");
  late final list = List.generate(
      widget.mistakes.length, (index) => widget.mistakes[index].copy());
  @override
  Widget build(BuildContext context) {
    final hasTajweedMistake = list
        .where((element) => element.type == Mistake.tajweedMistake)
        .isNotEmpty;
    final hasTashkelMistake = list
        .where((element) => element.type == Mistake.tashkelMistake)
        .isNotEmpty;
    final hasForgetMistake = list
        .where((element) => element.type == Mistake.forgetMistake)
        .isNotEmpty;
    return Column(
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
        MyCheckBox(
          text: 'خطأ حفظي',
          val: hasForgetMistake,
          color: forgetColor,
          onChanged: (val) {
            setState(() {
              if (hasForgetMistake) {
                list.removeWhere(
                    (element) => element.type == Mistake.forgetMistake);
              } else {
                list.add(Mistake(
                    wordId: widget.word.id, type: Mistake.forgetMistake));
              }
            });
          },
        ),
        MyCheckBox(
          text: 'خطأ تشكيلي',
          val: hasTashkelMistake,
          color: tashkelColor,
          subtitle: !hasTashkelMistake
              ? null
              : CupertinoSlidingSegmentedControl<int?>(
                  children: chars
                      .map((e) => Text(
                            e,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      .toList()
                      .asMap(),
                  groupValue: list
                      .where(
                          (element) => element.type == Mistake.tashkelMistake)
                      .first
                      .pos,
                  onValueChanged: (value) {
                    setState(() {
                      list
                          .where((element) =>
                              element.type == Mistake.tashkelMistake)
                          .first
                          .pos = value;
                    });
                  },
                ),
          onChanged: (val) {
            setState(() {
              if (hasTashkelMistake) {
                list.removeWhere(
                    (element) => element.type == Mistake.tashkelMistake);
              } else {
                list.add(Mistake(
                    wordId: widget.word.id, type: Mistake.tashkelMistake));
              }
            });
          },
        ),
        MyCheckBox(
          text: 'خطأ تجويدي',
          val: hasTajweedMistake,
          color: tajweedColor,
          subtitle: !hasTajweedMistake
              ? null
              : CupertinoSlidingSegmentedControl<int?>(
                  children: chars
                      .map((e) => Text(
                            e,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      .toList()
                      .asMap(),
                  groupValue: list
                      .where(
                          (element) => element.type == Mistake.tajweedMistake)
                      .first
                      .pos,
                  onValueChanged: (value) {
                    setState(() {
                      list
                          .where((element) =>
                              element.type == Mistake.tajweedMistake)
                          .first
                          .pos = value;
                    });
                  },
                ),
          onChanged: (val) {
            setState(() {
              if (hasTajweedMistake) {
                list.removeWhere(
                    (element) => element.type == Mistake.tajweedMistake);
              } else {
                list.add(Mistake(
                    wordId: widget.word.id, type: Mistake.tajweedMistake));
              }
            });
          },
        ),
        CustomTextButton(
          onPressed: () {
            if (hasTashkelMistake &&
                list
                        .where(
                            (element) => element.type == Mistake.tashkelMistake)
                        .first
                        .pos ==
                    null) {
              CustomToast.showToast(
                  "الرجاء اختيار موقع الخطأ التشكيلي في الكلمة");
            } else if (hasTajweedMistake &&
                list
                        .where(
                            (element) => element.type == Mistake.tajweedMistake)
                        .first
                        .pos ==
                    null) {
              CustomToast.showToast(
                  "الرجاء اختيار موقع الخطأ التجويدي في الكلمة");
            } else {
              widget.onMistake.call(widget.word.id, list);
              Navigator.pop(context);
            }
          },
          color: Theme.of(context).colorScheme.tertiary,
          text: "حفظ",
        ),
        5.getHightSizedBox,
      ],
    );
  }
}
