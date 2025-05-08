//Interface for LessonRepoImp
import 'package:language_app/domain/models/challenge.dart';

abstract class LessonRepo {
  //get challenge list
  Future<List<Challenge>> getChallengeList();
}
