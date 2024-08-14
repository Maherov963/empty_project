// Future<dynamic> helperFunction() async {
//   if (await _networkInfo.isConnected) {
//     try {
//       final account = await _localDataSource.getCachedAccount();
//       final remoteResponse =
//           await _personRemoteDataSource.addPerson(person, account!.token!);
//       return Right(remoteResponse);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(message: e.message));
//     } on UpdateException catch (e) {
//       return Left(UpdateFailure(message: e.message));
//     } on WrongAuthException catch (e) {
//       return Left(WrongAuthFailure(message: e.message));
//     } on Exception catch (e) {
//       return Left(UnKnownFailure(message: e.toString()));
//     }
//   } else {
//     return const Left(OfflineFailure());
//   }
// }
