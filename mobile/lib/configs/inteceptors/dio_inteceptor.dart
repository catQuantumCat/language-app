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
    final key = _userBox.get(StorageKeys.tokenKey);

    if (key != null) {
      options.headers.addAll({HttpHeaders.authorizationHeader: key});
    }

    
    

    super.onRequest(options, handler);
  }

  

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //If error is 401 -> unauthenticate
    if (err.response?.statusCode == 401) {
      log('Unauthorized error: ${err.response?.statusMessage}');
      _userBox.deleteAll([StorageKeys.userKey, StorageKeys.tokenKey]);
    }
    super.onError(err, handler);
  }
}
