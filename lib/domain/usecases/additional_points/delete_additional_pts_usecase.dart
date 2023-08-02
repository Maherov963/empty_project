import 'package:al_khalil/domain/repositories/additional_pts_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';

class DeleteAdditionalPtsUsecase {
  final AdditionalPointsRepository repository;

  DeleteAdditionalPtsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteAdditionalPoints(id);
  }
}
