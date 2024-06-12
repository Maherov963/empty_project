import 'package:dartz/dartz.dart';
import '../../data/errors/failures.dart';
import '../models/attendence/attendence.dart';

abstract class AttendenceRepository {
  Future<Either<Failure, Unit>> attendence(Attendence attendence);
  Future<Either<Failure, Attendence>> viewAttendence(String date, int? groupId);
  Future<Either<Failure, List<StudentAttendece>>> viewStudentAttendence(
      int personId);
}
