import 'package:language_app/domain/models/available_language.dart';
import 'package:language_app/domain/models/language.dart';

abstract class LanguageRepo {
  // Get all available languages that users can select
  Future<List<AvailableLanguage>> getAvailableLanguages();

  // Get languages that a user has already selected
  Future<List<Language>> getUserLanguages();

  // Add a new language to the user's profile
  Future<void> addUserLanguage(String languageId);

  // Check if a user has any languages
  Future<bool> hasUserLanguages();
}
