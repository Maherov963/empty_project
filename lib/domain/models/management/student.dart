import 'package:equatable/equatable.dart';
import '../static/id_name_model.dart';

// ignore: must_be_immutable
class Student extends Equatable {
  int? id;
  String? registerDate;
  IdNameModel? groupIdName;
  IdNameModel? studentState;
  Student({
    this.id,
    this.registerDate,
    this.groupIdName,
    this.studentState,
  });
  @override
  List<Object?> get props => [
        id,
        registerDate,
        groupIdName,
        studentState,
      ];
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json["ID_Student_Pep"],
      registerDate: json["Register_Date"],
      groupIdName: IdNameModel.fromJson(
        json["group"],
        idKey: "ID_Group",
        nameKey: "Group_Name",
      ),
      studentState: IdNameModel.fromJson(
        json["state"],
        idKey: "ID_State",
        nameKey: "State_Name",
      ),
    );
  }
  Student copy() {
    return Student(
      id: id,
      groupIdName: groupIdName?.copy(),
      registerDate: registerDate,
      studentState: studentState?.copy(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Student_Pep": id,
      "Register_Date": registerDate,
      "group": groupIdName == null
          ? null
          : groupIdName!.toJson(idKey: "ID_Group", nameKey: "Group_Name"),
      "state": studentState == null
          ? null
          : studentState!.toJson(idKey: "ID_State", nameKey: "State_Name"),
    };
  }
}
