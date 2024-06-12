import '../models/quran.dart';

class QuranProvider {
  late final Quran quran;

  final List<PageQuran> quranPages = [];

  Future<void> init() async {
    quran = await getQuran();
    for (var element in quran.juzs) {
      quranPages.addAll(element.pages);
    }
  }

  int getFirstPageOfJuz(int juz) {
    return quran.juzs[juz - 1].pages.first.id;
  }

  int getLastPageOfJuz(int juz) {
    return quran.juzs[juz - 1].pages.last.id;
  }

  List<PageQuran> getQuranPagesForJuz(int pageId) {
    return quran.juzs[Quran.getJuzOfPage(pageId) - 1].pages;
  }
}
