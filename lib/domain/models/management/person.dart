import 'package:al_khalil/domain/models/memorization/test.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:equatable/equatable.dart';
import '../static/custom_state.dart';

// ignore: must_be_immutable
class Person extends Equatable {
  int? id;
  String? firstName;
  String? lastName;
  String? midName;
  String? addName;
  String? birthDate; // yyyy-mm-dd
  String? birthPlace;
  String? email;
  String? imageLink; //0
  String? distinguishingSigns; //علامات مميزة
  String? note;
  String? createDate; //0
  int? personState;
  String? job;
  Education? education;
  Address? address;
  Mother? mother;
  Kin? kin;
  Father? father;
  String? primaryNumber;
  String? whatsappNumber;
  String? points;
  String? tempPoints;
  Custom? custom;
  Student? student;
  String? password;
  String? token;
  String? memorization;
  String? userName;
  List<QuranTest>? tests;
  Person({
    this.id,
    this.tests,
    this.firstName,
    this.lastName,
    this.midName,
    this.addName,
    this.birthDate,
    this.birthPlace,
    this.email,
    this.imageLink,
    this.distinguishingSigns,
    this.note,
    this.createDate,
    this.personState,
    this.job,
    this.education,
    this.address,
    this.mother,
    this.kin,
    this.father,
    this.primaryNumber,
    this.whatsappNumber,
    this.points,
    this.custom,
    this.student,
    this.password,
    this.token,
    this.memorization,
    this.userName,
    this.tempPoints,
  });

  factory Person.create() {
    return Person(
      father: Father(state: CustomState.aliveId),
      mother: Mother(state: CustomState.aliveId),
      address: Address(),
      education: Education(),
      student: Student(state: CustomState.activeId),
      custom: Custom(
        assitantsGroups: const [],
        superVisorGroups: const [],
        moderatorGroups: const [],
        state: CustomState.activeId,
      ),
      kin: Kin(),
    );
  }

  @override
  List<Object?> get props => [id];

  factory Person.fromJson(Map<String, dynamic> json) {
    List<dynamic>? jsonTests = json['tests'];
    List<QuranTest>? pages =
        jsonTests?.map((page) => QuranTest.fromJson(page)).toList();
    return Person(
      id: json["ID_Person"],
      tests: pages,
      firstName: json["First_Name"],
      lastName: json["Last_Name"],
      midName: json["Mid_Name"],
      addName: json["Additional_Name"],
      birthDate: json["Birth_Date"],
      birthPlace: json["Birth_Place"],
      email: json["Email"],
      imageLink: json["Image_URL"],
      distinguishingSigns: json["Distinguishing_Signs"],
      note: json["Note"],
      memorization: json["Memoraization"],
      userName: json["UserName"],
      token: json["api_token"],
      tempPoints: json["Temp_Points"]?.toString() ?? "0",
      primaryNumber: json["call_phone"]?["Number"],
      whatsappNumber: json["social_phone"]?["Number"],
      createDate: json["created_at"],
      personState: json["State"],
      job: json["job"]?["Job_Name"],
      education: json["education"] == null
          ? Education()
          : Education.fromJson(json["education"]),
      address: json["address"] == null
          ? Address()
          : Address.fromJson(json["address"]),
      mother:
          json["mother"] == null ? Mother() : Mother.fromJson(json["mother"]),
      kin: json["kin"] == null ? Kin() : Kin.fromJson(json["kin"]),
      father:
          json["father"] == null ? Father() : Father.fromJson(json["father"]),
      points: json["Points"]?.toString() ?? "0",
      custom: json["permission"] == null
          ? Custom()
          : Custom.fromJson(json["permission"]),
      student: json["student"] == null
          ? Student()
          : Student.fromJson(json["student"]),
      password: json["Password"],
    );
  }

  Person copy() {
    return Person(
      addName: addName,
      address: address?.copy(),
      birthDate: birthDate,
      birthPlace: birthPlace,
      createDate: createDate,
      custom: custom?.copy(),
      distinguishingSigns: distinguishingSigns,
      education: education?.copy(),
      email: email,
      father: father?.copy(),
      firstName: firstName,
      id: id,
      imageLink: imageLink,
      job: job,
      kin: kin?.copy(),
      lastName: lastName,
      memorization: memorization,
      midName: midName,
      mother: mother?.copy(),
      note: note,
      password: password,
      personState: personState,
      points: points,
      primaryNumber: primaryNumber,
      student: student?.copy(),
      token: token,
      userName: userName,
      whatsappNumber: whatsappNumber,
      tempPoints: tempPoints,
      tests: tests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ID_Person": id,
      "First_Name": firstName,
      "Last_Name": lastName,
      "Mid_Name": midName,
      "Additional_Name": addName,
      "Birth_Date": birthDate,
      "Birth_Place": birthPlace,
      "Email": email,
      "Image_URL": imageLink,
      "Distinguishing_Signs": distinguishingSigns,
      "Note": note,
      "created_at": createDate,
      "Points": points,
      "Temp_Points": tempPoints,
      "Memoraization": memorization,
      "api_token": token,
      "UserName": userName,
      "State": personState,
      "job": job == null || job == ""
          ? null
          : {
              "ID_Job": null,
              "Job_Name": job,
            },
      "education":
          education?.educationTypeId == null ? null : education!.toJson(),
      "address": address?.toJson(),
      "mother": mother?.toJson(),
      "kin": kin?.toJson(),
      "father": father?.toJson(),
      "call_phone": primaryNumber == null || primaryNumber == ""
          ? null
          : {
              "ID_Phone": null,
              "Number": primaryNumber,
            },
      "social_phone": whatsappNumber == null || whatsappNumber == ""
          ? null
          : {
              "ID_Phone": null,
              "Number": whatsappNumber,
            },
      "permission": custom?.toJson(),
      "student": student?.toJson(),
      "Password": password,
      "tests": tests?.map((test) => test.toJson()).toList(),
    };
  }

  int get getTestsAvg {
    double avrg = 0;
    tests?.forEach((element) {
      avrg += (element.mark ?? -900000);
    });
    if (tests!.isNotEmpty) {
      avrg = avrg / tests!.length;
    }
    return avrg.ceil();
  }

  String getFullName({bool fromSearch = false}) {
    String name = "";
    name = "$firstName $lastName";
    if (fromSearch && father?.fatherName != null) {
      return "$name بن ${father?.fatherName}";
    } else {
      return name;
    }
  }
}
