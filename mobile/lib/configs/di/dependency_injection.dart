import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:language_app/common/constants/storage_keys.dart';
import 'package:language_app/configs/service_providers/dio_provider.dart';
import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:language_app/data/repo_imp/lesson_repo_imp.dart';
import 'package:language_app/data/repo_imp/user_repo_imp.dart';
import 'package:language_app/domain/repo/lesson_repo.dart';
import 'package:language_app/domain/repo/user_repo.dart';

abstract class DependencyInjection {
  static Future<void> setup(GetIt getIt) async {
    // Register Box
    getIt.registerSingletonAsync<Box<dynamic>>(
      () async => await Hive.openBox(StorageKeys.userBox),
    );

    // Register Dio with dependency on Box
    getIt.registerSingletonAsync<Dio>(
      () async => DioProvider(await getIt.getAsync<Box<dynamic>>()).dio,
      dependsOn: [Box],
    );

    // Register UserRemoteDatasource
    getIt.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasource(getIt<Dio>()),
    );

    // Register UserRepo
    getIt.registerLazySingleton<UserRepo>(
      () => UserRepoImpl(
        userBox: getIt<Box<dynamic>>(),
        remoteDatasource: getIt<UserRemoteDatasource>(),
      ),
    );

    // Register AuthBloc

    // Register LessonRemoteDatasource
    getIt.registerLazySingleton<LessonRemoteDatasource>(
      () => LessonRemoteDatasource(dio: getIt<Dio>()),
    );

    // Register LessonRepo
    getIt.registerLazySingleton<LessonRepo>(
      () => LessonRepoImp(
        remoteDatasource: getIt<LessonRemoteDatasource>(),
      ),
    );

    // Wait for async dependencies to be ready
    await getIt.allReady();
  }
}
