import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/additional_pts_repo.dart';
import '../datasources/remote_db/additional_points_remote_repo.dart';

class AdditionalPointsRepositoryImpl implements AdditionalPointsRepository {
  final AdditionalPointsRemoteDataSource _additionalPointsRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AdditionalPointsRepositoryImpl(this._additionalPointsRemoteDataSource,
      this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, int>> addAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _additionalPointsRemoteDataSource
            .addAdditionalPoints(additionalPoints, account!.token!);
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
  Future<Either<Failure, Unit>> deleteAdditionalPoints(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _additionalPointsRemoteDataSource
            .deleteAdditionalPoints(id, account!.token!);
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
  Future<Either<Failure, Unit>> editAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _additionalPointsRemoteDataSource
            .editAdditionalPoints(additionalPoints, account!.token!);
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
  Future<Either<Failure, List<AdditionalPoints>>> viewAddionalPoints(
      AdditionalPoints additionalPoints) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remoteResponse = await _additionalPointsRemoteDataSource
            .viewAddionalPoints(additionalPoints, account!.token!);
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
