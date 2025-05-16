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
  // @override
  // Future<void> addUserLanguage(String languageId) async {
  //   try {
  //     final availableLanguages =
  //         await _remoteDatasource.getAvailableLanguages();
  //     final selectedLanguage = availableLanguages.firstWhere(
  //       (lang) => lang.id == languageId,
  //       orElse: () => throw Exception('Language not found'),
  //     );

  //     final User? user = await _userRepo.getUserInfo();
  //     if (user == null) {
  //       throw Exception('User not found');
  //     }

  //     final existingLanguageIndex = user.languages.indexWhere(
  //       (lang) => lang.languageId == languageId,
  //     );

  //     List<Language> updatedLanguages;
  //     if (existingLanguageIndex != -1) {
  //       updatedLanguages = [...user.languages];
  //       final existingLanguage =
  //           updatedLanguages.removeAt(existingLanguageIndex);
  //       updatedLanguages.insert(0, existingLanguage);
  //     } else {
  //       final newLanguage = Language(
  //         languageId: languageId,
  //         languageFlag: selectedLanguage.flagUrl ?? '',
  //         order: 1,
  //         lessonOrder: 1,
  //       );
  //       updatedLanguages = [newLanguage, ...user.languages];
  //     }

  //     updatedLanguages = updatedLanguages
  //         .asMap()
  //         .map((index, lang) {
  //           return MapEntry(
  //             index,
  //             Language(
  //               languageId: lang.languageId,
  //               languageFlag: lang.languageFlag,
  //               order: index + 1,
  //               lessonOrder: lang.lessonOrder,
  //             ),
  //           );
  //         })
  //         .values
  //         .toList();

  //     final languagesJson = updatedLanguages
  //         .map((lang) => {
  //               'languageId': lang.languageId,
  //               'languageFlag': lang.languageFlag,
  //               'order': lang.order,
  //               'lessonOrder': lang.lessonOrder,
  //             })
  //         .toList();

  //     log(languagesJson.toString());

  //     final updatedUser = await _userRepo.updateUserProfile(
  //       user.id,
  //       UpdateProfileDto(
  //         languages: languagesJson,
  //         lastSelectedLanguage: languageId,
  //       ),
  //     );

  //     // Update local user info
  //     await _userRepo.setUserInfo(data: updatedUser);
  //   } catch (e) {
  //     // If there's an error, ensure we clean up any partial state
  //     final User? user = await _userRepo.getUserInfo();
  //     if (user != null) {
  //       final updatedLanguages = user.languages
  //           .where((lang) => lang.languageId != languageId)
  //           .toList();
  //       final updatedUser = user.copyWith(languages: updatedLanguages);
  //       await _userRepo.setUserInfo(data: updatedUser);
  //     }
  //     rethrow;
  //   }
  // }

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
