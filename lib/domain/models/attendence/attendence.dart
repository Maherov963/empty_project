import 'package:al_khalil/domain/models/models.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Attendence extends Equatable {
  String? attendenceDate;
  int? groupId;
  int? activeStudentsCount;
  List<String>? dates;
  List<StudentAttendece>? studentAttendance;
  List<Group>? groups;
  Attendence({
    this.attendenceDate,
    this.groupId,
    this.activeStudentsCount,
    this.studentAttendance,
    this.groups,
    required this.dates,
  });
  static const List<int> allowed = [
    DateTime.saturday,
    DateTime.monday,
    DateTime.wednesday,
    DateTime.friday,
  ];

  factory Attendence.fromJson(Map<String, dynamic> json) {
    return Attendence(
      attendenceDate: json['attendenceDate'],
      activeStudentsCount: json['ActiveStudentsCount'],
      groupId: json['Group'],
      groups: (json['Groups'] as List?)
          ?.map((attendance) => Group.fromJson(attendance))
          .toList(),
      dates: (json['dates'] as List)
          .map((e) => e.toString().substring(0, 10))
          .toList()
        ..sort((a, b) => a.compareTo(b)),
      studentAttendance: (json['StudentAttendance'] as List)
          .map((attendance) => StudentAttendece.fromJson(attendance))
          .toList(),
    );
  }

  Attendence copy() {
    return Attendence(
      dates: dates,
      activeStudentsCount: activeStudentsCount,
      attendenceDate: attendenceDate,
      groupId: groupId,
      studentAttendance: studentAttendance?.map((e) => e.copy()).toList(),
      groups: groups?.map((e) => e.copy()).toList(),
    );
  }

  int? getAttendants() {
    return studentAttendance
        ?.where((element) => element.stateAttendance)
        .toList()
        .length;
  }

  List<StudentAttendece>? getAttendantsInGroup(int group, bool showAbsent) {
    return studentAttendance
        ?.where((element) =>
            (showAbsent ? true : element.stateAttendance) &&
            element.person?.student?.groubId == group)
        .toList();
  }

  int? getAbsents() {
    return studentAttendance
        ?.where((element) => !element.stateAttendance)
        .toList()
        .length;
  }

  Map<String, dynamic> toJson() {
    return {
      'attendenceDate': attendenceDate,
      'ActiveStudentsCount': activeStudentsCount,
      'Group': groupId,
      'dates': dates,
      'Groups': groups?.map((attendance) => attendance.toJson()).toList(),
      'StudentAttendance':
          studentAttendance?.map((attendance) => attendance.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        attendenceDate,
        groupId,
        studentAttendance,
      ];
}

// ignore: must_be_immutable
class StudentAttendece extends Equatable {
  static const String trueBool = "6";
  static const String falseBool = "7";
  Person? person;
  String? attendenceDate;
  bool stateGarrment;
  bool stateAttendance;
  bool stateBehavior;
  StudentAttendece({
    this.stateAttendance = false,
    this.stateBehavior = false,
    this.person,
    this.stateGarrment = false,
    this.attendenceDate,
  });
  factory StudentAttendece.fromJson(Map<String, dynamic> json) {
    return StudentAttendece(
      attendenceDate: json['created_at']?.toString().substring(0, 10),
      stateAttendance: json['State_Attendance'].toString() == trueBool,
      stateGarrment: json['State_Garrment'].toString() == trueBool,
      stateBehavior: json['State_Behavior'].toString() == trueBool,
      person: Person(
        id: json['student']?['ID_Person'],
        firstName: json['student']?['First_Name'],
        lastName: json['student']?['Last_Name'],
        student: json['student']?['student'] == null
            ? null
            : Student.fromJson(json['student']?['student']),
      ),
    );
  }
  StudentAttendece copy() {
    return StudentAttendece(
      person: person?.copy(),
      stateAttendance: stateAttendance,
      stateBehavior: stateBehavior,
      stateGarrment: stateGarrment,
      attendenceDate: attendenceDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': attendenceDate,
      'Students_Person_ID_Person': person?.id,
      'State_Attendance': stateAttendance ? trueBool : falseBool,
      'State_Garrment': stateGarrment ? trueBool : falseBool,
      'State_Behavior': stateBehavior ? trueBool : falseBool,
    };
  }

  @override
  List<Object?> get props => [
        person,
        stateAttendance,
        stateBehavior,
        stateGarrment,
      ];
}
