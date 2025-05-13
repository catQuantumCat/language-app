import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/common/enums/view_state_enum.dart';
import 'package:language_app/domain/models/unit_response.dart';
import 'package:language_app/domain/repos/knowledge_repo.dart';
import 'package:language_app/domain/repos/user_repo.dart';

part 'units_event.dart';
part 'units_state.dart';

class UnitsBloc extends Bloc<UnitsEvent, UnitsState> {
  final KnowledgeRepo _knowledgeRepo;
  final UserRepo _userRepo;

  UnitsBloc({
    required KnowledgeRepo knowledgeRepo,
    required UserRepo userRepo,
  })  : _knowledgeRepo = knowledgeRepo,
        _userRepo = userRepo,
        super(UnitsState(viewState: ViewStateEnum.initial)) {
    on<LoadUnitsEvent>(_onLoadUnits);
  }

  Future<void> _onLoadUnits(
    LoadUnitsEvent event,
    Emitter<UnitsState> emit,
  ) async {
    emit(state.copyWith(viewState: ViewStateEnum.loading));

    try {
      final currentUser = _userRepo.getUserInfo();
      if (currentUser == null || currentUser.languages.isEmpty) {
        emit(state.copyWith(
          viewState: ViewStateEnum.failed,
          errorMessage: 'Không tìm thấy ngôn ngữ đã chọn',
        ));
        return;
      }

      final languageId = event.languageId ?? currentUser.languages.first.languageId;
      final units = await _knowledgeRepo.getUnits(languageId);
      
      emit(state.copyWith(
        viewState: ViewStateEnum.succeed,
        units: units,
        selectedLanguageId: languageId,
      ));
    } catch (e) {
      emit(state.copyWith(
        viewState: ViewStateEnum.failed,
        errorMessage: e.toString(),
      ));
    }
  }
}
