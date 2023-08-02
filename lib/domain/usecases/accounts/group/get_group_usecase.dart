import 'package:dartz/dartz.dart';
import '../../../../data/errors/failures.dart';
import '../../../models/management/group.dart';
import '../../../repositories/group_repo.dart';

class GetGroupUsecase {
  final GroupRepository repository;

  GetGroupUsecase(this.repository);

  Future<Either<Failure, Group>> call(int id) async {
    return await repository.getGroup(id);
  }
}
