import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Kin extends Equatable {
  int? id;
  String? kinName;
  int? state;
  String? phoneNumber;
  String? job;
  Kin({
    this.id,
    this.kinName,
    this.state,
    this.phoneNumber,
    this.job,
  });
  Kin copy() {
    return Kin(
      id: id,
      job: job,
      kinName: kinName,
      state: state,
      phoneNumber: phoneNumber,
    );
  }

  @override
  List<Object?> get props => [id, kinName, state, phoneNumber, job];
  factory Kin.fromJson(Map<String, dynamic> json) {
    return Kin(
      id: json["ID_Kin"],
      kinName: json["Kin_Name"],
      job: json["job"] == null ? null : json["job"]["Job_Name"],
      phoneNumber: json["phone"] == null ? null : json["phone"]["Number"],
      state: json["state"]?["ID_State"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "ID_Kin": id,
      "Kin_Name": kinName,
      "phone": {"Number": phoneNumber},
      "job": {"Job_Name": job},
      "state": {"ID_State": state}
    };
  }
}
