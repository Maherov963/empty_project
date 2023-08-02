import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/custom.dart';
import '../../../repositories/person_repo.dart';

class AddPermissionUsecase {
  final PersonRepository repository;

  AddPermissionUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Custom custom) async {
    return await repository.addPermission(custom);
  }
}
