import 'package:al_khalil/domain/models/additional_points/addional_point.dart';
import 'package:al_khalil/domain/repositories/additional_pts_repo.dart';
import 'package:flutter/material.dart';
import '../states/states_handler.dart';

class AdditionalPointsProvider extends ChangeNotifier with StatesHandler {
  final AdditionalPointsRepository _repositoryImpl;

  bool isLoadingIn = false;
  List<int> loadingQeuee = [];

  AdditionalPointsProvider(this._repositoryImpl);

  Future<ProviderStates> viewAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrAddionalPoints =
        await _repositoryImpl.viewAddionalPoints(additionalPoints);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(failureOrAddionalPoints);
  }

  Future<ProviderStates> setExchangePrice(int price) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrAddionalPoints =
        await _repositoryImpl.setPointsExchange(price);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(failureOrAddionalPoints);
  }

  Future<ProviderStates> getExchangePrice() async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrAddionalPoints = await _repositoryImpl.getPointsExchange();
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(failureOrAddionalPoints);
  }

  Future<ProviderStates> addAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    loadingQeuee.add(additionalPoints.recieverPep!.id!);
    notifyListeners();
    final failureOrId =
        await _repositoryImpl.addAdditionalPoints(additionalPoints);
    loadingQeuee.remove(additionalPoints.recieverPep!.id!);
    notifyListeners();
    return failureOrDataToState(failureOrId);
  }

  Future<ProviderStates> editAdditionalPoints(
      AdditionalPoints additionalPoints) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone =
        await _repositoryImpl.editAdditionalPoints(additionalPoints);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(failureOrDone);
  }

  Future<ProviderStates> deleteAdditionalPoints(int id) async {
    isLoadingIn = true;
    notifyListeners();
    final failureOrDone = await _repositoryImpl.deleteAdditionalPoints(id);
    isLoadingIn = false;
    notifyListeners();
    return failureOrDataToState(failureOrDone);
  }
}
