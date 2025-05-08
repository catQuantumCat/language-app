import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/data/models/language_model.dart';
import 'package:language_app/domain/models/available_language.dart';
import 'package:retrofit/retrofit.dart';

part 'language_remote_datasource.g.dart';

@RestApi()
abstract class LanguageRemoteDatasource {
  factory LanguageRemoteDatasource(Dio dio, {String? baseUrl}) =
      _LanguageRemoteDatasource;

  @GET(availableLanguagesEndpoint)
  Future<List<AvailableLanguage>> getAvailableLanguages();

  @GET(userLanguagesEndpoint)
  Future<List<LanguageModel>> getUserLanguages();

  @POST(userLanguagesEndpoint)
  Future<void> addUserLanguage(@Body() Map<String, dynamic> languageData);
}
