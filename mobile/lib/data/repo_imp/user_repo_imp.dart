import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language_app/common/constants/storage_keys.dart';
import 'package:language_app/data/datasources/remote/user_remote_datasource.dart';
import 'package:language_app/data/models/auth_response_model.dart';
import 'package:language_app/data/models/login_model.dart';
import 'package:language_app/data/models/register_model.dart';
import 'package:language_app/domain/dto/user_dto.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repo/user_repo.dart';

class UserRepoImpl implements UserRepo {
  final Box _userBox;

  

  final UserRemoteDatasource _remoteDatasource;

  UserRepoImpl(
      {required Box userBox, required UserRemoteDatasource remoteDatasource})
      : _userBox = userBox,
        _remoteDatasource = remoteDatasource;
        

  @override
  Future<User> login({required LoginModel data}) async {
    final AuthResponseModel res = await _remoteDatasource.login(data);

    //set to local storage
    setToken(token: res.token);
    setUserInfo(data: res.toUser());

    return res.toUser();
  }

  @override
  Future<User> register({required RegisterModel data}) async {
    final AuthResponseModel res = await _remoteDatasource.register(data);

    //set to local storage
    setToken(token: res.token);
    setUserInfo(data: res.toUser());

    return res.toUser();
  }

  @override
  Future<String?> getToken() async {
    return _userBox.get(StorageKeys.tokenKey);
  }

  @override
  Future<Stream<String?>> getTokenStream() async {
    return _userBox
        .watch(key: StorageKeys.tokenKey)
        .map((event) => event.value as String?);
  }

  @override
  Future<void> setToken({String? token}) async {
    if (token != null) {
      await _userBox.put(StorageKeys.tokenKey, token);
    } else {
      await _userBox.delete(StorageKeys.tokenKey);
    }
  }

  @override
  Future<void> logout() async {
    await _userBox.deleteAll([StorageKeys.tokenKey, StorageKeys.userKey]);
    
  }

  @override
  Future<User> getUserInfo() async {
    final userJson = _userBox.get(StorageKeys.userKey);
    if (userJson == null) {
      throw Exception('User not found');
    }
    return User.fromJson(userJson);
  }

  @override
  Future<void> setUserInfo({required User data}) async {
    await _userBox.put(StorageKeys.userKey, data.toJson());
    
  }

  @override
  Future<void> editUserInfo({required UserDTO data}) {
    // TODO: implement editUserInfo
    throw UnimplementedError();
  }

  @override
  Future<Stream<User?>> getUserInfoStream() async {
    return _userBox
        .watch(key: StorageKeys.userKey)
        .map((event) => event.value != null ? User.fromJson(event.value) : null);
  }
}
