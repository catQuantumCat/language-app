// data/repo_imp/leaderboard_repo_imp.dart
import 'package:language_app/data/datasources/remote/leaderboard_remote_datasource.dart';
import 'package:language_app/domain/models/leaderboard_entry.dart';
import 'package:language_app/domain/repos/leaderboard_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';

class LeaderboardRepoImpl implements LeaderboardRepo {
  final LeaderboardRemoteDatasource _remoteDatasource;
  final UserRepo _userRepo;

  LeaderboardRepoImpl({
    required LeaderboardRemoteDatasource remoteDatasource,
    required UserRepo userRepo,
  })  : _remoteDatasource = remoteDatasource,
        _userRepo = userRepo;

  @override
  Future<LeaderboardResponse> getLeaderboard() async {
    return await _remoteDatasource.getLeaderboard();
  }

  @override
  Future<LeaderboardEntry?> getUserRank(String userId) async {
    return await _remoteDatasource.getUserRank(userId);
  }
}
