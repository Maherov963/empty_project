import 'package:equatable/equatable.dart';

import '../static/id_name_model.dart';

// ignore: must_be_immutable
class Father extends Equatable {
  int? id;
  String? fatherName;
  String? phoneNumber;
  String? jobName;
  IdNameModel? fatherState;
  Father({
    this.id,
    this.fatherName,
    this.phoneNumber,
    this.jobName,
    this.fatherState,
  });

  @override
  List<Object?> get props => [
        id,
        fatherName,
        phoneNumber,
        jobName,
        fatherState,
      ];
  factory Father.fromJson(Map<String, dynamic> json) {
    return Father(
      id: json["ID_Father"],
      fatherName: json["Father_Name"],
      phoneNumber: json["phone"] == null ? null : json["phone"]["Number"],
      jobName: json["job"] == null ? null : json["job"]["Job_Name"],
      fatherState: IdNameModel.fromJson(
        json["state"],
        idKey: "ID_State",
        nameKey: "State_Name",
      ),
    );
  }
  Father copy() {
    return Father(
      fatherName: fatherName,
      fatherState: fatherState?.copy(),
      id: id,
      jobName: jobName,
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Father": id,
      "Father_Name": fatherName,
      "phone": {
        "Number": phoneNumber,
      },
      "job": {
        "Job_Name": jobName,
      },
      "state": fatherState == null
          ? null
          : fatherState!.toJson(
              idKey: "ID_State",
              nameKey: "State_Name",
            ),
    };
  }
}
