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
  String? mistakes;
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

  factory Reciting.fromJson(Map<String, dynamic> json) {
    return Reciting(
      idReciting: json['ID_Recting'],
      reciterPep: Person.fromJson(json['Reciter_Pep']),
      page: json['Page'],
      notes: json['Notes'],
      mistakes: json['Mistakes'],
      duration: json['Duration'],
      ratesIdRate: json['Rates_ID_Rate'],
      tajweed: json['Rates_ID_Rate'] == 3 ? true : false,
      listenerPer: Person.fromJson(json['Listner_Per']),
      createdAt: json['created_at'].toString().substring(0, 10),
    );
  }

  Map<String, dynamic> toJson() => {
        'ID_Recting': idReciting,
        "Tajweed": tajweed,
        'Reciter_Pep': {
          "ID_Person": reciterPep?.id,
          "First_Name": reciterPep?.firstName,
          "Last_Name": reciterPep?.lastName,
        },
        'Page': page,
        'Notes': notes,
        'Mistakes': mistakes,
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
}
