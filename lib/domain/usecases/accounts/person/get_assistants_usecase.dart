import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/person.dart';
import '../../../repositories/person_repo.dart';

class GetAssistantsUsecase {
  final PersonRepository repository;

  GetAssistantsUsecase(this.repository);

  Future<Either<Failure, List<Person>>> call() async {
    return await repository.getAssistants();
  }
}
