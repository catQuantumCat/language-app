// domain/repos/mistake_repo.dart
import 'package:language_app/domain/models/mistake_entry.dart';

abstract class MistakeRepo {
  Future<List<MistakeEntry>> getUserMistakes(String userId);
  Future<MistakeDetail> getMistakeDetail(String mistakeId);
}
