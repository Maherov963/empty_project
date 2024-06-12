import 'package:al_khalil/domain/models/memorization/page.dart';
import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import 'package:al_khalil/features/quran/domain/models/quran.dart';
import 'test.dart';
export 'page.dart';
export 'test.dart';

class Memorization {
  List<Reciting>? recites;
  List<QuranTest>? tests;
  int? juz;
  Memorization({
    this.recites,
    this.juz,
    this.tests,
  });

  factory Memorization.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonRecites = json['pages'];
    List<Reciting> recites =
        jsonRecites.map((recite) => Reciting.fromJson(recite)).toList();
    List<dynamic> jsonTests = json['tests'];
    List<QuranTest> tests =
        jsonTests.map((test) => QuranTest.fromJson(test)).toList();

    return Memorization(
      recites: recites,
      tests: tests,
      juz: json['juz'],
    );
  }

  Map<String, dynamic> toJson() => {
        'tests': tests?.map((test) => test.toJson()).toList(),
        'juz': juz,
        "memos": recites?.map((recite) => recite.toJson()).toList(),
      };

  Reciting? getSuccesRecite(int pageId) {
    return recites
        ?.where((element) =>
            element.page == pageId &&
            element.ratesIdRate != Reciting.failReciteId)
        .firstOrNull;
  }

  QuranTest? getSuccesTest(int juz) {
    return tests
        ?.where((element) =>
            element.section == juz &&
            element.calculateRate() != Reciting.failReciteId)
        .firstOrNull;
  }

  List<Reciting>? getAllRecite(int pageId) {
    return recites?.where((element) => element.page == pageId).toList();
  }

  int getSuccesfulRecites(int juz) {
    return recites
            ?.where((element) =>
                Quran.getJuzOfPage(element.page) == juz &&
                element.ratesIdRate != Reciting.failReciteId)
            .length ??
        0;
  }

  List<Mistake> calculateOldReciteMistakes() {
    // if (oldMistakes != null) {
    //   return oldMistakes!;
    // } else {
    List<Mistake> oldMistakes = [];
    for (var recite in recites ?? <Reciting>[]) {
      oldMistakes.addAll(recite.mistakes ?? []);
    }
    for (var test in tests ?? <QuranTest>[]) {
      oldMistakes.addAll(test.mistakes ?? []);
    }
    return oldMistakes;
    // }
  }

  Memorization copy() => Memorization.fromJson(toJson());
}
