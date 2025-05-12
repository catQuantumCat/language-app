// modules/leaderboard/bloc/leaderboard_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/models/leaderboard_entry.dart';
import 'package:language_app/domain/repos/leaderboard_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  final LeaderboardRepo _leaderboardRepo;
  final UserRepo _userRepo;

  LeaderboardBloc({
    required LeaderboardRepo leaderboardRepo,
    required UserRepo userRepo,
  })  : _leaderboardRepo = leaderboardRepo,
        _userRepo = userRepo,
        super(LeaderboardState(viewState: ViewStateEnum.initial)) {
    on<LoadLeaderboardEvent>(_onLoadLeaderboard);
  }

  Future<void> _onLoadLeaderboard(
    LoadLeaderboardEvent event,
    Emitter<LeaderboardState> emit,
  ) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      final leaderboardResponse = await _leaderboardRepo.getLeaderboard();
      
      // Nếu không có currentUserRank từ API, thử lấy thông tin người dùng hiện tại
      LeaderboardEntry? currentUserRank = leaderboardResponse.currentUserRank;
      if (currentUserRank == null) {
        final currentUser = _userRepo.getUserInfo();
        if (currentUser != null) {
          try {
            currentUserRank = await _leaderboardRepo.getUserRank(currentUser.id);
          } catch (e) {
            // Không làm gì nếu không lấy được rank người dùng
          }
        }
      }

      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        leaderboardEntries: leaderboardResponse.leaderboard,
        currentUserRank: currentUserRank,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }
  }
}
