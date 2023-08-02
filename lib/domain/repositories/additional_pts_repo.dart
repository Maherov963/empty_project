import 'package:al_khalil/data/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/additional_points/addional_point.dart';

abstract class AdditionalPointsRepository {
  Future<Either<Failure, List<AdditionalPoints>>> viewAddionalPoints(
      AdditionalPoints additionalPoints);
  Future<Either<Failure, int>> addAdditionalPoints(
      AdditionalPoints additionalPoints);
  Future<Either<Failure, Unit>> editAdditionalPoints(
      AdditionalPoints additionalPoints);
  Future<Either<Failure, Unit>> deleteAdditionalPoints(int id);
}
