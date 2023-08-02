import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/attendence_repo.dart';
import '../datasources/remote_db/attendence_remote_repo.dart';

class AttendenceRepositoryImpl implements AttendenceRepository {
  final AttendenceRemoteDataSource _attendenceRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AttendenceRepositoryImpl(this._attendenceRemoteDataSource,
      this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Unit>> attendence(Attendence attendence) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteAttendence = await _attendenceRemoteDataSource.attendence(
            attendence, account!.token!);
        return Right(remoteAttendence);
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
  Future<Either<Failure, Attendence>> viewAttendence(
      String date, int groupId) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteAttendence = await _attendenceRemoteDataSource
            .viewAttendence(date, groupId, account!.token!);
        return Right(remoteAttendence);
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
  Future<Either<Failure, List<StudentAttendece>>> viewStudentAttendence(
      int personId) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteAttendence = await _attendenceRemoteDataSource
            .viewStudentAttendence(personId, account!.token!);
        return Right(remoteAttendence);
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
}
