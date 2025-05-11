part of 'home_bloc.dart';

final class HomeState extends Equatable {
  final ViewStateEnum viewState;
  final List<Unit> units;
  final int currentLesson;

  final Language? language;
  final int heartCount;
  final int streakCount;

  const HomeState({
    required this.viewState,
    this.units = const [],
    required this.currentLesson,
    this.language = const Language(
        flagUrl: "",
        languageId: "68022c102f05fe8c6a1166e4",
        level: 10,
        experience: 10),
    this.heartCount = 0,
    this.streakCount = 0,
  });

  HomeState copyWith({
    ViewStateEnum? viewState,
    List<Unit>? units,
    int? currentLesson,
    Language? language,
    int? heartCount,
    int? streakCount,
  }) {
    return HomeState(
      viewState: viewState ?? this.viewState,
      currentLesson: currentLesson ?? this.currentLesson,
      units: units ?? this.units,
      language: language ?? this.language,
      heartCount: heartCount ?? this.heartCount,
      streakCount: streakCount ?? this.streakCount,
    );
  }

  HomeState.failed()
      : units = [],
        viewState = ViewStateEnum.failed,
        currentLesson = 0,
        language = null,
        heartCount = 0,
        streakCount = 0;

  @override
  List<Object?> get props =>
      [viewState, units, currentLesson, language, heartCount, streakCount];
}
