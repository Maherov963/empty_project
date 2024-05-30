import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({this.message = ""});

  @override
  List<Object?> get props => [message];
}

class OfflineFailure extends Failure {
  const OfflineFailure({super.message = "لا يوجد إنترنت"});
}

class UpdateFailure extends Failure {
  const UpdateFailure({super.message = "يرجى تحديث التطبيق"});
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = "ServerFailure"});
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure({super.message = "EmptyCacheFailure"});
}

class NotLogedInFailure extends Failure {
  const NotLogedInFailure({super.message = "NotLogedInFailure"});
}

class PermissionFailure extends Failure {
  const PermissionFailure({super.message = "PermissionFailure"});
}

class WrongAuthFailure extends Failure {
  const WrongAuthFailure({super.message = "WrongAuthFailure"});
}

class UnKnownFailure extends Failure {
  const UnKnownFailure({super.message = "UnKnownFailure"});
}
