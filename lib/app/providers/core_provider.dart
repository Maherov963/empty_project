import 'package:al_khalil/app/providers/states/states_handler.dart';
import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/errors/failures.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:al_khalil/domain/models/static/id_name_model.dart';
import 'package:al_khalil/domain/usecases/auth/get_account_usecase.dart';
import 'package:al_khalil/domain/usecases/auth/log_in_usecase.dart';
import 'package:al_khalil/domain/usecases/auth/sign_out_usecase.dart';
import 'package:flutter/material.dart';
import '../../domain/usecases/auth/get_accounts_usecase.dart';
import '../../domain/usecases/auth/set_account_usecase.dart';
import '../../domain/usecases/auth/set_accounts_usecase.dart';
import '../../domain/usecases/setting/get_theme_usecase.dart';
import '../../domain/usecases/setting/set_theme_usecase.dart';
import 'states/provider_states.dart';

class CoreProvider extends ChangeNotifier with StatesHandler {
  final LogInUsecase _logInUsecase;
  final SignOutUsecase _signOutUsecase;
  final GetThemeUsecase _getThemeUsecase;
  final SetThemeUsecase _setThemeUsecase;
  final GetAccountUsecase _getAccountUsecase;
  final GetAccountsUsecase _getAccountsUsecase;
  final SetAccountsUsecase _setAccountsUsecase;
  final SetAccountUsecase _setAccountUsecase;

  int? isLoggingIn;

  String themeState = ThemeState.dark;
  String? local = "ar";
  Person? myAccount;
  List<Person> myAccounts = [];
  List<int> allowed = [
    DateTime.saturday,
    DateTime.monday,
    DateTime.wednesday,
    DateTime.friday,
  ];
  List<IdNameModel> parentsStates = [
    IdNameModel(id: 3, name: "على قيد الحياة"),
    IdNameModel(id: 4, name: "متوفى"),
    IdNameModel(id: 5, name: "غير ذلك"),
  ];
  List<IdNameModel> groupStates = [
    IdNameModel(id: 2, name: "نشط"),
    IdNameModel(id: 1, name: "غير نشط"),
  ];
  List<String> educationTypes = [
    "الصف الأول",
    "الصف الثاني",
    "الصف الثالث",
    "الصف الرابع",
    "الصف الخامس",
    "الصف السادس",
    "الصف السابع",
    "الصف الثامن",
    "الصف التاسع",
    "الصف العاشر",
    "الصف الحادي عشر",
    "بكالوريا",
    "جامعي",
    "متخرج",
    "لا يدرس",
  ];

  CoreProvider(
    this._logInUsecase,
    this._signOutUsecase,
    this._getAccountUsecase,
    this._getThemeUsecase,
    this._setThemeUsecase,
    this._getAccountsUsecase,
    this._setAccountsUsecase,
    this._setAccountUsecase,
  );

  Future<ProviderStates> initialState() async {
    isLoggingIn = 0;
    notifyListeners();
    final cashedAccount =
        eitherPersonOrErrorStateNullable(await _getAccountUsecase());
    if (cashedAccount is PersonNullState) {
      final failureOrMessage = await _logInUsecase(User(
        passWord: cashedAccount.person!.password,
        userName: cashedAccount.person!.userName,
      ));
      isLoggingIn = null;
      notifyListeners();
      return eitherPersonOrErrorState(failureOrMessage);
    } else {
      isLoggingIn = null;
      notifyListeners();
      return const ErrorState(failure: NotLogedInFailure());
    }
  }

  Future<void> getCashedAccount() async {
    final failureOrPersons = await _getAccountUsecase();
    final state = eitherPersonOrErrorStateNullable(failureOrPersons);
    if (state is PersonNullState) {
      myAccount = state.person;
    }
  }

  Future<ProviderStates> signOut() async {
    final failureOrDoneMessage = await _signOutUsecase();
    myAccounts.remove(myAccount);
    await setCashedAccounts();
    myAccount = null;
    return eitherDoneMessageOrErrorState(failureOrDoneMessage);
  }

  Future<void> setTheme(String state) async {
    themeState = state;
    await _setThemeUsecase(state);
    notifyListeners();
  }

  Future<void> getTheme() async {
    themeState = await _getThemeUsecase();
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
    final failureOrPerson = await _logInUsecase(user);
    isLoggingIn = null;
    notifyListeners();
    return eitherPersonOrErrorState(failureOrPerson);
  }

  Future<void> getCashedAccounts() async {
    final failureOrPersons = await _getAccountsUsecase();
    final state = eitherPersonsOrErrorState(failureOrPersons);
    if (state is PersonsState) {
      myAccounts = state.persons;
    }
  }

  Future<ProviderStates> setCashedAccounts() async {
    final failureOrPerson = await _setAccountsUsecase(myAccounts);
    return eitherDoneMessageOrErrorState(failureOrPerson);
  }

  Future<void> removeAccount(Person account) async {
    myAccounts.remove(account);
    await setCashedAccounts();
    notifyListeners();
  }

  Future<ProviderStates> setCashedAccount() async {
    final failureOrPerson = await _setAccountUsecase(myAccount!);
    myAccounts.firstWhere((e) => e.id == myAccount!.id).password =
        myAccount!.password;
    await _setAccountsUsecase(myAccounts);
    return eitherDoneMessageOrErrorState(failureOrPerson);
  }
}

abstract class ThemeState {
  static const String dark = "DARK";
  static const String light = "LIGHT";
  static const String system = "SYSTEM";
  static const List<String> value = [dark, light, system];
}
