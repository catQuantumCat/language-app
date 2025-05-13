import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/domain/models/unit_response.dart';
import 'package:language_app/domain/models/lesson_response.dart';
import 'package:language_app/domain/models/knowledge_response.dart';
import 'package:retrofit/retrofit.dart';

part 'knowledge_remote_datasource.g.dart';

@RestApi()
abstract class KnowledgeRemoteDatasource {
  factory KnowledgeRemoteDatasource(Dio dio, {String? baseUrl}) =
      _KnowledgeRemoteDatasource;

  @GET(unitsEndpoint)
  Future<List<UnitResponse>> getUnits(@Path("languageId") String languageId);

  @GET(lessonsEndpoint)
  Future<List<LessonResponse>> getLessons(@Path("unitId") String unitId);

  @GET(knowledgeEndpoint)
  Future<KnowledgeResponse> getKnowledge(@Path("lessonId") String lessonId);
}
