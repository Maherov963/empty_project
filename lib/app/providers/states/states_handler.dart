import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';

mixin StatesHandler {
  ProviderStates failureOrDataToState<T>(Either<Failure, T> either) {
    return either.fold(
      (failure) => ErrorState(failure: failure),
      (data) => DataState<T>(
        data: data,
      ),
    );
  }
}

abstract class ProviderStates {
  const ProviderStates();
}

class ErrorState extends ProviderStates {
  final Failure failure;

  const ErrorState({required this.failure});
}

class DataState<T> extends ProviderStates {
  final T data;

  DataState({required this.data});
}
