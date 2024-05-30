import 'dart:convert';
import 'package:al_khalil/main.dart';
import 'package:flutter/services.dart';
import 'ayah.dart';
import 'juz.dart';

//export
export 'ayah.dart';
export 'juz.dart';
export 'line.dart';
export 'word.dart';
export 'quran_page.dart';

class Quran {
  final List<Juz> juzs;

  const Quran({
    required this.juzs,
  });

  factory Quran.fromJson(List json) {
    return Quran(
      juzs: json.map((e) => Juz.fromJson(e)).toList(),
    );
  }

  List<Ayah> searchAyah(String word) {
    if (word.isEmpty) {
      return [];
    }
    final List<Ayah> searchedAyahs = [];
    for (var juz in juzs) {
      for (var page in juz.pages) {
        for (var ayah in page.ayahs) {
          if (ayah.ayah.contains(removeHarakat(word))) {
            searchedAyahs.add(ayah);
          }
        }
      }
    }
    return searchedAyahs;
  }
}

dynamic loadJson() async {
  String data = await rootBundle.loadString('assets/json/quran.json');
  return jsonDecode(data);
}

Future<Quran> getQuran() async {
  return Quran.fromJson(await loadJson());
}

String removeHarakat(String text) {
  return text
      .replaceAll("ّ", "")
      .replaceAll("َ", "")
      .replaceAll("ٌ", "")
      .replaceAll("ِ", "")
      .replaceAll("ُ", "")
      .replaceAll("ْ", "")
      .replaceAll("ّ", "")
      . //shadda
      replaceAll("ٍ", "")
      . //tanwen nasb
      replaceAll("ً", "")
      . //tanwen rf3
      replaceAll("ٌ", "")
      . //tanwen dm
      replaceAll("أ", "ا")
      . //hama kt3
      replaceAll("آ", "ا")
      . //madda
      replaceAll("إ", "ا"); //hamz ksr;
}

String numberToIndian(String x) {
  String result;
  switch (x) {
    case "0":
      result = "٠";
      break;
    case "1":
      result = "١";
      break;
    case "2":
      result = "٢";
      break;
    case "3":
      result = "٣";
      break;
    case "4":
      result = "٤";
      break;
    case "5":
      result = "٥";
      break;
    case "6":
      result = "٦";
      break;
    case "7":
      result = "٧";
      break;
    case "8":
      result = "٨";
      break;
    case "9":
      result = "٩";
      break;
    default:
      result = "٠";
  }
  return result;
}

String numbersToIndian(int x) {
  String result = "";
  for (var e in x.toString().split("")) {
    result += numberToIndian(e);
  }
  return result;
}
