import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/models/lesson_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';

part 'lessons_event.dart';
part 'lessons_state.dart';

class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  final KnowledgeRepo _knowledgeRepo;

  LessonsBloc({
    required KnowledgeRepo knowledgeRepo,
  })  : _knowledgeRepo = knowledgeRepo,
        super(LessonsState(viewState: ViewStateEnum.initial)) {
    on<LoadLessonsEvent>(_onLoadLessons);
  }

  Future<void> _onLoadLessons(
    LoadLessonsEvent event,
    Emitter<LessonsState> emit,
  ) async {
    emit(state.copyWith(
      viewState: ViewStateEnum.loading, 
      unitId: event.unitId,
      unitTitle: event.unitTitle,
      unitOrder: event.unitOrder,
    ));

    try {
      final lessons = await _knowledgeRepo.getLessons(event.unitId);
      
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        lessons: lessons,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }
  }
}
