part of 'knowledge_bloc.dart';

abstract class KnowledgeEvent extends Equatable {
  const KnowledgeEvent();

  @override
  List<Object> get props => [];
}

class LoadKnowledgeEvent extends KnowledgeEvent {
  final String lessonId;
  final String lessonTitle;

  const LoadKnowledgeEvent({
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  List<Object> get props => [lessonId, lessonTitle];
}

class NextKnowledgeItemEvent extends KnowledgeEvent {}

class PreviousKnowledgeItemEvent extends KnowledgeEvent {}
