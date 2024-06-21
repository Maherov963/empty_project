import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/management/student.dart';
import 'package:dartz/dartz.dart';
import '../../domain/models/management/group.dart';
import '../../domain/repositories/group_repo.dart';
import '../datasources/remote_db/group_remote_repo.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _groupRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  GroupRepositoryImpl(
      this._groupRemoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Unit>> addGroup(Group group) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse =
            await _groupRemoteDataSource.addGroup(group, account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Unit>> deleteGroup(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse =
            await _groupRemoteDataSource.deleteGroup(id, account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Unit>> editGroup(Group group) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();

        final remoteResponse =
            await _groupRemoteDataSource.editGroup(group, account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Group>> getGroup(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse =
            await _groupRemoteDataSource.getGroup(id, account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, List<Group>>> getAllGroup() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();

        final remoteResponse =
            await _groupRemoteDataSource.getAllGroup(account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Unit>> setDefaultGroup(int? id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        account?.custom?.defaultGroup = id;
        await _localDataSource.cacheAccount(account!);
        final remoteResponse =
            await _groupRemoteDataSource.setDefaultGroup(id, account.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Unit>> evaluateStudents(List<Student> students) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _groupRemoteDataSource.evaluateStudents(
            students, account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Unit>> moveStudents(
      List<Student> students, int group) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _groupRemoteDataSource.moveStudents(
            students, group, account!.token!);
        return Right(remoteResponse);
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
  Future<Either<Failure, Unit>> setStudentsState(
      List<Student> students, int state) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _groupRemoteDataSource.setStudentsState(
            students, state, account!.token!);
        return Right(remoteResponse);
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
