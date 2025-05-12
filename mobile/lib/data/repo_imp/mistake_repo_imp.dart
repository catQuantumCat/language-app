// data/repo_imp/mistake_repo_imp.dart
import 'package:language_app/data/datasources/remote/mistake_remote_datasource.dart';
import 'package:language_app/domain/models/mistake_entry.dart';
import 'package:language_app/domain/repos/mistake_repo.dart';

class MistakeRepoImpl implements MistakeRepo {
  final MistakeRemoteDatasource _remoteDatasource;

  MistakeRepoImpl({
    required MistakeRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  @override
  Future<List<MistakeEntry>> getUserMistakes(String userId) async {
    return await _remoteDatasource.getUserMistakes(userId);
  }

  @override
  Future<MistakeDetail> getMistakeDetail(String mistakeId) async {
    return await _remoteDatasource.getMistakeDetail(mistakeId);
  }
}
