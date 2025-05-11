import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/constants/view_state_enum.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/domain/models/language.dart';
import 'package:language_app/domain/repos/user_repo.dart';
import 'package:language_app/domain/use_cases/home_screen_fetch_use_case.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepo _userRepo;
  final HomeScreenFetchUseCase _homeScreenFetchUseCase;

  HomeBloc(
      {required UserRepo userRepo,
      required HomeScreenFetchUseCase homeScreenFetchUseCase})
      : _userRepo = userRepo,
        _homeScreenFetchUseCase = homeScreenFetchUseCase,
        super(HomeState(viewState: ViewStateEnum.initial, currentLesson: 0)) {
    on<LoadUnits>(_onLoadUnits);
    on<SelectLesson>(_onSelectLesson);
    on<CompleteLesson>(_onCompleteLesson);
    on<LoadMetadataEvent>(_onLoadMetadata);

    add(LoadUnits());
    add(LoadMetadataEvent());
  }

  Future<void> _onLoadMetadata(
      LoadMetadataEvent event, Emitter<HomeState> emit) async {
    log('_onLoadMetadata called');
    emit(state.copyWith(viewState: ViewStateEnum.loading));
    final userInfoStream = _userRepo.watchUserInfo();

    await emit.forEach(
      userInfoStream,
      onData: (data) {
        if (data != null) {
          return state.copyWith(
              streakCount: data.streak,
              heartCount: data.hearts,
              language:
                  data.languages.isNotEmpty ? data.languages.first : null);
        }

        return state;
      },
      onError: (error, stackTrace) {
        return HomeState.failed();
      },
    );
  }

  void _onLoadUnits(LoadUnits event, Emitter<HomeState> emit) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      if (state.language == null) {
        emit(HomeState.failed());
        log("language is null");
        return;
      }

      final units = await _homeScreenFetchUseCase.call(
          languageId: state.language!.languageId);

      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        units: units,
      ));
    } catch (e) {
      log(e.toString());
      emit(HomeState.failed());
    }
  }

  void _onSelectLesson(SelectLesson event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentLesson: event.lessonIndex));
  }

  void _onCompleteLesson(CompleteLesson event, Emitter<HomeState> emit) {
    final nextLesson = event.lessonIndex + 1;
    emit(state.copyWith(currentLesson: nextLesson));
  }
}
