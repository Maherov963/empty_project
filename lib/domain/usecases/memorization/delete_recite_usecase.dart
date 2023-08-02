import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../repositories/memorization_repo.dart';

class DeleteReciteUsecase {
  final MemorizationRepository repository;

  DeleteReciteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteRecite(id);
  }
}
