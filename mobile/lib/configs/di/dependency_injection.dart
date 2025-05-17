import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:language_app/common/constants/storage_keys.dart';
import 'package:language_app/configs/service_providers/dio_provider.dart';
import 'package:language_app/data/datasources/local/user_local_datasource.dart';
import 'package:language_app/data/datasources/remote/knowledge_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/language_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/leaderboard_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/mistake_remote_datasource.dart';
import 'package:language_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:language_app/data/repo_imp/knowledge_repo_imp.dart';
import 'package:language_app/data/repo_imp/language_repo_imp.dart';
import 'package:language_app/data/repo_imp/leaderboard_repo_imp.dart';
import 'package:language_app/data/repo_imp/lesson_repo_imp.dart';
import 'package:language_app/data/repo_imp/mistake_repo_imp.dart';
import 'package:language_app/data/repo_imp/user_repo_imp.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';
import 'package:language_app/domain/repos/language_repo.dart';
import 'package:language_app/domain/repos/leaderboard_repo.dart';
import 'package:language_app/domain/repos/lesson_repo.dart';
import 'package:language_app/domain/repos/mistake_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/domain/use_cases/home_screen_fetch_use_case.dart';

import 'package:language_app/services/upload_service.dart';
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
        dio: getIt<Dio>(), // Thêm Dio
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

    // Register LeaderboardRemoteDatasource
    getIt.registerLazySingleton<LeaderboardRemoteDatasource>(
      () => LeaderboardRemoteDatasource(getIt<Dio>()),
    );

    // Register LeaderboardRepo
    getIt.registerLazySingleton<LeaderboardRepo>(
      () => LeaderboardRepoImpl(
        remoteDatasource: getIt<LeaderboardRemoteDatasource>(),
        userRepo: getIt<UserRepo>(),
      ),
    );
    // Register MistakeRemoteDatasource
    getIt.registerLazySingleton<MistakeRemoteDatasource>(
      () => MistakeRemoteDatasource(getIt<Dio>()),
    );

    // Register MistakeRepo
    getIt.registerLazySingleton<MistakeRepo>(
      () => MistakeRepoImpl(
        remoteDatasource: getIt<MistakeRemoteDatasource>(),
      ),
    );

    // Register KnowledgeRemoteDatasource
    getIt.registerLazySingleton<KnowledgeRemoteDatasource>(
      () => KnowledgeRemoteDatasource(getIt<Dio>()),
    );

    // Register KnowledgeRepo
    getIt.registerLazySingleton<KnowledgeRepo>(
      () => KnowledgeRepoImpl(
        remoteDatasource: getIt<KnowledgeRemoteDatasource>(),
      ),
    );
    getIt.registerLazySingleton<UploadService>(
      () => UploadService(getIt<Dio>()),
    );

    getIt.registerLazySingleton<AudioPlayer>(
      () => AudioPlayer(),
    );

    // Wait for async dependencies to be ready
    await getIt.allReady();
  }
}
