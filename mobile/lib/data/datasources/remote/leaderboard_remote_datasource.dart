// data/datasources/remote/leaderboard_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:language_app/common/constants/endpoints.dart';
import 'package:language_app/domain/models/leaderboard_entry.dart';

class LeaderboardRemoteDatasource {
  final Dio _dio;

  LeaderboardRemoteDatasource(this._dio);

  Future<LeaderboardResponse> getLeaderboard() async {
    final response = await _dio.get(Endpoints.getLeaderboard);
    return LeaderboardResponse.fromJson(response.data);
  }

  Future<LeaderboardEntry> getUserRank(String userId) async {
    final response = await _dio.get('${Endpoints.getUserRank}/$userId');
    return LeaderboardEntry.fromJson(response.data);
  }
}
