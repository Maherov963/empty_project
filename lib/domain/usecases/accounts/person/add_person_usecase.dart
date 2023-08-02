import 'package:al_khalil/domain/models/management/person.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../repositories/person_repo.dart';

class AddPersonUsecase {
  final PersonRepository repository;

  AddPersonUsecase(this.repository);

  Future<Either<Failure, int>> call(Person person) async {
    return await repository.addPerson(person);
  }
}
