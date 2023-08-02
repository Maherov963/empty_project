import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/person.dart';
import '../../../repositories/person_repo.dart';

class GetPersonUsecase {
  final PersonRepository repository;

  GetPersonUsecase(this.repository);

  Future<Either<Failure, Person>> call(int id) async {
    return await repository.getPerson(id);
  }
}
