import 'package:dartz/dartz.dart';

abstract class SettingRepository {
  Future<String> getThemeMode();
  Future<Unit> setThemeMode(String state);
}
