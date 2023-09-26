import 'dart:convert';
import 'package:al_khalil/app/providers/core_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:al_khalil/data/errors/exceptions.dart';
import 'package:al_khalil/domain/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<String> getThemeMode();
  Future<Unit> setThemeMode(String state);
  Future<Unit> signOut();
  Future<Unit> cacheAccount(Person myAccount);
  Future<Person?> getCachedAccount();
  Future<Unit> cacheAccounts(List<Person> myAccounts);
  Future<List<Person>> getCachedAccounts();
}

class LocalDataSourceImpl implements LocalDataSource {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<Unit> cacheAccount(Person account) async {
    await sharedPreferences.setString(
        "localAccount", json.encode(account.toJson()));
    return Future.value(unit);
  }

  @override
  Future<Person?> getCachedAccount() async {
    final jsonString = sharedPreferences.getString("localAccount");
    if (jsonString != null) {
      Person decodeJsonData = Person.fromJson(json.decode(jsonString));
      return Future.value(decodeJsonData);
    } else {
      throw NotLogedInException();
    }
  }

  @override
  Future<Unit> signOut() async {
    await sharedPreferences.remove("localAccount");
    return Future.value(unit);
  }

  @override
  Future<Unit> setThemeMode(String state) async {
    await sharedPreferences.setString("ThemeMode", state);
    return Future.value(unit);
  }

  @override
  Future<String> getThemeMode() async {
    final isDarkMode = sharedPreferences.getString("ThemeMode");
    if (isDarkMode == null) {
      setThemeMode(ThemeState.system);
      return Future.value(ThemeState.system);
    } else {
      return Future.value(isDarkMode);
    }
  }

  @override
  Future<Unit> cacheAccounts(List<Person> myAccounts) async {
    await sharedPreferences.setStringList("localAccounts",
        myAccounts.map((e) => jsonEncode(e.toJson())).toList());
    return Future.value(unit);
  }

  @override
  Future<List<Person>> getCachedAccounts() {
    final jsonString = sharedPreferences.getStringList("localAccounts");
    if (jsonString != null) {
      List<Person> decodeJsonData =
          jsonString.map((e) => Person.fromJson(jsonDecode(e))).toList();
      return Future.value(decodeJsonData);
    } else {
      throw NotLogedInException();
    }
  }
}
