import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/management/person.dart';
import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/memorization_repo.dart';
import '../datasources/remote_db/memorization_remote.repo.dart';

class MemorizationRepositoryImpl implements MemorizationRepository {
  final MemorizationRemoteDataSource _memorizationRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  MemorizationRepositoryImpl(this._memorizationRemoteDataSource,
      this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<QuranSection>>> getMemorization(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource.viewMemorization(
            id, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
      } on WrongAuthException catch (e) {
        return Left(WrongAuthFailure(message: e.message));
      }
      // catch (e) {
      //   print(e);
      //   return Left(UnKnownFailure(message: e.toString()));
      // }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> editRecite(Reciting recitation) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource.editRecite(
            recitation, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
      } on WrongAuthException catch (e) {
        return Left(WrongAuthFailure(message: e.message));
      } catch (e) {
        return Left(UnKnownFailure(message: e.toString()));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> editTest(QuranTest quranTest) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource.editTest(
            quranTest, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
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
  Future<Either<Failure, int>> recite(Reciting recitation) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource.recite(
            recitation, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
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
  Future<Either<Failure, int>> test(QuranTest quranTest) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource.test(
            quranTest, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
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
  Future<Either<Failure, Unit>> deleteRecite(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource.deleteRecite(
            id, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
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
  Future<Either<Failure, Unit>> deleteTest(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo =
            await _memorizationRemoteDataSource.deleteTest(id, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
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
  Future<Either<Failure, List<Person>>> getTestsInDateRange(
      String? firstDate, String? lastDate) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteMemo = await _memorizationRemoteDataSource
            .getTestsInDateRange(firstDate, lastDate, account!.token!);
        return Right(remoteMemo);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UpdateException catch (e) {
        return Left(UpdateFailure(message: e.message));
      } on WrongAuthException catch (e) {
        return Left(WrongAuthFailure(message: e.message));
      } on Exception catch (e) {
        return Left(UnKnownFailure(message: e.toString()));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
