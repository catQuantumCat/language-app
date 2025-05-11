import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/data/models/result_model.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/domain/models/lesson.dart';
import 'package:language_app/domain/models/result.dart';
import 'package:language_app/domain/repos/lesson_repo.dart';

class LessonRepoImp implements LessonRepo {
  final LessonRemoteDatasource _remoteDatasource;

  LessonRepoImp({required LessonRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<List<Challenge>> getChallengeList({required String lessonId}) {
    return _remoteDatasource.getLessonExercises(lessonId);
  }

  @override
  Future<List<Unit>> getAllUnits({required String languageId}) {
    return _remoteDatasource.getUnits(languageId);
  }

  @override
  Future<List<Lesson>> getLessons({required String unitId}) {
    return _remoteDatasource.getLessons(unitId);
  }

  @override
  Future<void> sendResult({required Result result, required String unitId, required String userId}) async{
    final resultModel = ResultModel.fromDomain(result, userId: userId);
    return await _remoteDatasource.sendResult(unitId, resultModel);
  }

  
}
