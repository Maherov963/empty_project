import 'package:al_khalil/domain/models/management/student.dart';
import 'package:dartz/dartz.dart';
import '../../data/errors/failures.dart';
import '../models/management/group.dart';

abstract class GroupRepository {
  Future<Either<Failure, Unit>> addGroup(Group group);
  Future<Either<Failure, Unit>> editGroup(Group group);
  Future<Either<Failure, Unit>> deleteGroup(int id);
  Future<Either<Failure, Unit>> setDefaultGroup(int? id);
  Future<Either<Failure, Group>> getGroup(int id);
  Future<Either<Failure, List<Group>>> getAllGroup();

  Future<Either<Failure, Unit>> moveStudents(List<Student> students, int group);
  Future<Either<Failure, Unit>> evaluateStudents(List<Student> students);
  Future<Either<Failure, Unit>> setStudentsState(
      List<Student> students, int state);
}
