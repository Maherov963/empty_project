import 'package:dartz/dartz.dart';
import '../../../../data/errors/failures.dart';
import '../../../models/management/person.dart';
import '../../../repositories/person_repo.dart';

class GetStudentsForTestersUsecase {
  final PersonRepository repository;

  GetStudentsForTestersUsecase(this.repository);

  Future<Either<Failure, List<Person>>> call() async {
    return await repository.getStudentsForTesters();
  }
}
