import 'package:flutter_test/flutter_test.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';
import 'package:language_app/data/datasources/remote/language_remote_datasource.dart';
import 'package:language_app/data/models/language_model.dart';
import 'package:language_app/data/models/login_model.dart';
import 'package:language_app/data/models/register_model.dart';
import 'package:language_app/data/repo_imp/language_repo_imp.dart';
import 'package:language_app/domain/dtos/user_dto.dart';
import 'package:language_app/domain/models/available_language.dart';
import 'package:language_app/domain/models/language.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repos/user_repo.dart';

class MockLanguageRemoteDatasource implements LanguageRemoteDatasource {
  List<AvailableLanguage>? _availableLanguagesResponse;
  List<LanguageModel>? _userLanguagesResponse;

  void setGetAvailableLanguagesResponse(List<AvailableLanguage> response) {
    _availableLanguagesResponse = response;
  }

  void setGetUserLanguagesResponse(List<LanguageModel> response) {
    _userLanguagesResponse = response;
  }

  @override
  Future<List<AvailableLanguage>> getAvailableLanguages() async {
    return _availableLanguagesResponse ?? [];
  }

  @override
  Future<void> addUserLanguage(Map<String, dynamic> data) async {}

  @override
  Future<List<LanguageModel>> getUserLanguages() async {
    return _userLanguagesResponse ?? [];
  }
}

class MockUserRepo implements UserRepo {
  User? _userInfo;

  Future<void> setUserInfoMock(User? user) async {
    _userInfo = user;
  }

  @override
  Future<void> editUserInfo({required UserDTO data}) async {}

  @override
  Future<String?> getToken() async => null;
  @override
  Future<User?> getUserInfo() async => _userInfo;

  @override
  Future<User> login({required LoginModel data}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User> register({required RegisterModel data}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> setUserInfo({required User data}) async {
    _userInfo = data;
  }

  @override
  Stream<AppStateEnum> watchAppState() {
    return Stream.value(AppStateEnum.unauthenticated);
  }

  @override
  Stream<User?> watchUserInfo() {
    return Stream.value(_userInfo);
  }
  
  @override
  Future<void> triggerUserInfoUpdate() {
    // TODO: implement triggerUserInfoUpdate
    throw UnimplementedError();
  }
}

void main() {
  late LanguageRepoImpl languageRepo;
  late MockLanguageRemoteDatasource mockRemoteDatasource;
  late MockUserRepo mockUserRepo;

  setUp(() {
    mockRemoteDatasource = MockLanguageRemoteDatasource();
    mockUserRepo = MockUserRepo();
    languageRepo = LanguageRepoImpl(
      remoteDatasource: mockRemoteDatasource,
      userRepo: mockUserRepo,
    );
  });

  group('LanguageRepoImpl', () {
    group('getAvailableLanguages', () {
      test('should return list of available languages from remote datasource',
          () async {
        // Arrange
        final languages = [
          AvailableLanguage(
            id: '1',
            name: 'English',
            flagUrl: 'url1',
            code: 'en',
            description: 'English language',
          ),
          AvailableLanguage(
            id: '2',
            name: 'Spanish',
            flagUrl: 'url2',
            code: 'es',
            description: 'Spanish language',
          ),
        ];
        mockRemoteDatasource.setGetAvailableLanguagesResponse(languages);

        // Act
        final result = await languageRepo.getAvailableLanguages();

        // Assert
        expect(result, equals(languages));
      });
    });

    group('getUserLanguages', () {
      test('should return empty list when user info is null', () async {
        // Arrange
        await mockUserRepo.setUserInfoMock(null);

        // Act
        final result = await languageRepo.getUserLanguages();

        // Assert
        expect(result, isEmpty);
      });

      test('should return user languages when user info exists', () async {
        // Arrange
        final languages = [
          Language(languageId: '1', level: 1, experience: 100, flagUrl: 'url1'),
        ];
        final user = User(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          fullName: 'Test User',
          avatar: null,
          hearts: 5,
          experience: 0,
          streak: 0,
          languages: languages,
        );
        await mockUserRepo.setUserInfoMock(user);

        // Act
        final result = await languageRepo.getUserLanguages();

        // Assert
        expect(result, equals(languages));
      });
    });

    group('hasUserLanguages', () {
      test('should return false when user info is null', () async {
        // Arrange
        await mockUserRepo.setUserInfoMock(null);

        // Act
        final result = await languageRepo.hasUserLanguages();

        // Assert
        expect(result, isFalse);
      });

      test('should return true when user has languages', () async {
        // Arrange
        final user = User(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          fullName: 'Test User',
          avatar: null,
          hearts: 5,
          experience: 0,
          streak: 0,
          languages: [
            Language(
                languageId: '1', level: 1, experience: 100, flagUrl: 'url1'),
          ],
        );
        await mockUserRepo.setUserInfoMock(user);

        // Act
        final result = await languageRepo.hasUserLanguages();

        // Assert
        expect(result, isTrue);
      });
    });
  });
}
