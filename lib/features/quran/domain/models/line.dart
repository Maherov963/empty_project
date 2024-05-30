import 'word.dart';

abstract class Line {
  const Line();
  factory Line.fromJson(Map json) {
    switch (json["data"]["type"]) {
      case "start":
        return SurahNameLine.fromJson(json);
      case "besmellah":
        return BasmalehLine.fromJson(json);
      default:
        return NormalLine.fromJson(json);
    }
  }
}

class NormalLine extends Line {
  final List<Word> words;
  const NormalLine({required this.words});
  factory NormalLine.fromJson(Map json) {
    return NormalLine(
        words: (json["words"] as List).map((e) => Word.fromJson(e)).toList());
  }
}

class BasmalehLine extends Line {
  static const String basmaleh = "ﭑﭒﭓ";
  const BasmalehLine();
  factory BasmalehLine.fromJson(Map json) {
    return const BasmalehLine();
  }
}

class SurahNameLine extends Line {
  final String surahName;
  final int surahId;
  const SurahNameLine({required this.surahName, required this.surahId});
  factory SurahNameLine.fromJson(Map json) {
    return SurahNameLine(
        surahName: json["data"]["suraName"], surahId: json["data"]["surahId"]);
  }
}
