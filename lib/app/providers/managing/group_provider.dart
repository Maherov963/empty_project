import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/domain/repositories/group_repo.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/management/group.dart';

class GroupProvider extends ChangeNotifier with StatesHandler {
  final GroupRepository _repositoryImpl;
  bool isLoadingIn = false;
  int? isLoadingGroup;
  List<Group> groups = [];
  int totalStudent = 0;

  GroupProvider(this._repositoryImpl);

  Future<ProviderStates> getGroup(int id) async {
    isLoadingGroup = id;
    notifyListeners();
    final state = await _repositoryImpl.getGroup(id);
    isLoadingGroup = null;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getAllGroups() async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getAllGroup();
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> addGroup(Group group) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.addGroup(group);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> setDefaultGroup(int? id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.setDefaultGroup(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editGroup(Group group) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.editGroup(group);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }
}