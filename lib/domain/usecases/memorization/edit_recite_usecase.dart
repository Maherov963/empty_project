import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/memorization/meoms.dart';
import '../../repositories/memorization_repo.dart';

class EditReciteUsecase {
  final MemorizationRepository repository;

  EditReciteUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Reciting reciting) async {
    return await repository.editRecite(reciting);
  }
}
