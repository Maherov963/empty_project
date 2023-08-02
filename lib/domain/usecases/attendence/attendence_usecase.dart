import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/attendence/attendence.dart';
import '../../repositories/attendence_repo.dart';

class AttendenceUsecase {
  final AttendenceRepository repository;

  AttendenceUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Attendence attendence) async {
    return await repository.attendence(attendence);
  }
}
