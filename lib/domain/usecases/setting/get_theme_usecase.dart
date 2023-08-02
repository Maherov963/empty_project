import '../../repositories/setting_repo.dart';

class GetThemeUsecase {
  final SettingRepository repository;

  GetThemeUsecase(this.repository);

  Future<String> call() async {
    return await repository.getThemeMode();
  }
}
