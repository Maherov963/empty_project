import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/person.dart';

class AdminstrativeNote {
  int? id;
  String? note;
  String? updatedAt;
  Person? person;
  Person? admin;

  AdminstrativeNote({
    this.id,
    this.note,
    this.person,
    this.admin,
    this.updatedAt,
  });

  factory AdminstrativeNote.fromJson(Map<String, dynamic> json) {
    return AdminstrativeNote(
      id: json["ID_Adminstrative_Note"],
      note: json["Note"],
      updatedAt: DateTime.tryParse(json["updated_at"])?.getYYYYMMDD(),
      person: Person.fromJson(json["person"]),
      admin: Person.fromJson(json["created_by"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Adminstrative_Note": id,
      "Note": note,
      "updated_at": updatedAt,
      'person': {
        "ID_Person": person?.id,
        "First_Name": person?.firstName,
        "Last_Name": person?.lastName,
      },
      'created_by': {
        "ID_Person": admin?.id,
        "First_Name": admin?.firstName,
        "Last_Name": admin?.lastName,
      },
    };
  }

  AdminstrativeNote copy() => AdminstrativeNote.fromJson(toJson());
}
