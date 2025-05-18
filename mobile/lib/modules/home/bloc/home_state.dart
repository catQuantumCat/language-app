part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final ViewStateEnum viewState;
  final List<Unit> units;
  final int currentLesson;

  final Language? language;
  final int heartCount;
  final int streakCount;
  final int xpCount;

  const HomeState({
    required this.viewState,
    this.units = const [],
    required this.currentLesson,
    this.language,
    this.heartCount = 0,
    this.streakCount = 0,
    this.xpCount = 0,
  });

  HomeState copyWith({
    ViewStateEnum? viewState,
    List<Unit>? units,
    int? currentLesson,
    Language? language,
    int? heartCount,
    int? streakCount,
    int? xpCount,
  }) {
    return HomeState(
      viewState: viewState ?? this.viewState,
      currentLesson: currentLesson ?? this.currentLesson,
      units: units ?? this.units,
      language: language ?? this.language,
      heartCount: heartCount ?? this.heartCount,
      streakCount: streakCount ?? this.streakCount,
      xpCount: xpCount ?? this.xpCount,
    );
  }

  HomeState.failed()
      : units = [],
        viewState = ViewStateEnum.failed,
        currentLesson = 0,
        language = null,
        heartCount = 0,
        streakCount = 0,
        xpCount = 0;

  @override
  List<Object?> get props => [
        viewState,
        units,
        currentLesson,
        language,
        heartCount,
        streakCount,
        xpCount
      ];
}
