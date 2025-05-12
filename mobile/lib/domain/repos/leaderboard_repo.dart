// domain/repos/leaderboard_repo.dart
import 'package:language_app/domain/models/leaderboard_entry.dart';

abstract class LeaderboardRepo {
  Future<LeaderboardResponse> getLeaderboard();
  Future<LeaderboardEntry?> getUserRank(String userId);
}
