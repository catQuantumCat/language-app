//Interface for LessonRepoImp
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/domain/models/challenge.dart';
import 'package:language_app/domain/models/lesson.dart';

abstract class LessonRepo {
  //get challenge list
  Future<List<Challenge>> getChallengeList({required String lessonId});

  Future<List<Unit>> getAllUnits({required String languageId});

  Future<List<Lesson>> getLessons({required String unitId});
}
