// data/repo_imp/user_repo_imp.dart (cập nhật)
import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/common/enums/auth_state_enum.dart';
import 'package:language_app/data/datasources/local/user_local_datasource.dart';
import 'package:language_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:language_app/data/models/auth_response_model.dart';
import 'package:language_app/data/models/login_model.dart';
import 'package:language_app/data/models/register_model.dart';
import 'package:language_app/domain/dtos/update_profile_dto.dart';
import 'package:language_app/domain/models/user.dart';

import 'package:language_app/domain/models/user_rank_info.dart';
import 'package:language_app/domain/repos/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final UserLocalDatasource _localDatasource;
  final UserRemoteDatasource _remoteDatasource;
  final Dio _dio; // Thêm Dio
  final StreamController<AppStateEnum> _appStateController =
      StreamController<AppStateEnum>();

  final StreamController<User?> _userInfoController =
      StreamController<User?>.broadcast();
  UserRepoImpl({
    required UserLocalDatasource localDatasource,
    required UserRemoteDatasource remoteDatasource,
    required Dio dio,
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _dio = dio {
    _initAppStateStream();
    _initUserInfoStream();
  }

  Future<void> _initUserInfoStream() async {
    _userInfoController.onListen = () async {
      _userInfoController.add(_localDatasource.getUserInfo());
    };

    _localDatasource.getUserInfoStream().listen((user) {
      _userInfoController.add(user);
    });

    try {
      final remoteUser = await _remoteDatasource.getUserProfile();
      _localDatasource.setUserInfo(data: remoteUser);
    } catch (e) {
      log(e.toString(), name: "Error getting user info");
    }
  }

  Future<void> _initAppStateStream() async {
    final initialToken = await _localDatasource.getToken();
    final initialState = initialToken != null
        ? AppStateEnum.authenticated
        : AppStateEnum.unauthenticated;

    log(initialToken.toString(), name: "Token");
    _appStateController.onListen = () {
      _appStateController.add(initialState);
    };

    _localDatasource.getTokenStream().listen((token) {
      log(token.toString(), name: "Token");
      final state = token != null
          ? AppStateEnum.authenticated
          : AppStateEnum.unauthenticated;
      _appStateController.add(state);
    });
  }

  @override
  Future<User> login({required LoginModel data}) async {
    final AuthResponseModel res = await _remoteDatasource.login(data);

    log(res.toString(), name: "Login Response");

    //set to local storage
    await _localDatasource.setToken(token: res.token);
    await _localDatasource.setUserInfo(data: res.toUser());

    return res.toUser();
  }

  @override
  Future<User> register({required RegisterModel data}) async {
    final AuthResponseModel res = await _remoteDatasource.register(data);

    //set to local storage
    await _localDatasource.setToken(token: res.token);
    await _localDatasource.setUserInfo(data: res.toUser());

    return res.toUser();
  }

  @override
  Future<String?> getToken() async {
    return _localDatasource.getToken();
  }

  @override
  Future<void> logout() async {
    await _localDatasource.clearAll();
  }

  @override
  Future<User?> getUserInfo() async {
    final localUser = _localDatasource.getUserInfo();
    log(localUser.toString(), name: "Local User");
    if (localUser != null) {
      return localUser;
    }

    try {
      final remoteUser = await _remoteDatasource.getUserProfile();
      await _localDatasource.setUserInfo(data: remoteUser);
      return remoteUser;
    } catch (e) {
      log(e.toString(), name: "Error getting user info");
      return null;
    }
  }

  @override
  Future<void> setUserInfo({required User data}) async {
    await _localDatasource.setUserInfo(data: data);
  }

  

  @override
  Stream<User?> watchUserInfo() {
    return _userInfoController.stream;
  }

  @override
  Stream<AppStateEnum> watchAppState() {
    return _appStateController.stream;
  }

  @override
  Future<User> getUserProfile() async {
    final userProfile = await _remoteDatasource.getUserProfile();
    // Convert UserProfile to User if needed
    return userProfile;
  }

  @override
  Future<UserRankInfo> getUserRankInfo() async {
    return await _remoteDatasource.getUserRankInfo();
  }

  @override
  Future<User> updateUserProfile(String userId, UpdateProfileDto data) async {
    try {
      // Tạo Map để gửi dữ liệu
      Map<String, dynamic> requestData = {};

      // Thêm các trường dữ liệu cơ bản
      if (data.fullName != null) requestData['fullName'] = data.fullName;
      if (data.email != null) requestData['email'] = data.email;
      if (data.password != null) requestData['password'] = data.password;
      if (data.languages != null) requestData['languages'] = data.languages;
      if (data.lastSelectedLanguage != null) {
        requestData['lastSelectedLanguage'] = data.lastSelectedLanguage;
      }

      if (data.avatarFile != null) {
        FormData formData = FormData.fromMap(requestData);

        String fileName = data.avatarFile!.path.split('/').last;
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(
            data.avatarFile!.path,
            filename: fileName,
          ),
        ));

        final response = await _dio.patch(
          '${Endpoints.baseApi}users/$userId/profile',
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        log(response.data.toString(), name: "Update User Profile");

        final updatedProfile = User.fromJson(response.data);

        // Cập nhật thông tin user trong local storage
        await _localDatasource.setUserInfo(data: updatedProfile);

        // Add to stream controller
        _userInfoController.add(updatedProfile);

        return updatedProfile;
      } else {
        // Nếu không có file, sử dụng phương thức từ Retrofit
        final updatedProfile =
            await _remoteDatasource.updateUserProfile(userId, requestData);

        // Cập nhật thông tin user trong local storage
        await _localDatasource.setUserInfo(data: updatedProfile);

        // Add to stream controller
        _userInfoController.add(updatedProfile);

        return updatedProfile;
      }
    } catch (e) {
      log('Error updating profile: $e');
      rethrow;
    }
  }

  @override
  Future<void> forceUpdateUserProfile() async {
    final user = await _remoteDatasource.getUserProfile();
    await _localDatasource.setUserInfo(data: user);
    _userInfoController.add(user);
  }
}
