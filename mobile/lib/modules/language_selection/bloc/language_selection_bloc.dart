import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_app/domain/models/available_language.dart';
import 'package:language_app/domain/repos/language_repo.dart';

part 'language_selection_event.dart';
part 'language_selection_state.dart';

class LanguageSelectionBloc
    extends Bloc<LanguageSelectionEvent, LanguageSelectionState> {
  final LanguageRepo _languageRepo;

  LanguageSelectionBloc({required LanguageRepo languageRepo})
      : _languageRepo = languageRepo,
        super(const LanguageSelectionState.loading()) {
    on<LoadLanguagesEvent>(_onLoadLanguages);
    on<SelectLanguageEvent>(_onSelectLanguage);
    on<SubmitSelectedLanguageEvent>(_onSubmitSelectedLanguage);
  }

  Future<void> _onLoadLanguages(
    LoadLanguagesEvent event,
    Emitter<LanguageSelectionState> emit,
  ) async {
    emit(const LanguageSelectionState.loading());

    try {
      final languages = await _languageRepo.getAvailableLanguages();
      emit(LanguageSelectionState.loaded(
        availableLanguages: languages,
        selectedLanguageId: languages.isNotEmpty ? languages.first.id : null,
      ));
    } catch (e) {
      emit(LanguageSelectionState.error(
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectLanguage(
    SelectLanguageEvent event,
    Emitter<LanguageSelectionState> emit,
  ) {
    if (state is! LanguageSelectionLoadedState) return;

    final currentState = state as LanguageSelectionLoadedState;

    emit(currentState.copyWith(
      selectedLanguageId: event.languageId,
    ));
  }

  Future<void> _onSubmitSelectedLanguage(
    SubmitSelectedLanguageEvent event,
    Emitter<LanguageSelectionState> emit,
  ) async {
    if (state is! LanguageSelectionLoadedState) return;

    final currentState = state as LanguageSelectionLoadedState;
    final languageId = currentState.selectedLanguageId;

    if (languageId == null) return;

    emit(currentState.copyWith(status: LanguageSelectionStatus.submitting));

    try {
      await _languageRepo.addUserLanguage(languageId);
      emit(currentState.copyWith(status: LanguageSelectionStatus.success));
    } catch (e) {
      rethrow;
      // emit(currentState.copyWith(
      //   //TODO

      //   // status: LanguageSelectionStatus.error,
      //   // errorMessage: e.toString(),
      // ));
    }
  }
}
