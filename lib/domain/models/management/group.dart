import 'package:al_khalil/domain/models/models.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Group extends Equatable {
  int? id;
  String? groupName;
  List<Person>? students;
  List<Person>? assistants;
  Person? moderator;
  Person? superVisor;
  String? privateMeeting;
  int? classs;
  List<int>? educations;

  Group({
    this.id,
    this.educations,
    this.classs,
    this.groupName,
    this.students,
    this.moderator,
    this.superVisor,
    this.privateMeeting,
    this.assistants,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    final studentsList =
        json["students"] == null ? [] : json["students"] as List;
    final assitantsList =
        json["Assistants"] == null ? [] : json["Assistants"] as List;
    return Group(
      id: json["ID_Group"],
      groupName: json["Group_Name"],
      students: studentsList
          .map((e) => Person(
                id: e["ID_Student_Pep"],
                firstName: e["user"]?["First_Name"],
                lastName: e["user"]?["Last_Name"],
                tempPoints: e["user"]?["Temp_Points"]?.toString() ?? "0",
                education: e["user"]?["education"] == null
                    ? null
                    : Education.fromJson(e["user"]["education"]),
              ))
          .toList()
        ..sort((a, b) => a.getFullName().compareTo(b.getFullName())),
      assistants: assitantsList
          .map((e) => Person(
                id: e["ID_Person"],
                firstName: e["First_Name"],
                lastName: e["Last_Name"],
              ))
          .toList()
        ..sort((a, b) => a.getFullName().compareTo(b.getFullName())),
      moderator: json["Moderator"] is Map
          ? Person(
              id: json["Moderator"]["ID_Person"],
              firstName: json["Moderator"]["First_Name"],
              lastName: json["Moderator"]["Last_Name"],
            )
          : null,
      superVisor: json["Supervisor"] is Map
          ? Person(
              id: json["Supervisor"]["ID_Person"],
              firstName: json["Supervisor"]["First_Name"],
              lastName: json["Supervisor"]["Last_Name"],
            )
          : null,
      educations: (json['educations'] as List?)
          ?.map((e) => int.parse(e.toString()))
          .toList(),
      privateMeeting: json["Private_Meeting"],
      classs: Education.getIdFromEducation(json["Class"]),
    );
  }

  Group copy() {
    return Group(
      assistants: assistants?.map((e) => e.copy()).toList(),
      classs: classs,
      groupName: groupName,
      id: id,
      educations: educations,
      moderator: moderator?.copy(),
      privateMeeting: privateMeeting,
      students: students?.map((e) => e.copy()).toList(),
      superVisor: superVisor?.copy(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Group": id,
      "educations": educations,
      "Group_Name": groupName,
      "students": students!.map((e) => {"ID_Student_Pep": e.id}).toList(),
      "Assistants":
          assistants!.map((e) => {"ID_Permission_Pep": e.id}).toList(),
      "Class": Education.getEducationFromId(classs),
      "Private_Meeting": privateMeeting,
      "Moderator":
          moderator == null ? null : {"ID_Permission_Pep": moderator!.id},
      "Supervisor":
          superVisor == null ? null : {"ID_Permission_Pep": superVisor!.id},
    };
  }

  String get getEducations => educations!
      .map((e) => Education.getEducationFromId(e))
      .toList()
      .toString()
      .replaceAll("[", "")
      .replaceAll("]", "")
      .replaceAll(", ", " و")
      .replaceAll("والصف ", "و");

  @override
  List<Object?> get props => [
        id,
        groupName,
        students,
        moderator,
        superVisor,
        privateMeeting,
        classs,
      ];
}
