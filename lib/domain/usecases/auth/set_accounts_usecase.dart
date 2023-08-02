import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/management/person.dart';
import '../../repositories/auth_repo.dart';

class SetAccountsUsecase {
  final AuthRepository repository;

  SetAccountsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(List<Person> myAccounts) async {
    return await repository.setCachedAccounts(myAccounts);
  }
}
