// modules/leaderboard/bloc/leaderboard_state.dart
part of 'leaderboard_bloc.dart';

class LeaderboardState extends Equatable {
  final ViewStateEnum viewState;
  final List<LeaderboardEntry> leaderboardEntries;
  final LeaderboardEntry? currentUserRank;
  final String? errorMessage;

  const LeaderboardState({
    required this.viewState,
    this.leaderboardEntries = const [],
    this.currentUserRank,
    this.errorMessage,
  });

  LeaderboardState copyWith({
    ViewStateEnum? viewState,
    List<LeaderboardEntry>? leaderboardEntries,
    LeaderboardEntry? currentUserRank,
    String? errorMessage,
  }) {
    return LeaderboardState(
      viewState: viewState ?? this.viewState,
      leaderboardEntries: leaderboardEntries ?? this.leaderboardEntries,
      currentUserRank: currentUserRank ?? this.currentUserRank,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, leaderboardEntries, currentUserRank, errorMessage];
}
