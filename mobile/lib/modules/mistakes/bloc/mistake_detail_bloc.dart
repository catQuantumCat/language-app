// modules/mistakes/bloc/mistake_detail_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/models/mistake_entry.dart';
import 'package:language_app/domain/repos/mistake_repo.dart';

part 'mistake_detail_event.dart';
part 'mistake_detail_state.dart';

class MistakeDetailBloc extends Bloc<MistakeDetailEvent, MistakeDetailState> {
  final MistakeRepo _mistakeRepo;

  MistakeDetailBloc({
    required MistakeRepo mistakeRepo,
  })  : _mistakeRepo = mistakeRepo,
        super(MistakeDetailState(viewState: ViewStateEnum.initial)) {
    on<LoadMistakeDetailEvent>(_onLoadMistakeDetail);
  }

  Future<void> _onLoadMistakeDetail(
    LoadMistakeDetailEvent event,
    Emitter<MistakeDetailState> emit,
  ) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      final mistakeDetail = await _mistakeRepo.getMistakeDetail(event.mistakeId);
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        mistakeDetail: mistakeDetail,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }}}
