import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/domain/repositories/auth_repo.dart';
import 'package:al_khalil/domain/repositories/setting_repo.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:flutter/material.dart';

class CoreProvider extends ChangeNotifier with StatesHandler {
  final AuthRepository _authRepositoryImpl;
  final SettingRepository _settingRepositoryImpl;
  CoreProvider(this._authRepositoryImpl, this._settingRepositoryImpl);

  int? isLoggingIn;

  String themeState = ThemeState.dark;
  String? local = "ar";
  Person? myAccount;
  List<Person> myAccounts = [];
  Custom get myPermission => myAccount!.custom!;
  Future<ProviderStates> initialState() async {
    isLoggingIn = 0;
    notifyListeners();
    final cashedAccount =
        failureOrDataToState(await _authRepositoryImpl.getCachedAccount());
    if (cashedAccount is DataState<Person?>) {
      final failureOrMessage = await _authRepositoryImpl.logIn(User(
        passWord: cashedAccount.data!.password,
        userName: cashedAccount.data!.userName,
      ));
      isLoggingIn = null;
      notifyListeners();
      return failureOrDataToState(failureOrMessage);
    } else {
      isLoggingIn = null;
      notifyListeners();
      return const ErrorState(failure: NotLogedInFailure());
    }
  }

  Future<void> getCashedAccount() async {
    final failureOrPersons = await _authRepositoryImpl.getCachedAccount();
    final state = failureOrDataToState(failureOrPersons);
    if (state is DataState<Person?>) {
      myAccount = state.data;
    }
  }

  Future<ProviderStates> signOut() async {
    final failureOrDoneMessage = await _authRepositoryImpl.signOut();
    myAccounts.remove(myAccount);
    await setCashedAccounts();
    myAccount = null;
    return failureOrDataToState(failureOrDoneMessage);
  }

  Future<void> setTheme(String state) async {
    themeState = state;
    await _settingRepositoryImpl.setThemeMode(state);
    notifyListeners();
  }

  Future<void> getTheme() async {
    themeState = await _settingRepositoryImpl.getThemeMode();
    notifyListeners();
  }

  Future<void> setLocale(String? locale) async {
    local = locale;
    if (locale != null) {
      await LocalDataSourceImpl.sharedPreferences.setString("locale", locale);
    } else {
      await LocalDataSourceImpl.sharedPreferences.remove("locale");
    }

    notifyListeners();
  }

  getLocale() async {
    local = LocalDataSourceImpl.sharedPreferences.getString("locale");
    notifyListeners();
  }

  Future<ProviderStates> logIn(User user) async {
    isLoggingIn = user.id;
    notifyListeners();
    final failureOrPerson = await _authRepositoryImpl.logIn(user);
    isLoggingIn = null;
    notifyListeners();
    return failureOrDataToState(failureOrPerson);
  }

  Future<void> getCashedAccounts() async {
    final failureOrPersons = await _authRepositoryImpl.getCachedAccounts();
    final state = failureOrDataToState(failureOrPersons);
    if (state is DataState<List<Person>>) {
      myAccounts = state.data;
    }
  }

  Future<ProviderStates> setCashedAccounts() async {
    final failureOrPerson =
        await _authRepositoryImpl.setCachedAccounts(myAccounts);
    return failureOrDataToState(failureOrPerson);
  }

  Future<void> removeAccount(Person account) async {
    myAccounts.remove(account);
    await setCashedAccounts();
    notifyListeners();
  }

  Future<ProviderStates> setCashedAccount() async {
    final failureOrPerson =
        await _authRepositoryImpl.setCachedAccount(myAccount!);
    myAccounts.firstWhere((e) => e.id == myAccount!.id).password =
        myAccount!.password;
    await _authRepositoryImpl.setCachedAccounts(myAccounts);
    return failureOrDataToState(failureOrPerson);
  }
}

abstract class ThemeState {
  static const String dark = "DARK";
  static const String light = "LIGHT";
  static const String system = "SYSTEM";
  static const List<String> value = [dark, light, system];
}
