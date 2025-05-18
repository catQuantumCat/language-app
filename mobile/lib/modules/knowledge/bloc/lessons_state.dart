part of 'lessons_bloc.dart';

class LessonsState extends Equatable {
  final ViewStateEnum viewState;
  final List<LessonResponse> lessons;
  final String? unitId;
  final String? unitTitle;
  final int? unitOrder;
  final String? errorMessage;

  const LessonsState({
    required this.viewState,
    this.lessons = const [],
    this.unitId,
    this.unitTitle,
    this.unitOrder,
    this.errorMessage,
  });

  LessonsState copyWith({
    ViewStateEnum? viewState,
    List<LessonResponse>? lessons,
    String? unitId,
    String? unitTitle,
    int? unitOrder,
    String? errorMessage,
  }) {
    return LessonsState(
      viewState: viewState ?? this.viewState,
      lessons: lessons ?? this.lessons,
      unitId: unitId ?? this.unitId,
      unitTitle: unitTitle ?? this.unitTitle,
      unitOrder: unitOrder ?? this.unitOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [viewState, lessons, unitId, unitTitle, unitOrder, errorMessage];
}
