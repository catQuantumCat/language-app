import 'package:language_app/data/datasources/remote/knowledge_remote_datasource.dart';
import 'package:language_app/domain/models/unit_response.dart';
import 'package:language_app/domain/models/lesson_response.dart';
import 'package:language_app/domain/models/knowledge_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';

class KnowledgeRepoImpl implements KnowledgeRepo {
  final KnowledgeRemoteDatasource _remoteDatasource;

  KnowledgeRepoImpl({
    required KnowledgeRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<List<UnitResponse>> getUnits(String languageId) async {
    return await _remoteDatasource.getUnits(languageId);
  }

  @override
  Future<List<LessonResponse>> getLessons(String unitId) async {
    return await _remoteDatasource.getLessons(unitId);
  }

  @override
  Future<KnowledgeResponse> getKnowledge(String lessonId) async {
    return await _remoteDatasource.getKnowledge(lessonId);
  }
}
