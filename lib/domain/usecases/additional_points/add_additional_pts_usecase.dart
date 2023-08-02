import 'package:al_khalil/domain/repositories/additional_pts_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/additional_points/addional_point.dart';

class AddAdditionalPtsUsecase {
  final AdditionalPointsRepository repository;

  AddAdditionalPtsUsecase(this.repository);

  Future<Either<Failure, int>> call(AdditionalPoints additionalPoints) async {
    return await repository.addAdditionalPoints(additionalPoints);
  }
}
