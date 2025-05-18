import 'package:language_app/data/datasources/remote/language_remote_datasource.dart';

import 'package:language_app/domain/models/available_language.dart';
import 'package:language_app/domain/models/language.dart';

import 'package:language_app/domain/repos/language_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';

class LanguageRepoImpl implements LanguageRepo {
  final LanguageRemoteDatasource _remoteDatasource;
  final UserRepo _userRepo;

  LanguageRepoImpl({
    required LanguageRemoteDatasource remoteDatasource,
    required UserRepo userRepo,
  })  : _remoteDatasource = remoteDatasource,
        _userRepo = userRepo;

  @override
  Future<void> addUserLanguage(String languageId) async {
    final user = await _userRepo.getUserInfo();
    if (user == null) {
      throw Exception('User not found');
    }

    await _remoteDatasource.updateUserLanguage(user.id, {
      'languageId': languageId,
    });

    final userInfo = await _userRepo.getUserInfo();
    if (userInfo == null) {
      throw Exception('User not found');
    }

    await _userRepo.forceUpdateUserProfile();
    return;
  }

  @override
  Future<List<AvailableLanguage>> getAvailableLanguages() async {
    return await _remoteDatasource.getAvailableLanguages();
  }

  @override
  Future<List<Language>> getUserLanguages() async {
    final languageModels = await _remoteDatasource.getUserLanguages();
    return languageModels.map((model) => model.toLanguage()).toList();
  }

  @override
  Future<bool> hasUserLanguages() async {
    try {
      final languages = await getUserLanguages();
      return languages.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
