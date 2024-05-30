import '../models/quran.dart';

class QuranProvider {
  late final Quran quran;
  final List<QuranPage> quranPages = [];
  Future<void> init() async {
    quran = await getQuran();
    for (var element in quran.juzs) {
      quranPages.addAll(element.pages);
    }
  }
}
