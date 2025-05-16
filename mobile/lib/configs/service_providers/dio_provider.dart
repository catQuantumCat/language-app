import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/configs/inteceptors/dio_inteceptor.dart';

class DioProvider {
  static DioProvider? _instance;
  static Dio? _dio;
  final Box _userBox;
  
  DioProvider._internal(this._userBox);

  factory DioProvider(Box userBox) {
    _instance ??= DioProvider._internal(userBox);
    return _instance!;
  }

  Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  Dio _createDio() {
    Dio dio = Dio();

    dio.interceptors.add(ApiInteceptor(userBox: _userBox));
    dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseHeader: false,
        requestHeader: false,
        request: false,
        responseBody: false,
        error: true));

    dio.options.baseUrl = Endpoints.baseApi;

    return dio;
  }
}
