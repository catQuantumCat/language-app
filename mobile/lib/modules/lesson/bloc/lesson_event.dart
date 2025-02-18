part of 'lesson_bloc.dart';

sealed class LessonEvent extends Equatable {}

class LessonStartEvent extends LessonEvent {
  @override
  List<Object?> get props => [];
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
