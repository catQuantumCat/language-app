part of 'language_selection_bloc.dart';

enum LanguageSelectionStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error
}

abstract class LanguageSelectionState extends Equatable {
  const LanguageSelectionState();

  const factory LanguageSelectionState.loading() =
      LanguageSelectionLoadingState;
  const factory LanguageSelectionState.loaded({
    required List<AvailableLanguage> availableLanguages,
    String? selectedLanguageId,
    LanguageSelectionStatus status,
    String? errorMessage,
  }) = LanguageSelectionLoadedState;
  const factory LanguageSelectionState.error({
    required String errorMessage,
  }) = LanguageSelectionErrorState;

  @override
  List<Object?> get props => [];
}

class LanguageSelectionLoadingState extends LanguageSelectionState {
  const LanguageSelectionLoadingState();
}

class LanguageSelectionLoadedState extends LanguageSelectionState {
  final List<AvailableLanguage> availableLanguages;
  final String? selectedLanguageId;
  final LanguageSelectionStatus status;
  final String? errorMessage;

  const LanguageSelectionLoadedState({
    required this.availableLanguages,
    this.selectedLanguageId,
    this.status = LanguageSelectionStatus.loaded,
    this.errorMessage,
  });

  LanguageSelectionLoadedState copyWith({
    List<AvailableLanguage>? availableLanguages,
    String? selectedLanguageId,
    LanguageSelectionStatus? status,
    String? errorMessage,
  }) {
    return LanguageSelectionLoadedState(
      availableLanguages: availableLanguages ?? this.availableLanguages,
      selectedLanguageId: selectedLanguageId ?? this.selectedLanguageId,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [availableLanguages, selectedLanguageId, status, errorMessage];
}

class LanguageSelectionErrorState extends LanguageSelectionState {
  final String errorMessage;

  const LanguageSelectionErrorState({
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorMessage];
}
