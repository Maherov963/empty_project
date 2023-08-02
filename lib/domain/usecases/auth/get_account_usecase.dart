import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/management/person.dart';
import '../../repositories/auth_repo.dart';

class GetAccountUsecase {
  final AuthRepository repository;

  GetAccountUsecase(this.repository);

  Future<Either<Failure, Person?>> call() async {
    return await repository.getCachedAccount();
  }
}
