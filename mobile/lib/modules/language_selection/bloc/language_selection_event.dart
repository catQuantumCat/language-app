part of 'language_selection_bloc.dart';

abstract class LanguageSelectionEvent extends Equatable {
  const LanguageSelectionEvent();

  @override
  List<Object> get props => [];
}

class LoadLanguagesEvent extends LanguageSelectionEvent {
  const LoadLanguagesEvent();
}

class SelectLanguageEvent extends LanguageSelectionEvent {
  final String languageId;

  const SelectLanguageEvent(this.languageId);

  @override
  List<Object> get props => [languageId];
}

class SubmitSelectedLanguageEvent extends LanguageSelectionEvent {
  const SubmitSelectedLanguageEvent();
}
