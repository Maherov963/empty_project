import 'package:dartz/dartz.dart';

import '../../../data/errors/failures.dart';
import '../../repositories/auth_repo.dart';

class SignOutUsecase {
  final AuthRepository repository;

  SignOutUsecase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.signOut();
  }
}
