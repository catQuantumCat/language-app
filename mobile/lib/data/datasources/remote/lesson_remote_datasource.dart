import 'package:dio/dio.dart';
import 'package:language_app/data/models/result_model.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/domain/models/lesson.dart';
import 'package:retrofit/retrofit.dart';

part 'lesson_remote_datasource.g.dart';

@RestApi()
abstract class LessonRemoteDatasource {
  factory LessonRemoteDatasource(Dio dio, {String? baseUrl}) =
      _LessonRemoteDatasource;

  @GET("/languages/{id}/units")
  Future<List<Unit>> getUnits(@Path("id") String languageId);

  @GET("/unit/{id}/lessons")
  Future<List<Lesson>> getLessons(@Path("id") String unitId);

  @GET("/lesson/{id}/exercises")
  Future<List<Challenge>> getLessonExercises(@Path("id") String lessonId);

//https://english-app-backend2.onrender.com/api/unit/{unitId}/lessons/save-results
  @POST("/unit/{unitId}/lessons/save-results")
  Future<void> sendResult(
      @Path("unitId") String unitId, @Body() ResultModel result);
}
