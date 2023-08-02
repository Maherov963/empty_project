import '../models.dart';

class QuranTest {
  int? idTest;
  int? section;
  String? notes;
  String? mistakes;
  int? tajweed;
  Person? testerPer;
  Person? testedPep;
  int? mark;
  String? createdAt;

  QuranTest({
    this.idTest,
    this.section,
    this.notes,
    this.mistakes,
    this.tajweed = 0,
    this.testerPer,
    this.testedPep,
    this.mark = 80,
    this.createdAt,
  });

  factory QuranTest.fromJson(Map<String, dynamic> json) {
    return QuranTest(
      idTest: json['ID_Test'],
      section: json['Section'],
      notes: json['Notes'],
      mistakes: json['Mistakes'],
      tajweed: json['Tajweed'] == null
          ? null
          : int.tryParse(json['Tajweed'].toString()),
      testerPer: json['Tester_Per'] == null
          ? null
          : Person.fromJson(json['Tester_Per']),
      testedPep: Person.fromJson(json['Tested_Pep']),
      mark: json['Mark'],
      createdAt: json['created_at']?.toString().substring(0, 10),
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Test': idTest,
        'Section': section,
        'Notes': notes,
        'Mistakes': mistakes,
        'Tajweed': tajweed,
        'Tester_Per': {
          "ID_Person": testerPer?.id,
          "First_Name": testerPer?.firstName,
          "Last_Name": testerPer?.lastName,
        },
        'Tested_Pep': {
          "ID_Person": testedPep?.id,
          "First_Name": testedPep?.firstName,
          "Last_Name": testedPep?.lastName,
        },
        'Mark': mark,
        'created_at': createdAt,
      };

  QuranTest copy() {
    return QuranTest(
      createdAt: createdAt,
      idTest: idTest,
      mark: mark,
      mistakes: mistakes,
      notes: notes,
      section: section,
      tajweed: tajweed,
      testedPep: testedPep?.copy(),
      testerPer: testerPer?.copy(),
    );
  }
}
