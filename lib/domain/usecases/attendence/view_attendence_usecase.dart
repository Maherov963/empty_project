import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/attendence/attendence.dart';
import '../../repositories/attendence_repo.dart';

class ViewAttendenceUsecase {
  final AttendenceRepository repository;

  ViewAttendenceUsecase(this.repository);

  Future<Either<Failure, Attendence>> call(String date, int groupId) async {
    return await repository.viewAttendence(date, groupId);
  }
}
