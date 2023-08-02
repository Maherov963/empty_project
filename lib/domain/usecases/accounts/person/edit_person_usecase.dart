import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/person.dart';
import '../../../repositories/person_repo.dart';

class EditPersonUsecase {
  final PersonRepository repository;

  EditPersonUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Person person) async {
    return await repository.editPerson(person);
  }
}
