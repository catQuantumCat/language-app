import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:language_app/common/constants/storage_keys.dart';
import 'package:language_app/configs/service_providers/dio_provider.dart';
import 'package:language_app/data/datasources/local/user_local_datasource.dart';
import 'package:language_app/data/datasources/remote/language_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:language_app/data/repo_imp/language_repo_imp.dart';
import 'package:language_app/data/repo_imp/lesson_repo_imp.dart';
import 'package:language_app/data/repo_imp/user_repo_imp.dart';
import 'package:language_app/domain/repos/language_repo.dart';
import 'package:language_app/domain/repos/lesson_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/domain/use_cases/home_screen_fetch_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DependencyInjection {
  static Future<void> setup(GetIt getIt) async {
    getIt.registerSingletonAsync<Box<dynamic>>(
      () async => await Hive.openBox(StorageKeys.userBox),
    );

    getIt.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance(),
    );

    getIt.registerSingletonAsync<Dio>(
      () async => DioProvider(await getIt.getAsync<Box<dynamic>>()).dio,
      dependsOn: [Box],
    );

    getIt.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasource(getIt<Dio>()),
    );

    getIt.registerLazySingleton<UserLocalDatasource>(
      () => UserLocalDatasource(userBox: getIt<Box<dynamic>>()),
    );

    getIt.registerLazySingleton<UserRepo>(
      () => UserRepoImpl(
        localDatasource: getIt<UserLocalDatasource>(),
        remoteDatasource: getIt<UserRemoteDatasource>(),
      ),
    );

    getIt.registerLazySingleton<HomeScreenFetchUseCase>(
      () => HomeScreenFetchUseCase(
        prefs: getIt<SharedPreferences>(),
        lessonRepo: getIt<LessonRepo>(),
      ),
    );

    getIt.registerLazySingleton<LanguageRemoteDatasource>(
      () => LanguageRemoteDatasource(getIt<Dio>()),
    );

    getIt.registerLazySingleton<LanguageRepo>(
      () => LanguageRepoImpl(
        remoteDatasource: getIt<LanguageRemoteDatasource>(),
        userRepo: getIt<UserRepo>(),
      ),
    );
    
    getIt.registerLazySingleton<LessonRemoteDatasource>(
      () => LessonRemoteDatasource(getIt<Dio>()),
    );

    getIt.registerLazySingleton<LessonRepo>(
      () => LessonRepoImp(
        remoteDatasource: getIt<LessonRemoteDatasource>(),
      ),
    );

    await getIt.allReady();
  }
}
