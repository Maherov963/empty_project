import 'package:al_khalil/app/providers/managing/additional_points_provider.dart';
import 'package:al_khalil/app/providers/managing/group_provider.dart';
import 'package:al_khalil/app/providers/managing/person_provider.dart';
import 'package:al_khalil/app/providers/timer_provider.dart';
import 'package:al_khalil/data/datasources/local_db/shared_pref.dart';
import 'package:al_khalil/data/datasources/remote_db/attendence_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/auth_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/group_remote_repo.dart';
import 'package:al_khalil/data/datasources/remote_db/person_remote_repo.dart';
import 'package:al_khalil/data/repositories/auth_repo_impl.dart';
import 'package:al_khalil/data/repositories/person_repo_impl.dart';
import 'package:al_khalil/device/network/network_checker.dart';
import 'package:al_khalil/domain/repositories/attendence_repo.dart';
import 'package:al_khalil/domain/repositories/auth_repo.dart';
import 'package:al_khalil/domain/repositories/setting_repo.dart';
import 'package:al_khalil/domain/usecases/accounts/group/add_group_usecase.dart';
import 'package:al_khalil/domain/usecases/accounts/group/edit_group_usecase.dart';
import 'package:al_khalil/domain/usecases/accounts/group/get_all_group_usecase.dart';
import 'package:al_khalil/domain/usecases/accounts/person/get_testers_usecase.dart';
import 'package:al_khalil/domain/usecases/accounts/person/person_usecases.dart';
import 'package:al_khalil/domain/usecases/attendence/attendence_usecase.dart';
import 'package:al_khalil/domain/usecases/auth/get_account_usecase.dart';
import 'package:al_khalil/domain/usecases/auth/get_accounts_usecase.dart';
import 'package:al_khalil/domain/usecases/auth/log_in_usecase.dart';
import 'package:al_khalil/domain/usecases/auth/sign_out_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/delete_recite_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/edit_recite_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/edit_test_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/get_memorization_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/get_test_in_date_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/recite_usecase.dart';
import 'package:al_khalil/domain/usecases/memorization/test_usecase.dart';
import 'package:al_khalil/domain/usecases/setting/get_theme_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import '../app/providers/chat/chat_provider.dart';
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
import '../domain/usecases/accounts/group/get_group_usecase.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../domain/usecases/additional_points/additional_pts_usecases.dart';
import '../domain/usecases/attendence/view_attendence_usecase.dart';
import '../domain/usecases/attendence/view_student_attendence_usecase.dart';
import '../domain/usecases/auth/set_account_usecase.dart';
import '../domain/usecases/auth/set_accounts_usecase.dart';
import '../domain/usecases/memorization/delete_test_usecase.dart';
import '../domain/usecases/setting/set_theme_usecase.dart';

final sl = GetIt.I;
late final PackageInfo packageInfo;
Future<void> initInjections() async {
  //Providers
  sl.registerLazySingleton<PersonProvider>(() => PersonProvider(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<CoreProvider>(
      () => CoreProvider(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton<TimerProvider>(() => TimerProvider());
  sl.registerLazySingleton<GroupProvider>(
      () => GroupProvider(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton<AdditionalPointsProvider>(
      () => AdditionalPointsProvider(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton<AttendenceProvider>(() => AttendenceProvider(
        sl(),
        sl(),
        sl(),
      ));
  sl.registerLazySingleton<ChatProvider>(() => ChatProvider());

  sl.registerLazySingleton<MemorizationProvider>(() => MemorizationProvider(
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  //Useecases
  //auth
  sl.registerLazySingleton<GetAccountUsecase>(() => GetAccountUsecase(sl()));
  sl.registerLazySingleton<LogInUsecase>(() => LogInUsecase(sl()));
  sl.registerLazySingleton<SignOutUsecase>(() => SignOutUsecase(sl()));
  sl.registerLazySingleton<GetAccountsUsecase>(() => GetAccountsUsecase(sl()));
  sl.registerLazySingleton<SetAccountsUsecase>(() => SetAccountsUsecase(sl()));
  sl.registerLazySingleton<SetAccountUsecase>(() => SetAccountUsecase(sl()));
  //person
  sl.registerLazySingleton<AddPermissionUsecase>(
      () => AddPermissionUsecase(sl()));
  sl.registerLazySingleton<GetStudentsForTestersUsecase>(
      () => GetStudentsForTestersUsecase(sl()));
  sl.registerLazySingleton<AddPersonUsecase>(() => AddPersonUsecase(sl()));
  sl.registerLazySingleton<AddImageUsecase>(() => AddImageUsecase(sl()));
  sl.registerLazySingleton<AddStudentUsecase>(() => AddStudentUsecase(sl()));
  sl.registerLazySingleton<EditPermissionUsecase>(
      () => EditPermissionUsecase(sl()));
  sl.registerLazySingleton<EditPersonUsecase>(() => EditPersonUsecase(sl()));
  sl.registerLazySingleton<EditStudentUsecase>(() => EditStudentUsecase(sl()));
  sl.registerLazySingleton<GetModeratorsUsecase>(
      () => GetModeratorsUsecase(sl()));
  sl.registerLazySingleton<GetTestersUsecase>(() => GetTestersUsecase(sl()));
  sl.registerLazySingleton<GetAssistantsUsecase>(
      () => GetAssistantsUsecase(sl()));
  sl.registerLazySingleton<GetSupervisorsUsecase>(
      () => GetSupervisorsUsecase(sl()));
  sl.registerLazySingleton<DeletePersonUsecase>(
      () => DeletePersonUsecase(sl()));
  sl.registerLazySingleton<GetAllPersonUsecase>(
      () => GetAllPersonUsecase(sl()));
  sl.registerLazySingleton<GetPersonUsecase>(() => GetPersonUsecase(sl()));
  sl.registerLazySingleton<GetTheAllPersonUsecase>(
      () => GetTheAllPersonUsecase(sl()));
  //group
  sl.registerLazySingleton<AddGroupUsecase>(() => AddGroupUsecase(sl()));
  sl.registerLazySingleton<GetAllGroupUsecase>(() => GetAllGroupUsecase(sl()));
  sl.registerLazySingleton<EditGroupUsecase>(() => EditGroupUsecase(sl()));
  sl.registerLazySingleton<GetGroupUsecase>(() => GetGroupUsecase(sl()));
  //memorization
  sl.registerLazySingleton<GetMemorizationUsecase>(
      () => GetMemorizationUsecase(sl()));
  sl.registerLazySingleton<ReciteUsecase>(() => ReciteUsecase(sl()));
  sl.registerLazySingleton<GetTestInDateUsecase>(
      () => GetTestInDateUsecase(sl()));
  sl.registerLazySingleton<EditReciteUsecase>(() => EditReciteUsecase(sl()));
  sl.registerLazySingleton<TestUsecase>(() => TestUsecase(sl()));
  sl.registerLazySingleton<EditTestUsecase>(() => EditTestUsecase(sl()));
  sl.registerLazySingleton<DeleteReciteUsecase>(
      () => DeleteReciteUsecase(sl()));
  sl.registerLazySingleton<DeleteTestUsecase>(() => DeleteTestUsecase(sl()));
  //attendence
  sl.registerLazySingleton<AttendenceUsecase>(() => AttendenceUsecase(sl()));
  sl.registerLazySingleton<ViewStudentAttendenceUsecase>(
      () => ViewStudentAttendenceUsecase(sl()));
  sl.registerLazySingleton<ViewAttendenceUsecase>(
      () => ViewAttendenceUsecase(sl()));
  //setting
  sl.registerLazySingleton<GetThemeUsecase>(() => GetThemeUsecase(sl()));
  sl.registerLazySingleton<SetThemeUsecase>(() => SetThemeUsecase(sl()));
  //additional_points
  sl.registerLazySingleton<AddAdditionalPtsUsecase>(
      () => AddAdditionalPtsUsecase(sl()));
  sl.registerLazySingleton<EditAdditionalPtsUsecase>(
      () => EditAdditionalPtsUsecase(sl()));
  sl.registerLazySingleton<DeleteAdditionalPtsUsecase>(
      () => DeleteAdditionalPtsUsecase(sl()));
  sl.registerLazySingleton<ViewAdditionalPtsUsecase>(
      () => ViewAdditionalPtsUsecase(sl()));

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
  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton<Client>(() => Client());
  packageInfo = await PackageInfo.fromPlatform();
  await LocalDataSourceImpl.init();
}
