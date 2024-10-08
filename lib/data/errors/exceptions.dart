class ServerException implements Exception {
  final String message;

  ServerException({this.message = "ServerException"});
}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class NotLogedInException implements Exception {}

class PermissionException implements Exception {}

class UpdateException implements Exception {
  final String message;

  UpdateException({this.message = "WrongAuthFailure"});
}

class WrongAuthException implements Exception {
  final String message;

  WrongAuthException({this.message = "WrongAuthFailure"});
}

class UnKnownException implements Exception {}
