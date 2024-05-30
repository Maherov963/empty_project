import 'quran_page.dart';

class Juz {
  final int juzId;
  final List<QuranPage> pages;

  const Juz({
    required this.juzId,
    required this.pages,
  });
  factory Juz.fromJson(Map json) {
    return Juz(
      juzId: json["juzId"],
      pages: (json["pages"] as List).map((e) => QuranPage.fromJson(e)).toList(),
    );
  }
}
