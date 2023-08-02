import 'package:al_khalil/domain/models/models.dart';
import 'package:equatable/equatable.dart';
import '../static/id_name_model.dart';

// ignore: must_be_immutable
class Group extends Equatable {
  int? id;
  String? groupName;
  List<Person>? students;
  List<Person>? assistants;
  Person? moderator;
  Person? superVisor;
  String? privateMeeting;
  IdNameModel? state;
  String? classs;
  Group({
    this.id,
    this.classs,
    this.groupName,
    this.students,
    this.moderator,
    this.superVisor,
    this.privateMeeting,
    this.assistants,
    this.state,
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
                education: e["user"] == null || e["user"]["education"] == null
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
      privateMeeting: json["Private_Meeting"],
      classs: json["Class"],
      state: IdNameModel.fromJson(
        json["state"],
        idKey: "ID_State",
        nameKey: "State_Name",
      ),
    );
  }

  Group copy() {
    return Group(
      assistants: assistants?.map((e) => e.copy()).toList(),
      classs: classs,
      groupName: groupName,
      id: id,
      moderator: moderator?.copy(),
      privateMeeting: privateMeeting,
      state: state?.copy(),
      students: students?.map((e) => e.copy()).toList(),
      superVisor: superVisor?.copy(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Group": id,
      "Group_Name": groupName,
      "students": students!.map((e) => {"ID_Student_Pep": e.id}).toList(),
      "Assistants":
          assistants!.map((e) => {"ID_Permission_Pep": e.id}).toList(),
      "Class": classs,
      "Private_Meeting": privateMeeting,
      "state": state == null
          ? null
          : state!.toJson(
              idKey: "ID_State",
              nameKey: "State_Name",
            ),
      "Moderator":
          moderator == null ? null : {"ID_Permission_Pep": moderator!.id},
      "Supervisor":
          superVisor == null ? null : {"ID_Permission_Pep": superVisor!.id},
    };
  }

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
