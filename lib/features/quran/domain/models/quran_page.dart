import 'package:al_khalil/main.dart';

import 'ayah.dart';
import 'line.dart';

class PageQuran {
  final int id;
  final int juz;
  final String header;
  final List<Line> lines;
  final List<Ayah> ayahs;

  const PageQuran({
    required this.id,
    required this.juz,
    required this.ayahs,
    required this.header,
    required this.lines,
  });

  factory PageQuran.fromJson(Map json) {
    return PageQuran(
      id: json["page"],
      juz: json["juz"],
      header: json["header"],
      lines: (json["lines"] as List).map((e) => Line.fromJson(e)).toList(),
      ayahs: (json["ayahs"] as List)
          .map((e) => Ayah.fromJson(e, pageId: json["page"]))
          .toList(),
    );
  }
  String? get isFirstPage {
    if (id == 1) {
      return header;
    }
    if (quranProvider.quranPages[id - 1].header ==
        quranProvider.quranPages[id - 2].header) {
      return null;
    } else {
      return header;
    }
  }
}
