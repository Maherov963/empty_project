import 'package:al_khalil/domain/repositories/person_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/student.dart';

class EditStudentUsecase {
  final PersonRepository repository;

  EditStudentUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Student student) async {
    return await repository.editStudent(student);
  }
}
