import 'package:language_app/domain/models/unit_response.dart';
import 'package:language_app/domain/models/lesson_response.dart';
import 'package:language_app/domain/models/knowledge_response.dart';

abstract class KnowledgeRepo {
  Future<List<UnitResponse>> getUnits(String languageId);
  Future<List<LessonResponse>> getLessons(String unitId);
  Future<KnowledgeResponse> getKnowledge(String lessonId);
}
