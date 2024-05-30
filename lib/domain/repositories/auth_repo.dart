import 'package:al_khalil/data/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../models/models.dart';

abstract class AuthRepository {
  Future<Either<Failure, Person>> logIn(User user);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, Person?>> getCachedAccount();
  Future<Either<Failure, List<Person>>> getCachedAccounts();
  Future<Either<Failure, Unit>> setCachedAccounts(List<Person> myAccount);
  Future<Either<Failure, Unit>> setCachedAccount(Person myAccount);
}
