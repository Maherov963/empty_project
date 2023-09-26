import 'package:al_khalil/domain/models/memorization/meoms.dart';
import 'package:al_khalil/domain/usecases/memorization/delete_recite_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/get_memorization_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/get_test_in_date_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/recite_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/test_usecase.dart';
import 'package:flutter/material.dart';
import '../../../../domain/usecases/memorization/edit_recite_usecase.dart';
import '../../../../domain/usecases/memorization/edit_test_usecase.dart';
import '../../../domain/usecases/memorization/delete_test_usecase.dart';
import '../states/provider_states.dart';
import '../states/states_handler.dart';

class MemorizationProvider extends ChangeNotifier with StatesHandler {
  final GetMemorizationUsecase _getMemorizationUsecase;
  final GetTestInDateUsecase _getTestInDateUsecase;
  final ReciteUsecase _reciteUsecase;
  final TestUsecase _testUsecase;
  final EditTestUsecase _editTestUsecase;
  final EditReciteUsecase _editReciteUsecase;
  final DeleteReciteUsecase _deleteReciteUsecase;
  final DeleteTestUsecase _deleteTestUsecase;

  bool isLoadingIn = false;
  int? isLoadingMemo;

  MemorizationProvider(
    this._getMemorizationUsecase,
    this._reciteUsecase,
    this._testUsecase,
    this._editTestUsecase,
    this._editReciteUsecase,
    this._deleteReciteUsecase,
    this._deleteTestUsecase,
    this._getTestInDateUsecase,
  );

  Future<ProviderStates> getMemorization(int id) async {
    if (isLoadingMemo == null) {
      isLoadingMemo = id;
      notifyListeners();
      final failureOrMemorization = await _getMemorizationUsecase(id);
      isLoadingMemo = null;
      notifyListeners();
      return eitherQuranOrErrorState(failureOrMemorization);
    } else {
      return LoadingState();
    }
  }

  Future<ProviderStates> recite(Reciting reciting) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrID = await _reciteUsecase(reciting);
    isLoadingIn = false;
    notifyListeners();
    return eitherIdOrErrorState(failureOrID);
  }

  Future<ProviderStates> getTestsInDate(
      String? fistDate, String? lastDate) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrID = await _getTestInDateUsecase(fistDate, lastDate);
    isLoadingIn = false;
    notifyListeners();
    return eitherPersonsOrErrorState(failureOrID);
  }

  Future<ProviderStates> test(QuranTest quranTest) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrID = await _testUsecase(quranTest);
    isLoadingIn = false;
    notifyListeners();
    return eitherIdOrErrorState(failureOrID);
  }

  Future<ProviderStates> editTest(QuranTest quranTest) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _editTestUsecase(quranTest);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> editRecite(Reciting reciting) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _editReciteUsecase(reciting);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> deleteRecite(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _deleteReciteUsecase(id);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> deleteTest(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _deleteTestUsecase(id);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }
}
