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
import 'package:language_app/domain/dtos/user_dto.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/models/user_profile.dart';
import 'package:language_app/domain/models/user_rank_info.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:retrofit/http.dart';

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
    required Dio dio, // Thêm Dio vào constructor
  })  : _localDatasource = localDatasource,
        _remoteDatasource = remoteDatasource,
        _dio = dio {
    _initAppStateStream();
    _initUserInfoStream();
  }

  void _initUserInfoStream() {
    _userInfoController.onListen = () {
      _userInfoController.add(_localDatasource.getUserInfo());
    };

    _localDatasource.getUserInfoStream().listen((user) {
      _userInfoController.add(user);
    });
  }

  Future<void> _initAppStateStream() async {
    final initialToken = await _localDatasource.getToken();
    final initialState = initialToken != null
        ? AppStateEnum.authenticated
        : AppStateEnum.unauthenticated;

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
  User? getUserInfo() {
    return _localDatasource.getUserInfo();
  }

  @override
  Future<void> setUserInfo({required User data}) async {
    await _localDatasource.setUserInfo(data: data);
  }

  @override
  Future<void> editUserInfo({required UserDTO data}) {
    // TODO: implement editUserInfo
    throw UnimplementedError();
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
  Future<UserProfile> getUserProfile() async {
    return await _remoteDatasource.getUserProfile();
  }
  
  @override
  Future<UserRankInfo> getUserRankInfo() async {
    return await _remoteDatasource.getUserRankInfo();
  }
  
@override
Future<UserProfile> updateUserProfile(String userId, UpdateProfileDto data) async {
  try {
    // Tạo Map để gửi dữ liệu
    Map<String, dynamic> requestData = {};
    
    // Thêm các trường dữ liệu cơ bản
    if (data.fullName != null) requestData['fullName'] = data.fullName;
    if (data.email != null) requestData['email'] = data.email;
    if (data.password != null) requestData['password'] = data.password;
    
    // Xử lý file ảnh đại diện
    if (data.avatarFile != null) {
      // Sử dụng FormData và MultipartFile
      FormData formData = FormData.fromMap(requestData);
      
      String fileName = data.avatarFile!.path.split('/').last;
      formData.files.add(MapEntry(
        'avatar',
        await MultipartFile.fromFile(
          data.avatarFile!.path,
          filename: fileName,
        ),
      ));
      
      // Gọi API trực tiếp với Dio thay vì qua Retrofit
      final response = await _dio.patch(
        '${Endpoints.baseApi}users/$userId/profile',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      final updatedProfile = UserProfile.fromJson(response.data);
      
      // Cập nhật thông tin user trong local storage
      final currentUser = _localDatasource.getUserInfo();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          fullName: updatedProfile.fullName,
          email: updatedProfile.email,
          avatar: updatedProfile.avatar,
        );
        await _localDatasource.setUserInfo(data: updatedUser);
      }
      
      return updatedProfile;
    } else {
      // Nếu không có file, sử dụng phương thức từ Retrofit
      final updatedProfile = await _remoteDatasource.updateUserProfile(userId, requestData);
      
      // Cập nhật thông tin user trong local storage
      final currentUser = _localDatasource.getUserInfo();
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          fullName: updatedProfile.fullName,
          email: updatedProfile.email,
          avatar: updatedProfile.avatar,
        );
        await _localDatasource.setUserInfo(data: updatedUser);
      }
      
      return updatedProfile;
    }
  } catch (e) {
    print('Error updating profile: $e');
    rethrow;
  }
}



}
