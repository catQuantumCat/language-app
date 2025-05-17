part of 'lesson_bloc.dart';

sealed class LessonEvent extends Equatable {}

class LessonStartEvent extends LessonEvent {
  final String unitId;
  final String lessonId;
  final String languageId;

  LessonStartEvent(
      {required this.unitId, required this.lessonId, required this.languageId});

  @override
  List<Object?> get props => [unitId, lessonId, languageId];
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
  final bool isOutOfHeart;

  LessonExitEvent({required this.isOutOfHeart});
  @override
  List<Object?> get props => [isOutOfHeart];
}
