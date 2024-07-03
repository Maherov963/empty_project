import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/datasources/remote_db/adminstrative_note_remote_repo.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/repositories/adminstrativen_note_repo.dart';
import 'package:dartz/dartz.dart';

class AdminstrativeNoteRepositoryImpl implements AdminstrativeNoteRepository {
  final AdminstrativeNoteRemoteDataSource _adminstrativeNoteRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AdminstrativeNoteRepositoryImpl(this._adminstrativeNoteRemoteDataSource,
      this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, int>> addAdminstrativeNote(
      AdminstrativeNote adminstrativeNote) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _adminstrativeNoteRemoteDataSource
            .addAdminstrativeNote(adminstrativeNote, account!.token!);
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
  Future<Either<Failure, Unit>> deleteAdminstrativeNote(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _adminstrativeNoteRemoteDataSource
            .deleteAdminstrativeNote(id, account!.token!);
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
  Future<Either<Failure, Unit>> editAdminstrativeNote(
      AdminstrativeNote adminstrativeNote) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _adminstrativeNoteRemoteDataSource
            .editAdminstrativeNote(adminstrativeNote, account!.token!);
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
  Future<Either<Failure, List<AdminstrativeNote>>> viewAdminstrativeNote(
      AdminstrativeNote adminstrativeNote) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _adminstrativeNoteRemoteDataSource
            .viewAdminstrativeNote(adminstrativeNote, account!.token!);
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
  Future<Either<Failure, List<AdminstrativeNote>>>
      viewAllAdminstrativeNote() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _adminstrativeNoteRemoteDataSource
            .viewAllAdminstrativeNote(account!.token!);
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
