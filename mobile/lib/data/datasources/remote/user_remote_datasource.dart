import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/data/models/auth_response_model.dart';
import 'package:language_app/data/models/login_model.dart';
import 'package:language_app/data/models/register_model.dart';

import 'package:dio/dio.dart';

import 'package:retrofit/retrofit.dart';

part 'user_remote_datasource.g.dart';

@RestApi()
abstract class UserRemoteDatasource {
  factory UserRemoteDatasource(Dio dio, {String? baseUrl}) =
      _UserRemoteDatasource;
  @POST(loginEndpoint)
  Future<AuthResponseModel> login(@Body() LoginModel data);

  @POST(registerEndpoint)
  Future<AuthResponseModel> register(@Body() RegisterModel data);
}
