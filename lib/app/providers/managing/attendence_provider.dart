import 'package:al_khalil/domain/models/attendence/attendence.dart';
import 'package:al_khalil/domain/repositories/attendence_repo.dart';
import 'package:flutter/material.dart';
import '../states/states_handler.dart';

class AttendenceProvider extends ChangeNotifier with StatesHandler {
  final AttendenceRepository _repositoryImpl;

  bool isLoadingIn = false;

  AttendenceProvider(this._repositoryImpl);

  Future<ProviderStates> viewAttendence(int? groupId, String date) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.viewAttendence(date, groupId);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> viewStudentAttendence(int personId) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.viewStudentAttendence(personId);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> attendence(Attendence attendence) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.attendence(attendence);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }
}
