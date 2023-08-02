import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:equatable/equatable.dart';
import '../../../data/errors/failures.dart';
import '../../../domain/models/attendence/attendence.dart';

abstract class ProviderStates extends Equatable {
  const ProviderStates();

  @override
  List<Object?> get props => [];
}

class InitialState extends ProviderStates {}

class LoadingState extends ProviderStates {}

class ErrorState extends ProviderStates {
  final Failure failure;

  const ErrorState({required this.failure});

  @override
  List<Object> get props => [failure];
}

class QuranState extends ProviderStates {
  final List<QuranSection> quranSections;

  const QuranState({required this.quranSections});

  @override
  List<Object> get props => [quranSections];
}

class IdState extends ProviderStates {
  final int id;

  const IdState({required this.id});

  @override
  List<Object> get props => [id];
}

class MessageState extends ProviderStates {
  final String message;

  const MessageState({this.message = "تمت العملية بنجاح"});

  @override
  List<Object> get props => [message];
}

class UserState extends ProviderStates {
  final User user;

  const UserState({required this.user});

  @override
  List<Object> get props => [user];
}

class PersonState extends ProviderStates {
  final Person person;

  const PersonState({required this.person});

  @override
  List<Object> get props => [person];
}

class PersonNullState extends ProviderStates {
  final Person? person;

  const PersonNullState({required this.person});

  @override
  List<Object?> get props => [person];
}

class PersonsState extends ProviderStates {
  final List<Person> persons;

  const PersonsState({required this.persons});

  @override
  List<Object> get props => [persons];
}

class GroupsState extends ProviderStates {
  final List<Group> groups;

  const GroupsState({required this.groups});

  @override
  List<Object> get props => [groups];
}

class GroupState extends ProviderStates {
  final Group group;

  const GroupState({required this.group});

  @override
  List<Object> get props => [group];
}

class AttendenceState extends ProviderStates {
  final Attendence attendence;

  const AttendenceState({required this.attendence});

  @override
  List<Object> get props => [attendence];
}

class StudentAttendenceState extends ProviderStates {
  final List<StudentAttendece> attendence;

  const StudentAttendenceState({required this.attendence});

  @override
  List<Object> get props => [attendence];
}

class AdditonalPtsState extends ProviderStates {
  final List<AdditionalPoints> additionalPoints;

  const AdditonalPtsState({required this.additionalPoints});

  @override
  List<Object> get props => [additionalPoints];
}

class PermissionState extends ProviderStates {}
