import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import '../models.dart';

class QuranTest {
  int? idTest;
  int? section;
  String? notes;
  bool tajweed;
  Person? testerPer;
  Person? testedPep;
  int? mark;
  int? tajweedMark;
  int? rate;
  List<Mistake>? mistakes;
  String? createdAt;

  QuranTest({
    this.idTest,
    this.section,
    this.notes,
    this.rate,
    this.mistakes,
    this.tajweed = false,
    this.testerPer,
    this.testedPep,
    this.mark,
    this.createdAt,
  });

  factory QuranTest.fromJson(Map<String, dynamic> json) {
    final mistakesList = json["mistakes"] as List?;

    return QuranTest(
      idTest: json['ID_Test'],
      rate: json['Rate'],
      section: json['Section'],
      notes: json['Notes'],
      mistakes: mistakesList?.map((e) => Mistake.fromJson(e)).toList(),
      tajweed: (json['Tajweed'] ?? 0) == 0 ? false : true,
      testerPer: json['person_tester'] == null
          ? null
          : Person.fromJson(json['person_tester']),
      testedPep: json['person_student'] is int?
          ? null
          : Person.fromJson(json['person_student']),
      mark: json['Mark'],
      createdAt: json['created_at']?.toString().substring(0, 10),
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Test': idTest,
        'Rate': rate,
        'Section': section,
        'mistakes': mistakes?.map((e) => e.toJson()).toList(),
        'Notes': notes,
        "Tajweed": tajweed ? 1 : 0,
        'person_tester': {
          "ID_Person": testerPer?.id,
          "First_Name": testerPer?.firstName,
          "Last_Name": testerPer?.lastName,
        },
        'person_student': {
          "ID_Person": testedPep?.id,
          "First_Name": testedPep?.firstName,
          "Last_Name": testedPep?.lastName,
        },
        'Mark': mark,
        'Tajweed_Mark': tajweedMark,
        'created_at': createdAt,
      };

  int? calculateRate() {
    int memoMark = calculateMark();
    int tajweedMark = calculateTajweedMark();
    if (memoMark < 80) {
      return Reciting.failReciteId;
    } else {
      if (memoMark + tajweedMark >= 110) {
        return Reciting.excellentReciteId;
      } else if (memoMark + tajweedMark >= 90) {
        return Reciting.veryGoodReciteId;
      } else {
        return Reciting.goodReciteId;
      }
    }
  }

  int calculateMark() {
    int totalMark = 100;

    for (var mistake in mistakes ?? <Mistake>[]) {
      if (mistake.type == Mistake.testForgetSelfCorrectionMistake) {
        totalMark -= 2;
      } else if (mistake.type == Mistake.testForgetMistake) {
        totalMark -= 5;
      } else if (mistake.type == Mistake.testTashkelSelfCorrectionMistake) {
        totalMark -= 5;
      } else if (mistake.type == Mistake.testTashkelMistake) {
        totalMark -= 10;
      }
    }
    return totalMark.clamp(0, 100);
  }

  int calculateTajweedMark() {
    if (!tajweed) {
      return 0;
    }
    int totalMark = 25;

    for (var mistake in mistakes ?? <Mistake>[]) {
      if (mistake.type == Mistake.testTajweedSelfCorrectionMistake) {
        totalMark -= 2;
      } else if (mistake.type == Mistake.testTajweedMistake) {
        totalMark -= 5;
      }
    }
    return totalMark.clamp(0, 25);
  }

  QuranTest copy() => QuranTest.fromJson(toJson());
}
