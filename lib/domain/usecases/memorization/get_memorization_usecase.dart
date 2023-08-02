import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/memorization/meoms.dart';
import '../../repositories/memorization_repo.dart';

class GetMemorizationUsecase {
  final MemorizationRepository repository;

  GetMemorizationUsecase(this.repository);

  Future<Either<Failure, List<QuranSection>>> call(int id) async {
    return await repository.getMemorization(id);
  }
}
