part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final ViewStateEnum viewState;
  final List<Unit> units;
  final int currentLesson;

  const HomeState({
    required this.viewState,
    this.units = const [],
    required this.currentLesson,
  });

  HomeState copyWith(
      {ViewStateEnum? viewState, List<Unit>? units, int? currentLesson}) {
    return HomeState(
      viewState: viewState ?? this.viewState,
      currentLesson: currentLesson ?? this.currentLesson,
      units: units ?? this.units,
    );
  }

  const HomeState.failed(this.units)
      : viewState = ViewStateEnum.failed,
        currentLesson = 0;

  @override
  List<Object?> get props => [viewState, units, currentLesson];
}
