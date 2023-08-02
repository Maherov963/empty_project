import 'package:equatable/equatable.dart';

import '../static/id_name_model.dart';

// ignore: must_be_immutable
class Kin extends Equatable {
  int? id;
  String? kinName;
  IdNameModel? kinState;
  String? phoneNumber;
  String? job;
  Kin({
    this.id,
    this.kinName,
    this.kinState,
    this.phoneNumber,
    this.job,
  });
  Kin copy() {
    return Kin(
      id: id,
      job: job,
      kinName: kinName,
      kinState: kinState?.copy(),
      phoneNumber: phoneNumber,
    );
  }

  @override
  List<Object?> get props => [id, kinName, kinState, phoneNumber, job];
  factory Kin.fromJson(Map<String, dynamic> json) {
    return Kin(
      id: json["ID_Kin"],
      kinName: json["Kin_Name"],
      job: json["job"] == null ? null : json["job"]["Job_Name"],
      phoneNumber: json["phone"] == null ? null : json["phone"]["Number"],
      kinState: IdNameModel.fromJson(
        json["state"],
        idKey: "ID_State",
        nameKey: "State_Name",
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "ID_Kin": id,
      "Kin_Name": kinName,
      "phone": {
        "Number": phoneNumber,
      },
      "job": {
        "Job_Name": job,
      },
      "state": kinState == null
          ? null
          : kinState!.toJson(
              idKey: "ID_State",
              nameKey: "State_Name",
            ),
    };
  }
}
