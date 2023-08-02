import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Education extends Equatable {
  int? id;
  String? educationType;
  String? majorName;
  String? majorYear;

  Education({
    this.id,
    this.educationType,
    this.majorName,
    this.majorYear,
  });

  @override
  List<Object?> get props => [
        id,
        educationType,
        majorName,
        majorYear,
      ];
  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json["ID_Education"],
      educationType: json["Education_Type"],
      majorName: json["major"]?["Major_Name"],
      majorYear: json["major"]?["Year"]?.toString(),
    );
  }
  Education copy() {
    return Education(
      id: id,
      educationType: educationType,
      majorName: majorName,
      majorYear: majorYear,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Education": id,
      "Education_Type": educationType,
      "major": {
        "Major_Name": majorName,
        "Year": majorYear,
      }
    };
  }
}
