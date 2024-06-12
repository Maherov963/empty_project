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

class TestPopUp extends StatefulWidget {
  const TestPopUp({
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
  State<TestPopUp> createState() => _TestPopUpState();
}

class _TestPopUpState extends State<TestPopUp> {
  late List<String> chars = removeHarakat(widget.word.text).split("");
  late final list = List.generate(
      widget.mistakes.length, (index) => widget.mistakes[index].copy());
  @override
  Widget build(BuildContext context) {
    final hastestTashkelSelfCorrection = list
        .where((element) =>
            element.type == Mistake.testTashkelSelfCorrectionMistake)
        .isNotEmpty;

    final hastestForgetSelfCorrection = list
        .where((element) =>
            element.type == Mistake.testForgetSelfCorrectionMistake)
        .isNotEmpty;

    final hastestTajweedSelfCorrection = list
        .where((element) =>
            element.type == Mistake.testTajweedSelfCorrectionMistake)
        .isNotEmpty;

    final hastestTashkel = list
        .where((element) => element.type == Mistake.testTashkelMistake)
        .isNotEmpty;

    final hastestForget = list
        .where((element) => element.type == Mistake.testForgetMistake)
        .isNotEmpty;

    final hastestTajweed = list
        .where((element) => element.type == Mistake.testTajweedMistake)
        .isNotEmpty;

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
          MyCheckBox(
            text: Mistake.testForgetSelfCorrection,
            val: hastestForgetSelfCorrection,
            color: forgetColor,
            leading: const Icon(Icons.done),
            onChanged: (val) {
              setState(() {
                if (hastestForget) {
                  list.removeWhere(
                      (element) => element.type == Mistake.testForgetMistake);
                }
                if (hastestForgetSelfCorrection) {
                  list.removeWhere((element) =>
                      element.type == Mistake.testForgetSelfCorrectionMistake);
                } else {
                  list.add(Mistake(
                      wordId: widget.word.id,
                      type: Mistake.testForgetSelfCorrectionMistake));
                }
              });
            },
          ),
          MyCheckBox(
            text: Mistake.testForget,
            val: hastestForget,
            leading: const Icon(Icons.close),
            color: forgetColor,
            onChanged: (val) {
              setState(() {
                if (hastestForgetSelfCorrection) {
                  list.removeWhere((element) =>
                      element.type == Mistake.testForgetSelfCorrectionMistake);
                }
                if (hastestForget) {
                  list.removeWhere(
                      (element) => element.type == Mistake.testForgetMistake);
                } else {
                  list.add(Mistake(
                      wordId: widget.word.id, type: Mistake.testForgetMistake));
                }
              });
            },
          ),
          MyCheckBox(
            text: Mistake.testTashkelSelfCorrection,
            val: hastestTashkelSelfCorrection,
            color: tashkelColor,
            leading: const Icon(Icons.done),
            subtitle: !hastestTashkelSelfCorrection
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
                        .where((element) =>
                            element.type ==
                            Mistake.testTashkelSelfCorrectionMistake)
                        .first
                        .pos,
                    onValueChanged: (value) {
                      setState(() {
                        list
                            .where((element) =>
                                element.type ==
                                Mistake.testTashkelSelfCorrectionMistake)
                            .first
                            .pos = value;
                      });
                    },
                  ),
            onChanged: (val) {
              setState(() {
                if (hastestTashkel) {
                  list.removeWhere(
                      (element) => element.type == Mistake.testTashkelMistake);
                }
                if (hastestTashkelSelfCorrection) {
                  list.removeWhere(
                    (element) =>
                        element.type ==
                        Mistake.testTashkelSelfCorrectionMistake,
                  );
                } else {
                  list.add(
                    Mistake(
                      wordId: widget.word.id,
                      type: Mistake.testTashkelSelfCorrectionMistake,
                    ),
                  );
                }
              });
            },
          ),
          MyCheckBox(
            text: Mistake.testTashkel,
            val: hastestTashkel,
            color: tashkelColor,
            leading: const Icon(Icons.close),
            subtitle: !hastestTashkel
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
                        .where((element) =>
                            element.type == Mistake.testTashkelMistake)
                        .first
                        .pos,
                    onValueChanged: (value) {
                      setState(() {
                        list
                            .where((element) =>
                                element.type == Mistake.testTashkelMistake)
                            .first
                            .pos = value;
                      });
                    },
                  ),
            onChanged: (val) {
              setState(() {
                if (hastestTashkelSelfCorrection) {
                  list.removeWhere((element) =>
                      element.type == Mistake.testTashkelSelfCorrectionMistake);
                }
                if (hastestTashkel) {
                  list.removeWhere(
                      (element) => element.type == Mistake.testTashkelMistake);
                } else {
                  list.add(Mistake(
                      wordId: widget.word.id,
                      type: Mistake.testTashkelMistake));
                }
              });
            },
          ),
          MyCheckBox(
            text: Mistake.testTajweedSelfCorrection,
            val: hastestTajweedSelfCorrection,
            color: tajweedColor,
            leading: const Icon(Icons.done),
            subtitle: !hastestTajweedSelfCorrection
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
                        .where((element) =>
                            element.type ==
                            Mistake.testTajweedSelfCorrectionMistake)
                        .first
                        .pos,
                    onValueChanged: (value) {
                      setState(() {
                        list
                            .where((element) =>
                                element.type ==
                                Mistake.testTajweedSelfCorrectionMistake)
                            .first
                            .pos = value;
                      });
                    },
                  ),
            onChanged: (val) {
              setState(() {
                if (hastestTajweed) {
                  list.removeWhere(
                      (element) => element.type == Mistake.testTajweedMistake);
                }
                if (hastestTajweedSelfCorrection) {
                  list.removeWhere((element) =>
                      element.type == Mistake.testTajweedSelfCorrectionMistake);
                } else {
                  list.add(Mistake(
                      wordId: widget.word.id,
                      type: Mistake.testTajweedSelfCorrectionMistake));
                }
              });
            },
          ),
          MyCheckBox(
            text: Mistake.testTajweed,
            val: hastestTajweed,
            color: tajweedColor,
            leading: const Icon(Icons.close),
            subtitle: !hastestTajweed
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
                        .where((element) =>
                            element.type == Mistake.testTajweedMistake)
                        .first
                        .pos,
                    onValueChanged: (value) {
                      setState(() {
                        list
                            .where((element) =>
                                element.type == Mistake.testTajweedMistake)
                            .first
                            .pos = value;
                      });
                    },
                  ),
            onChanged: (val) {
              setState(() {
                if (hastestTajweedSelfCorrection) {
                  list.removeWhere((element) =>
                      element.type == Mistake.testTajweedSelfCorrectionMistake);
                }
                if (hastestTajweed) {
                  list.removeWhere(
                      (element) => element.type == Mistake.testTajweedMistake);
                } else {
                  list.add(Mistake(
                      wordId: widget.word.id,
                      type: Mistake.testTajweedMistake));
                }
              });
            },
          ),
          CustomTextButton(
            onPressed: () {
              if ((hastestTashkelSelfCorrection &&
                      list
                              .where((element) =>
                                  element.type ==
                                  Mistake.testTashkelSelfCorrectionMistake)
                              .first
                              .pos ==
                          null) ||
                  (hastestTashkel &&
                      list
                              .where((element) =>
                                  element.type == Mistake.testTashkelMistake)
                              .first
                              .pos ==
                          null)) {
                CustomToast.showToast(
                    "الرجاء اختيار موقع الخطأ التشكيلي في الكلمة");
              } else if ((hastestTajweedSelfCorrection &&
                      list
                              .where((element) =>
                                  element.type ==
                                  Mistake.testTajweedSelfCorrectionMistake)
                              .first
                              .pos ==
                          null) ||
                  (hastestTajweed &&
                      list
                              .where((element) =>
                                  element.type == Mistake.testTajweedMistake)
                              .first
                              .pos ==
                          null)) {
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
      ),
    );
  }
}
