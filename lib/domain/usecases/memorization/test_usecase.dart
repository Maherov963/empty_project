import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/memorization/meoms.dart';
import '../../repositories/memorization_repo.dart';

class TestUsecase {
  final MemorizationRepository repository;

  TestUsecase(this.repository);

  Future<Either<Failure, int>> call(QuranTest quranTest) async {
    return await repository.test(quranTest);
  }
}
