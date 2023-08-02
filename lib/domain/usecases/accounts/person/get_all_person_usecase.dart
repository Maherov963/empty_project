import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/person.dart';
import '../../../repositories/person_repo.dart';

class GetAllPersonUsecase {
  final PersonRepository repository;

  GetAllPersonUsecase(this.repository);

  Future<Either<Failure, List<Person>>> call(Person? person) async {
    return await repository.getAllPerson(person);
  }
}
