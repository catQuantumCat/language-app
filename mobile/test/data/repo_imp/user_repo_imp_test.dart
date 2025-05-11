import 'package:flutter_test/flutter_test.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';
import 'package:language_app/data/datasources/local/user_local_datasource.dart';
import 'package:language_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:language_app/data/models/auth_response_model.dart';
import 'package:language_app/data/models/login_model.dart';
import 'package:language_app/data/models/register_model.dart';
import 'package:language_app/data/repo_imp/user_repo_imp.dart';
import 'package:language_app/domain/models/user.dart';

class MockUserLocalDatasource implements UserLocalDatasource {
  String? _token;
  User? _userInfo;

  Future<void> setTokenMock(String? token) async {
    _token = token;
  }

  Future<void> setUserInfoMock(User? user) async {
    _userInfo = user;
  }

  @override
  Future<void> clearAll() async {
    _token = null;
    _userInfo = null;
  }

  @override
  Future<String?> getToken() async {
    return _token;
  }

  @override
  Stream<String?> getTokenStream() {
    return Stream.value(_token);
  }

  @override
  User? getUserInfo() {
    return _userInfo;
  }

  @override
  Stream<User?> getUserInfoStream() {
    return Stream.value(_userInfo);
  }

  @override
  Future<void> setToken({String? token}) async {
    _token = token;
  }

  @override
  Future<void> setUserInfo({required User data}) async {
    _userInfo = data;
  }
}

class MockUserRemoteDatasource implements UserRemoteDatasource {
  AuthResponseModel? _loginResponse;
  AuthResponseModel? _registerResponse;
  User? _profileResponse;

  void setLoginResponse(AuthResponseModel response) {
    _loginResponse = response;
  }

  void setRegisterResponse(AuthResponseModel response) {
    _registerResponse = response;
  }

  @override
  Future<AuthResponseModel> login(LoginModel data) async {
    if (_loginResponse == null) {
      throw Exception('Login response not set');
    }
    return _loginResponse!;
  }

  @override
  Future<AuthResponseModel> register(RegisterModel data) async {
    if (_registerResponse == null) {
      throw Exception('Register response not set');
    }
    return _registerResponse!;
  }
  
  @override
  Future<User> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }
}

void main() {
  late UserRepoImpl userRepo;
  late MockUserLocalDatasource mockLocalDatasource;
  late MockUserRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockLocalDatasource = MockUserLocalDatasource();
    mockRemoteDatasource = MockUserRemoteDatasource();
    userRepo = UserRepoImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
    );
  });

  group('UserRepoImpl', () {
    group('login', () {
      test('should store token and user info locally after successful login',
          () async {
        // Arrange
        final loginData = LoginModel(
          username: 'testuser',
          password: 'password',
        );
        final user = User(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          fullName: 'Test User',
          avatar: null,
          hearts: 5,
          experience: 0,
          streak: 0,
          languages: [],
        );
        final authResponse = AuthResponseModel(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          fullName: 'Test User',
          avatar: null,
          hearts: 5,
          experience: 0,
          streak: 0,
          languages: [],
          token: 'test_token',
        );
        mockRemoteDatasource.setLoginResponse(authResponse);

        // Act
        final result = await userRepo.login(data: loginData);

        // Assert
        expect(result, equals(authResponse.toUser()));
      });
    });

    group('register', () {
      test(
          'should store token and user info locally after successful registration',
          () async {
        // Arrange
        final registerData = RegisterModel(
          email: 'test@test.com',
          password: 'password',
          username: 'testuser',
          fullName: 'Test User',
        );
        final user = User(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          fullName: 'Test User',
          avatar: null,
          hearts: 5,
          experience: 0,
          streak: 0,
          languages: [],
        );
        final authResponse = AuthResponseModel(
          id: '1',
          username: 'testuser',
          email: 'test@test.com',
          fullName: 'Test User',
          avatar: null,
          hearts: 5,
          experience: 0,
          streak: 0,
          languages: [],
          token: 'test_token',
        );
        mockRemoteDatasource.setRegisterResponse(authResponse);

        // Act
        final result = await userRepo.register(data: registerData);

        // Assert
        expect(result, equals(authResponse.toUser()));
      });
    });

    group('getToken', () {
      test('should return token from local storage', () async {
        // Arrange
        const token = 'test_token';
        await mockLocalDatasource.setTokenMock(token);

        // Act
        final result = await userRepo.getToken();

        // Assert
        expect(result, equals(token));
      });
    });

    group('logout', () {
      test('should clear all data from local storage', () async {
        // Act
        await userRepo.logout();

        // Assert
        expect(mockLocalDatasource.getUserInfo(), isNull);
        expect(await mockLocalDatasource.getToken(), isNull);
      });
    });

    group('getUserInfo', () {
      test('should return user info from local storage', () {
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
          languages: [],
        );
        mockLocalDatasource.setUserInfoMock(user);

        // Act
        final result = userRepo.getUserInfo();

        // Assert
        expect(result, equals(user));
      });
    });

    group('watchAppState', () {
      test('should emit authenticated state when token exists', () async {
        // Arrange
        await mockLocalDatasource.setTokenMock('test_token');

        // Act
        final states = await userRepo.watchAppState().take(1).toList();

        // Assert
        expect(states, equals([AppStateEnum.authenticated]));
      });

      test('should emit unauthenticated state when token does not exist',
          () async {
        // Arrange
        await mockLocalDatasource.setTokenMock(null);

        // Act
        final states = await userRepo.watchAppState().take(1).toList();

        // Assert
        expect(states, equals([AppStateEnum.unauthenticated]));
      });
    });
  });
}
