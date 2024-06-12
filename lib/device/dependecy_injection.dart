import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/adminstrative_note_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/datasources/remote_db/adminstrative_note_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/attendence_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/auth_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/group_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/person_remote_repo.dart';
import 'package:al_khalil/data/repositories/adminstrativen_note_repo_impl.dart';
import 'package:al_khalil/data/repositories/auth_repo_impl.dart';
import 'package:al_khalil/data/repositories/person_repo_impl.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/domain/repositories/adminstrativen_note_repo.dart';
import 'package:al_khalil/domain/repositories/attendence_repo.dart';
import 'package:al_khalil/domain/repositories/auth_repo.dart';
import 'package:al_khalil/domain/repositories/setting_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import '../app/providers/core_provider.dart';
import '../app/providers/managing/attendence_provider.dart';
import '../app/providers/managing/memorization_provider.dart';
import '../data/datasources/remote_db/additional_points_remote_repo.dart';
import '../data/datasources/remote_db/memorization_remote.repo.dart';
import '../data/repositories/additional_pts_repo_impl.dart';
import '../data/repositories/attendence_repo_impl.dart';
import '../data/repositories/group_repo_impl.dart';
import '../data/repositories/memorization_repo_impl.dart';
import '../data/repositories/setting_repo_impl.dart';
import '../domain/repositories/additional_pts_repo.dart';
import '../domain/repositories/group_repo.dart';
import '../domain/repositories/memorization_repo.dart';
import '../domain/repositories/person_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';

final sl = GetIt.instance;

late final PackageInfo packageInfo;

Future<void> initInjections() async {
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<Client>(() => Client());
  packageInfo = await PackageInfo.fromPlatform();
  await LocalDataSourceImpl.init();

  //Datasources
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AdditionalPointsRemoteDataSource>(
      () => AdditionalPointsRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PersonRemoteDataSource>(
      () => PersonRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<GroupRemoteDataSource>(
      () => GroupRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<MemorizationRemoteDataSource>(
      () => MemorizationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AttendenceRemoteDataSource>(
      () => AttendenceRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AdminstrativeNoteRemoteDataSource>(
      () => AdminstrativeNoteRemoteDataSourceImpl(sl()));

  //Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<MemorizationRepository>(
      () => MemorizationRepositoryImpl(
            sl(),
            sl(),
            sl(),
          ));
  sl.registerLazySingleton<AdditionalPointsRepository>(
      () => AdditionalPointsRepositoryImpl(
            sl(),
            sl(),
            sl(),
          ));
  sl.registerLazySingleton<AttendenceRepository>(() => AttendenceRepositoryImpl(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<SettingRepository>(() => SettingRepositoryImpl(
        sl(),
      ));
  sl.registerLazySingleton<AdminstrativeNoteRepository>(
      () => AdminstrativeNoteRepositoryImpl(sl(), sl(), sl()));

  //Providers
  sl.registerLazySingleton<PersonProvider>(() => PersonProvider(sl()));
  sl.registerLazySingleton<CoreProvider>(() => CoreProvider(sl(), sl()));
  sl.registerLazySingleton<GroupProvider>(() => GroupProvider(sl()));
  sl.registerLazySingleton<AdminstrativeNoteProvider>(
      () => AdminstrativeNoteProvider(sl()));
  sl.registerLazySingleton<AdditionalPointsProvider>(
      () => AdditionalPointsProvider(sl()));
  sl.registerLazySingleton<AttendenceProvider>(() => AttendenceProvider(sl()));
  sl.registerLazySingleton<MemorizationProvider>(
      () => MemorizationProvider(sl()));
}
