import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:al_khalil/domain/models/management/custom.dart';
import 'package:al_khalil/domain/models/management/student.dart';
import 'package:al_khalil/domain/repositories/person_repo.dart';
import '../../domain/models/management/person.dart';
import '../datasources/remote_db/person_remote_repo.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource _personRemoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  PersonRepositoryImpl(
      this._personRemoteDataSource, this._localDataSource, this._networkInfo);

  @override
  Future<Either<Failure, int>> addPerson(Person person) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.addPerson(person, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> deletePerson(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.deletePerson(id, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> editPerson(Person person) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.editPerson(person, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, Person>> getPerson(int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();

        final remotePerson =
            await _personRemoteDataSource.getPerson(id, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getAllPerson(Person? person) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();

        final remotePerson = await _personRemoteDataSource
            .getAllPerson(account!.token!, person: person);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> addImage(String imageLink, int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson = await _personRemoteDataSource.addImage(
            imageLink, account!.token!, id);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> addPermission(Custom custom) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson = await _personRemoteDataSource.addPermission(
            custom, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> addStudent(Student student) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.addStudent(student, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> editPermission(Custom custom) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson = await _personRemoteDataSource.editPermission(
            custom, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, Unit>> editStudent(Student student) async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.editStudent(student, account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getAssistants() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.getAssistants(account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getModerators() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.getModerators(account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getSupervisors() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.getSupervisors(account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getTheAllPeople() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.getTheAllPerson(account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getTesters() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson =
            await _personRemoteDataSource.getTesters(account!.token!);
        return Right(remotePerson);
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
  Future<Either<Failure, List<Person>>> getStudentsForTesters() async {
    if (await _networkInfo.isConnected) {
      try {
        final account = await _localDataSource.getCachedAccount();
        final remotePerson = await _personRemoteDataSource
            .getStudentsForTesters(account!.token!);
        return Right(remotePerson);
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
