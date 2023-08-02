import 'package:al_khalil/domain/repositories/person_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/models.dart';

class GetModeratorsUsecase {
  final PersonRepository repository;

  GetModeratorsUsecase(this.repository);

  Future<Either<Failure, List<Person>>> call() async {
    return await repository.getModerators();
  }
}
