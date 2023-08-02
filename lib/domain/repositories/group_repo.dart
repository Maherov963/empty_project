import 'package:dartz/dartz.dart';
import '../../data/errors/failures.dart';
import '../models/management/group.dart';

abstract class GroupRepository {
  Future<Either<Failure, Unit>> addGroup(Group group);
  Future<Either<Failure, Unit>> editGroup(Group group);
  Future<Either<Failure, Unit>> deleteGroup(int id);
  Future<Either<Failure, Group>> getGroup(int id);
  Future<Either<Failure, List<Group>>> getAllGroup();
}
