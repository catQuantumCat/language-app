import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language_app/common/constants/storage_keys.dart';

class ApiInteceptor extends Interceptor {
  final Box _userBox;

  ApiInteceptor({required Box userBox}) : _userBox = userBox;
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _userBox.get(StorageKeys.tokenKey);

    if (token != null) {
      log('Adding token to request: $token', name: 'ApiInterceptor');
      options.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    } else {
      log('No token found for request: ${options.path}', name: 'ApiInterceptor');
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //If error is 401 -> unauthenticate
    if (err.response?.statusCode == 401) {
      log('Unauthorized error: ${err.response?.data}');
      _userBox.deleteAll([StorageKeys.userKey, StorageKeys.tokenKey]);
    }
    super.onError(err, handler);
  }
}
