import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Mother extends Equatable {
  int? id;
  String? motherName;
  String? phoneNumber;
  String? jobName;
  int? state;
  Mother({
    this.id,
    this.motherName,
    this.phoneNumber,
    this.jobName,
    this.state,
  });

  @override
  List<Object?> get props => [
        id,
        motherName,
        phoneNumber,
        jobName,
        state,
      ];
  factory Mother.fromJson(Map<String, dynamic> json) {
    return Mother(
      id: json["ID_Mother"],
      motherName: json["Mother_Name"],
      phoneNumber: json["phone"] == null ? null : json["phone"]["Number"],
      jobName: json["phone"] == null ? null : json["job"]["Job_Name"],
      state: json["state"]?["ID_State"],
    );
  }
  Mother copy() {
    return Mother(
      id: id,
      jobName: jobName,
      motherName: motherName,
      state: state,
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Mother": id,
      "Mother_Name": motherName,
      "phone": {"Number": phoneNumber},
      "job": {"Job_Name": jobName},
      "state": {"ID_State": state}
    };
  }
}
