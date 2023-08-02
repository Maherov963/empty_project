import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/memorization/meoms.dart';
import '../../repositories/memorization_repo.dart';

class ReciteUsecase {
  final MemorizationRepository repository;

  ReciteUsecase(this.repository);

  Future<Either<Failure, int>> call(Reciting reciting) async {
    return await repository.recite(reciting);
  }
}
