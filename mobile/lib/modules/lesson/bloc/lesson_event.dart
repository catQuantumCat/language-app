part of 'lesson_bloc.dart';

sealed class LessonEvent extends Equatable {}

class LessonStartEvent extends LessonEvent {
  final String lessonId;
  final String unitId;

  LessonStartEvent({required this.lessonId, required this.unitId});
  @override
  List<Object?> get props => [lessonId, unitId];
}

class CheckAnswerEvent<T> extends LessonEvent {
  final T userAnswer;

  CheckAnswerEvent({required this.userAnswer});
  @override
  List<Object?> get props => [userAnswer];
}

class ContinueEvent extends LessonEvent {
  @override
  List<Object?> get props => [];
}

class LessonExitEvent extends LessonEvent {
  @override
  List<Object?> get props => [];
}
