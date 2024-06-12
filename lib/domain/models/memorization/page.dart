import 'package:al_khalil/features/quran/domain/models/mistake.dart';
import '../models.dart';

class QuranPage {
  int? idPage;
  String? surah;
  Reciting? reciting;

  QuranPage({
    this.idPage,
    this.reciting,
    this.surah,
  });

  factory QuranPage.fromJson(Map<String, dynamic> json) {
    return QuranPage(
      idPage: json['ID_Page'],
      surah: json['Surah'],
      reciting:
          json['reciting'] == null ? null : Reciting.fromJson(json['reciting']),
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Page': idPage,
        'Surah': surah,
        'reciting': reciting?.toJson(),
      };

  QuranPage copy() => QuranPage.fromJson(toJson());
}

class Reciting {
  int? idReciting;
  Person? reciterPep;
  int? page;
  bool tajweed;
  String? notes;
  List<Mistake>? mistakes;
  int? duration;
  int? ratesIdRate;
  Person? listenerPer;
  String? createdAt;

  Reciting({
    this.idReciting,
    this.reciterPep,
    this.page,
    this.notes,
    this.mistakes,
    this.duration,
    this.ratesIdRate,
    this.listenerPer,
    this.createdAt,
    this.tajweed = false,
  });

  static const int failReciteId = 0;
  static const int goodReciteId = 1;
  static const int veryGoodReciteId = 2;
  static const int excellentReciteId = 3;

  static const String failRecite = "فشل";
  static const String goodRecite = "جيد";
  static const String veryGoodRecite = "جيد جداً";
  static const String excellentRecite = "ممتاز";

  static const List<String> ratesType = [
    failRecite,
    goodRecite,
    veryGoodRecite,
    excellentRecite,
  ];

  static String? getRateFromId(int? id) {
    if (id == null) {
      return null;
    }
    return ratesType[id];
  }

  static int? getIdFromRate(String? rate) {
    if (rate == null) {
      return null;
    }
    return ratesType.indexOf(rate);
  }

  factory Reciting.fromJson(Map<String, dynamic> json) {
    final mistakesList =
        json["mistakes"] == null ? [] : json["mistakes"] as List;
    return Reciting(
      idReciting: json['ID_Recting'],
      reciterPep: Person.fromJson(json['Reciter_Pep']),
      page: json['Page'],
      notes: json['Notes'],
      mistakes: mistakesList.map((e) => Mistake.fromJson(e)).toList(),
      duration: json['Duration'],
      ratesIdRate: json['Rates_ID_Rate'],
      tajweed: (json['Tajweed'] ?? 0) == 0 ? false : true,
      listenerPer: Person.fromJson(json['Listner_Per']),
      createdAt: json['created_at']?.toString().substring(0, 10),
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Recting': idReciting,
        "Tajweed": tajweed ? 1 : 0,
        'Reciter_Pep': {
          "ID_Person": reciterPep?.id,
          "First_Name": reciterPep?.firstName,
          "Last_Name": reciterPep?.lastName,
        },
        'Page': page,
        'Notes': notes,
        'mistakes': mistakes?.map((e) => e.toJson()).toList(),
        'Duration': duration,
        'Rates_ID_Rate': ratesIdRate,
        'Listner_Per': {
          "ID_Person": listenerPer?.id,
          "First_Name": listenerPer?.firstName,
          "Last_Name": listenerPer?.lastName,
        },
        'created_at': createdAt,
      };

  Reciting copy() => Reciting.fromJson(toJson());

  int calculateRate() {
    bool hasTashkel = false;
    int forgetMistaks = 0;
    int tajweedMistaks = 0;

    for (var mistake in mistakes ?? <Mistake>[]) {
      if (mistake.type == Mistake.tashkelMistake) {
        hasTashkel = true;
      } else if (mistake.type == Mistake.tajweedMistake) {
        tajweedMistaks++;
      } else {
        forgetMistaks++;
      }
    }
    if (hasTashkel || forgetMistaks >= 2) {
      return Reciting.failReciteId;
    } else if (forgetMistaks == 1) {
      if (tajweedMistaks < 5 && tajweed) {
        return Reciting.veryGoodReciteId;
      } else {
        return Reciting.goodReciteId;
      }
    } else {
      if (tajweedMistaks < 5 && tajweed) {
        return Reciting.excellentReciteId;
      } else {
        return Reciting.veryGoodReciteId;
      }
    }
  }
}
