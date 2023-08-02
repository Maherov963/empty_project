import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/student.dart';
import '../../../repositories/person_repo.dart';

class AddStudentUsecase {
  final PersonRepository repository;

  AddStudentUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Student student) async {
    return await repository.addStudent(student);
  }
}
