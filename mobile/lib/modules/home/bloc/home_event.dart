part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class LoadUnits extends HomeEvent {}

class SelectLesson extends HomeEvent {
  final int lessonIndex;
  SelectLesson({required this.lessonIndex});
}

class CompleteLesson extends HomeEvent {
  final int lessonIndex;
  CompleteLesson({required this.lessonIndex});
}

class LoadMetadataEvent extends HomeEvent {}
