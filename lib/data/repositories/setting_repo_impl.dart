import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/setting_repo.dart';

class SettingRepositoryImpl implements SettingRepository {
  final LocalDataSource _localDataSource;

  SettingRepositoryImpl(
    this._localDataSource,
  );

  @override
  Future<String> getThemeMode() async {
    return await _localDataSource.getThemeMode();
  }

  @override
  Future<Unit> setThemeMode(String state) async {
    return await _localDataSource.setThemeMode(state);
  }
}
