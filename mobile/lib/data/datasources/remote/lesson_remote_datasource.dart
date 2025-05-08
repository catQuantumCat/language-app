import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:retrofit/retrofit.dart';

part 'lesson_remote_datasource.g.dart';

@RestApi()
abstract class LessonRemoteDatasource {
  factory LessonRemoteDatasource(Dio dio, {String? baseUrl}) =
      _LessonRemoteDatasource;

  @GET(getExercises)
  Future<List<Challenge>> getExerciseList();
}
