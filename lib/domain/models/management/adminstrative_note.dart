import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';

class AdminstrativeNote {
  int? id;
  String? note;
  String? updatedAt;
  List<Person>? people;
  Person? admin;

  AdminstrativeNote({
    this.id,
    this.note,
    this.people,
    this.admin,
    this.updatedAt,
  });

  factory AdminstrativeNote.fromJson(Map<String, dynamic> json) {
    final peopleList = json["people"] as List?;

    return AdminstrativeNote(
      id: json["ID_Adminstrative_Note"],
      note: json["Note"],
      updatedAt: DateTime.tryParse(json["updated_at"])?.getYYYYMMDD(),
      people: peopleList?.map((person) => Person.fromJson(person)).toList(),
      admin: Person.fromJson(json["created_by"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Adminstrative_Note": id,
      "Note": note,
      "updated_at": updatedAt,
      'people': people
          ?.map(
            (e) => {
              "ID_Person": e.id,
              "First_Name": e.firstName,
              "Last_Name": e.lastName,
            },
          )
          .toList(),
      'created_by': {
        "ID_Person": admin?.id,
        "First_Name": admin?.firstName,
        "Last_Name": admin?.lastName,
      },
    };
  }

  AdminstrativeNote copy() => AdminstrativeNote.fromJson(toJson());
}
