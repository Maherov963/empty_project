import 'package:equatable/equatable.dart';
import '../static/id_name_model.dart';

// ignore: must_be_immutable
class Mother extends Equatable {
  int? id;
  String? motherName;
  String? phoneNumber;
  String? jobName;
  IdNameModel? motherState;
  Mother(
      {this.id,
      this.motherName,
      this.phoneNumber,
      this.jobName,
      this.motherState});

  @override
  List<Object?> get props => [
        id,
        motherName,
        phoneNumber,
        jobName,
        motherState,
      ];
  factory Mother.fromJson(Map<String, dynamic> json) {
    return Mother(
      id: json["ID_Mother"],
      motherName: json["Mother_Name"],
      phoneNumber: json["phone"] == null ? null : json["phone"]["Number"],
      jobName: json["phone"] == null ? null : json["job"]["Job_Name"],
      motherState: IdNameModel.fromJson(
        json["state"],
        idKey: "ID_State",
        nameKey: "State_Name",
      ),
    );
  }
  Mother copy() {
    return Mother(
      id: id,
      jobName: jobName,
      motherName: motherName,
      motherState: motherState?.copy(),
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Mother": id,
      "Mother_Name": motherName,
      "phone": {
        "Number": phoneNumber,
      },
      "job": {
        "Job_Name": jobName,
      },
      "state": motherState == null
          ? null
          : motherState!.toJson(
              idKey: "ID_State",
              nameKey: "State_Name",
            ),
    };
  }
}
