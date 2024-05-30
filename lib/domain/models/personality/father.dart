import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Father extends Equatable {
  int? id;
  String? fatherName;
  String? phoneNumber;
  String? jobName;
  int? state;
  Father({
    this.id,
    this.fatherName,
    this.phoneNumber,
    this.jobName,
    this.state,
  });

  @override
  List<Object?> get props => [
        id,
        fatherName,
        phoneNumber,
        jobName,
        state,
      ];
  factory Father.fromJson(Map<String, dynamic> json) {
    return Father(
      id: json["ID_Father"],
      fatherName: json["Father_Name"],
      phoneNumber: json["phone"] == null ? null : json["phone"]["Number"],
      jobName: json["job"] == null ? null : json["job"]["Job_Name"],
      state: json["state"]?["ID_State"],
    );
  }
  Father copy() {
    return Father(
      fatherName: fatherName,
      state: state,
      id: id,
      jobName: jobName,
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Father": id,
      "Father_Name": fatherName,
      "phone": {"Number": phoneNumber},
      "job": {"Job_Name": jobName},
      "state": {"ID_State": state},
    };
  }
}
