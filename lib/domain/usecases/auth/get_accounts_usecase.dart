import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';
import '../../models/management/person.dart';
import '../../repositories/auth_repo.dart';

class GetAccountsUsecase {
  final AuthRepository repository;

  GetAccountsUsecase(this.repository);

  Future<Either<Failure, List<Person>>> call() async {
    return await repository.getCachedAccounts();
  }
}
