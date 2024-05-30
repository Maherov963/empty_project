import 'package:dartz/dartz.dart';
import '../../../../data/errors/failures.dart';
import '../../../models/management/group.dart';
import '../../../repositories/group_repo.dart';

class AddGroupUsecase {
  final GroupRepository repository;

  AddGroupUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Group group) async {
    return await repository.addGroup(group);
  }
}
