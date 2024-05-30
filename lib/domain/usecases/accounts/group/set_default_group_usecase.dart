import 'package:dartz/dartz.dart';
import '../../../../data/errors/failures.dart';
import '../../../repositories/group_repo.dart';

class SetDefaultGroupUsecase {
  final GroupRepository repository;

  const SetDefaultGroupUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int? id) async {
    return await repository.setDefaultGroup(id);
  }
}
