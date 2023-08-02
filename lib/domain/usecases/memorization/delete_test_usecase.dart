import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../repositories/memorization_repo.dart';

class DeleteTestUsecase {
  final MemorizationRepository repository;

  DeleteTestUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteTest(id);
  }
}
