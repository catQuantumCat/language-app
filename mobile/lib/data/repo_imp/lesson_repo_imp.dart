import 'package:language_app/data/datasources/remote/lesson_remote_datasource.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/domain/repos/lesson_repo.dart';

class LessonRepoImp implements LessonRepo {
  final LessonRemoteDatasource _remoteDatasource;

  LessonRepoImp({required LessonRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  @override
  Future<List<Challenge>> getChallengeList() {
    return _remoteDatasource.getExerciseList();
  }
}
