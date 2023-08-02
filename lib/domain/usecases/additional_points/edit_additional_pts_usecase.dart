import 'package:al_khalil/domain/repositories/additional_pts_repo.dart';
import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/additional_points/addional_point.dart';

class EditAdditionalPtsUsecase {
  final AdditionalPointsRepository repository;

  EditAdditionalPtsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(AdditionalPoints additionalPoints) async {
    return await repository.editAdditionalPoints(additionalPoints);
  }
}
