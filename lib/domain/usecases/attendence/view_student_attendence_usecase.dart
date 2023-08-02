import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/attendence/attendence.dart';
import '../../repositories/attendence_repo.dart';

class ViewStudentAttendenceUsecase {
  final AttendenceRepository repository;

  ViewStudentAttendenceUsecase(this.repository);

  Future<Either<Failure, List<StudentAttendece>>> call(int personId) async {
    return await repository.viewStudentAttendence(personId);
  }
}
