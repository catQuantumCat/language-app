// domain/models/leaderboard_entry.dart
class LeaderboardEntry {
  final String userId;
  final String username;
  final String fullName;
  final String? avatar;
  final int experience;
  final String? languageFlag;
  final int rank;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    required this.fullName,
    this.avatar,
    required this.experience,
    this.languageFlag,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      avatar: json['avatar'] as String?,
      experience: json['experience'] as int,
      languageFlag: json['languageFlag'] as String?,
      rank: json['rank'] as int,
    );
  }
}

class LeaderboardResponse {
  final List<LeaderboardEntry> leaderboard;
  final LeaderboardEntry? currentUserRank;

  LeaderboardResponse({
    required this.leaderboard,
    this.currentUserRank,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    return LeaderboardResponse(
      leaderboard: (json['leaderboard'] as List<dynamic>)
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentUserRank: json['currentUserRank'] != null
          ? LeaderboardEntry.fromJson(json['currentUserRank'] as Map<String, dynamic>)
          : null,
    );
  }
}
