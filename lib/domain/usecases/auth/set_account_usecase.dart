import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/management/person.dart';
import '../../repositories/auth_repo.dart';

class SetAccountUsecase {
  final AuthRepository repository;

  SetAccountUsecase(this.repository);

  Future<Either<Failure, Unit>> call(Person myAccounts) async {
    return await repository.setCachedAccount(myAccounts);
  }
}
