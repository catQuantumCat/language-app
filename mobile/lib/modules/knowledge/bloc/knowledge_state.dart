part of 'knowledge_bloc.dart';

enum KnowledgeItemType { vocabulary, grammar }

class KnowledgeItem {
  final KnowledgeItemType type;
  final dynamic data; // Vocabulary hoặc Grammar

  KnowledgeItem.vocabulary(Vocabulary vocabulary)
      : type = KnowledgeItemType.vocabulary,
        data = vocabulary;

  KnowledgeItem.grammar(Grammar grammar)
      : type = KnowledgeItemType.grammar,
        data = grammar;
}

class KnowledgeState extends Equatable {
  final ViewStateEnum viewState;
  final KnowledgeResponse? knowledge;
  final List<KnowledgeItem> knowledgeItems;
  final int? currentItemIndex;
  final String? lessonId;
  final String? lessonTitle;
  final String? errorMessage;

  const KnowledgeState({
    required this.viewState,
    this.knowledge,
    this.knowledgeItems = const [],
    this.currentItemIndex,
    this.lessonId,
    this.lessonTitle,
    this.errorMessage,
  });

  bool get isLastItem => 
      currentItemIndex != null && 
      knowledgeItems.isNotEmpty && 
      currentItemIndex! >= knowledgeItems.length - 1;

  bool get isFirstItem => 
      currentItemIndex != null && 
      knowledgeItems.isNotEmpty && 
      currentItemIndex! <= 0;

  KnowledgeItem? get currentItem => 
      currentItemIndex != null && 
      knowledgeItems.isNotEmpty && 
      currentItemIndex! < knowledgeItems.length
          ? knowledgeItems[currentItemIndex!]
          : null;

  KnowledgeState copyWith({
    ViewStateEnum? viewState,
    KnowledgeResponse? knowledge,
    List<KnowledgeItem>? knowledgeItems,
    int? currentItemIndex,
    String? lessonId,
    String? lessonTitle,
    String? errorMessage,
  }) {
    return KnowledgeState(
      viewState: viewState ?? this.viewState,
      knowledge: knowledge ?? this.knowledge,
      knowledgeItems: knowledgeItems ?? this.knowledgeItems,
      currentItemIndex: currentItemIndex ?? this.currentItemIndex,
      lessonId: lessonId ?? this.lessonId,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    viewState, 
    knowledge, 
    knowledgeItems, 
    currentItemIndex, 
    lessonId, 
    lessonTitle, 
    errorMessage
  ];
}
