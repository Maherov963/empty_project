import 'dart:math';
import 'dart:ui' as ui;
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/pages/page_screen/quran_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/mistake.dart';
import '../../domain/models/quran.dart';
import '../../widgets/basmalah_widget.dart';
import '../../widgets/normalline_widget.dart';
import '../../widgets/surahname_widget.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({
    super.key,
    required this.initialPage,
    required this.pageState,
    required this.onMistake,
    required this.oldMistakes,
    required this.reciting,
    required this.onChangePage,
    required this.quranPages,
    required this.pageController,
    required this.test,
  });
  final int initialPage;
  final List<Mistake> oldMistakes;
  final Reciting? reciting;
  final QuranTest? test;
  final PageState pageState;
  static const int lineFactory = 17;
  final Function(int, List<Mistake>) onMistake;
  final Function(int) onChangePage;
  final List<PageQuran> quranPages;
  final PageController pageController;
  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var padding =
        MediaQueryData.fromView(ui.PlatformDispatcher.instance.implicitView!)
            .padding;
    final maxHieght = max(hieght - padding.top - padding.bottom - 16,
            width - padding.left - padding.right - 16) /
        PageBuilder.lineFactory;
    return SafeArea(
      child: PageView.builder(
        itemCount: widget.quranPages.length,
        physics: widget.pageState == PageState.reciting
            ? const NeverScrollableScrollPhysics()
            : null,
        controller: widget.pageController,
        onPageChanged: widget.onChangePage,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                PageHeader(
                  maxHieght: maxHieght,
                  header: widget.quranPages[index].header,
                  juz: widget.quranPages[index].juz,
                ),
                Expanded(
                  child: ListView(
                    physics: isPortrait
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    children: widget.quranPages[index].lines.map(
                      (line) {
                        if (line is NormalLine) {
                          return NormalLineWidget(
                            test: widget.test,
                            onMistake: widget.onMistake,
                            maxHieght: maxHieght,
                            reciting: widget.reciting,
                            page: widget.quranPages[index].id,
                            words: line.words,
                            pageState: widget.pageState,
                            oldMistakes: widget.oldMistakes,
                          );
                        } else if (line is SurahNameLine) {
                          return SurahNameWidget(
                            maxHieght: maxHieght,
                            surahName: line.surahName,
                          );
                        } else {
                          final isBaqarahBasmalah =
                              widget.quranPages[index].id == 2;
                          return BasmalahWidget(
                            maxHieght: maxHieght,
                            isBaqarahBasmalah: isBaqarahBasmalah,
                          );
                        }
                      },
                    ).toList(),
                  ),
                ),
                PageFooter(
                  maxHieght: maxHieght,
                  page: widget.quranPages[index].id,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.maxHieght,
    required this.header,
    required this.juz,
  });
  final double maxHieght;
  final String header;
  final int juz;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: maxHieght,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(header,
                style: GoogleFonts.scheherazadeNew(color: Colors.black)),
            Text("الجزء ${numbersToIndian(juz)}",
                style: GoogleFonts.scheherazadeNew(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}

class PageFooter extends StatelessWidget {
  const PageFooter({
    super.key,
    required this.maxHieght,
    required this.page,
  });
  final double maxHieght;
  final int page;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHieght,
      child: Text(numbersToIndian(page),
          style: GoogleFonts.scheherazadeNew(color: Colors.black)),
    );
  }
}
