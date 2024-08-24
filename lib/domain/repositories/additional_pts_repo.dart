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
  Future<Either<Failure, int>> getPointsExchange();
  Future<Either<Failure, Unit>> setPointsExchange(int price);
  Future<Either<Failure, Unit>> addEachAdditionalPoints(
      List<AdditionalPoints> additionalPoint);
  Future<Either<Failure, String>> addPhoneAdditionalPoints(
      AdditionalPoints additionalPoints);
}
