import 'package:al_khalil/domain/repositories/person_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../data/errors/failures.dart';
import '../../../models/management/custom.dart';

class EditPermissionUsecase {
  final PersonRepository repository;

  EditPermissionUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Custom custom) async {
    return await repository.editPermission(custom);
  }
}
