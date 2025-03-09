//Interface for LessonRepoImp
import 'package:language_app/data/models/challenge.dart';

abstract class LessonRepo {
  //get challenge list
  Future<List<Challenge>> getChallengeList();
}
