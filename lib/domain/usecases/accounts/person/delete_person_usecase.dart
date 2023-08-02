import 'package:al_khalil/domain/repositories/person_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';

class DeletePersonUsecase {
  final PersonRepository repository;

  DeletePersonUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deletePerson(id);
  }
}
