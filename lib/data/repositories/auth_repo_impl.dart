import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/datasources/remote_db/auth_remote_repo.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/personality/user.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:al_khalil/domain/repositories/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
      this._authRemoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Person>> logIn(User user) async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteUser = await _authRemoteDataSource.logIn(user);
        remoteUser.password = user.passWord;
        await _localDataSource.cacheAccount(remoteUser);
        return Right(remoteUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on WrongAuthException catch (e) {
        return Left(WrongAuthFailure(message: e.message));
      } on Exception catch (e) {
        return Left(UnKnownFailure(message: e.toString()));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _localDataSource.signOut();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on WrongAuthException catch (e) {
      return Left(WrongAuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Person?>> getCachedAccount() async {
    try {
      Person? cachedAcc = await _localDataSource.getCachedAccount();
      return Right(cachedAcc);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on WrongAuthException catch (e) {
      return Left(WrongAuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Person>>> getCachedAccounts() async {
    try {
      List<Person> cachedAcc = await _localDataSource.getCachedAccounts();
      return Right(cachedAcc);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on WrongAuthException catch (e) {
      return Left(WrongAuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCachedAccounts(
      List<Person> myAccounts) async {
    try {
      final cachedAcc = await _localDataSource.cacheAccounts(myAccounts);
      return Right(cachedAcc);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on WrongAuthException catch (e) {
      return Left(WrongAuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setCachedAccount(Person myAccount) async {
    try {
      final cachedAcc = await _localDataSource.cacheAccount(myAccount);
      return Right(cachedAcc);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on WrongAuthException catch (e) {
      return Left(WrongAuthFailure(message: e.message));
    } on Exception catch (e) {
      return Left(UnKnownFailure(message: e.toString()));
    }
  }
}
