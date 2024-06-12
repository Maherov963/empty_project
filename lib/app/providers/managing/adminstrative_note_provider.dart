import 'package:al_khalil/domain/models/management/adminstrative_note.dart';
import 'package:al_khalil/domain/repositories/adminstrativen_note_repo.dart';
import 'package:flutter/material.dart';
import '../states/states_handler.dart';

class AdminstrativeNoteProvider extends ChangeNotifier with StatesHandler {
  final AdminstrativeNoteRepository _repositoryImpl;

  List<int> isLoadingIn = [];

  AdminstrativeNoteProvider(this._repositoryImpl);

  Future<ProviderStates> addAdminstrativeNote(AdminstrativeNote note) async {
    isLoadingIn.add(0);
    notifyListeners();
    final state = await _repositoryImpl.addAdminstrativeNote(note);
    isLoadingIn.remove(0);
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> deleteAdminstrativeNote(int id) async {
    isLoadingIn.add(id);
    notifyListeners();
    final state = await _repositoryImpl.deleteAdminstrativeNote(id);
    isLoadingIn.remove(id);

    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editAdminstrativeNote(AdminstrativeNote note) async {
    isLoadingIn.add(note.id!);
    notifyListeners();
    final state = await _repositoryImpl.editAdminstrativeNote(note);
    isLoadingIn.remove(note.id!);
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> viewAdminstrativeNote(AdminstrativeNote note) async {
    isLoadingIn.add(0);
    notifyListeners();
    final state = await _repositoryImpl.viewAdminstrativeNote(note);
    isLoadingIn.remove(0);
    notifyListeners();
    return failureOrDataToState(state);
  }
}
