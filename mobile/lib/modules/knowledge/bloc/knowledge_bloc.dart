import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/models/knowledge_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';

part 'knowledge_event.dart';
part 'knowledge_state.dart';

class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {
  final KnowledgeRepo _knowledgeRepo;

  KnowledgeBloc({
    required KnowledgeRepo knowledgeRepo,
  })  : _knowledgeRepo = knowledgeRepo,
        super(KnowledgeState(viewState: ViewStateEnum.initial)) {
    on<LoadKnowledgeEvent>(_onLoadKnowledge);
    on<NextKnowledgeItemEvent>(_onNextKnowledgeItem);
    on<PreviousKnowledgeItemEvent>(_onPreviousKnowledgeItem);
  }

  Future<void> _onLoadKnowledge(
    LoadKnowledgeEvent event,
    Emitter<KnowledgeState> emit,
  ) async {
    emit(state.copyWith(
      viewState: ViewStateEnum.loading,
      lessonId: event.lessonId,
      lessonTitle: event.lessonTitle,
    ));

    try {
      final knowledge = await _knowledgeRepo.getKnowledge(event.lessonId);
      
      // Sắp xếp vocabulary và grammar theo order
      final sortedVocabulary = List<Vocabulary>.from(knowledge.vocabulary)
        ..sort((a, b) => a.order.compareTo(b.order));
      
      final sortedGrammar = List<Grammar>.from(knowledge.grammar)
        ..sort((a, b) => a.order.compareTo(b.order));
      
      // Tạo danh sách các item để hiển thị
      final List<KnowledgeItem> knowledgeItems = [];
      
      // Thêm vocabulary items
      for (var vocab in sortedVocabulary) {
        knowledgeItems.add(KnowledgeItem.vocabulary(vocab));
      }
      
      // Thêm grammar items
      for (var grammar in sortedGrammar) {
        knowledgeItems.add(KnowledgeItem.grammar(grammar));
      }
      
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        knowledge: knowledge,
        knowledgeItems: knowledgeItems,
        currentItemIndex: knowledgeItems.isNotEmpty ? 0 : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onNextKnowledgeItem(
    NextKnowledgeItemEvent event,
    Emitter<KnowledgeState> emit,
  ) {
    if (state.currentItemIndex == null || 
        state.knowledgeItems.isEmpty ||
        state.currentItemIndex! >= state.knowledgeItems.length - 1) {
      return;
    }
    
    emit(state.copyWith(
      currentItemIndex: state.currentItemIndex! + 1,
    ));
  }

  void _onPreviousKnowledgeItem(
    PreviousKnowledgeItemEvent event,
    Emitter<KnowledgeState> emit,
  ) {
    if (state.currentItemIndex == null || 
        state.knowledgeItems.isEmpty ||
        state.currentItemIndex! <= 0) {
      return;
    }
    
    emit(state.copyWith(
      currentItemIndex: state.currentItemIndex! - 1,
    ));
  }
}
