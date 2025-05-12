// modules/mistakes/bloc/mistakes_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/models/mistake_entry.dart';
import 'package:language_app/domain/models/user.dart';
import 'package:language_app/domain/repos/mistake_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';

part 'mistakes_event.dart';
part 'mistakes_state.dart';

class MistakesBloc extends Bloc<MistakesEvent, MistakesState> {
  final MistakeRepo _mistakeRepo;
  final UserRepo _userRepo;

  MistakesBloc({
    required MistakeRepo mistakeRepo,
    required UserRepo userRepo,
  })  : _mistakeRepo = mistakeRepo,
        _userRepo = userRepo,
        super(MistakesState(viewState: ViewStateEnum.initial)) {
    on<LoadMistakesEvent>(_onLoadMistakes);
  }

  Future<void> _onLoadMistakes(
    LoadMistakesEvent event,
    Emitter<MistakesState> emit,
  ) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      final User? currentUser = _userRepo.getUserInfo();
      if (currentUser == null) {
        emit(state.copyWith(
          viewState: ViewStateEnum.failed,
          errorMessage: 'Người dùng chưa đăng nhập',
        ));
        return;
      }

      final mistakes = await _mistakeRepo.getUserMistakes(currentUser.id);
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        mistakes: mistakes,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }
  }
}
