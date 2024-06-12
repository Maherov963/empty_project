import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Education extends Equatable {
  int? id;
  int? educationTypeId;
  String? majorName;
  String? majorYear;

  Education({
    this.id,
    this.educationTypeId,
    this.majorName,
    this.majorYear,
  });
  static const int class1Id = 1;
  static const int class2Id = 2;
  static const int class3Id = 3;
  static const int class4Id = 4;
  static const int class5Id = 5;
  static const int class6Id = 6;
  static const int class7Id = 7;
  static const int class8Id = 8;
  static const int class9Id = 9;
  static const int class10Id = 10;
  static const int class11Id = 11;
  static const int class12Id = 12;
  static const int collegeId = 13;
  static const int graduatedId = 14;
  static const int noneId = 15;

  static const List<int> educationTypesIds = [
    class1Id,
    class2Id,
    class3Id,
    class4Id,
    class5Id,
    class6Id,
    class7Id,
    class8Id,
    class9Id,
    class10Id,
    class11Id,
    class12Id,
    collegeId,
    graduatedId,
    noneId,
  ];

  static const String class1 = "الصف الأول";
  static const String class2 = "الصف الثاني";
  static const String class3 = "الصف الثالث";
  static const String class4 = "الصف الرابع";
  static const String class5 = "الصف الخامس";
  static const String class6 = "الصف السادس";
  static const String class7 = "الصف السابع";
  static const String class8 = "الصف الثامن";
  static const String class9 = "الصف التاسع";
  static const String class10 = "الصف العاشر";
  static const String class11 = "الصف الحادي عشر";
  static const String class12 = "بكالوريا";
  static const String college = "جامعي";
  static const String graduated = "متخرج";
  static const String none = "لا يدرس";

  static const List<String> educationTypes = [
    class1,
    class2,
    class3,
    class4,
    class5,
    class6,
    class7,
    class8,
    class9,
    class10,
    class11,
    class12,
    college,
    graduated,
    none,
  ];

  static String? getEducationFromId(int? id) {
    if (id == null) {
      return null;
    }
    return educationTypes[id - 1];
  }

  String? getEducation() {
    if (id == null) {
      return null;
    }
    return educationTypes[educationTypeId!];
  }

  static int? getIdFromEducation(String? education) {
    if (education == null) {
      return null;
    }
    return educationTypes.indexOf(education) + 1;
  }

  @override
  List<Object?> get props => [
        id,
        educationTypeId,
        majorName,
        majorYear,
      ];

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json["ID_Education"],
      educationTypeId: json["Education_Type"],
      majorName: json["major"]?["Major_Name"],
      majorYear: json["major"]?["Year"]?.toString(),
    );
  }

  Education copy() {
    return Education(
      id: id,
      educationTypeId: educationTypeId,
      majorName: majorName,
      majorYear: majorYear,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Education": id,
      "Education_Type": educationTypeId,
      "major": {
        "Major_Name": majorName,
        "Year": majorYear,
      }
    };
  }
}
