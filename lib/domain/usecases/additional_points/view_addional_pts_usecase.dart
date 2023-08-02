import 'package:al_khalil/domain/repositories/additional_pts_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/additional_points/addional_point.dart';

class ViewAdditionalPtsUsecase {
  final AdditionalPointsRepository repository;

  ViewAdditionalPtsUsecase(this.repository);

  Future<Either<Failure, List<AdditionalPoints>>> call(
      AdditionalPoints additionalPoints) async {
    return await repository.viewAddionalPoints(additionalPoints);
  }
}
