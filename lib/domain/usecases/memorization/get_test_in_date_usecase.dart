import 'package:al_khalil/domain/models/management/person.dart';
import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../repositories/memorization_repo.dart';

class GetTestInDateUsecase {
  final MemorizationRepository repository;

  GetTestInDateUsecase(this.repository);

  Future<Either<Failure, List<Person>>> call(
      String? firstDate, String? lastDate) async {
    return await repository.getTestsInDateRange(firstDate, lastDate);
  }
}
