// modules/leaderboard/bloc/leaderboard_event.dart
part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object> get props => [];
}

class LoadLeaderboardEvent extends LeaderboardEvent {}
