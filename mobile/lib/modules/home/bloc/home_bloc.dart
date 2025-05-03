import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:language_app/common/constants/view_state_enum.dart';
import 'package:language_app/data/models/unit.dart';
import 'package:language_app/data/dummy/dummy_data.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc()
      : super(HomeState(viewState: ViewStateEnum.initial, currentLesson: 0)) {
    on<LoadUnits>(_onLoadUnits);
    on<SelectLesson>(_onSelectLesson);
    on<CompleteLesson>(_onCompleteLesson);

    add(LoadUnits());
  }

  void _onLoadUnits(LoadUnits event, Emitter<HomeState> emit) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      final units = dummyUnits;
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        units: units,
      ));
    } catch (e) {
      emit(HomeState.failed(state.units));
    }
  }

  void _onSelectLesson(SelectLesson event, Emitter<HomeState> emit) {
    emit(state.copyWith(currentLesson: event.lessonIndex));
  }

  void _onCompleteLesson(CompleteLesson event, Emitter<HomeState> emit) {
    // In a real app, you would update the lesson completion status
    // For now, we'll just select the next lesson
    final nextLesson = event.lessonIndex + 1;
    emit(state.copyWith(currentLesson: nextLesson));
  }
}
