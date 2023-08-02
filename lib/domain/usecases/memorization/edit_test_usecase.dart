import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/memorization/meoms.dart';
import '../../repositories/memorization_repo.dart';

class EditTestUsecase {
  final MemorizationRepository repository;

  EditTestUsecase(this.repository);

  Future<Either<Failure, Unit>> call(QuranTest quranTest) async {
    return await repository.editTest(quranTest);
  }
}
