import 'package:al_khalil/domain/models/management/person.dart';
import 'package:dartz/dartz.dart';
import '../../data/errors/failures.dart';
import '../../domain/models/memorization/meoms.dart';

abstract class MemorizationRepository {
  Future<Either<Failure, Unit>> editTest(QuranTest quranTest);
  Future<Either<Failure, int>> test(QuranTest quranTest);
  Future<Either<Failure, Unit>> editRecite(Reciting quranPage);
  Future<Either<Failure, Unit>> deleteRecite(int id);
  Future<Either<Failure, Unit>> deleteTest(int id);
  Future<Either<Failure, int>> recite(Reciting quranPage);
  Future<Either<Failure, List<QuranSection>>> getMemorization(int id);
  Future<Either<Failure, List<Person>>> getTestsInDateRange(
      String? firstDate, String? lastDate);
}
