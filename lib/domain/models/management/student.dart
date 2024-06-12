import 'package:al_khalil/data/extensions/extension.dart';
import 'package:al_khalil/domain/models/management/group.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Student extends Equatable {
  int? id;
  String? registerDate;
  int? groubId;
  String? groubName;
  int? state;

  Student({
    this.id,
    this.groubName,
    this.groubId,
    this.registerDate,
    this.state,
  });

  @override
  List<Object?> get props => [
        id,
        registerDate,
        state,
      ];

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["ID_Student_Pep"],
      registerDate:
          DateTime.tryParse(json["Register_Date"].toString())?.getYYYYMMDD(),
      groubId: json["group"]?["ID_Group"],
      groubName: json["group"]?["Group_Name"],
      state: json["state"]?["ID_State"],
    );
  }
  Student copy() {
    return Student(
      id: id,
      groubId: groubId,
      groubName: groubName,
      registerDate: registerDate,
      state: state,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Student_Pep": id,
      "Register_Date": registerDate,
      "group": {"ID_Group": groubId, "Group_Name": groubName},
      "state": {"ID_State": state}
    };
  }

  Group? recommendGroup(List<Group> groups, int? education) {
    if (education == null) {
      return null;
    } else {
      List<Group> filtered = [];
      for (var group in groups) {
        if (group.educations!.contains(education)) {
          filtered.add(group);
        }
      }
      filtered.sort((a, b) => a.students!.length.compareTo(b.students!.length));
      groubId = filtered.firstOrNull?.id;
      groubName = filtered.firstOrNull?.groupName;
      return filtered.firstOrNull;
    }
  }
}
