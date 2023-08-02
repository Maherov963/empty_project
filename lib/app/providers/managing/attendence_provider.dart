import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:flutter/material.dart';
import '../../../../domain/usecases/attendence/attendence_usecase.dart';
import '../../../../domain/usecases/attendence/view_attendence_usecase.dart';
import '../../../domain/usecases/attendence/view_student_attendence_usecase.dart';
import '../states/provider_states.dart';
import '../states/states_handler.dart';

class AttendenceProvider extends ChangeNotifier with StatesHandler {
  final ViewAttendenceUsecase _viewAttendenceUsecase;
  final AttendenceUsecase _attendenceUsecase;
  final ViewStudentAttendenceUsecase _viewStudentAttendenceUsecase;

  bool isLoadingIn = false;
  int? isLoadingStAtt;

  AttendenceProvider(
    this._viewAttendenceUsecase,
    this._attendenceUsecase,
    this._viewStudentAttendenceUsecase,
  );

  Future<ProviderStates> viewAttendence(int groupId, String date) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrAttendence = await _viewAttendenceUsecase(date, groupId);
    isLoadingIn = false;
    notifyListeners();
    return eitherAttendenceStateOrErrorState(failureOrAttendence);
  }

  Future<ProviderStates> viewStudentAttendence(int personId) async {
    if (isLoadingStAtt == null) {
      isLoadingStAtt = personId;
      notifyListeners();
      final failureOrAttendence = await _viewStudentAttendenceUsecase(personId);
      isLoadingStAtt = null;
      notifyListeners();
      return eitherStudentAttendenceStateOrErrorState(failureOrAttendence);
    } else {
      return LoadingState();
    }
  }

  Future<ProviderStates> attendence(Attendence attendence) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _attendenceUsecase(attendence);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }
}
