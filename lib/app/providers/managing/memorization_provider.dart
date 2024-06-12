import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/domain/repositories/memorization_repo.dart';
import 'package:flutter/material.dart';
import '../states/states_handler.dart';

class MemorizationProvider extends ChangeNotifier with StatesHandler {
  final MemorizationRepository _repositoryImpl;

  bool isLoadingIn = false;

  MemorizationProvider(this._repositoryImpl);

  Future<ProviderStates> getMemorization(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getMemorization(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> recite(Reciting reciting) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.recite(reciting);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> getTestsInDate(
      String? fistDate, String? lastDate) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.getTestsInDateRange(fistDate, lastDate);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> test(QuranTest quranTest) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.test(quranTest);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editTest(QuranTest quranTest) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.editTest(quranTest);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> editRecite(Reciting reciting) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.editRecite(reciting);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> deleteRecite(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.deleteRecite(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }

  Future<ProviderStates> deleteTest(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final state = await _repositoryImpl.deleteTest(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(state);
  }
}
