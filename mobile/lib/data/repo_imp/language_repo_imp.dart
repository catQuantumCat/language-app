import 'package:language_app/data/datasources/remote/language_remote_datasource.dart';
import 'package:language_app/domain/models/available_language.dart';
import 'package:language_app/domain/models/language.dart';
import 'package:language_app/domain/models/user.dart';
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
    //TODO Patch to user info
    // await _remoteDatasource.addUserLanguage({'languageId': languageId});

    final User? user = await _userRepo.getUserInfo();
    //TODO: get flag url from remote datasource
    if (user != null) {
      final data = user.copyWith(languages: [
        Language(languageId: languageId, level: 0, experience: 0, flagUrl: '')
      ]);
      await _userRepo.setUserInfo(data: data);
    }
  }

  @override
  Future<List<AvailableLanguage>> getAvailableLanguages() async {
    return await _remoteDatasource.getAvailableLanguages();
  }

  @override
  Future<List<Language>> getUserLanguages() async {
    //TODO: separate user languages
    final info = await _userRepo.getUserInfo();
    return info?.languages ?? [];

    // final languageModels = await _remoteDatasource.getUserLanguages();
    // return languageModels.map((model) => model.toLanguage()).toList();
  }

  @override
  Future<bool> hasUserLanguages() async {
    try {
      final User? user = await _userRepo.getUserInfo();
      return user != null && user.languages.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
