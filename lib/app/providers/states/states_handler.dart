import 'package:dartz/dartz.dart';
import '../../../data/errors/failures.dart';

// mixin class StatesHandler {
//   ProviderStates eitherDoneMessageOrErrorState(Either<Failure, Unit> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (_) => const MessageState(),
//     );
//   }

//   ProviderStates eitherGroupsOrErrorState(Either<Failure, List<Group>> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (groups) => GroupsState(groups: groups),
//     );
//   }

//   ProviderStates eitherPersonsOrErrorState(
//       Either<Failure, List<Person>> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (persons) => PersonsState(persons: persons),
//     );
//   }

//   ProviderStates eitherGroupOrErrorState(
//       Either<Failure, Group> either, String doneMessage) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (group) => GroupState(group: group),
//     );
//   }

//   ProviderStates eitherQuranOrErrorState(Either<Failure, Memorization> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (memorization) => QuranState(memorization: memorization),
//     );
//   }

//   ProviderStates eitherAttendenceStateOrErrorState(
//       Either<Failure, Attendence> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (attendence) => AttendenceState(attendence: attendence),
//     );
//   }

//   ProviderStates eitherStudentAttendenceStateOrErrorState(
//       Either<Failure, List<StudentAttendece>> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (attendence) => StudentAttendenceState(attendence: attendence),
//     );
//   }

//   ProviderStates eitherAddionalPtsStateOrErrorState(
//       Either<Failure, List<AdditionalPoints>> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (additionalPoints) =>
//           AdditonalPtsState(additionalPoints: additionalPoints),
//     );
//   }

//   ProviderStates eitherPersonOrErrorState(Either<Failure, Person> either) {
//     return either.fold(
//       (failure) => ErrorState(failure: failure),
//       (person) => PersonState(
//         person: person,
//       ),
//     );
//   }

//   ProviderStates eitherPersonOrErrorStateNullable(
//       Either<Failure, Person?> either) {
//     return either.fold(
//       (failure) => ErrorState(failure: failure),
//       (person) => PersonNullState(
//         person: person,
//       ),
//     );
//   }

//   ProviderStates failureOrUserToState(Either<Failure, User> either) {
//     return either.fold(
//       (failure) => ErrorState(failure: failure),
//       (user) => UserState(
//         user: user,
//       ),
//     );
//   }

//   ProviderStates eitherIdOrErrorState(Either<Failure, int> either) {
//     return either.fold(
//       (failure) => ErrorState(
//         failure: failure,
//       ),
//       (id) => IdState(id: id),
//     );
//   }
// }

mixin StatesHandler {
  ProviderStates failureOrDataToState<T>(Either<Failure, T> either) {
    return either.fold(
      (failure) => ErrorState(failure: failure),
      (data) => DataState<T>(
        data: data,
      ),
    );
  }

  // ProviderStates failureOrDoneToState(Either<Failure, Unit> either) {
  //   return either.fold(
  //     (failure) => ErrorState(failure: failure),
  //     (_) => DoneState(),
  //   );
  // }
}

abstract class ProviderStates {
  const ProviderStates();
}

// class DoneState extends ProviderStates {}

class ErrorState extends ProviderStates {
  final Failure failure;

  const ErrorState({required this.failure});
}

class DataState<T> extends ProviderStates {
  final T data;

  DataState({required this.data});
}
