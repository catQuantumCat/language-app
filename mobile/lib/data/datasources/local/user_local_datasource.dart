import 'package:hive_flutter/hive_flutter.dart';
import 'package:language_app/common/constants/storage_keys.dart';
import 'package:language_app/domain/models/user.dart';
import 'dart:convert';

class UserLocalDatasource {
  final Box _userBox;

  UserLocalDatasource({required Box userBox}) : _userBox = userBox;

  Future<String?> getToken() async {
    return _userBox.get(StorageKeys.tokenKey);
  }

  Stream<String?> getTokenStream() {
    return _userBox
        .watch(key: StorageKeys.tokenKey)
        .map((event) => event.value as String?);
  }

  Future<void> setToken({String? token}) async {
    if (token != null) {
      await _userBox.put(StorageKeys.tokenKey, token);
    } else {
      await _userBox.delete(StorageKeys.tokenKey);
    }
  }

  Future<void> clearAll() async {
    await _userBox.deleteAll([StorageKeys.tokenKey, StorageKeys.userKey]);
  }

  User? getUserInfo() {
    final userJson = _userBox.get(StorageKeys.userKey);
    if (userJson == null) return null;

    if (userJson is String) {
      return User.fromJson(jsonDecode(userJson));
    }

    if (userJson is Map<String, dynamic>) {
      return User.fromJson(userJson);
    }
    return null;
  }

  Future<void> setUserInfo({required User data}) async {
    final userJson = jsonEncode(data.toJson());
    await _userBox.put(StorageKeys.userKey, userJson);
  }

  Stream<User?> getUserInfoStream() {
    return _userBox.watch(key: StorageKeys.userKey).map((event) {
      if (event.value == null) return null;
      if (event.value is String) {
        return User.fromJson(jsonDecode(event.value));
      }
      if (event.value is Map<String, dynamic>) {
        return User.fromJson(event.value);
      }
      return null;
    });
  }
}
