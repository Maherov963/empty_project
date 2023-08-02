import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:dartz/dartz.dart';
import '../../../repositories/group_repo.dart';

class EditGroupUsecase {
  final GroupRepository repository;

  EditGroupUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Group group) async {
    return await repository.editGroup(group);
  }
}
