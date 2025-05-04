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

    log(options.headers.toString(), name: "onRequest");
    log(options.uri.toString(), name: "onRequest path");

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(response.data.toString(), name: "onResponse");
    super.onResponse(response, handler);
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
