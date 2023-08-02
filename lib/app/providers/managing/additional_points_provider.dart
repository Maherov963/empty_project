import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:flutter/material.dart';
import '../../../domain/usecases/additional_points/additional_pts_usecases.dart';
import '../states/provider_states.dart';
import '../states/states_handler.dart';

class AdditionalPointsProvider extends ChangeNotifier with StatesHandler {
  final AddAdditionalPtsUsecase _addAdditionalPtsUsecase;
  final EditAdditionalPtsUsecase _editAdditionalPtsUsecase;
  final DeleteAdditionalPtsUsecase _deleteAdditionalPtsUsecase;
  final ViewAdditionalPtsUsecase _viewAdditionalPtsUsecase;

  bool isLoadingIn = false;
  int? isLoadingPts;

  AdditionalPointsProvider(
    this._addAdditionalPtsUsecase,
    this._editAdditionalPtsUsecase,
    this._deleteAdditionalPtsUsecase,
    this._viewAdditionalPtsUsecase,
  );

  Future<ProviderStates> viewAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    if (isLoadingPts == null) {
      isLoadingPts = additionalPoints.recieverPep?.id ?? 0;
      notifyListeners();
      final failureOrAddionalPoints =
          await _viewAdditionalPtsUsecase(additionalPoints);
      isLoadingPts = null;
      notifyListeners();
      return eitherAddionalPtsStateOrErrorState(failureOrAddionalPoints);
    } else {
      return LoadingState();
    }
  }

  Future<ProviderStates> addAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrId = await _addAdditionalPtsUsecase(additionalPoints);
    isLoadingIn = false;
    notifyListeners();
    return eitherIdOrErrorState(failureOrId);
  }

  Future<ProviderStates> editAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _editAdditionalPtsUsecase(additionalPoints);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }

  Future<ProviderStates> deleteAdditionalPoints(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _deleteAdditionalPtsUsecase(id);
    isLoadingIn = false;
    notifyListeners();
    return eitherDoneMessageOrErrorState(failureOrDone);
  }
}
