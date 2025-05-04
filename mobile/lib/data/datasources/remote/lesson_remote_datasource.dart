import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:retrofit/retrofit.dart';

@RestApi()
final class LessonRemoteDatasource {
  final Dio _dio;

  LessonRemoteDatasource({required Dio dio}) : _dio = dio;
  Future<List<Challenge>> getExerciseList() async {
    final response = await _dio.get(Endpoints.getExercises);

    final List<Challenge> toReturn = [];

    for (final d in response.data) {
      toReturn.add(Challenge.fromJson(d));
    }

    return toReturn;
  }
}
