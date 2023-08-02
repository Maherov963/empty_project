import 'package:dartz/dartz.dart';
import '../../../../data/errors/failures.dart';
import '../../../models/management/group.dart';
import '../../../repositories/group_repo.dart';

class GetAllGroupUsecase {
  final GroupRepository repository;

  GetAllGroupUsecase(this.repository);

  Future<Either<Failure, List<Group>>> call() async {
    return await repository.getAllGroup();
  }
}
