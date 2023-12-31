import 'package:al_khalil/app/providers/states/provider_states.dart';
import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/domain/usecases/accounts/group/edit_group_usecase.dart';
import 'package:flutter/material.dart';
import '../../../../domain/models/management/group.dart';
import '../../../../domain/usecases/accounts/group/add_group_usecase.dart';
import '../../../../domain/usecases/accounts/group/get_all_group_usecase.dart';
import '../../../../domain/usecases/accounts/group/get_group_usecase.dart';

class GroupProvider extends ChangeNotifier with StatesHandler {
  final AddGroupUsecase _addGroupUsecase;
  final EditGroupUsecase _editGroupUsecase;
  final GetAllGroupUsecase _getAllGroupUsecase;
  final GetGroupUsecase _getGroupUsecase;
  bool isLoadingIn = false;
  int? isLoadingGroup;
  List<Group> groups = [];
  int totalStudent = 0;

  GroupProvider(this._addGroupUsecase, this._getAllGroupUsecase,
      this._editGroupUsecase, this._getGroupUsecase);
  Future<ProviderStates> getGroup(int id) async {
    if (isLoadingGroup == null) {
      isLoadingGroup = id;
      notifyListeners();
      final failureOrGroup = await _getGroupUsecase(id);
      isLoadingGroup = null;
      notifyListeners();
      return eitherGroupOrErrorState(failureOrGroup, "تمت عملية التعديل بنجاح");
    } else {
      return LoadingState();
    }
  }

  Future<ProviderStates> getAllGroups() async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrGroups = await _getAllGroupUsecase();
    isLoadingIn = false;
    notifyListeners();
    return eitherGroupsOrErrorState(failureOrGroups);
  }

  Future<ProviderStates> addGroup(Group group) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _addGroupUsecase(group);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> editGroup(Group group) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _editGroupUsecase(group);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }
}
